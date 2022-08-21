import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ojos_app/helpers/server_gate.dart';
import 'events.dart';
import 'model.dart';
import 'states.dart';

class CategoriesBloc extends Bloc<CategoriesEvents, CategoriesStates> {
  CategoriesBloc() : super(CategoriesStateStart()) {
    on<CategoriesEventStart>(_getData);
  }
  ServerGate serverGate = ServerGate();
  void _getData(
    CategoriesEventStart event,
    Emitter<CategoriesStates> emit,
  ) async {
    emit(CategoriesStateStart());
    CustomResponse response = await serverGate.getFromServer(
      url: "categories",
    );
    if (response.success) {
      CategoriesModel _model =
          CategoriesModel.fromJson(response.response!.data);
      emit(CategoriesStateSuccess(data: _model.result));
    } else {
      emit(CategoriesStateFailed(
          errType: response.errType,
          msg: response.msg,
          statusCode: response.statusCode));
    }
  }
}
