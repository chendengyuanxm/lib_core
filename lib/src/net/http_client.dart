import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lib_core/lib_core.dart';
import 'package:lib_core/src/net/model/error_result.dart';
import 'package:lib_core/src/util/index.dart';
import 'default_transformer.dart';
import 'http_code.dart';
import 'http_request_exception.dart';
import 'interceptors/log_interceptor.dart';
import 'interface/i_http_config.dart';

/// @author: Devin
/// @date: 2021/10/27 14:43
/// @description: 网络请求类
class HttpClient {
  static HttpClient _instance = HttpClient._();
  static late IHttpConfig _httpConfig;
  static late Dio _dio;

  static const String GET = "GET";
  static const String POST = "POST";
  static const String DELETE = "DELETE";
  static const String PUT = "PUT";

  bool _showLoading = false;
  List<CancelToken> _cancelTokenList = [];
  static const downLoadReceiveTimeout = 60 * 1000;

  factory HttpClient() {
    return _instance;
  }

  HttpClient._();

  static initConfig(IHttpConfig httpConfig) {
    _httpConfig = httpConfig;
    _dio = Dio();
    _dio.options = _httpConfig.configBaseOptions();
    _dio.transformer = FlutterTransformer();

    if (_httpConfig.configInterceptors() != null) {
      _dio.interceptors.addAll(_httpConfig.configInterceptors()!);
    }

    if (_httpConfig.configLogEnable()) {
      _dio.interceptors.add(LogsInterceptors());
    }

    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) {
        ///true：忽略证书校验
        return _httpConfig.configHttps(cert, host, port);
      };
    };
  }

  Future<T?> get<T>(
    String url,
    Map<String, dynamic> queryParams, {
    Options? options,
    CancelToken? cancelToken,
    bool isShowProgress = true,
    String? loadingText,
    bool? isCheckNetwork,
  }) {
    return _request<T>(
      GET,
      url,
      queryParameters: queryParams,
      options: options,
      isShowProgress: isShowProgress,
      loadingText: loadingText,
      isCheckNetwork: isCheckNetwork,
    );
  }

  Future<T?> post<T>(
    String url,
    Map<String, dynamic> queryParams, {
    dynamic body,
    Options? options,
    CancelToken? cancelToken,
    bool isShowProgress = true,
    String? loadingText,
    bool? isCheckNetwork,
  }) {
    return _request<T>(
      POST,
      url,
      data: body == null ? {} : body,
      queryParameters: queryParams,
      options: options,
      cancelToken: cancelToken,
      isShowProgress: isShowProgress,
      loadingText: loadingText,
      isCheckNetwork: isCheckNetwork,
    );
  }

  Future<T?> delete<T>(
    String url,
    Map<String, dynamic> queryParams, {
    dynamic body,
    Options? options,
    CancelToken? cancelToken,
    bool isShowProgress = true,
    String? loadingText,
    bool? isCheckNetwork,
  }) {
    return _request<T>(
      DELETE,
      url,
      data: body,
      queryParameters: queryParams,
      options: options,
      cancelToken: cancelToken,
      isShowProgress: isShowProgress,
      loadingText: loadingText,
      isCheckNetwork: isCheckNetwork,
    );
  }

  Future<T?> put<T>(
    String url,
    Map<String, dynamic> queryParams, {
    dynamic body,
    Options? options,
    CancelToken? cancelToken,
    bool isShowProgress = true,
    String? loadingText,
    bool? isCheckNetwork,
  }) {
    return _request<T>(
      PUT,
      url,
      data: body == null ? {} : body,
      queryParameters: queryParams,
      options: options,
      cancelToken: cancelToken,
      isShowProgress: isShowProgress,
      loadingText: loadingText,
      isCheckNetwork: isCheckNetwork,
    );
  }

  Future<bool> download(
      String url,
      String savePath, {
        int? receiveTimeout = downLoadReceiveTimeout,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onReceiveProgress,
      }) async {
    LogUtil.i('downloadFile() url:$url  savePath:$savePath');
    bool isSuccess;

    ///添加CancelToken,用于取消请求
    cancelToken ??= CancelToken();
    _cancelTokenList.add(cancelToken);

    ///设置超时时间
    if (receiveTimeout != null) {
      options ??= Options();
      options.receiveTimeout = receiveTimeout;
    }

    try {
      await _dio.download(url, savePath, cancelToken: cancelToken, onReceiveProgress: onReceiveProgress, options: options);
      isSuccess = true;
      LogUtil.i('downloadFile() success, url:$url  savePath:$savePath');
    } catch (e) {
      LogUtil.e('downloadFile fail:$e');
      isSuccess = false;
    }

    ///请求完成移除cancelToken
    _cancelTokenList.remove(cancelToken);
    return isSuccess;
  }

  Future<T?> _request<T>(
    String method,
    url, {
    data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
    bool? isShowProgress,
    String? loadingText,
    bool? isCheckNetwork,
  }) async {
    /// 设置默认值
    isShowProgress ??= _httpConfig.isShowProgress();
    loadingText ??= _httpConfig.configLoadingText();
    isCheckNetwork ??= _httpConfig.isCheckNetwork();

    if (isCheckNetwork) {
      ///判断网络连接
      ConnectivityResult connResult = await Connectivity().checkConnectivity();
      if (connResult == ConnectivityResult.none) {
        throw HttpRequestException('-1', HttpCode.networkError, '无网络连接，请检查网络设置');
      }
    }

    options ??= Options();
    options.method = method;

    /// 设置cancelToken
    cancelToken ??= CancelToken();
    _cancelTokenList.add(cancelToken);

    /// 显示加载框
    if (isShowProgress && !_showLoading) {
      _showProgress(loadingText);
    }

    try {
      Response resp = await _dio.request(url, data: data, queryParameters: queryParameters, options: options, cancelToken: cancelToken);
      HttpResult result = await _handleResult<T>(resp, false);
      if (result.success) {
        return result.data;
      } else {
        throw HttpRequestException(result.httpCode!, result.code, result.message!);
      }
    } on DioError catch (dioErr) {
      LogUtil.e(dioErr);
      ErrorResult result = _createErrorBean(dioErr);
      throw HttpRequestException(result.httpCode!, result.code, result.message!);
    } on Error catch (e) {
      LogUtil.e(e.stackTrace.toString());
      throw HttpRequestException('-1', HttpCode.unKnowError, e.toString());
    } finally {
      if (isShowProgress && _showLoading) {
        _dismissProgress();
      }

      if (_cancelTokenList.contains(cancelToken)) {
        _cancelTokenList.remove(cancelToken);
      }
    }
  }

  Future<HttpResult<T>> _handleResult<T>(Response resp, bool isList) async {
    if (resp.data == null || resp.data == '') {
      HttpResult<T> result = HttpResult();
      result.code = HttpCode.httpNotContent;
      result.message = 'HTTP NOT CONTENT';
      return result;
    }

    HttpResult<T> result = await _httpConfig.parseResult<T>(resp.data, isList);
    result.json = resp.data;
    return result;
  }

  ErrorResult _createErrorBean(DioError error) {
    switch (error.type) {
      case DioErrorType.cancel:
        return ErrorResult(code: HttpCode.cancel, message: "请求取消");

      case DioErrorType.connectTimeout:
        return ErrorResult(code: HttpCode.connectTimeout, message: "连接超时");

      case DioErrorType.sendTimeout:
        return ErrorResult(code: HttpCode.sendTimeout, message: "请求超时");

      case DioErrorType.receiveTimeout:
        return ErrorResult(code: HttpCode.receiveTimeout, message: "响应超时");

      case DioErrorType.response:
        String errCode = error.response?.statusCode?.toString() ?? HttpCode.unKnowError;
        String errMsg = error.response?.statusMessage ?? '未知错误';
        return ErrorResult(code: errCode, message: errMsg);

      default:
        return ErrorResult(code: HttpCode.unKnowError, message: error.message);
    }
  }

  _showProgress(String text) {
    if (!_showLoading) {
      _showLoading = true;
      BuildContext context = navigationKey.currentState!.overlay!.context;
      DialogUtil.showLoadingDialog(context, message: text);
    }
  }

  _dismissProgress() {
    if (_showLoading) {
      _showLoading = false;
      locator<NavigationService>().pop();
    }
  }

  void addInterceptor(InterceptorsWrapper interceptor) {
    _dio.interceptors.add(interceptor);
  }

  void removeInterceptor(InterceptorsWrapper interceptor) {
    _dio.interceptors.remove(interceptor);
  }

  ///取消所有请求
  void cancelAll() {
    LogUtil.i('cancelAll:${_cancelTokenList.length}');
    _cancelTokenList.forEach((cancelToken) {
      cancel(cancelToken);
    });
    _cancelTokenList.clear();
  }

  ///取消指定的请求
  void cancel(CancelToken? cancelToken) {
    if (cancelToken != null && !cancelToken.isCancelled) {
      cancelToken.cancel();
    }
  }

  ///取消指定的请求
  void cancelList(List<CancelToken>? cancelTokenList) {
    LogUtil.i('cancelList:${cancelTokenList?.length}');
    cancelTokenList?.forEach((cancelToken) {
      cancel(cancelToken);
    });
  }
}