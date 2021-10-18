import 'package:dio/dio.dart';
import 'dart:math' as math;

class LogsInterceptors extends InterceptorsWrapper {
  final logSize = 128;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('-------------------------- Request -----------------------------');
    printKV('uri', options.uri);
    printKV('method', options.method);
    printKV('contentType', options.contentType.toString());
    printKV('responseType', options.responseType.toString());
    printKV('extra', options.extra);

    StringBuffer stringBuffer = new StringBuffer();
    options.headers.forEach((key, v) => stringBuffer.write('\n  $key:$v'));
    printKV('header', stringBuffer.toString());
    stringBuffer.clear();

    print("data:");
    printAll(options.data);
    print('-------------------------- Request -----------------------------');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('-------------------------- Response -----------------------------');
    _printResponse(response);
    print('-------------------------- Response -----------------------------');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    print('-------------------------- Error -----------------------------');
    print(err);
    if (err.response != null) {
      _printResponse(err.response!);
    }
    print('-------------------------- Error -----------------------------');
    super.onError(err, handler);
  }

  void _printResponse(Response response) {
    printKV('uri', response.requestOptions.uri);
    printKV('statusCode', response.statusCode);
    if(response.isRedirect!)
      printKV('redirect',response.realUri);
    print("headers:");
    print(" " + response.headers.toString().replaceAll("\n", "\n "));

    print("Response Text:");
    printAll(response.toString());
    print("");
  }

  printKV(String key, Object? v) {
    print('$key: $v');
  }

  printAll(msg) {
    msg.toString().split("\n").forEach(_printAll);
  }

  _printAll(String msg) {
    int groups = (msg.length / logSize).ceil();
    for (int i = 0; i < groups; ++i) {
      print(msg.substring(
          i * logSize, math.min<int>(i * logSize + logSize, msg.length)));
    }
  }
}
