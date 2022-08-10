import 'package:flutter/widgets.dart';
import 'package:lib_core/src/service/navigation_service.dart';

/// created by devin
/// 2022/3/22 10:52
/// description:
mixin PageObserver<T extends StatefulWidget> on State<T>, RouteAware {
  String get pageName => T.toString();
  bool visible = false;

  @override
  void initState() {
    print('$pageName start >>');
    super.initState();
  }

  @override
  void dispose() {
    print('$pageName end >>');
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    print('$pageName didPush >>');
    this.visible = true;
  }

  @override
  void didPushNext() {
    print('$pageName didPushNext >>');
    this.visible = false;
  }

  @override
  void didPop() {
    print('$pageName didPop >>');
    this.visible = false;
  }

  @override
  void didPopNext() {
    print('$pageName didPopNext >>');
    this.visible = true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }
}