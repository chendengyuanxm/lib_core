import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'localization_provider.dart';
import 'theme_provider.dart';
import 'user_provider.dart';

List<SingleChildWidget> core_providers = [
  ...independentServices,
  ...dependentServices,
];

List<SingleChildWidget> independentServices = [
  ChangeNotifierProvider(
    lazy: true,
    create: (context) => LocalizationProvider(context),
  ),
  ChangeNotifierProvider<ThemeProvider>.value(value: ThemeProvider()),
  ChangeNotifierProvider<UserProvider>.value(value: UserProvider()),
];

List<SingleChildWidget> dependentServices = [
  //这里使用ProxyProvider来定义需要依赖其他Provider的服务
];