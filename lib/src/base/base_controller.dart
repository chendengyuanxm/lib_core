import 'package:get/get.dart';

/// created by devin
/// 2022/1/6 11:00
///
abstract class BaseController extends GetxController {

  void notifyListeners() {
    super.update();
  }
}
