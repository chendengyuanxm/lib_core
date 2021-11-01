import 'dart:io';

import 'package:dio/dio.dart';
import 'package:lib_core/lib_core.dart';
import '../http_code.dart';

/// @author: Devin
/// @date: 2021/10/27 14:43
/// @description: 网络配置类接口
abstract class IHttpConfig {

  BaseOptions configBaseOptions();

  List<int> configHttpResultSuccessCodeList() {
    return HttpCode.successCodeList;
  }

  bool configLogEnable() {
    return true;
  }

  List<Interceptor>? configInterceptors();

  bool configHttps(X509Certificate cert, String host, int port);

  Future<HttpResult<T>> parseResult<T>(Map<String, dynamic> json, bool isList);

  bool isShowProgress();

  String configLoadingText();

  bool isCheckNetwork();
}