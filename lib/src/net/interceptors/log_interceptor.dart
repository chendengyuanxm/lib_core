import 'package:dio/dio.dart';
import 'dart:math' as math;

import 'package:lib_core/src/util/index.dart';
import 'package:logger/logger.dart';

class LogsInterceptors extends InterceptorsWrapper {
  final logSize = 128;
  var logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      printEmojis: false,
      noBoxingByDefault: true,
    ),
  );

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _print('-------------------------- Request -----------------------------');
    printKV('uri', options.uri);
    printKV('method', options.method);
    printKV('contentType', options.contentType.toString());
    printKV('responseType', options.responseType.toString());
    printKV('extra', options.extra);

    StringBuffer stringBuffer = new StringBuffer();
    options.headers.forEach((key, v) => stringBuffer.write('\n  $key:$v'));
    printKV('header', stringBuffer.toString());
    stringBuffer.clear();

    _print("data:");
    printAll(options.data.toString());
    _print('-------------------------- Request -----------------------------');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _print('-------------------------- Response -----------------------------');
    _printResponse(response);
    _print('-------------------------- Response -----------------------------');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    _print('-------------------------- Error -----------------------------');
    if (err.response != null) {
      _printResponse(err.response!);
    }
    _print('-------------------------- Error -----------------------------');
    super.onError(err, handler);
  }

  void _printResponse(Response response) {
    printKV('uri', response.requestOptions.uri);
    printKV('statusCode', response.statusCode);
    if(response.isRedirect!)
      printKV('redirect',response.realUri);
    _print("headers:");
    _print(" " + response.headers.toString().replaceAll("\n", "\n "));

    _print("Response:");
    printAll(response.data);
    _print("");
  }

  _print(msg) {
    logger.d(msg);
  }

  printKV(String key, Object? v) {
    logger.d('$key: $v');
  }

  printAll(msg) {
    if (msg.toString().length < 5000) {
      logger.d(msg);
    } else {
      logger.d(msg.toString());
    }
    // msg.toString().split("\n").forEach(_printAll);
  }

  _printAll(String msg) {
    int groups = (msg.length / logSize).ceil();
    for (int i = 0; i < groups; ++i) {
      print(msg.substring(
          i * logSize, math.min<int>(i * logSize + logSize, msg.length)));
    }
  }
}
