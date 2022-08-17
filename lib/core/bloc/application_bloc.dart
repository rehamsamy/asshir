import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:ojos_app/core/constants.dart';
import 'package:ojos_app/core/database/db.dart';
import 'package:ojos_app/core/entities/extra_glasses_entity.dart';
import 'package:ojos_app/core/res/utils.dart';
import 'package:ojos_app/features/main_root.dart';
import 'package:ojos_app/features/profile/domin/entities/profile_entity.dart';
import 'package:ojos_app/features/user_management/domain/repositories/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'application_events.dart';
import 'application_state.dart';

class ApplicationBloc extends Bloc<ApplicationEvent, ApplicationState> {
  // Indicates if the application is initialized or not.
  var _isInitialized = false;

  final _supportedLanguages = [LANG_AR, LANG_EN];

  ApplicationBloc() : super(ApplicationState.initialState);

  // Supported locales
  Iterable<Locale> get supportedLocales => _supportedLanguages.map(
        (language) => Locale(language, ''),
      );

  ApplicationState get initialState => ApplicationState.initialState;

  @override
  Stream<ApplicationState> mapEventToState(ApplicationEvent event) async* {
    if (event is ApplicationStartedEvent) {
      final newState = await _handleApplicationStartedEvent(event);
      if (newState != null) yield newState;
    }
    if (event is SetApplicationLanguageEvent) {
      yield await _handleSetApplicationLanguageEvent(event);
    }
    if (event is SetExtraGlassesEvent) {
      yield await _handleSetExtraGlassesEvent(event.extraGlassesEntity);
    }
    if (event is SetProfileSplashEvent) {
      yield await _handleSetPRofileSpalshEvent(event.profileEntity);
    }
    if (event is SetUserDataLoginEvent) {
      yield await _handleSetUserProfileEvent();
    }
    if (event is UserLogoutEvent) {
      yield await _handleUserLogoutEvent();
    }
    if (event is GetFCMTokenAndUpdateItEvent) {
      getFCMTokenAndUpdateIt();
      yield this.state;
    }
  }

  Future<ApplicationState> _handleSetUserProfileEvent() async {
    final userData = await UserRepository.cachedUserData;
    return this.state.copyWith(userData: userData);
  }

  Future<ApplicationState?> _handleApplicationStartedEvent(
    ApplicationStartedEvent event,
  ) async {
    // If we already started the app -> stop.
    if (_isInitialized) return null;

    await UserRepository.initSharedPreferences();

    // Init DB for caching.
    await AppDB.init();

    // Init language.
    final language = await _getCurrentLanguage();

    // Init user profile.

    _isInitialized = true;

    return ApplicationState(
      language: language,
    );
  }

  Future<ApplicationState> _handleSetApplicationLanguageEvent(
    SetApplicationLanguageEvent event,
  ) async {
    switch (event.language) {
      case LANG_AR:
        // If the language is already arabic -> don't change anything.
        if (this.state.language == LANG_AR) return this.state;

        final setLanguageResult = await _setLanguage(LANG_AR);
        if (setLanguageResult) {
          return this.state.copyWith(language: LANG_AR);
        }

        return this.state;
      case LANG_EN:
        // If the language is already english -> don't change anything.
        if (this.state.language == LANG_EN) return this.state;

        final setLanguageResult = await _setLanguage(LANG_EN);
        if (setLanguageResult) {
          return this.state.copyWith(language: LANG_EN);
        }

        return this.state;
    }
    return this.state;
  }

  Future<ApplicationState> _handleUserLogoutEvent() async {
    await GetIt.I<UserRepository>().logout();
    await firebaseMessaging.deleteToken();
    return this.state.clearProfile();
  }

  Future<String> _getCurrentLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    var lang = prefs.getString(KEY_LANG);
    if (lang == null || lang.isEmpty) {
      await prefs.setString(KEY_LANG, LANG_AR);
      lang = LANG_AR;
    }
    return lang;
  }

  Future<bool> _setLanguage(String language) async {
    utils.setLang(language);
    // Persist the new language.
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(KEY_LANG, language);
    return true;
  }

  getFCMTokenAndUpdateIt() async {
    await _configureFCM();
  }

  Future<void> _configureFCM() async {
    firebaseMessaging.requestPermission(
      sound: true,
      badge: true,
      alert: true,
      provisional: true,
      announcement: true,
      carPlay: true,
      criticalAlert: false,
    );

    if (Platform.isIOS)
      firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

    // // await _configureFCMToken();
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   RemoteNotification? _notification = message.notification;
    //   // TODO :
    //   // AndroidNotification? _android = message.notification?.android;
    //   print('omar is $message');
    //   if (_notification != null) {
    //     final title = _notification.title;
    //     final body = _notification.body;
    //     final payload = jsonEncode(message.data);
    //     // notificationsService.showNotification(
    //     //     title ?? 'Title', body ?? 'Body', payload);
    //   }
    // });
  }

  Future<ApplicationState> _handleSetExtraGlassesEvent(ExtraGlassesEntity extraGlassesEntity) async {
    return this.state.copyWith(extraGlasses: extraGlassesEntity);
  }

  Future<ApplicationState> _handleSetPRofileSpalshEvent(ProfileEntity? profileEntity) async {
    return this.state.copyWith(profile: profileEntity);
  }

  bool get isInitialized => _isInitialized;
}

// Future<dynamic> backgroundMessageHandler(Map<String, dynamic> message) async {
//   _showNotification(message);
// }

// _showNotification(Map<String, dynamic> message) async {
// final title = message['notification']['title'];
// final body = message['notification']['body'];
// final payload = jsonEncode(message['data']);
// await notificationsService.showNotification(title, body, payload);
// }

// Future<dynamic>? myBackgroundMessageHandler(Map<String, dynamic> message) {
  // if (message.containsKey('data')) {
    // Handle data message
    // final dynamic data = message['data'];
  // }

  // if (message.containsKey('notification')) {
  //   // Handle notification message
  //   final dynamic notification = message['notification'];
  // }
  // return null;
  // Or do other work.
// }
