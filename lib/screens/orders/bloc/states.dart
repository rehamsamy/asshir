import 'model.dart';

class OrdersStates {}

class OrdersStateStart extends OrdersStates {}

class OrdersStateSuccess extends OrdersStates {
  List<OrderItem>? data = [];
  OrdersStateSuccess({
    this.data,
  });
}

class OrdersStateFailed extends OrdersStates {
  String? msg;
  int? errType, statusCode;
  OrdersStateFailed({this.msg, this.errType, this.statusCode});
}
