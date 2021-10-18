import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/core_providers.dart';
import 'service/index.dart';

void runPreMain() {
  WidgetsFlutterBinding.ensureInitialized();
  _debugOptions();
  setupServices();
  // Stetho.initialize();
}

void runPreApp(Widget app) {
  runApp(
    MultiProvider(
      providers: core_providers,
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