/// @author: Devin
/// @date: 2021/11/1 15:04
/// @description: 
abstract class IToast {

  void show(String? msg, {bool isShowLong = false, double? fontSize});

  void showDebug(String? msg, {bool isShowLong = false, double? fontSize});
}