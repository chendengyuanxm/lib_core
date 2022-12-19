import 'package:fluttertoast/fluttertoast.dart';
import 'package:lib_core/src/toast/default_toast.dart';
import 'package:lib_core/src/toast/i_toast.dart';

showToast(String message) {
  Fluttertoast.showToast(msg: message);
}

class ToastUtil {
  ToastUtil._();

  static IToast _toast = DefaultToast();

  static void init(IToast? toast) {
    if (toast != null) {
      _toast = toast;
    }
  }

  static void show(String? msg, {bool isShowLong = false, double? fontSize}) {
    _toast.show(msg, isShowLong: isShowLong, fontSize: fontSize);
  }

  static void showDebug(String? msg, {bool isShowLong = false, double? fontSize}) {
    _toast.showDebug(msg, isShowLong: isShowLong, fontSize: fontSize);
  }
}