import 'package:flutter/cupertino.dart';
import 'package:lib_core/src/util/log_util.dart';
import 'package:lib_core/src/i_core_config.dart';
import 'package:lib_core/src/core_const.dart';

class LocalizationProvider extends ChangeNotifier {
  Locale? _currentLocale;
  Locale? get locale => _currentLocale;
  List<Locale> get supportLocale => CoreConst.coreConfig.supportedLocales;

  LocalizationProvider(BuildContext context) {
    _currentLocale = Localizations.maybeLocaleOf(context);
    LogUtil.v('current locate: $_currentLocale');
  }

  changeCurrentLocale(Locale locale) {
    LogUtil.v('change locate: $locale');
    _currentLocale = locale;
    notifyListeners();
  }
}