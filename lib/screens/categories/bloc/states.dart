import 'model.dart';

class CategoriesStates {}

class CategoriesStateStart extends CategoriesStates {}

class CategoriesStateSuccess extends CategoriesStates {
  List<CategoryItem>? data = [];
  CategoriesStateSuccess({
    this.data,
  });
}

class CategoriesStateFailed extends CategoriesStates {
  String? msg;
  int? errType, statusCode;
  CategoriesStateFailed({this.msg, this.errType, this.statusCode});
}
