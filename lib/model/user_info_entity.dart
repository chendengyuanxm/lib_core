import 'package:lib_core/generated/json/base/json_convert_content.dart';

class UserInfo with JsonConvert<UserInfo> {
	String? name;
	String? passwd;
	String? token;
}
