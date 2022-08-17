import 'package:dio/dio.dart';
import 'package:ojos_app/core/errors/base_error.dart';
import 'package:ojos_app/core/params/base_params.dart';
import 'package:ojos_app/core/results/result.dart';
import 'package:ojos_app/core/usecases/usecase.dart';
import 'package:ojos_app/features/cart/domin/repositories/cartr_repository.dart';

class ApplyRetrieveParams extends BaseParams {
  final String reason;
  final String place;
  final String name;
  final String phone;
  final String productId;

  ApplyRetrieveParams({
    required this.reason,
    required this.place,
    required this.name,
    required this.phone,
    required this.productId,
    required CancelToken cancelToken,
  }) : super(cancelToken: cancelToken);
}

class ApplyRetrieve extends UseCase<Object, ApplyRetrieveParams> {
  final CartRepository repository;

  ApplyRetrieve(this.repository);

  @override
  Future<Result<BaseError, Object>> call(ApplyRetrieveParams params) {
    // TODO: implement call
    throw UnimplementedError();
  }
}
/*
    return repository.applyRetrieve(
      name: params.name,
      phone: params.phone,
      reason: params.reason,
      productId: params.productId,
      cancelToken: params.cancelToken,
      place: params.place,
    );
 */