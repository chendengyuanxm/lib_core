import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lib_core/src/ext/device_extensions.dart';
import 'toast_util.dart';

/// 系统工具类
class SystemUtil {

  /// Returns current PlatformName
  String platformName() {
    if (isLinux) return 'Linux';
    if (isWeb) return 'Web';
    if (isMacOS) return 'macOS';
    if (isWindows) return 'Windows';
    if (isAndroid) return 'Android';
    if (isIos) return 'iOS';
    return '';
  }

  /// 拷贝文本内容到剪切板
  static bool copyToClipboard(String text, {String? successMessage, BuildContext? context}) {
    if (text.isNotEmpty) {
      Clipboard.setData(new ClipboardData(text: text));
      if (context != null) {
        showToast('copy success');
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  /// 隐藏软键盘，具体可看：TextInputChannel
  static void hideKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  /// 展示软键盘，具体可看：TextInputChannel
  static void showKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.show');
  }

  /// 清除数据
  static void clearClientKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.clearClient');
  }

}