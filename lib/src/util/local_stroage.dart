import 'dart:convert';
import 'shared_preference.dart';

const TOKEN = "token";
const USER_INFO = "userInfo";

class LocalStorage {
  static Future<String?> getToken() async {
    return await SharedPreference.get(TOKEN);
  }

  static Future<bool> setToken(String token) async {
    return await SharedPreference.set(TOKEN, token);
  }

  static Future<bool> setUserInfo<T>(T? userInfo) async {
    return await SharedPreference.set(USER_INFO, userInfo == null ? '' : jsonEncode(userInfo));
  }

  // todo
  static Future<T?> getUserInfo<T>() async {
    String? json = await SharedPreference.get(USER_INFO);
    return json == null || json.isEmpty ? null : jsonDecode(json);
  }
}
