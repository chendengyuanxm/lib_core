import 'package:lib_core/src/model/user_info_entity.dart';

userInfoFromJson(UserInfo data, Map<String, dynamic> json) {
	if (json['name'] != null) {
		data.name = json['name'].toString();
	}
	if (json['passwd'] != null) {
		data.passwd = json['passwd'].toString();
	}
	if (json['token'] != null) {
		data.token = json['token'].toString();
	}
	return data;
}

Map<String, dynamic> userInfoToJson(UserInfo entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['name'] = entity.name;
	data['passwd'] = entity.passwd;
	data['token'] = entity.token;
	return data;
}