
class LogUtil {
  static const String _defTag = "debug";
  static bool _debugMode = true;
  static int _maxLen = 128;
  static String _tagValue = _defTag;

  static void init({
    String tag = _defTag,
    bool isDebug = true,
    int maxLen = 128,
  }) {
    _tagValue = tag;
    _debugMode = isDebug;
    _maxLen = maxLen;
  }

  static void i(Object object, {String? tag}) {
    if (_debugMode) {
      _printLog(tag, ' v ', object);
    }
  }

  static void e(Object object, {String? tag}) {
    _printLog(tag, ' e ', object);
  }

  static void v(Object object, {String? tag}) {
    if (_debugMode) {
      _printLog(tag, ' v ', object);
    }
  }

  static void _printLog(String? tag, String? stag, Object object) {
    String da = object.toString();
    tag = tag ?? _tagValue;
    if (da.length <= _maxLen) {
      print('————————————————————————————$tag——————————————————————————————————');
      print("$da");
      print('———————————————————————————————————————————————————————————————————');
      return;
    }
    print(
        '————————————————————————————$tag——————————————————————————————————');
    while (da.isNotEmpty) {
      if (da.length > _maxLen) {
        print("${da.substring(0, _maxLen)}");
        da = da.substring(_maxLen, da.length);
      } else {
        print("$da");
        da = "";
      }
    }
    print('———————————————————————————————————————————————————————————————————');
  }
}
