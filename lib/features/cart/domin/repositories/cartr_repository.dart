import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ojos_app/core/errors/base_error.dart';
import 'package:ojos_app/core/repositories/repository.dart';
import 'package:ojos_app/core/results/result.dart';
import 'package:ojos_app/features/cart/domin/entities/coupon_code_entity.dart';

abstract class CartRepository extends Repository {
  Future<Result<BaseError, CouponCodeEntity>> applyCouponCode({
    @required String total,
    @required String couponCode,
    CancelToken cancelToken,
  });
  // Future<Result<BaseError, Object>> applyRetrieve({
  //   @required String reason,
  //   @required String place,
  //   @required String name,
  //   @required String phone,
  //   @required String productId,
  //   CancelToken cancelToken,
  // });
}
