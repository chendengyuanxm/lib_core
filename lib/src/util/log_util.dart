
class LogConfig {
  int? priority;
  String? tag;
  int? maxLen;

  LogConfig({this.priority, this.tag, this.maxLen});
}

class LogUtil {
  static const int VERBOSE = 2;
  static const int DEBUG = 3;
  static const int JSON = 4;
  static const int INFO = 5;
  static const int WARN = 6;
  static const int ERROR = 7;

  static int _logPriority = VERBOSE;
  static const String _defTag = "debug";
  static int _maxLen = 128;
  static String _tagValue = _defTag;

  static void init(LogConfig? config) {
    _tagValue = config?.tag ?? _tagValue;
    _logPriority = config?.priority ?? _logPriority;
    _maxLen = config?.maxLen ?? _maxLen;
  }

  static void v(Object? object, {String? tag}) {
    _printLog(VERBOSE, tag, object);
  }

  static void d(Object? object, {String? tag}) {
    _printLog(DEBUG, tag, object);
  }

  static void i(Object? object, {String? tag}) {
    _printLog(INFO, tag, object);
  }

  static void w(Object? object, {String? tag}) {
    _printLog(WARN, tag, object);
  }

  static void e(Object? object, {String? tag}) {
    _printLog(ERROR, tag, object);
  }

  static void _printLog(int priority, String? tag, Object? object) {
    if (priority < _logPriority) return;

    tag = tag ?? _tagValue;
    String data = object?.toString() ?? 'null';
    if (data.length <= _maxLen) {
      print('————————————————————————————$tag$priority——————————————————————————————————');
      print("$data");
      print('——————————————————————————————————————————————————————————————————————');
      return;
    }
    print(
        '————————————————————————————$tag$priority————————————————————————————————————');
    while (data.isNotEmpty) {
      if (data.length > _maxLen) {
        print("${data.substring(0, _maxLen)}");
        data = data.substring(_maxLen, data.length);
      } else {
        print("$data");
        data = "";
      }
    }
    print('——————————————————————————————————————————————————————————————————————');
  }
}
