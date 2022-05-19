import 'package:flutter/cupertino.dart';
import 'package:lib_core/src/base/base_stateful_widget.dart';
import 'package:lib_core/src/base/page_observer.dart';
import 'package:lib_core/src/base/permission_observer.dart';
import 'package:lib_core/src/util/index.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class BaseState<T extends BaseStatefulWidget> extends State<T> with WidgetsBindingObserver, RouteAware, PageObserver, PermissionObserver {
  @override
  List<Permission> getCheckPermissions() => widget.checkPermissions ?? [];
}