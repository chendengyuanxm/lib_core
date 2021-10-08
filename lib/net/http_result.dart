class HttpResult<T> {
  final int statusCode;
  final String errorCode;
  final String message;
  final T? data;

  HttpResult({required this.statusCode, required this.message, required this.errorCode, this.data});

  bool get success => this.statusCode == 200;
}