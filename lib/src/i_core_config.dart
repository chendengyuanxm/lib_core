import 'package:flutter/material.dart';

/// @author: Devin
/// @date: 2021/11/3 10:44
/// @description: 
abstract class ICoreConfig {
  List<Locale> get supportedLocales;
  MaterialColor get primaryColor;
}