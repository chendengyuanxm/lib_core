import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lib_core/src/net/abstract_http_client.dart';
import 'package:lib_core/src/service/index.dart';
import 'package:lib_core/src/service/navigation_service.dart';
import 'package:lib_core/src/util/index.dart';
import 'default_transformer.dart';
import 'error_code.dart';
import 'http_options.dart';
import 'http_request_exception.dart';
import 'interceptors/log_interceptor.dart';
import 'interceptors/token_interceptor.dart';

abstract class HttpClientMixin implements HttpClient {
  late Dio _dio;
  late HttpOptions options;
  bool showLoading = false;

  static const VALIDATE_STATUS = [200, 201, 204];

  static const String GET = "GET";
  static const String POST = "POST";
  static const String DELETE = "DELETE";
  static const String PUT = "PUT";

  HttpClientMixin([HttpOptions? options]) {
    _dio = new Dio(_createOptions(options));
    _dio.transformer = FlutterTransformer();
    _dio.interceptors.add(TokenInterceptor());
    _dio.interceptors.add(LogsInterceptors());
  }

  _createOptions(HttpOptions? options) {
    BaseOptions baseOptions = new BaseOptions();
    if (options != null) {
      baseOptions.baseUrl = options.baseUrl;
      baseOptions.connectTimeout = options.connectTimeout ?? 60 * 1000;
      baseOptions.headers = options.headers ?? {"accept": "application/json"};
      baseOptions.validateStatus = (status) => VALIDATE_STATUS.contains(status);
    }

    return baseOptions;
  }

  Future<T?> get<T>(
      String url,
      Map<String, dynamic> queryParams, {
        Options? options,
        CancelToken? cancelToken,
        bool isShowProgress = true,
      }) {
    return _request<T>(GET, url, queryParameters: queryParams, options: options, isShowProgress: isShowProgress);
  }

  Future<T?> post<T>(
      String url,
      Map<String, dynamic> queryParams, {
        dynamic body,
        Options? options,
        CancelToken? cancelToken,
        bool isShowProgress = true,
      }) {
    return _request<T>(POST, url,
        data: body == null ? {} : body, queryParameters: queryParams, options: options, cancelToken: cancelToken, isShowProgress: isShowProgress);
  }

  Future<T?> delete<T>(
      String url,
      Map<String, dynamic> queryParams, {
        dynamic body,
        Options? options,
        CancelToken? cancelToken,
        bool isShowProgress = true,
      }) {
    return _request<T>(DELETE, url, data: body, queryParameters: queryParams, options: options, cancelToken: cancelToken, isShowProgress: isShowProgress);
  }

  Future<T?> put<T>(
      String url,
      Map<String, dynamic> queryParams, {
        dynamic body,
        Options? options,
        CancelToken? cancelToken,
        bool isShowProgress = true,
      }) {
    return _request<T>(PUT, url,
        data: body == null ? {} : body, queryParameters: queryParams, options: options, cancelToken: cancelToken, isShowProgress: isShowProgress);
  }

  Future<T?> _request<T>(
      String method,
      path, {
        data,
        Map<String, dynamic>? queryParameters,
        CancelToken? cancelToken,
        Options? options,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
        bool isShowProgress = true,
      }) async {
    try {
      _showProgress(isShowProgress);
      Response resp = await _dio.request(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options ?? Options()..method = method,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      T result = _handleResult<T>(resp);
      return result;
    } on DioError catch (dioErr) {
      LogUtil.e(dioErr);
      if (dioErr.response != null) {
        var errorResponse = dioErr.response;
        var statusCode = errorResponse?.statusCode;
        var errorCode = ErrorCode.ERROR_CODE_UNKNOWN;
        var errorMsg = errorResponse.toString();
        throw HttpRequestException(statusCode!, errorCode, errorMsg);
      }
    } on Error catch (e) {
      LogUtil.e(e.stackTrace.toString());
      throw HttpRequestException(-1, ErrorCode.ERROR_CODE_UNKNOWN, e.toString());
    } finally {
      _dismissProgress();
    }
  }

  T _handleResult<T>(Response resp) {
    if (resp.data == null || resp.data == '') {
      throw HttpRequestException(-1, ErrorCode.HTTP_NOT_CONTENT, 'HTTP NOT CONTENT');
    } else {
      T t = parseResult(resp);
      return t;
    }
  }

  _showProgress(bool isShowProgress) {
    if (isShowProgress && !showLoading) {
      showLoading = true;
      BuildContext context = navigationKey.currentState!.overlay!.context;
      DialogUtil.showLoadingDialog(context);
    }
  }

  _dismissProgress() {
    if (showLoading) {
      showLoading = false;
      locator<NavigationService>().pop();
    }
  }
}