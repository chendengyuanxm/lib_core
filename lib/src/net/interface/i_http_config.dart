import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lib_core/lib_core.dart';
import '../http_code.dart';

/// @author: Devin
/// @date: 2021/10/27 14:43
/// @description: 网络配置类接口
abstract class IHttpConfig {

  List get successCodeList;

  bool get isLogEnable => true;

  bool get isShowProgress => true;

  String get defaultLoadingText => 'loading...';

  bool get isCheckNetwork => true;

  BaseOptions configBaseOptions();

  List<Interceptor>? configInterceptors();

  bool configHttps(X509Certificate cert, String host, int port);

  Future<HttpResult<T>> parseResult<T>(int statusCode, Map<String, dynamic> json, bool isList);

  Future showLoading(String text) async {
    BuildContext context = navigationKey.currentState!.overlay!.context;
    await DialogUtil.showLoadingDialog(context, message: text);
  }

  void dismissLoading() {
    BuildContext context = navigationKey.currentState!.overlay!.context;
    Navigator.of(context).pop();
  }
}