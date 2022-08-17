import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart' as Get;
import 'package:ojos_app/core/localization/translations.dart';
import 'package:ojos_app/core/res/app_assets.dart';
import 'package:ojos_app/core/res/edge_margin.dart';
import 'package:ojos_app/core/res/global_color.dart';
import 'package:ojos_app/core/res/screen/vertical_padding.dart';
import 'package:ojos_app/core/res/text_size.dart';
import 'package:ojos_app/core/res/text_style.dart';
import 'package:ojos_app/core/res/utils.dart';
import 'package:ojos_app/core/res/width_height.dart';
import 'package:ojos_app/core/ui/widget/image/image_caching.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ojos_app/features/product/domin/entities/product_entity.dart';
import 'package:ojos_app/features/product/presentation/pages/lenses_details_page.dart';
import 'package:ojos_app/features/product/presentation/pages/product_details_page.dart';
import 'package:ojos_app/features/product/presentation/args/product_details_args.dart';
import 'dart:math' as math;

class ItemProductHomeWidget extends StatefulWidget {
  final ProductEntity? product;
  final double? width;
  final double? height;

  // final double height;
  const ItemProductHomeWidget({this.product, this.width, required this.height});

  @override
  _ItemProductHomeWidgetState createState() => _ItemProductHomeWidgetState();
}

class _ItemProductHomeWidgetState extends State<ItemProductHomeWidget> {
  @override
  Widget build(BuildContext context) {
    double width = widget.width ?? globalSize.setWidthPercentage(43, context);
    double height =
        widget.height ?? globalSize.setHeightPercentage(60, context);


    return Container(
      padding: EdgeInsets.only(
          left: utils.getLang() == 'ar' ? 0.0 : EdgeMargin.verySub,
          right: utils.getLang() == 'ar' ? EdgeMargin.verySub : 0.0),
      child: InkWell(
        onTap: () {
          print('click');

          Get.Get.toNamed(ProductDetailsPage.routeName,
              preventDuplicates: false,
              arguments: ProductDetailsArguments(product: widget.product!));
        },
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0.w))),
          child: Container(
              decoration: BoxDecoration(
                color: globalColor.white,
                borderRadius: BorderRadius.circular(12.0.w),
              ),
              //   padding: const EdgeInsets.all(1.0),
              width: width,
              height: height,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(EdgeMargin.verySub),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0.w)),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  ImageCacheWidget(
                                    imageUrl: widget.product!.image ?? '',
                                    boxFit: BoxFit.fill,
                                    imageHeight: 100,
                                    imageWidth: 100,
                                  ),
                                  Positioned(
                                    bottom: 0.0,
                                    right: 4.0,
                                    child: widget.product!.isNew != null &&
                                            widget.product!.isNew!
                                        ? Container(
                                            decoration: BoxDecoration(
                                              color: globalColor.primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(12.0.w),
                                            ),
                                            height: 22.h,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: EdgeMargin.sub,
                                                  right: EdgeMargin.sub),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: 2.w,
                                                  ),
                                                  SvgPicture.asset(
                                                    AppAssets.newww,
                                                    width: 12.w,
                                                  ),
                                                  SizedBox(
                                                    width: 4.w,
                                                  ),
                                                  Text(
                                                    '${Translations.of(context).translate('new')}',
                                                    style: textStyle
                                                        .smallTSBasic
                                                        .copyWith(
                                                            color: globalColor
                                                                .white),
                                                  ),
                                                  SizedBox(
                                                    width: 2.w,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : Container(
                                            child: Text(''),
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(EdgeMargin.sub),
                            child: FittedBox(
                              child: Row(
                                children: [
                                  Container(
                                    width: width,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        _buildPriceWidget(
                                            width: width,
                                            price: widget.product!.price,
                                            discountPrice: widget
                                                .product!.discountPrice
                                        ),
                                        VerticalPadding(
                                          percentage: 0.5,
                                        ),
                                        Container(
                                          child: RichText(
                                            overflow: TextOverflow.ellipsis,
                                            strutStyle: StrutStyle(
                                                fontSize: textSize.middle),
                                            maxLines: 2,
                                            text: TextSpan(
                                                style: textStyle.middleTSBasic
                                                    .copyWith(
                                                  color: globalColor.black,
                                                ),
                                                text:
                                                    widget.product!.name ?? ''),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  _buildPriceWidget(
      {required double? price,
      required double? discountPrice,
      required double width}) {
    // double finalPrice = price! - discountPrice!;
    RegExp regex = RegExp(r'([.]*0)(?!.*\d)');

    String newPrice = price.toString().replaceAll(regex, '');
    String newDiscountPrice = discountPrice.toString().replaceAll(regex, '');

    return Container(
      width: width,
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          discountPrice == null || discountPrice == 0.0
              ? SizedBox.shrink()
              : RichText(
                  text: TextSpan(
                    text: '$newDiscountPrice',
                    style: textStyle.smallTSBasic.copyWith(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.lineThrough,
                        color: globalColor.grey),
                    children: <TextSpan>[
                      new TextSpan(
                          text:
                              ' ${Translations.of(context).translate('rail')}',
                          style: textStyle.subMinTSBasic
                              .copyWith(color: globalColor.grey)),
                    ],
                  ),
                ),
          discountPrice == null || discountPrice == 0.0?Container():Spacer(),
          RichText(
            text: TextSpan(
              text: '$newPrice',
              style: textStyle.smallTSBasic.copyWith(
                  fontWeight: FontWeight.bold, color: globalColor.primaryColor),
              children: <TextSpan>[
                new TextSpan(
                    text: ' ${Translations.of(context).translate('rail')}',
                    style: textStyle.subMinTSBasic
                        .copyWith(color: globalColor.primaryColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
