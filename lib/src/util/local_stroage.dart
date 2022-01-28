import 'dart:convert';
import 'shared_preference.dart';

const TOKEN = "token";
const USER_INFO = "userInfo";

class LocalStorage {
  static Future<String?> getToken() async {
    return await SharedPreference.getString(TOKEN);
  }

  static Future<bool> setToken(String token) async {
    return await SharedPreference.setString(TOKEN, token);
  }

  static Future<bool> setUserInfo<T>(T? userInfo) async {
    return await SharedPreference.setString(USER_INFO, userInfo == null ? '' : jsonEncode(userInfo));
  }

  // todo
  static Future<T?> getUserInfo<T>() async {
    String? json = await SharedPreference.getString(USER_INFO);
    return json == null || json.isEmpty ? null : jsonDecode(json);
  }
}
