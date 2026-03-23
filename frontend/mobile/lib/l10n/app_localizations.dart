import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_mn.dart';

// ignore_for_file: type=lint

abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('mn'),
  ];

  // ── Existing keys ──────────────────────────────────────────
  String get settings;
  String get darkMode;
  String get notifications;
  String get language;
  String get login;
  String get register;
  String get email;
  String get password;
  String get name;
  String get dashboard;
  String get todaySteps;
  String get totalSteps;
  String get distance;
  String get calories;
  String get history;
  String get rewards;
  String get profile;
  String get logout;
  String get save;
  String get cancel;

  // ── New keys ───────────────────────────────────────────────
  String get pointsAvailable;
  String get available;
  String get thisWeek;
  String get points;
  String get days;
  String get editProfile;
  String get healthDetails;
  String get helpSupport;
  String get streak;
  String get todayPoints;
  String get keepWalking;
  String get moreSteps;
  String get goal;
  String get dailyActivity;
  String get yourBalance;
  String get chooseLanguage;
  String get enableNotifications;
  String get appLanguage;
  String get postpone;
  String get openSettings;
  String get healthPermissionTitle;
  String get healthPermissionDesc;
  String get setDailyGoal;
  String get enterSteps;
  String get steps;
  String get time;
  String get saveChanges;
  String get changePhoto;
  String get updateHealthInfo;
  String get calculatedStats;
  String get weAreHereToHelp;
  String get faq;
  String get howEarnPoints;
  String get howEarnPointsAnswer;
  String get howRedeemRewards;
  String get howRedeemRewardsAnswer;
  String get canTransferPoints;
  String get canTransferPointsAnswer;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(
        lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'mn'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'mn':
      return AppLocalizationsMn();
  }
  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale".');
}
