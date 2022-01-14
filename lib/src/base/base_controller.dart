import 'package:get/get.dart';
import 'viewmodel_helper.dart';

/// created by devin
/// 2022/1/6 11:00
///
abstract class BaseController extends GetxController with ViewModelHelper {
  void notifyListeners() {
    super.update();
  }
}
