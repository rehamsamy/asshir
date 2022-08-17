import 'package:ojos_app/features/cart/data/models/payment_method_model.dart';
import '../constants.dart';
import 'base_dao.dart';

class CachedPaymentMethodDao extends BaseDao<PaymentMethodModel> {
  CachedPaymentMethodDao()
      : super(
          BOX_PAYMENT_METHOD,
          (c) => c.toJson(),
          (json) => PaymentMethodModel.fromJson(json),
          (c) => c.id.toString(),
        );
}
