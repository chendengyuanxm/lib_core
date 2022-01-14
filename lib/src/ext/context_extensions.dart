import 'package:flutter/material.dart';

double tabletBreakpointGlobal = 600.0;
double desktopBreakpointGlobal = 720.0;

extension ContextExtensions on BuildContext {
  /// 返回屏幕大小
  Size get screenSize => MediaQuery.of(this).size;

  /// 返回屏幕宽度
  double get screenWidth => MediaQuery.of(this).size.width;

  /// 返回屏幕高度
  double get screenHeight => MediaQuery.of(this).size.height;

  /// 返回屏幕设备像素比例
  double get pixelRatio => MediaQuery.of(this).devicePixelRatio;

  /// 返回亮度
  Brightness get platformBrightness => MediaQuery.of(this).platformBrightness;

  /// 返回状态栏高度
  double get statusBarHeight => MediaQuery.of(this).padding.top;

  /// 返回导航栏高度
  double get navigationBarHeight => MediaQuery.of(this).padding.bottom;

  /// 返回当前主题上下文
  ThemeData get theme => Theme.of(this);

  /// 返回主颜色 
  Color get primaryColor => theme.primaryColor;

  /// 返回次颜色 
  Color get accentColor => theme.hintColor;

  /// 返回架构背景色 
  Color get scaffoldBackgroundColor => theme.scaffoldBackgroundColor;

  /// 返回卡颜色 
  Color get cardColor => theme.cardColor;

  /// 返回分隔符颜色 
  Color get dividerColor => theme.dividerColor;

  /// 返回分隔符颜色 
  Color get iconColor => theme.iconTheme.color!;

  /// 聚焦到指定的FocusNode
  void requestFocus(FocusNode focus) {
    FocusScope.of(this).requestFocus(focus);
  }

  /// 判断是否iPhone设备
  bool isPhone() => MediaQuery.of(this).size.width < tabletBreakpointGlobal;

  /// 判断是否平板设备
  bool isTablet() =>
      MediaQuery.of(this).size.width < desktopBreakpointGlobal &&
      MediaQuery.of(this).size.width >= tabletBreakpointGlobal;

  /// 判断是否桌面设备
  bool isDesktop() => MediaQuery.of(this).size.width >= desktopBreakpointGlobal;
}
