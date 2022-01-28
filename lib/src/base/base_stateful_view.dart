import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lib_core/lib_core.dart';
import 'package:permission_handler/permission_handler.dart';

/// created by devin
/// 2022/1/13 14:56
///
abstract class BaseStatefulView<T extends BaseController> extends StatelessWidget with WidgetsBindingObserver {

  const BaseStatefulView({Key? key}) : super(key: key);

  final String? tag = null;

  T get controller => Get.find<T>(tag: tag);

  void initState(GetBuilderState state) {
    WidgetsBinding.instance?.addObserver(this);
    checkPermissions();
  }

  void dispose(GetBuilderState state) {
    WidgetsBinding.instance?.removeObserver(this);
  }

  void didChangeDependencies(GetBuilderState state) {}

  void didUpdateWidget(GetBuilder oldWidget, GetBuilderState<T> state) {}

  Widget buildWidget(BuildContext context, T controller);

  BuildContext? get context => Get.context;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<T>(
      init: controller,
      builder: (controller) => buildWidget.call(context, controller),
      initState: initState,
      dispose: dispose,
      didChangeDependencies: didChangeDependencies,
      didUpdateWidget: didUpdateWidget,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch(state){
      case AppLifecycleState.resumed:
        checkPermissions();
        break;
      default:
        break;
    }
  }

  bool verifyPermissions(Map<Permission, PermissionStatus> statuses) {
    statuses.removeWhere((key, value) => value.isGranted);
    return statuses.length <= 0;
  }

  checkPermissions() async {
    List<Permission> unGrantedPermissions = [];
    await Future.forEach<Permission>(permissions, (element) async {
      bool granted = await element.isGranted;
      if (!granted) unGrantedPermissions.add(element);
    });

    Map<Permission, PermissionStatus> statuses = await unGrantedPermissions.request();
    bool verified = verifyPermissions(statuses);
    if (!verified) {
      bool confirmed = await DialogUtil.showAlertDialog(Get.context!, content: '未获取相关权限，是否前往设置？');
      if (confirmed != null && confirmed) {
        await openAppSettings();
      }
    }
  }

  List<Permission> get permissions => [];
}
