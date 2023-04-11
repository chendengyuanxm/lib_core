import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:lib_core/lib_core.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:stetho_network_inspector/stetho_network_inspector.dart';

import 'provider/core_providers.dart';
import 'service/index.dart';

void runPreMain() async {
  WidgetsFlutterBinding.ensureInitialized();
  /// 打印APP INFO
  await _displayAppInfo();
  /// 检测网络
  await _checkConnectivity();
  /// 调试开关
  _debugOptions();
  /// 注册服务
  setupServices();
  /// android 状态栏为透明的沉浸
  if (Platform.isAndroid) {
    Stetho.initialize();
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
  /// 初始化FlutterDownload
  await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
}

void runPreApp(Widget app) {
  runApp(
    MultiProvider(
      providers: coreProviders,
      child: app,
    ),
  );
}

_debugOptions() {
  // debugPaintBaselinesEnabled = true;
  // debugPaintPointersEnabled = true;//标志打开一个特殊模式，任何正在点击的对象都会以深青色突出显示
  // debugPaintLayerBordersEnabled = true; //该标志用橙色或轮廓线标出每个层的边界
  // debugRepaintRainbowEnabled = true;//标志， 只要他们重绘时，这会使该层被一组旋转色所覆盖。（颜色改变以为在重绘，可以看到重绘组件）
  // debugPaintLayerBordersEnabled = true; // 使每个层围绕其边界绘制一个框。
  // debugPaintSizeEnabled = true; //绘制边界， (常用,可以查看是否widget有重叠绘制,)
  // debugPrintMarkNeedsLayoutStacks = true;
  // debugPrintMarkNeedsPaintStacks = true; //重新绘制的原因. （感觉用处不大）
}

_displayAppInfo() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  String appName = packageInfo.appName;
  String packageName = packageInfo.packageName;
  String version = packageInfo.version;
  String buildNumber = packageInfo.buildNumber;
  print("=======App=======");
  print("应用名称$appName");
  print("包名$packageName");
  print("版本号$version");
  print("创建号$buildNumber");
  print("=======End=======");
}

_checkConnectivity() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    // I am connected to a mobile network.
    ToastUtil.show("当前使用移动网络");
  } else if (connectivityResult == ConnectivityResult.wifi) {
    ToastUtil.show("当前使用WIFI网络");
  }
}