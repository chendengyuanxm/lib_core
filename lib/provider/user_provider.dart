import 'package:flutter/cupertino.dart';
import 'package:lib_core/model/user_info_entity.dart';

class UserProvider extends ChangeNotifier {
  UserInfo? _userInfo;
  UserInfo? get userInfo => _userInfo;

  setChatUserInfo(UserInfo user) {
    this._userInfo = user;
    notifyListeners();
  }
}