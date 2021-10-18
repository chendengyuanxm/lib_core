import 'dart:convert';
import 'package:lib_core/src/model/user_info_entity.dart';

import 'shared_preference.dart';

const TOKEN = "token";
const USER_INFO = "userInfo";
const LAST_LOGIN_USER_NAME = "lastLoginUserName";

class LocalStorage {
  static Future<String?> getToken() async {
    return await SharedPreference.get(TOKEN);
  }

  static Future<bool> setToken(String token) async {
    return await SharedPreference.set(TOKEN, token);
  }

  static Future<bool> setUserInfo(UserInfo? userInfo) async {
    return await SharedPreference.set(USER_INFO, userInfo == null ? '' : jsonEncode(userInfo));
  }

  static Future<UserInfo?> getUserInfo() async {
    String? json = await SharedPreference.get(USER_INFO);
    return json == null || json.isEmpty ? null : UserInfo().fromJson(jsonDecode(json));
  }
}
