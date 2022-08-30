import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  static late SharedPreferences prefs;

  static init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static String? getString(String key, {String? defaultValue}) {
    return prefs.containsKey(key) ? prefs.getString(key) : defaultValue;
  }

  static Future<bool> setString(String key, String value) async {
    return prefs.setString(key, value);
  }

  static int? getInt(String key, {int? defaultValue}) {
    return prefs.containsKey(key) ? prefs.getInt(key) : defaultValue;
  }

  static Future<bool> setInt(String key, int value) {
    return prefs.setInt(key, value);
  }

  static bool? getBool(String key, {bool? defaultValue}) {
    return prefs.containsKey(key) ? prefs.getBool(key) : defaultValue ?? false;
  }

  static Future<bool> setBool(String key, bool value) async {
    return prefs.setBool(key, value);
  }

  static Future<bool> remove(String key) async {
    return await prefs.remove(key);
  }

  static T getJsonObject<T>(String key) {
    var jsonStr = prefs.getString(key);
    return jsonStr != null ? json.decode(jsonStr) : Map<String, dynamic>();
  }

  static Future<bool> setJsonObject<T>(String key, T jsonObject) async {
    return await prefs.setString(key, json.encode(jsonObject));
  }
}
