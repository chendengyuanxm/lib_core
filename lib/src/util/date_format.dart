/// Outputs year as four digits
///
/// Example:
///     formatDate(DateTime(1989), [yyyy]);
///     // => 1989
const String yyyy = 'yyyy';

/// Outputs year as two digits
///
/// Example:
///     formatDate(DateTime(1989), [yy]);
///     // => 89
const String yy = 'yy';

/// Outputs month as two digits
///
/// Example:
///     formatDate(DateTime(1989, 11), [mm]);
///     // => 11
///     formatDate(DateTime(1989, 5), [mm]);
///     // => 05
const String mm = 'mm';

/// Outputs month compactly
///
/// Example:
///     formatDate(DateTime(1989, 11), [mm]);
///     // => 11
///     formatDate(DateTime(1989, 5), [m]);
///     // => 5
const String m = 'm';

/// Outputs month as long name
///
/// Example:
///     formatDate(DateTime(1989, 2), [MM]);
///     // => february
const String MM = 'MM';

/// Outputs month as short name
///
/// Example:
///     formatDate(DateTime(1989, 2), [M]);
///     // => feb
const String M = 'M';

/// Outputs day as two digits
///
/// Example:
///     formatDate(DateTime(1989, 2, 21), [dd]);
///     // => 21
///     formatDate(DateTime(1989, 2, 5), [dd]);
///     // => 05
const String dd = 'dd';

/// Outputs day compactly
///
/// Example:
///     formatDate(DateTime(1989, 2, 21), [d]);
///     // => 21
///     formatDate(DateTime(1989, 2, 5), [d]);
///     // => 5
const String d = 'd';

/// Outputs week in month
///
/// Example:
///     formatDate(DateTime(1989, 2, 21), [w]);
///     // => 4
const String w = 'w';

/// Outputs week in year as two digits
///
/// Example:
///     formatDate(DateTime(1989, 12, 31), [W]);
///     // => 53
///     formatDate(DateTime(1989, 2, 21), [W]);
///     // => 08
const String WW = 'WW';

/// Outputs week in year compactly
///
/// Example:
///     formatDate(DateTime(1989, 2, 21), [W]);
///     // => 8
const String W = 'W';

/// Outputs week day as long name
///
/// Example:
///     formatDate(DateTime(2018, 1, 14), [DD]);
///     // => sunday
const String DD = 'DD';

/// Outputs week day as long name
///
/// Example:
///     formatDate(DateTime(2018, 1, 14), [D]);
///     // => sun
const String D = 'D';

/// Outputs hour (0 - 11) as two digits
///
/// Example:
///     formatDate(DateTime(1989, 02, 1, 15), [hh]);
///     // => 03
const String hh = 'hh';

/// Outputs hour (0 - 11) compactly
///
/// Example:
///     formatDate(DateTime(1989, 02, 1, 15), [h]);
///     // => 3
const String h = 'h';

/// Outputs hour (0 to 23) as two digits
///
/// Example:
///     formatDate(DateTime(1989, 02, 1, 15), [HH]);
///     // => 15
const String HH = 'HH';

/// Outputs hour (0 to 23) compactly
///
/// Example:
///     formatDate(DateTime(1989, 02, 1, 5), [H]);
///     // => 5
const String H = 'H';

/// Outputs minute as two digits
///
/// Example:
///     formatDate(DateTime(1989, 02, 1, 15, 40), [nn]);
///     // => 40
///     formatDate(DateTime(1989, 02, 1, 15, 4), [nn]);
///     // => 04
const String nn = 'nn';

/// Outputs minute compactly
///
/// Example:
///     formatDate(DateTime(1989, 02, 1, 15, 4), [n]);
///     // => 4
const String n = 'n';

/// Outputs second as two digits
///
/// Example:
///     formatDate(DateTime(1989, 02, 1, 15, 40, 10), [ss]);
///     // => 10
///     formatDate(DateTime(1989, 02, 1, 15, 40, 5), [ss]);
///     // => 05
const String ss = 'ss';

/// Outputs second compactly
///
/// Example:
///     formatDate(DateTime(1989, 02, 1, 15, 40, 5), [s]);
///     // => 5
const String s = 's';

