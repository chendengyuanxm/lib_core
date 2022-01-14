import 'package:flutter/cupertino.dart';
import 'package:lib_core/src/base/base_stateful_widget.dart';
import 'package:lib_core/src/util/index.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class BaseState<T extends BaseStatefulWidget> extends State<T> with WidgetsBindingObserver {
  List<Permission> _checkPermissions = [];

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    super.initState();
    _checkPermissions = getCheckPermissions();
    checkPermissions();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch(state){
      case AppLifecycleState.resumed:
        checkPermissions();
        break;
    }
  }

  bool verifyPermissions(Map<Permission, PermissionStatus> statuses) {
    statuses.removeWhere((key, value) => value.isGranted);
    return statuses.length <= 0;
  }

  checkPermissions() async {
    List<Permission> unGrantedPermissions = [];
    await Future.forEach<Permission>(_checkPermissions, (element) async {
      bool granted = await element.isGranted;
      if (!granted) unGrantedPermissions.add(element);
    });

    Map<Permission, PermissionStatus> statuses = await unGrantedPermissions.request();
    bool verified = verifyPermissions(statuses);
    if (!verified) {
      bool confirmed = await DialogUtil.showAlertDialog(context, content: '未获取相关权限，是否前往设置？');
      if (confirmed != null && confirmed) {
        await openAppSettings();
      }
    }
  }

  List<Permission> getCheckPermissions() => [];
}