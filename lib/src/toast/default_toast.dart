import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lib_core/lib_core.dart';
import 'package:lib_core/src/toast/i_toast.dart';

/// @author: Devin
/// @date: 2021/11/1 15:06
/// @description: 
class DefaultToast extends IToast {

  @override
  void show(String? msg, {bool isShowLong = false, double? fontSize}) {
    if (msg == null || msg.isEmpty) {
      LogUtil.e('toast message can`t be empty');
      return;
    }

    Fluttertoast.showToast(msg: msg, toastLength: isShowLong ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT, fontSize: fontSize);
  }

  @override
  void showDebug(String? msg, {bool isShowLong = false, double? fontSize}) {
    if (msg == null || msg.isEmpty) {
      LogUtil.e('toast message can`t be empty');
      return;
    }

    Fluttertoast.showToast(msg: msg, toastLength: isShowLong ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT, fontSize: fontSize, backgroundColor: Colors.red);
  }

}