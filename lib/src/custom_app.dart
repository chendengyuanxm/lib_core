// import 'package:flutter/material.dart';
// import 'package:lib_core/src/provider/localization_provider.dart';
// import 'package:lib_core/src/provider/theme_provider.dart';
// import 'package:lib_core/src/service/index.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:lib_core/generated/l10n.dart';
//
// class CustomApp extends StatelessWidget {
//
//   final String title;
//   final Size designSize;
//   final Widget? home;
//   final ThemeData? theme;
//   final GlobalKey<NavigatorState>? navigatorKey;
//   final RouteFactory? onGenerateRoute;
//
//   const CustomApp({Key? key, required this.title, required this.designSize, this.home, this.theme, this.navigatorKey, this.onGenerateRoute}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilInit(
//       designSize: designSize,
//       builder: () => MaterialApp(
//         title: title,
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData(
//           primaryColor: Provider.of<ThemeProvider>(context).primaryColor,
//           accentColor: Provider.of<ThemeProvider>(context).accentColor,
//           inputDecorationTheme: InputDecorationTheme(
//             enabledBorder: InputBorder.none,
//             focusedBorder: InputBorder.none,
//           ),
//         ),
//         home: home,
//         navigatorKey: navigationKey,
//         onGenerateRoute: onGenerateRoute,
//         localizationsDelegates: [
//           S.delegate,
//           GlobalMaterialLocalizations.delegate,
//           GlobalCupertinoLocalizations.delegate,
//           GlobalWidgetsLocalizations.delegate,
//           // RefreshLocalizations.delegate,
//         ],
//         supportedLocales: S.delegate.supportedLocales,
//         locale: Provider.of<LocalizationProvider>(context).locale,
//       ),
//     );
//   }
// }