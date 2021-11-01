import 'package:lib_core/src/net/http_code.dart';

abstract class BaseHttpResult {
  String code;
  String? httpCode;
  String? message;

  BaseHttpResult({required this.code, this.httpCode, this.message});

  bool get success => HttpCode.successCodeList.contains(code);
}