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

  /// `偷天换日`
  String get appName {
    return Intl.message(
      '偷天换日',
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

  /// `Install WatchFace via Bluetooth`
  String get bleEntry {
    return Intl.message(
      'Install WatchFace via Bluetooth',
      name: 'bleEntry',
      desc: '',
      args: [],
    );
  }

  /// `☕buy the developers a cup of coffee👈`
  String get rewardMe {
    return Intl.message(
      '☕buy the developers a cup of coffee👈',
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

  /// `App has successfully obtained permissions`
  String get getPromise {
    return Intl.message(
      'App has successfully obtained permissions',
      name: 'getPromise',
      desc: '',
      args: [],
    );
  }

  /// `App does not have permission`
  String get notPromise {
    return Intl.message(
      'App does not have permission',
      name: 'notPromise',
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

  /// `Failed to delete the WatchFace`
  String get delFaceFail {
    return Intl.message(
      'Failed to delete the WatchFace',
      name: 'delFaceFail',
      desc: '',
      args: [],
    );
  }

  /// `All files have been deleted`
  String get clearDirectorySuccess {
    return Intl.message(
      'All files have been deleted',
      name: 'clearDirectorySuccess',
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

  /// `replacement fail`
  String get replaceFail {
    return Intl.message(
      'replacement fail',
      name: 'replaceFail',
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

  /// `working status: `
  String get workingState {
    return Intl.message(
      'working status: ',
      name: 'workingState',
      desc: '',
      args: [],
    );
  }

  /// `replacement in progress`
  String get working {
    return Intl.message(
      'replacement in progress',
      name: 'working',
      desc: '',
      args: [],
    );
  }

  /// `waiting for the start`
  String get noWorking {
    return Intl.message(
      'waiting for the start',
      name: 'noWorking',
      desc: '',
      args: [],
    );
  }

  /// `sure`
  String get sure {
    return Intl.message(
      'sure',
      name: 'sure',
      desc: '',
      args: [],
    );
  }

  /// `cancel`
  String get cancel {
    return Intl.message(
      'cancel',
      name: 'cancel',
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

  /// `copy to Mi Fitness`
  String get health_appbarTitle {
    return Intl.message(
      'copy to Mi Fitness',
      name: 'health_appbarTitle',
      desc: '',
      args: [],
    );
  }

  /// `\nthe features on this page are only available for Xiaomi Band 7 + Mi Fitness`
  String get health_waring {
    return Intl.message(
      '\nthe features on this page are only available for Xiaomi Band 7 + Mi Fitness',
      name: 'health_waring',
      desc: '',
      args: [],
    );
  }

  /// `give me permission to the internal data`
  String get health_step1 {
    return Intl.message(
      'give me permission to the internal data',
      name: 'health_step1',
      desc: '',
      args: [],
    );
  }

  /// `(have permission)`
  String get health_step1_state {
    return Intl.message(
      '(have permission)',
      name: 'health_step1_state',
      desc: '',
      args: [],
    );
  }

  /// `select the WatchFace you want to replace`
  String get health_step2 {
    return Intl.message(
      'select the WatchFace you want to replace',
      name: 'health_step2',
      desc: '',
      args: [],
    );
  }

  /// `selected:`
  String get health_step2_state {
    return Intl.message(
      'selected:',
      name: 'health_step2_state',
      desc: '',
      args: [],
    );
  }

  /// `began to replace`
  String get health_step3 {
    return Intl.message(
      'began to replace',
      name: 'health_step3',
      desc: '',
      args: [],
    );
  }

  /// `open Mi Fitness and apply the [$targetName] WatchFace`
  String get health_step4 {
    return Intl.message(
      'open Mi Fitness and apply the [\$targetName] WatchFace',
      name: 'health_step4',
      desc: '',
      args: [],
    );
  }

  /// `other tools`
  String get health_otherTools {
    return Intl.message(
      'other tools',
      name: 'health_otherTools',
      desc: '',
      args: [],
    );
  }

  /// `clear the WatchFace directory`
  String get health_clearWatchFace {
    return Intl.message(
      'clear the WatchFace directory',
      name: 'health_clearWatchFace',
      desc: '',
      args: [],
    );
  }

  /// `Set up the success`
  String get set_target_setSuccess {
    return Intl.message(
      'Set up the success',
      name: 'set_target_setSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Note watchFace name`
  String get set_target_noteTitle {
    return Intl.message(
      'Note watchFace name',
      name: 'set_target_noteTitle',
      desc: '',
      args: [],
    );
  }

  /// `Because the file name is not readable, you need to manually enter the name of the WatchFace that corresponds to the file for later correspondence.`
  String get set_target_noteDesc {
    return Intl.message(
      'Because the file name is not readable, you need to manually enter the name of the WatchFace that corresponds to the file for later correspondence.',
      name: 'set_target_noteDesc',
      desc: '',
      args: [],
    );
  }

  /// `Please enter watchFace name here`
  String get set_target_inputHint {
    return Intl.message(
      'Please enter watchFace name here',
      name: 'set_target_inputHint',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the name of the WatchFace you selected for remarks`
  String get set_target_noNameToast {
    return Intl.message(
      'Please enter the name of the WatchFace you selected for remarks',
      name: 'set_target_noNameToast',
      desc: '',
      args: [],
    );
  }

  /// `If you know the name of the file that corresponds to the replaced WatchFace, you can select the file here. The app will save the Settings and replace the files you choose later.\n\nIt is recommended to install the dial to be selected normally before selection to avoid incorrect information obtained by APP.`
  String get set_target_shuoMing {
    return Intl.message(
      'If you know the name of the file that corresponds to the replaced WatchFace, you can select the file here. The app will save the Settings and replace the files you choose later.\n\nIt is recommended to install the dial to be selected normally before selection to avoid incorrect information obtained by APP.',
      name: 'set_target_shuoMing',
      desc: '',
      args: [],
    );
  }

  /// `Customize the replacement watchFace file`
  String get set_target_appbar_title {
    return Intl.message(
      'Customize the replacement watchFace file',
      name: 'set_target_appbar_title',
      desc: '',
      args: [],
    );
  }

  /// `file list`
  String get set_target_file_list {
    return Intl.message(
      'file list',
      name: 'set_target_file_list',
      desc: '',
      args: [],
    );
  }

  /// `Unknown File`
  String get set_target_unknownFile {
    return Intl.message(
      'Unknown File',
      name: 'set_target_unknownFile',
      desc: '',
      args: [],
    );
  }

  /// `File name: `
  String get set_target_fileName {
    return Intl.message(
      'File name: ',
      name: 'set_target_fileName',
      desc: '',
      args: [],
    );
  }

  /// `File length: `
  String get set_target_fileSize {
    return Intl.message(
      'File length: ',
      name: 'set_target_fileSize',
      desc: '',
      args: [],
    );
  }

  /// `Select`
  String get set_target_select {
    return Intl.message(
      'Select',
      name: 'set_target_select',
      desc: '',
      args: [],
    );
  }

  /// `the replacement succeeded. please apply the [$targetName] WatchFace in the Zepp Life local WatchFace`
  String get zepplife_success {
    return Intl.message(
      'the replacement succeeded. please apply the [\$targetName] WatchFace in the Zepp Life local WatchFace',
      name: 'zepplife_success',
      desc: '',
      args: [],
    );
  }

  /// `Failed to create directory. Please install WatchFace in 'zepp life' first`
  String get zepplife_createDirFail {
    return Intl.message(
      'Failed to create directory. Please install WatchFace in \'zepp life\' first',
      name: 'zepplife_createDirFail',
      desc: '',
      args: [],
    );
  }

  /// `directions for use: \n    The first step is to select the WatchFace you want to replace. Step 2, give me permission. Step 3, click replace now, open the WatchFace management in the 'zepp life', there is a [$targetName] WatchFace in the local WatchFace, click apply watchFace.`
  String get zepplife_shiYongShuoMing {
    return Intl.message(
      'directions for use: \n    The first step is to select the WatchFace you want to replace. Step 2, give me permission. Step 3, click replace now, open the WatchFace management in the \'zepp life\', there is a [\$targetName] WatchFace in the local WatchFace, click apply watchFace.',
      name: 'zepplife_shiYongShuoMing',
      desc: '',
      args: [],
    );
  }

  /// `copy to Zepp Life`
  String get zepplife_appbarTitle {
    return Intl.message(
      'copy to Zepp Life',
      name: 'zepplife_appbarTitle',
      desc: '',
      args: [],
    );
  }

  /// `\nthe features on this page are only available for Xiaomi Band 7 + Zepp Life`
  String get zepplife_waring {
    return Intl.message(
      '\nthe features on this page are only available for Xiaomi Band 7 + Zepp Life',
      name: 'zepplife_waring',
      desc: '',
      args: [],
    );
  }

  /// `select the WatchFace you want to replace`
  String get zepplife_step1 {
    return Intl.message(
      'select the WatchFace you want to replace',
      name: 'zepplife_step1',
      desc: '',
      args: [],
    );
  }

  /// `selected: `
  String get zepplife_step1_state {
    return Intl.message(
      'selected: ',
      name: 'zepplife_step1_state',
      desc: '',
      args: [],
    );
  }

  /// `give me permission to the internal data`
  String get zepplife_step2 {
    return Intl.message(
      'give me permission to the internal data',
      name: 'zepplife_step2',
      desc: '',
      args: [],
    );
  }

  /// `(have permission)`
  String get zepplife_step2_state {
    return Intl.message(
      '(have permission)',
      name: 'zepplife_step2_state',
      desc: '',
      args: [],
    );
  }

  /// `Immediately replace`
  String get zepplife_step3 {
    return Intl.message(
      'Immediately replace',
      name: 'zepplife_step3',
      desc: '',
      args: [],
    );
  }

  /// `Reward developers`
  String get pay_title {
    return Intl.message(
      'Reward developers',
      name: 'pay_title',
      desc: '',
      args: [],
    );
  }

  /// `scan band`
  String get ble_scan {
    return Intl.message(
      'scan band',
      name: 'ble_scan',
      desc: '',
      args: [],
    );
  }

  /// `scanning`
  String get ble_scanning {
    return Intl.message(
      'scanning',
      name: 'ble_scanning',
      desc: '',
      args: [],
    );
  }

  /// `Bluetooth install`
  String get ble_title {
    return Intl.message(
      'Bluetooth install',
      name: 'ble_title',
      desc: '',
      args: [],
    );
  }

  /// `connection`
  String get ble_connect {
    return Intl.message(
      'connection',
      name: 'ble_connect',
      desc: '',
      args: [],
    );
  }

  /// `connecting`
  String get ble_connecting {
    return Intl.message(
      'connecting',
      name: 'ble_connecting',
      desc: '',
      args: [],
    );
  }

  /// `device connected`
  String get ble_connected {
    return Intl.message(
      'device connected',
      name: 'ble_connected',
      desc: '',
      args: [],
    );
  }

  /// `Connection failed. Please try again`
  String get ble_connectFail {
    return Intl.message(
      'Connection failed. Please try again',
      name: 'ble_connectFail',
      desc: '',
      args: [],
    );
  }

  /// `Bluetooth connection is disconnected`
  String get ble_disconnected {
    return Intl.message(
      'Bluetooth connection is disconnected',
      name: 'ble_disconnected',
      desc: '',
      args: [],
    );
  }

  /// `connected to: `
  String get ble_connectedTo {
    return Intl.message(
      'connected to: ',
      name: 'ble_connectedTo',
      desc: '',
      args: [],
    );
  }

  /// `Select WatchFace`
  String get ble_select_file {
    return Intl.message(
      'Select WatchFace',
      name: 'ble_select_file',
      desc: '',
      args: [],
    );
  }

  /// `Reselect WatchFace`
  String get ble_reselectFile {
    return Intl.message(
      'Reselect WatchFace',
      name: 'ble_reselectFile',
      desc: '',
      args: [],
    );
  }

  /// `selected: `
  String get ble_selected {
    return Intl.message(
      'selected: ',
      name: 'ble_selected',
      desc: '',
      args: [],
    );
  }

  /// `Install Now`
  String get ble_install {
    return Intl.message(
      'Install Now',
      name: 'ble_install',
      desc: '',
      args: [],
    );
  }

  /// `Installation progress: `
  String get ble_installProgress {
    return Intl.message(
      'Installation progress: ',
      name: 'ble_installProgress',
      desc: '',
      args: [],
    );
  }

  /// `Undiscovered service`
  String get ble_notFindService {
    return Intl.message(
      'Undiscovered service',
      name: 'ble_notFindService',
      desc: '',
      args: [],
    );
  }

  /// `Operation timed out`
  String get ble_timeout {
    return Intl.message(
      'Operation timed out',
      name: 'ble_timeout',
      desc: '',
      args: [],
    );
  }

  /// `Install Fail`
  String get ble_install_fail {
    return Intl.message(
      'Install Fail',
      name: 'ble_install_fail',
      desc: '',
      args: [],
    );
  }

  /// `Install Success`
  String get ble_install_success {
    return Intl.message(
      'Install Success',
      name: 'ble_install_success',
      desc: '',
      args: [],
    );
  }

  /// `Disclaimer: This feature has not been fully tested and the developer is not responsible for any consequences caused by its use.`
  String get ble_tips {
    return Intl.message(
      'Disclaimer: This feature has not been fully tested and the developer is not responsible for any consequences caused by its use.',
      name: 'ble_tips',
      desc: '',
      args: [],
    );
  }

  /// `If your band cannot be scanned, please enable 'Discoverable mode' in ZeppLife or Mi Fitness.`
  String get ble_tips2 {
    return Intl.message(
      'If your band cannot be scanned, please enable \'Discoverable mode\' in ZeppLife or Mi Fitness.',
      name: 'ble_tips2',
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
