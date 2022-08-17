import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ojos_app/core/datasources/remote_data_source.dart';
import 'package:ojos_app/core/errors/base_error.dart';
import 'package:ojos_app/features/cart/data/models/coupon_code_model.dart';

abstract class CartRemoteDataSource extends RemoteDataSource {
  Future<Either<BaseError, CouponCodeModel>> applyCouponCode({
    @required String total,
    @required String couponCode,
    CancelToken cancelToken,
  });
  // Future<Either<BaseError, Object>> applyRetrieve({
  //   @required String name,
  //   @required String reason,
  //   @required String place,
  //   @required String phone,
  //   @required String productId,
  //   CancelToken cancelToken,
  // });
}
