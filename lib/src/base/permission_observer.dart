import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:lib_core/lib_core.dart';
import 'package:permission_handler/permission_handler.dart';

/// created by devin
/// 2022/3/30 11:08
/// description: 
mixin PermissionObserver<T extends StatefulWidget> on State<T>, WidgetsBindingObserver {
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

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   LogUtil.i('didChangeAppLifecycleState >> $state');
  //   switch(state){
  //     case AppLifecycleState.resumed:
  //       checkPermissions();
  //       break;
  //   }
  // }

  bool verifyPermissions(Map<Permission, PermissionStatus> statuses) {
    statuses.removeWhere((key, value) => value.isGranted);
    return statuses.length <= 0;
  }

  checkPermissions() async {
    LogUtil.i('check permission ...');
    List<Permission> unGrantedPermissions = [];
    await Future.forEach<Permission>(_checkPermissions, (element) async {
      bool granted = await element.isGranted;
      if (!granted) unGrantedPermissions.add(element);
    });

    Map<Permission, PermissionStatus> statuses = await unGrantedPermissions.request();
    bool verified = verifyPermissions(statuses);
    if (!verified) {
      bool? confirmed = await DialogUtil.showAlertDialog(context, content: '未获取相关权限，是否前往设置？');
      if (confirmed != null && confirmed) {
        await openAppSettings();
      }
    }
  }

  List<Permission> getCheckPermissions() => [];
}