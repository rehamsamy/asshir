import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' as Get;
import 'package:ojos_app/core/bloc/application_bloc.dart';
import 'package:ojos_app/core/bloc/application_events.dart';
import 'package:ojos_app/core/bloc/application_state.dart';
import 'package:ojos_app/core/constants.dart';
import 'package:ojos_app/core/entities/category_entity.dart';
import 'package:ojos_app/core/errors/connection_error.dart';
import 'package:ojos_app/core/localization/translations.dart';
import 'package:ojos_app/core/res/app_assets.dart';
import 'package:ojos_app/core/res/edge_margin.dart';
import 'package:ojos_app/core/res/global_color.dart';
import 'package:ojos_app/core/res/screen/horizontal_padding.dart';
import 'package:ojos_app/core/res/screen/vertical_padding.dart';
import 'package:ojos_app/core/res/shared_preference_utils/shared_preferences.dart';
import 'package:ojos_app/core/res/text_style.dart';
import 'package:ojos_app/core/res/utils.dart';
import 'package:ojos_app/core/res/width_height.dart';
import 'package:ojos_app/core/ui/button/icon_button_widget.dart';
import 'package:ojos_app/core/ui/dailog/confirm_dialog.dart';
import 'package:ojos_app/core/ui/dailog/login_first_dialog.dart';
import 'package:ojos_app/core/ui/dailog/soon_dailog.dart';
import 'package:ojos_app/core/ui/items_shimmer/base_shimmer.dart';
import 'package:ojos_app/core/ui/items_shimmer/home/offer_item_shimmer.dart';
import 'package:ojos_app/core/ui/items_shimmer/item_general_shimmer.dart';
import 'package:ojos_app/core/ui/list/build_list_product.dart';
import 'package:ojos_app/core/ui/widget/title_with_view_all_widget.dart';
import 'package:ojos_app/features/cart/presentation/pages/cart_page.dart';
import 'package:ojos_app/features/home/data/models/product_model.dart';
import 'package:ojos_app/features/home/domain/services/home_api.dart';
import 'package:ojos_app/features/home/presentation/args/products_view_all_args.dart';
import 'package:ojos_app/features/home/presentation/blocs/CATEGORIES_BLOC.dart';
import 'package:ojos_app/features/home/presentation/blocs/offer_bloc.dart';
import 'package:ojos_app/features/home/presentation/blocs/products_bloc.dart';
import 'package:ojos_app/features/home/presentation/pages/products_view_all_page.dart';
import 'package:ojos_app/features/home/presentation/widget/item_offer_bottom_widget.dart';
import 'package:ojos_app/features/home/presentation/widget/item_offer_middle1_widget.dart';
import 'package:ojos_app/features/home/presentation/widget/item_offer_middle2_widget.dart';
import 'package:ojos_app/features/home/presentation/widget/item_offer_widget.dart';
import 'package:ojos_app/features/notification/presentation/pages/notification_page.dart';
import 'package:ojos_app/features/others/presentation/pages/favorite_page.dart';
import 'package:ojos_app/features/others/presentation/pages/offers_page.dart';
import 'package:ojos_app/features/others/presentation/pages/settings_page.dart';
import 'package:ojos_app/features/product/presentation/widgets/item_product_home_widget.dart';
import 'package:ojos_app/features/profile/presentation/pages/profile_page.dart';
import 'package:ojos_app/features/reviews/presentation/pages/reviews_page.dart';
import 'package:ojos_app/features/search/presentation/pages/search_page.dart';
import 'package:ojos_app/features/section/presentation/blocs/section_home_bloc.dart';
import 'package:ojos_app/features/user_management/domain/repositories/user_repository.dart';
import 'package:ojos_app/features/user_management/presentation/pages/sign_in_page.dart';
//import 'package:residemenu/residemenu.dart' as Rs;

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

AppBar homeAppBar(
  BuildContext context,
  bool isAuth,
) =>
    AppBar(
      backgroundColor: globalColor.appBar,
      brightness: Brightness.light,
      elevation: 0,
      title: Container(
        child: Image.asset(
          AppAssets.appbar_logo,
          width: 130.w,
          height: 140.h,
        ),
      ),
      centerTitle: false,
      actions: [
        IconButtonWidget(
            icon: Icon(
              Icons.search,
              size: 25,
              color: Colors.black,
            ),
            onTap: () async {
              Get.Get.toNamed(SearchPage.routeName, arguments: null);
            }),
        HorizontalPadding(
          percentage: 3.0,
        ),
        IconButtonWidget(
          icon: SvgPicture.asset(
            AppAssets.cart_btnv_svg,
            width: 25,
            height: 25,
            color: Colors.black,
          ),
          onTap: () async {
            if (await UserRepository.hasToken && isAuth!) {
              Get.Get.toNamed(CartPage.routeName);
            } else {
              showDialog(
                context: context,
                builder: (ctx) => LoginFirstDialog(),
              );
            }
          },
        ),
        HorizontalPadding(
          percentage: 2.5,
        ),
        IconButtonWidget(
          icon: SvgPicture.asset(
            AppAssets.notification,
            width: 25,
            height: 25,
            color: Colors.black,
          ),
          onTap: () async {
            if (await UserRepository.hasToken && isAuth) {
              Get.Get.toNamed(NotificationPage.routeName);
            } else {
              showDialog(
                context: context,
                builder: (ctx) => LoginFirstDialog(title: false),
              );
            }
          },
        ),
        HorizontalPadding(
          percentage: 3.0,
        ),
      ],
    );
