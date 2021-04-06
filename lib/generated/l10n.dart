// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null, 'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;
 
      return instance;
    });
  } 

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null, 'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `home`
  String get home {
    return Intl.message(
      'home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Please select your date`
  String get hay_chon_ngay_sinh_cua_ban {
    return Intl.message(
      'Please select your date',
      name: 'hay_chon_ngay_sinh_cua_ban',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get xem {
    return Intl.message(
      'Submit',
      name: 'xem',
      desc: '',
      args: [],
    );
  }

  /// `overview`
  String get tong_quan {
    return Intl.message(
      'overview',
      name: 'tong_quan',
      desc: '',
      args: [],
    );
  }

  /// `Life milestones`
  String get moc_cuoc_doi {
    return Intl.message(
      'Life milestones',
      name: 'moc_cuoc_doi',
      desc: '',
      args: [],
    );
  }

  /// `Birth date chart`
  String get bieu_do_ngay_sinh {
    return Intl.message(
      'Birth date chart',
      name: 'bieu_do_ngay_sinh',
      desc: '',
      args: [],
    );
  }

  /// `Select language`
  String get chon_ngon_ngu {
    return Intl.message(
      'Select language',
      name: 'chon_ngon_ngu',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'vi'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}