class OrdersModel {
  OrdersModel({
      this.status, 
      this.msg, 
      this.result,});

  OrdersModel.fromJson(dynamic json) {
    status = json['status'];
    msg = json['msg'];
    if (json['result'] != null) {
      result = [];
      json['result'].forEach((v) {
        result?.add(OrderItem.fromJson(v));
      });
    }
  }
  bool? status;
  String? msg;
  List<OrderItem>? result;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['msg'] = msg;
    if (result != null) {
      map['result'] = result?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class OrderItem {
  OrderItem({
      this.id, 
      this.uuid, 
      this.userId, 
      this.couponId, 
      this.tax, 
      this.deliveryFee, 
      this.subtotal, 
      this.discount, 
      this.paidAmount, 
      this.remainingAmount, 
      this.methodId, 
      this.mehtodName, 
      this.status, 
      this.cityId, 
      this.cityname, 
      this.neighborhoodId, 
      this.neighborhood, 
      this.description, 
      this.quantityId, 
      this.quantityName, 
      this.loadId, 
      this.loadProduct, 
      this.deliveryTo, 
      this.deliveryto, 
      this.destType, 
      this.desttype, 
      this.destName, 
      this.guardNumber,});

  OrderItem.fromJson(dynamic json) {
    id = json['id'];
    uuid = json['uuid'];
    userId = json['user_id'];
    couponId = json['coupon_id'];
    tax = json['tax'];
    deliveryFee = json['delivery_fee'];
    subtotal = json['subtotal'];
    discount = json['discount'];
    paidAmount = json['paid_amount'];
    remainingAmount = json['remaining_amount'];
    methodId = json['method_id'];
    mehtodName = json['mehtod_name'];
    status = json['status'];
    cityId = json['city_id'];
    cityname = json['cityname'];
    neighborhoodId = json['neighborhood_id'];
    neighborhood = json['neighborhood'];
    description = json['description'];
    quantityId = json['quantity_id'];
    quantityName = json['quantity_name'];
    loadId = json['load_id'];
    loadProduct = json['load_product'];
    deliveryTo = json['delivery_to'];
    deliveryto = json['deliveryto'];
    destType = json['dest_type'];
    desttype = json['desttype'];
    destName = json['dest_name'];
    guardNumber = json['guard_number'];
  }
  int? id;
  String? uuid;
  int? userId;
  dynamic couponId;
  int? tax;
  int? deliveryFee;
  int? subtotal;
  int? discount;
  int? paidAmount;
  int? remainingAmount;
  int? methodId;
  String? mehtodName;
  String? status;
  int? cityId;
  String? cityname;
  int? neighborhoodId;
  String? neighborhood;
  String? description;
  int? quantityId;
  String? quantityName;
  int? loadId;
  String? loadProduct;
  int? deliveryTo;
  String? deliveryto;
  int? destType;
  String? desttype;
  String? destName;
  String? guardNumber;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['uuid'] = uuid;
    map['user_id'] = userId;
    map['coupon_id'] = couponId;
    map['tax'] = tax;
    map['delivery_fee'] = deliveryFee;
    map['subtotal'] = subtotal;
    map['discount'] = discount;
    map['paid_amount'] = paidAmount;
    map['remaining_amount'] = remainingAmount;
    map['method_id'] = methodId;
    map['mehtod_name'] = mehtodName;
    map['status'] = status;
    map['city_id'] = cityId;
    map['cityname'] = cityname;
    map['neighborhood_id'] = neighborhoodId;
    map['neighborhood'] = neighborhood;
    map['description'] = description;
    map['quantity_id'] = quantityId;
    map['quantity_name'] = quantityName;
    map['load_id'] = loadId;
    map['load_product'] = loadProduct;
    map['delivery_to'] = deliveryTo;
    map['deliveryto'] = deliveryto;
    map['dest_type'] = destType;
    map['desttype'] = desttype;
    map['dest_name'] = destName;
    map['guard_number'] = guardNumber;
    return map;
  }

}