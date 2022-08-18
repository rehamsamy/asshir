import 'dart:async';
import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:ojos_app/app.dart';
import 'package:ojos_app/core/bloc/simple_bloc_delegate.dart';
import 'package:ojos_app/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:ojos_app/features/product/presentation/pages/lenses_details_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'core/datasources/concrete_core_remote_data_source.dart';
import 'core/datasources/core_remote_data_source.dart';
import 'core/repositories/concrete_core_repository.dart';
import 'core/repositories/core_repository.dart';
import 'core/res/shared_preference_utils/shared_preferences.dart';
import 'features/cart/data/datasources/cart_remote_data_source.dart';
import 'features/cart/data/datasources/concrete_cart_remote_data_source.dart';
import 'features/cart/data/repositories/concrete_cart_repository.dart';
import 'features/cart/domin/repositories/cartr_repository.dart';
import 'features/main_root.dart';
import 'features/order/data/datasources/concrete_order_remote_data_source.dart';
import 'features/order/data/datasources/order_remote_data_source.dart';
import 'features/order/data/repositories/concrete_order_repository.dart';
import 'features/order/domain/repositories/order_repository.dart';
import 'features/product/data/datasources/concrete_product_remote_data_source.dart';
import 'features/product/data/datasources/product_remote_data_source.dart';
import 'features/product/data/repositories/concrete_product_repository.dart';
import 'features/product/domin/entities/ProductLinkDetailsArguments.dart';
import 'features/product/domin/repositories/product_repository.dart';
import 'features/profile/data/datasources/concrete_profile_remote_data_source.dart';
import 'features/profile/data/datasources/profile_remote_data_source.dart';
import 'features/profile/data/repositories/concrete_profile_repository.dart';
import 'features/profile/domin/repositories/profile_repository.dart';
import 'features/user_management/data/datasources/concrete_user_remote_data_source.dart';
import 'features/user_management/data/datasources/user_remote_data_source.dart';
import 'features/user_management/data/repositories/concrete_user_repository.dart';
import 'features/user_management/domain/repositories/user_repository.dart';
import 'package:get/get.dart' as Get;

//0951971272
//12345678
final uuid = Uuid();
final locator = GetIt.instance;
FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;


void setupLocator() {
  // Handle DI stuffs.
  //===================================
  //    general Repo
  //===================================

  locator.registerFactory<CoreRemoteDataSource>(
    () => ConcreteCoreRemoteDataSource(),
  );
  locator.registerFactory<CoreRepository>(
    () => ConcreteCoreRepository(locator<CoreRemoteDataSource>()),
  );
  //===================================
  // for user Management & profile
  //===================================
  locator.registerFactory<UserRemoteDataSource>(
    () => ConcreteUserRemoteDataSource(),
  );
  locator.registerFactory<UserRepository>(
    () => ConcreteUserRepository(locator<UserRemoteDataSource>()),
  );

  //=====================
  //     For Product
  //=====================
  locator.registerFactory<ProductRemoteDataSource>(
    () => ConcreteProductRemoteDataSource(),
  );
  locator.registerFactory<ProductRepository>(
    () => ConcreteProductRepository(locator<ProductRemoteDataSource>()),
  );

  //=====================
  //     For Cart
  //=====================
  locator.registerFactory<CartRemoteDataSource>(
    () => ConcreteCartRemoteDataSource(),
  );
  locator.registerFactory<CartRepository>(
    () => ConcreteCartRepository(locator<CartRemoteDataSource>()),
  );

  //=====================
  //     For Profile
  //=====================
  locator.registerFactory<ProfileRemoteDataSource>(
    () => ConcreteProfileRemoteDataSource(),
  );
  locator.registerFactory<ProfileRepository>(
    () => ConcreteProfileRepository(locator<ProfileRemoteDataSource>()),
  );

  //=====================
  //     For Order
  //=====================
  locator.registerFactory<OrderRemoteDataSource>(
    () => ConcreteOrderRemoteDataSource(),
  );
  locator.registerFactory<OrderRepository>(
    () => ConcreteOrderRepository(locator<OrderRemoteDataSource>()),
  );
}

void setupBloc() {
  Bloc.observer = SimpleBlocObserver();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // FlutterError.onError = (FlutterErrorDetails details) {
  //   FlutterError.dumpErrorToConsole(details);
  //   log(details.stack?.toString() ?? 'null stack');
  // };

  String lang = await _getLanguage();

  setupLocator();

  setupBloc();
  print(lang);

  await appSharedPrefs.init();
  CoreRepository.prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  await firebaseMessaging.getToken().then((value) => print("the value " + value!));
  handleDynamicLinks();
  runApp(MyApp(lang: lang));
}

void handleDynamicLinks() async {
  // PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getInitialLink();
  //_handlerDeepLink(data);

  dynamicLinks.onLink.listen((dynamicLinkData) {
    Get.Get.toNamed(LensesDetailsPage.routeName, arguments: ProductLinkDetailsArguments(id: int.parse(dynamicLinkData.link.query.split('=')[1])));
    print('shaimaaaa   deep link is  ////////////////////////////////////////////////////////////////////////'
        '//////////////////////////////////////////////////////////////////'
        '/////////////////////////////////////////////////////////////////'
        '///////////////////////////////////////////////////////////////////'
        '////////////////////////////////////////////////////////////////////'
        '//////////////////'
        '////////'
        '/'
        '//////////////////////// ///////////////'
        '//////////////'
        '///////////////////////////////////////////////////////${dynamicLinkData.link.path}');
    print('shaimaaaa   deep link is  ////////////////////////////////////////////////////////////////////////'
        '//////////////////////////////////////////////////////////////////'
        '/////////////////////////////////////////////////////////////////'
        '///////////////////////////////////////////////////////////////////'
        '////////////////////////////////////////////////////////////////////'
        '//////////////////'
        '////////'
        '/'
        '//////////////////////// ///////////////'
        '//////////////'
        '///////////////////////////////////////////////////////${dynamicLinkData.link.queryParameters['product_id']}');
  }).onError((e) {
    print('shaimnaaaaaaa  error occured on dynamic link ${e.toString()}');
  });
}

// void _handlerDeepLink(PendingDynamicLinkData? data) {
//   Uri deepLink = data!.link;
//   print('shaimaa deep link is  ${deepLink}');
// }

Future<String> _getLanguage() async {
  final prefs = await SharedPreferences.getInstance();
  var lang = prefs.getString(KEY_LANG);
  if (lang == null || lang.isEmpty) {
    await prefs.setString(KEY_LANG, LANG_AR);
    lang = LANG_AR;
  }
  return lang;
}
//flutter packages pub run build_runner build --delete-conflicting-outputs
