import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';

class AppSharedPreferences {
  static SharedPreferences? __spf;

  bool isInitialized = false;

  AppSharedPreferences() {
    SharedPreferences.getInstance().then((value) {
      __spf = value;
    });
  }

  init() async {
    if (__spf == null) {
      __spf = await SharedPreferences.getInstance();
    }
  }

  storeToken(String token) {
    if (__spf == null) appSharedPrefs.init();
    __spf!.setString(TOKEN, token);
    print('access token is========================$token');
  }

  getToken() {
    if (__spf == null) appSharedPrefs.init();
    return __spf!.getString(TOKEN) ?? '';
  }

  Future<int?> get selectedGenderStyle async {
    if (__spf == null) appSharedPrefs.init();
    final isShowIntroduction = __spf!.getInt(KEY_SELECTED_GENDER_STYLE);
    if (isShowIntroduction != null) return isShowIntroduction;
    return Future.value(null);
  }

  Future<bool> persistSelectedGenderStyle(int? value) {
    if (__spf == null) appSharedPrefs.init();
    return __spf!.setInt(KEY_SELECTED_GENDER_STYLE, value ?? -1);
  }

  Future<bool?> get selectedNotifyNewProduct async {
    if (__spf == null) appSharedPrefs.init();
    final isShowIntroduction = __spf!.getBool(KEY_SELECTED_NOTIFY_NEW_PRODUCT);
    if (isShowIntroduction != null) return isShowIntroduction;
    return Future.value(null);
  }

  Future<bool> persistSelectedNotifyNewProduct(bool? value) {
    if (__spf == null) appSharedPrefs.init();
    return __spf!.setBool(KEY_SELECTED_NOTIFY_NEW_PRODUCT, value ?? false);
  }

  Future<bool?> get selectedNotifyOffer async {
    if (__spf == null) appSharedPrefs.init();
    final isShowIntroduction = __spf!.getBool(KEY_SELECTED_NOTIFY_OFFER);
    if (isShowIntroduction != null) return isShowIntroduction;
    return Future.value(null);
  }

  Future<bool> persistSelectedNotifyOffer(bool value) {
    if (__spf == null) appSharedPrefs.init();
    return __spf!.setBool(KEY_SELECTED_NOTIFY_OFFER, value);
  }

  Future<bool?> get selectedNotifyWallet async {
    if (__spf == null) appSharedPrefs.init();
    final isShowIntroduction = __spf!.getBool(KEY_SELECTED_NOTIFY_WALLET);
    if (isShowIntroduction != null) return isShowIntroduction;
    return Future.value(null);
  }

  Future<bool> persistSelectedNotifyWallet(bool value) {
    if (__spf == null) appSharedPrefs.init();
    return __spf!.setBool(KEY_SELECTED_NOTIFY_WALLET, value);
  }
}

AppSharedPreferences appSharedPrefs = AppSharedPreferences();
