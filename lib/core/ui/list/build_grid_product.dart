import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ojos_app/core/localization/translations.dart';
import 'package:ojos_app/core/res/global_color.dart';
import 'package:ojos_app/core/res/text_style.dart';
import 'package:ojos_app/core/res/width_height.dart';
import 'package:ojos_app/core/ui/items_shimmer/item_general_shimmer.dart';
import 'package:ojos_app/core/ui/widget/network/network_grid.dart';
import 'package:ojos_app/features/product/domin/entities/product_entity.dart';
import 'package:ojos_app/features/product/domin/repositories/product_repository.dart';
import 'package:ojos_app/features/product/domin/usecases/get_products.dart';
import 'package:ojos_app/features/product/presentation/widgets/item_product_home_widget.dart';

import '../../../main.dart';

class BuildGridProductWidget extends StatefulWidget {
  final void Function(List<ProductEntity>)? getProducts;

  final Map<String, dynamic> params;

  final CancelToken cancelToken;

  final double? listWidth;
  final double? listHeight;

  final double? itemWidth;
  final double? itemHeight;

  final bool isScrollList;

  final bool isEnableRefresh;
  final bool isEnablePagination;

  //final bool isFromLearningPage;
  final Axis listScrollDirection;
  final bool isFromHomePage;
  final bool isFromSearchPage;

  //final bool isAuth;
  final SliverGridDelegate? gridDelegate;

  const BuildGridProductWidget({
    required this.params,
    this.getProducts,
    required this.cancelToken,
    this.isFromHomePage = false,
    this.isFromSearchPage = false,
    this.listWidth = 100,
    this.listHeight = 100,
    this.itemHeight,
    this.itemWidth,
    this.isScrollList = true,
    this.isEnableRefresh = true,
    this.isEnablePagination = true,
    //  this.isFromLearningPage = false,
    this.listScrollDirection = Axis.vertical,
    this.gridDelegate,
    // this.isAuth = true,
  });

  @override
  State<StatefulWidget> createState() {
    return _BuildGridProductWidgetState();
  }
}

class _BuildGridProductWidgetState extends State<BuildGridProductWidget>
    with AutomaticKeepAliveClientMixin<BuildGridProductWidget> {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    double widthC =
        globalSize.setWidthPercentage(widget.listWidth ?? 100, context);
    double heightC =
        globalSize.setHeightPercentage(widget.listHeight ?? 100, context);

    return Container(
      width: widthC,
      height: heightC,
      child: NetworkGrid<ProductEntity>(
        enablePagination: widget.isEnablePagination,
        enableRefresh: widget.isEnableRefresh,
        isScroll: widget.isScrollList,
        sliverGridDelegate: widget.gridDelegate ??
            SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 1,
              mainAxisSpacing: 1,
              childAspectRatio: globalSize.setWidthPercentage(60, context) /
                  globalSize.setWidthPercentage(47, context),
            ),
        placeHolder: (context) {
          return !widget.isFromHomePage
              ? Center(
                  child: Text(
                    Translations.of(context).translate('no_product'),
                    style: textStyle.smallTSBasic
                        .copyWith(color: globalColor.black),
                    textAlign: TextAlign.center,
                  ),
                )
              : SizedBox();
        },
        itemBuilder: (context, subject) {
          return getDesiredSubjectItem(
              subject, widget.itemWidth, widget.itemHeight);
        },
        loader: (pageSize, pageIndex) {
          return GetProduct(locator<ProductRepository>())(
            GetProductParams(
              page: pageIndex,
              pagesize: pageSize,
              filterParams: widget.params,
              isFromSearchPage: widget.isFromSearchPage,
              cancelToken: widget.cancelToken,
            ),
          );
        },
        loadingWidgetBuilder: (context) {
          return GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: 10,
              shrinkWrap: true,
              gridDelegate: widget.gridDelegate ??
                  SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 1,
                    mainAxisSpacing: 1,
                    childAspectRatio:
                        globalSize.setWidthPercentage(60, context) /
                            globalSize.setWidthPercentage(47, context),
                  ),
              itemBuilder: (BuildContext context, int index) {
                return ItemGeneralShimmer(
                  height: widget.itemHeight ??
                      globalSize.setWidthPercentage(60, context),
                  width: widget.itemWidth ??
                      globalSize.setWidthPercentage(47, context),
                );
              });
        },
      ),
    );
  }

  Widget getDesiredSubjectItem(
      ProductEntity? product, double? itemWidth, double? itemHeight) {
    return ItemProductHomeWidget(
      product: product,
      height: itemHeight ?? globalSize.setWidthPercentage(60, context),
      width: itemWidth ?? globalSize.setWidthPercentage(47, context),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
