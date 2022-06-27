import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();
GlobalKey<NavigatorState> get navigationKey => _navigationKey;
NavigatorState get navigation => _navigationKey.currentState!;
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class NavigationService {
  get pushNamed => navigation.pushNamed;

  get push => navigation.push;

  get pushReplace => navigation.pushReplacement;
  
  get pushReplacementNamed => navigation.pushReplacementNamed;

  get pop => navigation.pop;

  get pushNamedAndRemoveUntil => navigation.pushNamedAndRemoveUntil;

  get popAndPushNamed => navigation.popAndPushNamed;

  get popUntil => navigation.popUntil;

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