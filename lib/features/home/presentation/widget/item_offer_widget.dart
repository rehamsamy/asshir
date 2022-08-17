import 'package:flutter/material.dart';
import 'package:ojos_app/core/entities/offer_item_entity.dart';
import 'package:ojos_app/core/ui/widget/image/image_caching.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' as Get;
import 'package:ojos_app/features/product/domin/entities/product_entity.dart';
import 'package:ojos_app/features/product/presentation/args/product_details_args.dart';
import 'package:ojos_app/features/product/presentation/pages/lenses_details_page.dart';
import 'package:ojos_app/features/product/presentation/pages/product_details_page.dart';

class ItemOfferWidget extends StatelessWidget {
  final OfferItemEntity? offerItem;
  final double? width;
  const ItemOfferWidget({this.offerItem, this.width});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.Get.toNamed(ProductDetailsPage.routeName,
            preventDuplicates: false,
            arguments: ProductDetailsArguments(
                product: ProductEntity(
              categoryId: null,
              name: offerItem!.name,
              id: offerItem!.productId,
              gender: null,
              discountPrice: 0.0,
              discountTypeInt: offerItem!.discountTypeInt,
              discountType: null,
              type: null,
              frameShape: null,
              price: null,
              description: null,
              availability: null,
              brandId: null,
              productReviews: null,
              brandInfo: null,
              featured: null,
              genderId: null,
              isReview: null,
              hasCouponCode: null,
              isNew: false,
              lensesFree: null,
              image: offerItem!.image,
              colorInfo: null,
              rate: null,
              isGlasses: null,
              sizeModeInfo: null,
              sizeFaceInfo: null,
              shapeFaceInfo: null,
              shapeframeinfo: null,
              shopId: null,
              shopInfo: null,
              typeProduct: null,
              photoInfo: null,
              isFavorite: null,
            )));
      },
      child: Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(0.0)),
            child: Stack(
              children: [
                Container(
                  width: width,
                  height: 184.h,
                  child: ImageCacheWidget(
                    imageUrl: offerItem!.image!,
                    imageWidth: width!,
                    imageHeight: 184.h,
                    boxFit: BoxFit.fill,
                    imageBorderRadius: 0.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
