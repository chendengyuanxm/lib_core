class HttpCode {

  HttpCode._();

  /// 成功码
  static List successCodeList = [];

  static const String defaultError = "-1";
  /// 未知错误
  static const String unKnowError = "-1";
  /// 返回无内容
  static const String httpNotContent = "-2";

  static String networkError = '-3';

  static String jsonParseException = '-4';

  static String connectTimeout = '-5';

  static String sendTimeout = '-6';

  static String receiveTimeout = '-7';

  static String cancel = '-8';

  static String defaultCode = '-10';
}