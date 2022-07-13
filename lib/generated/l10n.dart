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
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
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
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `replace your watchFace`
  String get appName {
    return Intl.message(
      'replace your watchFace',
      name: 'appName',
      desc: '',
      args: [],
    );
  }

  /// `Mi Fitness Replacement`
  String get healthEntry {
    return Intl.message(
      'Mi Fitness Replacement',
      name: 'healthEntry',
      desc: '',
      args: [],
    );
  }

  /// `zepp Life Replacement`
  String get zeppLifeEntry {
    return Intl.message(
      'zepp Life Replacement',
      name: 'zeppLifeEntry',
      desc: '',
      args: [],
    );
  }

  /// `☕buy the author a cup of coffee👈`
  String get rewardMe {
    return Intl.message(
      '☕buy the author a cup of coffee👈',
      name: 'rewardMe',
      desc: '',
      args: [],
    );
  }

  /// `please select the WatchFace first`
  String get firstSelectFace {
    return Intl.message(
      'please select the WatchFace first',
      name: 'firstSelectFace',
      desc: '',
      args: [],
    );
  }

  /// `please grant permission first`
  String get firstGivePromise {
    return Intl.message(
      'please grant permission first',
      name: 'firstGivePromise',
      desc: '',
      args: [],
    );
  }

  /// `deleted existing WatchFace`
  String get deletedNowFace {
    return Intl.message(
      'deleted existing WatchFace',
      name: 'deletedNowFace',
      desc: '',
      args: [],
    );
  }

  /// `no age of mars WatchFace found, please install and use the WatchFace first:`
  String get dontFundWatchFace {
    return Intl.message(
      'no age of mars WatchFace found, please install and use the WatchFace first:',
      name: 'dontFundWatchFace',
      desc: '',
      args: [],
    );
  }

  /// `age of mars`
  String get targetName {
    return Intl.message(
      'age of mars',
      name: 'targetName',
      desc: '',
      args: [],
    );
  }

  /// `replacement completed`
  String get replaceSuccess {
    return Intl.message(
      'replacement completed',
      name: 'replaceSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Tips`
  String get tips_title {
    return Intl.message(
      'Tips',
      name: 'tips_title',
      desc: '',
      args: [],
    );
  }

  /// `got it`
  String get gotIt {
    return Intl.message(
      'got it',
      name: 'gotIt',
      desc: '',
      args: [],
    );
  }

  /// `Customizing the replaced WatchFace requires permission to access the WatchFace directory, please select 'Use this folder' on the next page`
  String get health_setTipsContent {
    return Intl.message(
      'Customizing the replaced WatchFace requires permission to access the WatchFace directory, please select \'Use this folder\' on the next page',
      name: 'health_setTipsContent',
      desc: '',
      args: [],
    );
  }

  /// `directions for use: \n       To replace a WatchFace, you need to apply the [$targetName] WatchFace in the Band displays online first. and then back to Local, open [$targetName] and stay on the WatchFace apply page. place Mi Fitness in the background and then open this app to start following the steps.`
  String get health_shiYongShuoMing {
    return Intl.message(
      'directions for use: \n       To replace a WatchFace, you need to apply the [\$targetName] WatchFace in the Band displays online first. and then back to Local, open [\$targetName] and stay on the WatchFace apply page. place Mi Fitness in the background and then open this app to start following the steps.',
      name: 'health_shiYongShuoMing',
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
      Locale.fromSubtags(languageCode: 'zh'),
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
