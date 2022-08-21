import 'package:kiwi/kiwi.dart';
import 'package:ojos_app/screens/categories/bloc/bloc.dart';


void initKiwi() {
  KiwiContainer container = KiwiContainer();
  container.registerFactory((c) => CategoriesBloc());

}
