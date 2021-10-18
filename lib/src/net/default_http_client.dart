import 'package:lib_core/generated/json/base/json_convert_content.dart';
import 'package:lib_core/src/net/abstract_http_client.dart';
import 'package:dio/dio.dart';
import 'http_options.dart';
import 'http_request_exception.dart';

class DefaultHttpClient extends HttpClient {

  factory DefaultHttpClient([HttpOptions? options]) => DefaultHttpClient._internal(options);

  DefaultHttpClient._internal([HttpOptions? options]) : super(options);

  @override
  T parseResult<T>(Response resp) {
    int status = int.parse(resp.data['code']);
    String message = resp.data['message'] ?? resp.data['msg'];
    dynamic result = resp.data['body'];
    if (status == 100) {
      if (T == dynamic) {
        return result;
      } else {
        T bean = JsonConvert.fromJsonAsT<T>(result);
        return bean;
      }
    }

    throw HttpRequestException(status, status.toString(), message);
  }

}