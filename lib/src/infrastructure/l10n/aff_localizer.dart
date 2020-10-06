import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'locales/messages_all.dart';

class AffLocalizer {
  // workaroud for contextless translation
  // see https://github.com/flutter/flutter/issues/14518#issuecomment-447481671
  static AffLocalizer instance;

  static Future<AffLocalizer> load(Locale locale) {
    final String name =
        locale.countryCode == null ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      instance = AffLocalizer();
      return instance;
    });
  }

  static AffLocalizer of(BuildContext context) {
    return Localizations.of<AffLocalizer>(context, AffLocalizer);
  }

  String get ok => Intl.message('OK');
  String get yes => Intl.message('Yes');
  String get no => Intl.message('No');
  String get cancel => Intl.message('Cancel');
  String get warning => Intl.message('Warning');
  String get error => Intl.message('Error');

  String get newShipment => Intl.message('New');
  String get select => Intl.message('Select');
  String get anUnExpectedErrorOccurred =>
      Intl.message('An unexpected error occurred!');
  String get information => Intl.message('Information');
  String get question => Intl.message('Question');
  String get message => Intl.message('Message');
  String get loading => Intl.message('Loading...');
  String get invalidValue => Intl.message('Invalid value');
  String get requiredValue => Intl.message('Required');
  String get search => Intl.message('Search');
  String get date => Intl.message('Date');
  String get time => Intl.message('Time');
  String get delete => Intl.message('Delete');
  String get noData => Intl.message('No data');
  String get all => Intl.message('All');
  String get recordNotFound => Intl.message('Record not found!');
}

class AffLocalizationsDelegate extends LocalizationsDelegate<AffLocalizer> {
  const AffLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return [const Locale('en'), const Locale('tr')]
        .any((l) => l.languageCode == locale.languageCode);
  }

  @override
  Future<AffLocalizer> load(Locale locale) {
    return AffLocalizer.load(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<AffLocalizer> old) {
    return false;
  }
}
