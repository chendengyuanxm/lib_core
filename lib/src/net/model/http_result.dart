import 'package:lib_core/src/net/model/base_http_result.dart';
import 'package:lib_core/src/net/http_code.dart';
import 'package:lib_core/src/net/model/error_result.dart';

class HttpResult<T> extends BaseHttpResult{
  bool isList;

  T? data;

  List<T>? dataList;

  Map<String, dynamic>? json;

  HttpResult({this.isList = false, this.data, this.dataList, this.json}) : super(code: HttpCode.defaultError);

  ErrorResult obtainErrorBean() {
    return ErrorResult(code: code, message: message);
  }
}