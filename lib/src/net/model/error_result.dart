import 'package:lib_core/src/net/model/base_http_result.dart';

class ErrorResult extends BaseHttpResult {
  ErrorResult({
    required String code,
    int? httpCode,
    String? message,
  }) : super(code: code, httpCode: httpCode, message: message);

  @override
  String toString() {
    return '[$code] $message';
  }
}
