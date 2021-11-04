import 'dart:io';
import 'package:dio/src/interceptor.dart';
import 'package:dio/src/options.dart';
import 'package:lib_core/src/net/interceptors/token_interceptor.dart';
import 'package:lib_core/src/net/interface/i_http_config.dart';
import 'package:lib_core/src/net/model/http_result.dart';

abstract class DefaultHttpConfig extends IHttpConfig {
  @override
  BaseOptions configBaseOptions();

  @override
  bool configHttps(X509Certificate cert, String host, int port) {
    return true;
  }

  @override
  List<Interceptor>? configInterceptors() {
    List<Interceptor> interceptors = [];
    interceptors.add(TokenInterceptor());
    return interceptors;
  }

  @override
  Future<HttpResult<T>> parseResult<T>(int statusCode, Map<String, dynamic> json, bool isList);
}