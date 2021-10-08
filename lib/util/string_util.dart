class StringUtil {

  static bool isValidEmail(String email) {
    String pattern = "^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*\$";
    return RegExp(pattern).hasMatch(email);
  }

  static bool isValidPhone(String phone) {
    // String pattern = "^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[8-9])|(147,145))\\d{8}\$";
    String pattern = "^(13[0-9]|14[01456879]|15[0-35-9]|16[2567]|17[0-8]|18[0-9]|19[0-35-9])\\d{8}\$";
    return RegExp(pattern).hasMatch(phone);
  }

  static bool isValidBankCard(String cardNo) {
    String pattern = "^([1-9]{1})(\\d{14}|\\d{15}|\\d{18})\$";
    return RegExp(pattern).hasMatch(cardNo);
  }

}