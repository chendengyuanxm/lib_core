import 'package:flutter/cupertino.dart';
import 'package:lib_core/lib_core.dart';
import 'package:permission_handler/permission_handler.dart';

/// created by devin
/// 2022/1/7 15:05
///
abstract class BaseView extends StatefulWidget {
  const BaseView({Key? key, this.checkPermissions}) : super(key: key);

  final List<Permission>? checkPermissions;

  @override
  State<StatefulWidget> createState() => _BaseState();

  @protected
  Widget build(BuildContext context);
}

class _BaseState extends State<BaseView> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    super.initState();
    checkPermissions();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.build(context);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
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
    if (widget.checkPermissions == null) return;

    List<Permission> unGrantedPermissions = [];
    await Future.forEach<Permission>(widget.checkPermissions!, (element) async {
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
}
