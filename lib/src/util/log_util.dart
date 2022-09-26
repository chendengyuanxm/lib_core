
enum LogPriority {
  verbose,
  debug,
  json,
  info,
  warn,
  error,
}

extension LogPriorityExt on LogPriority{
  static const map = {
    LogPriority.verbose: 2,
    LogPriority.debug: 3,
    LogPriority.json: 4,
    LogPriority.info: 5,
    LogPriority.warn: 6,
    LogPriority.error: 7,
  };
  int get level => map[this]!;
}

class LogConfig {
  LogPriority? priority;
  String? tag;
  int? maxLen;

  LogConfig({this.priority, this.tag, this.maxLen});
}

class LogUtil {
  static LogPriority _logPriority = LogPriority.verbose;
  static const String _defTag = "debug";
  static int _maxLen = 128;
  static String _tagValue = _defTag;

  static void init(LogConfig? config) {
    _tagValue = config?.tag ?? _tagValue;
    _logPriority = config?.priority ?? _logPriority;
    _maxLen = config?.maxLen ?? _maxLen;
  }

  static void v(Object? object, {String? tag}) {
    _printLog(LogPriority.verbose, tag, object);
  }

  static void d(Object? object, {String? tag}) {
    _printLog(LogPriority.debug, tag, object);
  }

  static void i(Object? object, {String? tag}) {
    _printLog(LogPriority.info, tag, object);
  }

  static void w(Object? object, {String? tag}) {
    _printLog(LogPriority.warn, tag, object);
  }

  static void e(Object? object, {String? tag}) {
    _printLog(LogPriority.error, tag, object);
  }

  static void _printLog(LogPriority priority, String? tag, Object? object) {
    if (priority.level < _logPriority.level) return;

    tag = tag ?? _tagValue;
    String data = object?.toString() ?? 'null';
    if (data.length <= _maxLen) {
      print('————————————————————————————$tag${priority.name}——————————————————————————————————');
      print("$data");
      print('——————————————————————————————————————————————————————————————————————');
      return;
    }
    print(
        '————————————————————————————$tag${priority.name}————————————————————————————————————');
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