/// Outputs millisecond as three digits
///
/// Example:
///     formatDate(DateTime(1989, 02, 1, 15, 40, 10, 999), [SSS]);
///     // => 999
///     formatDate(DateTime(1989, 02, 1, 15, 40, 10, 99), [SS]);
///     // => 099
///     formatDate(DateTime(1989, 02, 1, 15, 40, 10, 0), [SS]);
///     // => 009
const String SSS = 'SSS';

/// Outputs millisecond compactly
///
/// Example:
///     formatDate(DateTime(1989, 02, 1, 15, 40, 10, 999), [SSS]);
///     // => 999
///     formatDate(DateTime(1989, 02, 1, 15, 40, 10, 99), [SS]);
///     // => 99
///     formatDate(DateTime(1989, 02, 1, 15, 40, 10, 9), [SS]);
///     // => 9
const String S1 = 'S';

/// Outputs microsecond as three digits
///
/// Example:
///     formatDate(DateTime(1989, 02, 1, 15, 40, 10, 0, 999), [uuu]);
///     // => 999
///     formatDate(DateTime(1989, 02, 1, 15, 40, 10, 0, 99), [uuu]);
///     // => 099
///     formatDate(DateTime(1989, 02, 1, 15, 40, 10, 0, 9), [uuu]);
///     // => 009
const String uuu = 'uuu';

/// Outputs millisecond compactly
///
/// Example:
///     formatDate(DateTime(1989, 02, 1, 15, 40, 10, 0, 999), [u]);
///     // => 999
///     formatDate(DateTime(1989, 02, 1, 15, 40, 10, 0, 99), [u]);
///     // => 99
///     formatDate(DateTime(1989, 02, 1, 15, 40, 10, 0, 9), [u]);
///     // => 9
const String u = 'u';

/// Outputs if hour is AM or PM
///
/// Example:
///     print(formatDate(DateTime(1989, 02, 1, 5), [am]));
///     // => AM
///     print(formatDate(DateTime(1989, 02, 1, 15), [am]));
///     // => PM
const String am = 'am';

/// Outputs timezone as time offset
///
/// Example:
///
const String z = 'z';
const String Z = 'Z';

String formatDate(DateTime date, List<String> formats) {
  final sb = StringBuffer();

  for (String format in formats) {
    if (format == yyyy) {
      sb.write(_digits(date.year, 4));
    } else if (format == yy) {
      sb.write(_digits(date.year % 100, 2));
    } else if (format == mm) {
      sb.write(_digits(date.month, 2));
    } else if (format == m) {
      sb.write(date.month);
    } else if (format == MM) {
      sb.write(monthLong[date.month - 1]);
    } else if (format == M) {
      sb.write(monthShort[date.month - 1]);
    } else if (format == dd) {
      sb.write(_digits(date.day, 2));
    } else if (format == d) {
      sb.write(date.day);
    } else if (format == w) {
      sb.write((date.day + 7) ~/ 7);
    } else if (format == W) {
      sb.write((dayInYear(date) + 7) ~/ 7);
    } else if (format == WW) {
      sb.write(_digits((dayInYear(date) + 7) ~/ 7, 2));
    } else if (format == DD) {
      sb.write(dayLong[date.weekday - 1]);
    } else if (format == D) {
      sb.write(dayShort[date.weekday - 1]);
    } else if (format == HH) {
      sb.write(_digits(date.hour, 2));
    } else if (format == H) {
      sb.write(date.hour);
    } else if (format == hh) {
      int hour = date.hour % 12;
      if (hour == 0) hour = 12;
      sb.write(_digits(hour, 2));
    } else if (format == h) {
      int hour = date.hour % 12;
      if (hour == 0) hour = 12;
      sb.write(hour);
    } else if (format == am) {
      sb.write(date.hour < 12 ? 'AM' : 'PM');
    } else if (format == nn) {
      sb.write(_digits(date.minute, 2));
    } else if (format == n) {
      sb.write(date.minute);
    } else if (format == ss) {
      sb.write(_digits(date.second, 2));
    } else if (format == s) {
      sb.write(date.second);
    } else if (format == SSS) {
      sb.write(_digits(date.millisecond, 3));
    } else if (format == S1) {
      sb.write(date.second);
    } else if (format == uuu) {
      sb.write(_digits(date.microsecond, 2));
    } else if (format == u) {
      sb.write(date.microsecond);
    } else if (format == z) {
      if (date.timeZoneOffset.inMinutes == 0) {
        sb.write('Z');
      } else {
        if (date.timeZoneOffset.isNegative) {
          sb.write('-');
          sb.write(_digits((-date.timeZoneOffset.inHours) % 24, 2));
          sb.write(_digits((-date.timeZoneOffset.inMinutes) % 60, 2));
        } else {
          sb.write('+');
          sb.write(_digits(date.timeZoneOffset.inHours % 24, 2));
          sb.write(_digits(date.timeZoneOffset.inMinutes % 60, 2));
        }
      }
    } else if (format == Z) {
      sb.write(date.timeZoneName);
    } else {
      sb.write(format);
    }
  }

  return sb.toString();
}

