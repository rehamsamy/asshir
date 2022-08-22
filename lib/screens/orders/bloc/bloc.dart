import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ojos_app/helpers/server_gate.dart';
import 'events.dart';
import 'model.dart';
import 'states.dart';

class OrdersBloc extends Bloc<OrdersEvents, OrdersStates> {
  OrdersBloc() : super(OrdersStateStart()) {
    on<OrdersEventStart>(_getData);
  }
  ServerGate serverGate = ServerGate();
  void _getData(
      OrdersEventStart event,
      Emitter<OrdersStates> emit,
      ) async {
    emit(OrdersStateStart());
    CustomResponse response = await serverGate.getFromServer(
      url: "orders",
    );
    if (response.success) {
      OrdersModel _model =
      OrdersModel.fromJson(response.response!.data);
      emit(OrdersStateSuccess(data: _model.result));
    } else {
      emit(OrdersStateFailed(
          errType: response.errType,
          msg: response.msg,
          statusCode: response.statusCode));
    }
  }
}
