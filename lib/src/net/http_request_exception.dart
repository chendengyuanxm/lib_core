class HttpRequestException implements Exception {
  final int statusCode;
  final String errCode;
  final String errMsg;

  HttpRequestException(this.statusCode, this.errCode, this.errMsg);

  @override
  String toString() {
    return 'statusCode: $statusCode, errCode: $errCode, errMsg: $errMsg';
  }
}