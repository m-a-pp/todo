import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

export 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Localization {
  static const en = Locale('en');
  static const ru = Locale('ru');

  static const supportedLocales = [en, ru];

  static LocalizationsDelegate<AppLocalizations> get delegate =>
      AppLocalizations.delegate;

  static AppLocalizations of(BuildContext context) =>
      AppLocalizations.of(context)!;
  
  const Localization._();
}
