import 'package:flutter/material.dart';

GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();
GlobalKey<NavigatorState> get navigationKey => _navigationKey;

class NavigationService {

  NavigatorState get navigator => _navigationKey.currentState!;

  get pushNamed => navigator.pushNamed;

  get push => navigator.push;

  get pushReplace => navigator.pushReplacement;

  get pop => navigator.pop;

  get pushNamedAndRemoveUntil => navigator.pushNamedAndRemoveUntil;

  pushPage(Widget page) {
    return push(_buildRoute(page));
  }

  delayPushPage(Widget page) {
    Future.delayed(Duration.zero, () => pushPage(page));
  }

  pushReplacePage(Widget page) {
    return pushReplace(_buildRoute(page));
  }

  static Route _buildRoute(Widget page) {
    return new PageRouteBuilder(
      settings: RouteSettings(
        name: page.toStringShort(),
      ),
      opaque: false,
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return page;
      },
      transitionsBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        return new FadeTransition(
          opacity: animation,
          child: new FadeTransition(
            opacity: new Tween<double>(begin: 0.5, end: 1.0).animate(animation),
            child: child,
          ),
        );
      },
    );
  }
}