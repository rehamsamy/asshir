class CategoriesModel {
  CategoriesModel({
    required this.status,
    required this.msg,
    required this.result,
  });
  late final bool status;
  late final String msg;
  late final List<CategoryItem> result;

  CategoriesModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    msg = json['msg'];
    result = List.from(json['result']).map((e)=>CategoryItem.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['msg'] = msg;
    _data['result'] = result.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class CategoryItem {
  CategoryItem({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.adv,
    required this.firstProducts,
  });
  late final int id;
  late final String name;
  late final String description;
  late final String image;
  late final bool adv;
  late final List<FirstProducts> firstProducts;

  CategoryItem.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    description = json['description'];
    image = json['image'];
    adv = json['adv'];
    firstProducts = List.from(json['first_products']).map((e)=>FirstProducts.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['description'] = description;
    _data['image'] = image;
    _data['adv'] = adv;
    _data['first_products'] = firstProducts.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class FirstProducts {
  FirstProducts({
    required this.id,
    this.sku,
    required this.name,
    required this.price,
    required this.quantity,
    this.discountPrice,
    this.discountType,
    required this.categoryId,
    this.brandId,
    this.userId,
    required this.description,
    required this.image,
    required this.avalability,
    required this.isFeatured,
    required this.quality,
    required this.isNew,
    required this.status,
    required this.mostRequested,
    required this.mostSelling,
    required this.createdAt,
    required this.updatedAt,
    required this.rate,
    required this.priceAfterDiscount,
    required this.isReview,
    required this.isFavorite,
  });
  late final int id;
  late final Null sku;
  late final String name;
  late final int price;
  late final String quantity;
  late final int? discountPrice;
  late final String? discountType;
  late final int categoryId;
  late final Null brandId;
  late final Null userId;
  late final String description;
  late final String image;
  late final bool avalability;
  late final bool isFeatured;
  late final bool quality;
  late final bool isNew;
  late final bool status;
  late final bool mostRequested;
  late final bool mostSelling;
  late final String createdAt;
  late final String updatedAt;
  late final String rate;
  late final String priceAfterDiscount;
  late final bool isReview;
  late final bool isFavorite;

  FirstProducts.fromJson(Map<String, dynamic> json){
    id = json['id'];
    sku = null;
    name = json['name'];
    price = json['price'];
    quantity = json['quantity'];
    discountPrice = null;
    discountType = null;
    categoryId = json['category_id'];
    brandId = null;
    userId = null;
    description = json['description'];
    image = json['image'];
    avalability = json['avalability'];
    isFeatured = json['is_featured'];
    quality = json['quality'];
    isNew = json['is_new'];
    status = json['status'];
    mostRequested = json['most_requested'];
    mostSelling = json['most_selling'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    rate = json['rate'];
    priceAfterDiscount = json['price_after_discount'];
    isReview = json['isReview'];
    isFavorite = json['isFavorite'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['sku'] = sku;
    _data['name'] = name;
    _data['price'] = price;
    _data['quantity'] = quantity;
    _data['discount_price'] = discountPrice;
    _data['discount_type'] = discountType;
    _data['category_id'] = categoryId;
    _data['brand_id'] = brandId;
    _data['user_id'] = userId;
    _data['description'] = description;
    _data['image'] = image;
    _data['avalability'] = avalability;
    _data['is_featured'] = isFeatured;
    _data['quality'] = quality;
    _data['is_new'] = isNew;
    _data['status'] = status;
    _data['most_requested'] = mostRequested;
    _data['most_selling'] = mostSelling;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['rate'] = rate;
    _data['price_after_discount'] = priceAfterDiscount;
    _data['isReview'] = isReview;
    _data['isFavorite'] = isFavorite;
    return _data;
  }
}