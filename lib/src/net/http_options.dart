class HttpOptions {
  late String baseUrl;
  int? connectTimeout;
  int? receiveTimeout;
  int? sendTimeout;
  Map<String, dynamic>? headers;

  HttpOptions({required this.baseUrl, this.connectTimeout, this.receiveTimeout, this.sendTimeout, this.headers});
}