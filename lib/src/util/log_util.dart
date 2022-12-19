import 'dart:convert';
import 'dart:io';

import 'package:lib_core/lib_core.dart';
import 'package:logger/logger.dart';
import 'package:logger/src/outputs/file_output.dart';

enum LogPriority {
  verbose,
  debug,
  wtf,
  info,
  warn,
  error,
}

extension LogPriority2Level on LogPriority {
  static Map<LogPriority, Level> map = {
    LogPriority.verbose: Level.verbose,
    LogPriority.debug: Level.debug,
    LogPriority.wtf: Level.wtf,
    LogPriority.info: Level.info,
    LogPriority.warn: Level.warning,
    LogPriority.error: Level.error,
  };
  Level get level => map[this] ?? Level.nothing;
  String get abbr => this.name.substring(0, 1);
}

class LogConfig {
  LogPriority? priority;
  String? tag;
  int? maxLen;
  bool? saveLocalLog;

  LogConfig({this.priority, this.tag, this.maxLen, this.saveLocalLog = false});
}

class LogUtil {
  static LogPriority _logPriority = LogPriority.verbose;
  static const String _defTag = "debug";
  static int _maxLen = 128;
  static String _tagValue = _defTag;
  static bool _saveLocalLog = false;
  static var logger = Logger();

  static Future<File> get file async {
    String dir = await FileUtil.tempPath;
    File file = File('$dir/logs/log-${formatDate(DateTime.now(), [yyyy, mm, dd])}.txt');
    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }
    print('创建日志文件：${file.path}');
    return file;
  }

  static init(LogConfig? config) async {
    _tagValue = config?.tag ?? _tagValue;
    _logPriority = config?.priority ?? _logPriority;
    _maxLen = config?.maxLen ?? _maxLen;
    _saveLocalLog = config?.saveLocalLog ?? _saveLocalLog;

    logger = Logger(
      level: _logPriority.level,
      printer: PrettyPrinter(
        methodCount: 0,
        lineLength: _maxLen,
        printEmojis: false,
        printTime: false,
        noBoxingByDefault: true,
      ),
      output: MultiOutput([
        ConsoleOutput(),
        if (_saveLocalLog) FileOutput(file: await file),
      ]),
    );
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

  static void wtf(Object? object, {String? tag}) {
    _printLog(LogPriority.wtf, tag, object);
  }

  static void _printLog(LogPriority priority, String? tag, Object? object) {
    tag = tag ?? _tagValue;
    String data = object?.toString() ?? 'null';
    String time = formatDateTimestamp(DateTime.now().millisecondsSinceEpoch, formats: [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss]);
    if (data.length <= _maxLen) {
      logger.log(priority.level, '—————————————————————————$time $tag ${priority.abbr}——————————————————————————————————');
      logger.log(priority.level, data);
      logger.log(priority.level, '——————————————————————————————————————————————————————————————————————————————————————');
    } else {
      logger.log(priority.level, '————————————————————————————————————$tag ${priority.abbr}———————————————————————————————————————————');
      while (data.isNotEmpty) {
        if (data.length > _maxLen) {
          logger.log(priority.level, data.substring(0, _maxLen));
          data = data.substring(_maxLen, data.length);
        } else {
          logger.log(priority.level, data);
          data = "";
        }
      }
      logger.log(priority.level, '——————————————————————————————————————————————————————————————————————————————————————');
    }
  }
}