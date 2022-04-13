import 'package:flutter/cupertino.dart';
import 'package:lib_core/lib_core.dart';
import 'package:lib_core/src/base/permission_observer.dart';
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

class _BaseState extends State<BaseView> with WidgetsBindingObserver, PermissionObserver {

  @override
  Widget build(BuildContext context) => widget.build(context);

}