formatDateString(
  String dateString, {
  List<String> formats: const [
    yyyy,
    '-',
    mm,
    '-',
    dd,
    ' ',
    HH,
    ':',
    nn,
    ":",
    ss
  ],
}) {
  try {
    DateTime date = DateTime.parse(dateString);
    return formatDate(date, formats);
  } catch (error) {
    print(error);
  }

  return '';
}

formatDateTimestamp(
  int timeStamp, {
  List<String> formats: const [yyyy, '年', mm, '月', dd, '日 ', HH, ':', nn],
}) {
  try {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timeStamp, isUtc: false);
    return formatDate(date, formats);
  } catch (error) {
    print(error);
  }

  return '';
}

String _digits(int value, int length) {
  String ret = '$value';
  if (ret.length < length) {
    ret = '0' * (length - ret.length) + ret;
  }
  return ret;
}

const List<String> monthShort = const <String>[
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec'
];

const List<String> monthLong = const <String>[
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'
];

const List<String> dayShort = const [
  'Mon',
  'Tue',
  'Wed',
  'Thur',
  'Fri',
  'Sat',
  'Sun'
];

const List<String> dayLong = const [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday'
];

int dayInYear(DateTime date) =>
    date.difference(DateTime(date.year, 1, 1)).inDays;

///根据日期，返回星座
String getConstellation(String timeStamp) {
  if (timeStamp.isEmpty) return '';
  DateTime birthday = DateTime.fromMillisecondsSinceEpoch(
      int.tryParse(timeStamp)!,
      isUtc: false);
  final String capricorn = '摩羯座'; //Capricorn 摩羯座（12月22日～1月20日）
  final String aquarius = '水瓶座'; //Aquarius 水瓶座（1月21日～2月19日）
  final String pisces = '双鱼座'; //Pisces 双鱼座（2月20日～3月20日）
  final String aries = '白羊座'; //3月21日～4月20日
  final String taurus = '金牛座'; //4月21～5月21日
  final String gemini = '双子座'; //5月22日～6月21日
  final String cancer = '巨蟹座'; //Cancer 巨蟹座（6月22日～7月22日）
  final String leo = '狮子座'; //Leo 狮子座（7月23日～8月23日）
  final String virgo = '处女座'; //Virgo 处女座（8月24日～9月23日）
  final String libra = '天秤座'; //Libra 天秤座（9月24日～10月23日）
  final String scorpio = '天蝎座'; //Scorpio 天蝎座（10月24日～11月22日）
  final String sagittarius = '射手座'; //Sagittarius 射手座（11月23日～12月21日）

  int month = birthday.month;
  int day = birthday.day;
  String constellation = '';

  switch (month) {
    case DateTime.january:
      constellation = day < 21 ? capricorn : aquarius;
      break;
    case DateTime.february:
      constellation = day < 20 ? aquarius : pisces;
      break;
    case DateTime.march:
      constellation = day < 21 ? pisces : aries;
      break;
    case DateTime.april:
      constellation = day < 21 ? aries : taurus;
      break;
    case DateTime.may:
      constellation = day < 22 ? taurus : gemini;
      break;
    case DateTime.june:
      constellation = day < 22 ? gemini : cancer;
      break;
    case DateTime.july:
      constellation = day < 23 ? cancer : leo;
      break;
    case DateTime.august:
      constellation = day < 24 ? leo : virgo;
      break;
    case DateTime.september:
      constellation = day < 24 ? virgo : libra;
      break;
    case DateTime.october:
      constellation = day < 24 ? libra : scorpio;
      break;
    case DateTime.november:
      constellation = day < 23 ? scorpio : sagittarius;
      break;
    case DateTime.december:
      constellation = day < 22 ? sagittarius : capricorn;
      break;
  }

  return constellation;
}
