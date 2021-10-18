import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'toast_util.dart';

/// 系统工具类
class SystemUtil {

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