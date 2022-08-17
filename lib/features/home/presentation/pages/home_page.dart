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

class HomePage extends StatefulWidget {
  static const routeName = '/home/pages/HomePage';

  final TabController? tabController;

  const HomePage({this.tabController});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget? rightChild, leftChild;
  final PageController adsSliderOne = PageController();
  final PageController adsSliderTwo = PageController();
  var currentPageValue = 0;

  int? _styleSelected;
  GlobalKey _key = GlobalKey();

  List<ProductModel>? listOfProduct;
  List<ProductModel>? listOfMenProduct;

  var _cancelToken = CancelToken();
  var _offerBloc = OfferBloc();
  var _categoriesBloc = CategoryBloc();
  var _productBloc = ProductsBloc();
  var _listKey = GlobalKey();

  bool? isAuth;
  bool isOpen = false;
  HomeApi api = HomeApi();

  @override
  void initState() {
    super.initState();
    _offerBloc.add(SetupOfferEvent(cancelToken: _cancelToken));
    _categoriesBloc.add(SetupCategoryEvent(cancelToken: _cancelToken));
    isAuth = appSharedPrefs.getToken() == '' ? false : true;
    api.feachCategories();
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar({height, state}) => AppBar(
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
                if (await UserRepository.hasToken && isAuth!) {
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

    double width = globalSize.setWidthPercentage(100, context);
    double height = globalSize.setHeightPercentage(100, context) -
        appBar().preferredSize.height -
        MediaQuery.of(context).viewPadding.top;

    return BlocBuilder<ApplicationBloc, ApplicationState>(
        bloc: BlocProvider.of<ApplicationBloc>(context),
        builder: (context, state) {
          return Scaffold(
              backgroundColor: globalColor.scaffoldBackGroundGreyColor,
              appBar: appBar(height: height, state: state),
              body: Container(
                  height: height,
                  key: _listKey,
                  child: RefreshIndicator(
                    onRefresh: () async {
                      setState(() {
                        _listKey = GlobalKey();
                      });
                      return null;
                    },
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Container(
                        child: Column(
                          children: [



                            _buildTopAds(
                                context: context,
                                width: width,
                                height: height,
                                pageController: adsSliderOne),
                            _buildBottomAdsTwo(
                                context: context, width: width, height: height),
                            VerticalPadding(
                              percentage: .5,
                            ),
                            _buildDiscountAds1(
                                context: context, width: width, height: height),
                            VerticalPadding(
                              percentage: .5,
                            ),
                            _buildMostSold(
                                context: context, width: width, height: height),
                            VerticalPadding(
                              percentage: .5,
                            ),
                            _buildDiscountAds1(
                                context: context, width: width, height: height),
                            _buildDiscountAds2(
                                context: context, width: width, height: height),
                            VerticalPadding(
                              percentage: .5,
                            ),
                            _buildMenProduct(
                                context: context, width: width, height: height),
                            VerticalPadding(
                              percentage: .5,
                            ),
                            _buildTopAds(
                                context: context,
                                width: width,
                                height: height,
                                pageController: adsSliderTwo),
                            VerticalPadding(
                              percentage: .5,
                            ),
                            _buildCategoriesHome(context1:context ,width: width, height: height),
                            _buildBottomAdsTwo(
                                context: context, width: width, height: height),
                            VerticalPadding(
                              percentage: .5,
                            ),
                            _buildBottomAdsOne(
                                context: context, width: width, height: height),
                            VerticalPadding(
                              percentage: .5,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )));
          // );
        });
  }

  @override
  void dispose() {
    _cancelToken.cancel();
    _offerBloc.close();
    super.dispose();
  }

  ///Lis-t of interview questions.
  Widget getListItem(
    Color color,
    String iconPath,
    String title,
  ) {
    return GestureDetector(
      key: title == 'Behavioural Based' ? Key('item') : null,
      child: Container(
        color: color,
        height: 300.0,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Hero(
              tag: iconPath,
              child: Image.asset(
                iconPath,
                width: 80.0,
                height: 80.0,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.headline6!.copyWith(
                    color: globalColor.white,
                    fontSize: 10,
                    fontFamily: 'Cairo',
                  ),
              textAlign: TextAlign.center,
            )
          ],
        )),
      ),
      onTap: () {},
    );
  }

  Card getMaterialResideMenuItem(String drawerMenuTitle, String drawerMenuIcon,
      {MenuSpecItem? state,
      bool ishideArrow = true,
      tralingfunc,
      leadingWidget}) {
    return Card(
      child: new InkWell(
        onTap: () {
          if (state == null)
            tralingfunc();
          else {
            _onItemMenuPress(state);
          }
        },
        child: Container(
            margin: EdgeInsets.only(
              right: isRtl(context) ? 10.0 : 0.0,
            ),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      SvgPicture.asset(
                        drawerMenuIcon,
                        color: globalColor.primaryColor,
                        width: 20,
                      ),
                      Container(
                        width: 30,
                      ),
                      Text(
                        Translations.of(context).translate(drawerMenuTitle),
                        style: textStyle.normalTSBasic
                            .copyWith(color: globalColor.black),
                      )
                    ],
                  ),
                  margin: EdgeInsets.only(left: 12.0, top: 5, bottom: 5),
                ),
                Padding(
                  child: ishideArrow
                      ? Container()
                      : Container(
                          child: leadingWidget == null
                              ? Icon(
                                  utils.getLang() == 'ar'
                                      ? Icons.keyboard_arrow_left
                                      : Icons.keyboard_arrow_right,
                                  color: globalColor.primaryColor,
                                  size: 25,
                                )
                              : leadingWidget,
                        ),
                  padding: EdgeInsets.only(right: 0),
                )
              ],
            )),
      ),
    );
  }

  Widget getMaterialResideMenuItem2(
      String drawerMenuTitle, String drawerMenuIcon,
      {MenuSpecItem? state,
      bool ishideArrow = true,
      tralingfunc,
      leadingWidget}) {
    return new InkWell(
      onTap: () {
        if (state == null)
          tralingfunc();
        else {
          _onItemMenuPress(state);
        }
      },
      child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                color: globalColor.primaryColor,
              ),
              borderRadius: BorderRadius.circular(6)),
          margin: EdgeInsets.only(
            right: isRtl(context) ? 10.0 : 0.0,
          ),
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      Translations.of(context).translate(drawerMenuTitle),
                      style: textStyle.normalTSBasic.copyWith(
                        color: globalColor.primaryColor,
                      ),
                    )
                  ],
                ),
                margin:
                    EdgeInsets.only(left: 12.0, top: 1, bottom: 1, right: 12),
              ),
            ],
          )),
    );
  }

  _onItemMenuPress(MenuSpecItem state) async {
    switch (state) {
      case MenuSpecItem.HomePage:
        break;
      case MenuSpecItem.ProfilePage:
        if (await UserRepository.hasToken && isAuth!) {
          Get.Get.toNamed(ProfilePage.routeName);
        } else {
          showDialog(
            context: context,
            builder: (ctx) => LoginFirstDialog(),
          );
        }

        break;
      case MenuSpecItem.BrandPage:
        widget.tabController!.animateTo(1);
        break;
      case MenuSpecItem.OrderPage:
        widget.tabController!.animateTo(4);
        break;
      case MenuSpecItem.SectionPage:
        widget.tabController!.animateTo(3);
        break;
      case MenuSpecItem.WalletPage:
        showDialog(
          context: context,
          builder: (ctx) => SoonDialog(),
        );

        break;
      case MenuSpecItem.FavoritePage:
        if (await UserRepository.hasToken && isAuth!) {
          Get.Get.toNamed(FavoritePage.routeName);
        } else {
          showDialog(
            context: context,
            builder: (ctx) => LoginFirstDialog(),
          );
        }

        break;
      case MenuSpecItem.ReviewsPage:
        if (await UserRepository.hasToken && isAuth!) {
          Get.Get.toNamed(ReviewPage.routeName);
        } else {
          showDialog(
            context: context,
            builder: (ctx) => LoginFirstDialog(),
          );
        }

        break;
      case MenuSpecItem.OffersPage:
        Get.Get.toNamed(OffersPage.routeName);
        break;
      case MenuSpecItem.SettingsPage:
        Get.Get.toNamed(SettingsPage.routeName);
        break;
      case MenuSpecItem.SignInPage:
        Get.Get.toNamed(SignInPage.routeName);
        break;
      case MenuSpecItem.SignOut:
        showDialog(
          context: context,
          builder: (ctx) => ConfirmDialog(
            title: Translations.of(context).translate('logout'),
            confirmMessage:
                Translations.of(context).translate('are_you_sure_logout'),
            actionYes: () {
              BlocProvider.of<ApplicationBloc>(context).add(UserLogoutEvent());
              Get.Get.back();
            },
            actionNo: () {
              setState(() {
                Get.Get.back();
              });
            },
          ),
        );
        break;
      default:
        break;
    }
  }

  bool isRtl(context) => TextDirection.rtl == Directionality.of(context);

  getHeaderText(String userName) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            Translations.of(context).translate('welcome'),
            style: textStyle.normalTSBasic.copyWith(color: globalColor.black),
          ),
          Text(
            userName,
            maxLines: 1,
            style: textStyle.normalTSBasic.copyWith(color: globalColor.black),
          ),
        ],
      ),
    );
  }

  onError(BuildContext context) {
    Fluttertoast.showToast(
      msg: Translations.of(context).translate('err_unexpected'),
      gravity: ToastGravity.BOTTOM,
    );
  }

  _buildTopAds(
      {required BuildContext context,
      required double width,
      required PageController pageController,
      required double height}) {
    return BlocListener<OfferBloc, OfferState>(
      bloc: _offerBloc,
      listener: (BuildContext context, state) async {
        if (state is OfferDoneState) {
          // _navigateTo(context, state.extraGlassesEntity);
        }
      },
      child: BlocBuilder<OfferBloc, OfferState>(
          bloc: _offerBloc,
          builder: (BuildContext context, state) {
            if (state is OfferFailureState) {
              return Container(
                width: width,
                height: 134.h,
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                            (state.error is ConnectionError)
                                ? Translations.of(context)
                                    .translate('err_connection')
                                : Translations.of(context)
                                    .translate('err_unexpected'),
                            style: textStyle.normalTSBasic
                                .copyWith(color: globalColor.accentColor)),
                      ),
                      RaisedButton(
                        onPressed: () {
                          _offerBloc
                              .add(SetupOfferEvent(cancelToken: _cancelToken));
                        },
                        elevation: 1.0,
                        child: Text(Translations.of(context).translate('retry'),
                            style: textStyle.smallTSBasic
                                .copyWith(color: globalColor.white)),
                        color: Theme.of(context).accentColor,
                      ),
                    ],
                  ),
                ),
              );
            }
            if (state is OfferDoneState) {
              if (state.offer!.topHome.isNotEmpty) {
                return Container(
                  width: width,
                  height: 134.h,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PageView.builder(
                        controller: pageController,
                        itemCount: state.offer!.topHome.length,
                        itemBuilder: (BuildContext context, int index) =>
                            ItemOfferWidget(
                          offerItem: state.offer!.topHome[index],
                          width: width,
                        ),
                      ),
                      Positioned(
                          bottom: 10,
                          child: SmoothPageIndicator(
                            controller: pageController,
                            count: state.offer!.topHome.length,
                            effect: ScrollingDotsEffect(
                                // spacing: 8.0,
                                // radius: 12.0,
                                // dotWidth: 12.0,
                                // dotHeight: 12.0,
                                // dotColor: Colors.white,
                                // paintStyle: PaintingStyle.fill,
                                // strokeWidth: 2,
                                // activeDotColor: globalColor.goldColor,
                                ),
                          ))
                    ],
                  ),
                );
              } else {
                return Container();
              }
            }

            return Container(
              width: width,
              height: 184.h,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    EdgeMargin.small, 0.0, EdgeMargin.small, 0.0),
                child: HomeAdsItemShimmer(
                  height: 184,
                  width: width,
                ),
              ),
            );
          }),
    );
  }

  _buildMostSold(
      {required BuildContext context,
      required double width,
      required double height}) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: EdgeMargin.small, right: EdgeMargin.small),
            child: TitleWithViewAllWidget(
              width: width,
              title: Translations.of(context).translate('most_sold'),
              onClickView: () {
                Get.Get.toNamed(ProductsVeiwAllPage.routeName,
                    arguments:
                        ProductsViewAllArgs(params: {FILTER_BEST_SALES: '0'}));
              },
              strViewAll: Translations.of(context).translate('view_all'),
            ),
          ),
          Container(
            height: globalSize.setWidthPercentage(60, context),
            child: BuildListProductWidget(
              cancelToken: _cancelToken,
              params: {FILTER_BEST_SALES: '0'},
              listScrollDirection: Axis.horizontal,
              isEnablePagination: false,
              isEnableRefresh: false,
              isFromHomePage: true,
              isScrollList: true,
              listWidth: width,
              listHeight: height * .4,
            ),
          ),
        ],
      ),
    );
  }

  _buildMenProduct(
      {required BuildContext context,
      required double width,
      required double height}) {
    return Container(
      key: _key,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: EdgeMargin.small, right: EdgeMargin.small),
            child: TitleWithViewAllWidget(
              width: width,
              title: _styleSelected == null || _styleSelected == -1111
                  ? Translations.of(context).translate('men_women_style')
                  : _styleSelected == 38
                      ? Translations.of(context).translate('men_style')
                      : Translations.of(context).translate('women_style'),
              onClickView: () {
                Get.Get.toNamed(ProductsVeiwAllPage.routeName,
                    arguments: ProductsViewAllArgs(
                        params: _styleSelected == null ||
                                _styleSelected == -1111
                            ? {}
                            : {FILTER_GENDER_ID: _styleSelected.toString()}));
              },
              strViewAll: Translations.of(context).translate('view_all'),
            ),
          ),
          Container(
            height: globalSize.setWidthPercentage(60, context),
            child: BuildListProductWidget(
              cancelToken: _cancelToken,
              params: _styleSelected == null || _styleSelected == -1111
                  ? {}
                  : {FILTER_GENDER_ID: _styleSelected.toString()},
              listScrollDirection: Axis.horizontal,
              isEnablePagination: false,
              isEnableRefresh: false,
              isFromHomePage: true,
              isScrollList: true,
              listWidth: width,
              listHeight: height * .4,
            ),
          ),
        ],
      ),
    );
  }

  _buildProductsCategorySection(
      {required BuildContext context,
      required double width,
      required double height,
      required CategoryEntity item}) {
    // _productBloc.add(
    //     SetupProductsEvent(id: item.id.toString(), cancelToken: _cancelToken));
    return _buildWidgetProduct(
      id: item.id,
      height: height,
      title: item.name!,
      width: width,
      context: context,
    );
  }

  // _buildWidgetProduct(
  //     {required BuildContext context,
  //     required double width,
  //     required double height,
  //     required String title,
  //     required int id}) {
  //   return BlocListener<ProductsBloc, ProductsState>(
  //     bloc: _productBloc,
  //     listener: (BuildContext context, state) async {
  //       if (state is SectionHomeDoneState) {}
  //     },
  //     child: BlocBuilder<ProductsBloc, ProductsState>(
  //         bloc: _productBloc,
  //         builder: (BuildContext context, state) {
  //           if (state is ProductsFailureState) {
  //             return Container(
  //               width: width,
  //               child: Center(
  //                 child: Column(
  //                   children: [
  //                     Padding(
  //                       padding: const EdgeInsets.all(12.0),
  //                       child: Text(
  //                           (state.error is ConnectionError)
  //                               ? Translations.of(context)
  //                                   .translate('err_connection')
  //                               : Translations.of(context)
  //                                   .translate('err_unexpected'),
  //                           style: textStyle.normalTSBasic
  //                               .copyWith(color: globalColor.accentColor)),
  //                     ),
  //                     RaisedButton(
  //                       onPressed: () {
  //                         _productBloc.add(SetupProductsEvent(
  //                             cancelToken: _cancelToken, id: id.toString()));
  //                       },
  //                       elevation: 1.0,
  //                       child: Text(Translations.of(context).translate('retry'),
  //                           style: textStyle.smallTSBasic
  //                               .copyWith(color: globalColor.white)),
  //                       color: Theme.of(context).accentColor,
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             );
  //           }
  //           if (state is ProductsDoneState) {
  //             return Container(
  //               child: Column(
  //                 children: [
  //                   Padding(
  //                     padding: const EdgeInsets.only(
  //                         left: EdgeMargin.small, right: EdgeMargin.small),
  //                     child: TitleWithViewAllWidget(
  //                       width: width,
  //                       title: title,
  //                       onClickView: () {
  //                         if (id != null)
  //                           Get.Get.toNamed(ProductsVeiwAllPage.routeName,
  //                               arguments: ProductsViewAllArgs(
  //                                   params: {'category_id': id.toString()}));
  //                       },
  //                       strViewAll: 'view_all',
  //                     ),
  //                   ),
  //                   state.products!.length == 0
  //                       ? Container(
  //                           height: globalSize.setWidthPercentage(30, context),
  //                           alignment: AlignmentDirectional.centerStart,
  //                           child: Center(
  //                             child: Text(
  //                                 Translations.of(context).translate(
  //                                   'products_not_found',
  //                                 ),
  //                                 style: TextStyle(
  //                                     color: globalColor.primaryColor)),
  //                           ),
  //                         )
  //                       : Container(
  //                           height: globalSize.setWidthPercentage(60, context),
  //                           alignment: AlignmentDirectional.centerStart,
  //                           child: ListView.builder(
  //                               physics: BouncingScrollPhysics(),
  //                               itemCount: state.products!.length,
  //                               shrinkWrap: true,
  //                               scrollDirection: Axis.horizontal,
  //                               itemBuilder: (BuildContext context, int index) {
  //                                 return ItemProductHomeWidget(
  //                                   height: globalSize.setWidthPercentage(
  //                                       60, context),
  //                                   width: globalSize.setWidthPercentage(
  //                                       47, context),
  //                                   product: state.products![index],
  //                                 );
  //                               }),
  //                         ),
  //                 ],
  //               ),
  //             );
  //           }
  //
  //           return BaseShimmerWidget(
  //             child: Column(
  //               children: [
  //                 Padding(
  //                   padding: const EdgeInsets.only(
  //                       left: EdgeMargin.small,
  //                       right: EdgeMargin.small,
  //                       bottom: EdgeMargin.small),
  //                   child: TitleWithViewAllWidget(
  //                     width: width,
  //                     title: title,
  //                     onClickView: () {
  //                       if (id != null)
  //                         Get.Get.toNamed(ProductsVeiwAllPage.routeName,
  //                             arguments: ProductsViewAllArgs(
  //                                 params: {'category_id': id.toString()}));
  //                     },
  //                     strViewAll: 'view_all',
  //                   ),
  //                 ),
  //                 Container(
  //                   width: width,
  //                   height: 5.h,
  //                   color: Colors.grey[200],
  //                 ),
  //               ],
  //             ),
  //           );
  //         }),
  //   );
  // }

  _buildWidgetProduct(
      {required BuildContext context,
      required double width,
      required double height,
      required String title,
      required int? id}) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: EdgeMargin.small,
                right: EdgeMargin.small,
                bottom: EdgeMargin.small),
            child: TitleWithViewAllWidget(
              width: width,
              title: title,
              onClickView: () {
                if (id != null)
                  Get.Get.toNamed(ProductsVeiwAllPage.routeName,
                      arguments: ProductsViewAllArgs(
                          params: {'category_id': id.toString()}));
              },
              strViewAll: 'view_all',
            ),
          ),
          Container(
          height: globalSize.setWidthPercentage(60, context),
            child: BuildListProductWidget(
              cancelToken: _cancelToken,
              params: {'category_id': id.toString()},
              listScrollDirection: Axis.horizontal,
              isEnablePagination: false,
              isEnableRefresh: false,
              isFromHomePage: true,
              isScrollList: true,
              listWidth: width,
              listHeight: height * .4,
            ),
          ),
        ],
      ),
    );
  }

  _buildDiscountAds1(
      {required BuildContext context,
      required double width,
      required double height}) {
    return BlocListener<OfferBloc, OfferState>(
      bloc: _offerBloc,
      listener: (BuildContext context, state) async {
        if (state is OfferDoneState) {
          // _navigateTo(context, state.extraGlassesEntity);
        }
      },
      child: BlocBuilder<OfferBloc, OfferState>(
          bloc: _offerBloc,
          builder: (BuildContext context, state) {
            if (state is OfferFailureState) {
              return Container(
                width: width,
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                            (state.error is ConnectionError)
                                ? Translations.of(context)
                                    .translate('err_connection')
                                : Translations.of(context)
                                    .translate('err_unexpected'),
                            style: textStyle.normalTSBasic
                                .copyWith(color: globalColor.accentColor)),
                      ),
                      RaisedButton(
                        onPressed: () {
                          _offerBloc
                              .add(SetupOfferEvent(cancelToken: _cancelToken));
                        },
                        elevation: 1.0,
                        child: Text(Translations.of(context).translate('retry'),
                            style: textStyle.smallTSBasic
                                .copyWith(color: globalColor.white)),
                        color: Theme.of(context).accentColor,
                      ),
                    ],
                  ),
                ),
              );
            }
            if (state is OfferDoneState) {
              if (state.offer!.middleOneHome != null &&
                  state.offer!.middleOneHome.isNotEmpty) {
                return Container(
                  child: ListView.builder(
                      itemCount: state.offer!.middleOneHome.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return ItemOfferMiddle1Widget(
                          height: height,
                          width: width,
                          offerItem: state.offer!.middleOneHome[index],
                        );
                      }),
                );
              } else {
                return Container();
              }
            }

            return Container(
              width: width,
              height: 90.h,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    EdgeMargin.small, 0.0, EdgeMargin.small, 0.0),
                child: HomeAdsItemShimmer(
                  height: 90.h,
                  width: width,
                ),
              ),
            );
          }),
    );
  }

  _buildDiscountAds2(
      {required BuildContext context,
      required double width,
      required double height}) {
    return BlocListener<OfferBloc, OfferState>(
      bloc: _offerBloc,
      listener: (BuildContext context, state) async {
        if (state is OfferDoneState) {
          // _navigateTo(context, state.extraGlassesEntity);
        }
      },
      child: BlocBuilder<OfferBloc, OfferState>(
          bloc: _offerBloc,
          builder: (BuildContext context, state) {
            if (state is OfferFailureState) {
              return Container(
                width: width,
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                            (state.error is ConnectionError)
                                ? Translations.of(context)
                                    .translate('err_connection')
                                : Translations.of(context)
                                    .translate('err_unexpected'),
                            style: textStyle.normalTSBasic
                                .copyWith(color: globalColor.accentColor)),
                      ),
                      RaisedButton(
                        onPressed: () {
                          _offerBloc
                              .add(SetupOfferEvent(cancelToken: _cancelToken));
                        },
                        elevation: 1.0,
                        child: Text(Translations.of(context).translate('retry'),
                            style: textStyle.smallTSBasic
                                .copyWith(color: globalColor.white)),
                        color: Theme.of(context).accentColor,
                      ),
                    ],
                  ),
                ),
              );
            }
            if (state is OfferDoneState) {
              if (state.offer!.middleTwoHome != null &&
                  state.offer!.middleTwoHome.isNotEmpty) {
                return Container(
                  child: ListView.builder(
                      itemCount: state.offer!.middleTwoHome.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return ItemOfferMiddle2Widget(
                          height: height,
                          width: width,
                          offerItem: state.offer!.middleTwoHome[index],
                        );
                      }),
                );
              } else {
                return Container();
              }
            }

            return Container(
              width: width,
              height: 90.h,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    EdgeMargin.small, 0.0, EdgeMargin.small, 0.0),
                child: HomeAdsItemShimmer(
                  height: 90.h,
                  width: width,
                ),
              ),
            );
          }),
    );
  }

  _buildBottomAdsOne(
      {required BuildContext context,
      required double width,
      required double height}) {
    return BlocListener<OfferBloc, OfferState>(
      bloc: _offerBloc,
      listener: (BuildContext context, state) async {
        if (state is OfferDoneState) {
          // _navigateTo(context, state.extraGlassesEntity);
        }
      },
      child: BlocBuilder<OfferBloc, OfferState>(
          bloc: _offerBloc,
          builder: (BuildContext context, state) {
            if (state is OfferFailureState) {
              return Container(
                width: width,
                height: 90.h,
                child: Center(
                  child: Column(
                    children: [
                      Text(
                          (state.error is ConnectionError)
                              ? Translations.of(context)
                                  .translate('err_connection')
                              : Translations.of(context)
                                  .translate('err_unexpected'),
                          style: textStyle.normalTSBasic
                              .copyWith(color: globalColor.accentColor)),
                      RaisedButton(
                        onPressed: () {
                          _offerBloc
                              .add(SetupOfferEvent(cancelToken: _cancelToken));
                        },
                        elevation: 1.0,
                        child: Text(Translations.of(context).translate('retry'),
                            style: textStyle.smallTSBasic
                                .copyWith(color: globalColor.white)),
                        color: Theme.of(context).accentColor,
                      ),
                    ],
                  ),
                ),
              );
            }
            if (state is OfferDoneState) {
              if (state.offer!.bottomOneHome.isNotEmpty) {
                return Container(
                  height: 90.h,
                  child: PageView.builder(
                      itemCount: state.offer!.bottomOneHome.length,
                      itemBuilder: (context, index) {
                        return ItemOfferBottomWidget(
                          height: height,
                          offerItem: state.offer!.bottomOneHome[index],
                          width: width,
                        );
                      }),
                );
              } else {
                return Container();
              }
            }

            return Container(
              width: width,
              height: 90.h,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    EdgeMargin.small, 0.0, EdgeMargin.small, 0.0),
                child: HomeAdsItemShimmer(
                  height: 90.h,
                  width: width,
                ),
              ),
            );
          }),
    );
  }

  _buildBottomAdsTwo(
      {required BuildContext context,
      required double width,
      required double height}) {
    return BlocListener<OfferBloc, OfferState>(
      bloc: _offerBloc,
      listener: (BuildContext context, state) async {
        if (state is OfferDoneState) {
          // _navigateTo(context, state.extraGlassesEntity);
        }
      },
      child: BlocBuilder<OfferBloc, OfferState>(
          bloc: _offerBloc,
          builder: (BuildContext context, state) {
            if (state is OfferFailureState) {
              return Container(
                width: width,
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                            (state.error is ConnectionError)
                                ? Translations.of(context)
                                    .translate('err_connection')
                                : Translations.of(context)
                                    .translate('err_unexpected'),
                            style: textStyle.normalTSBasic
                                .copyWith(color: globalColor.accentColor)),
                      ),
                      RaisedButton(
                        onPressed: () {
                          _offerBloc
                              .add(SetupOfferEvent(cancelToken: _cancelToken));
                        },
                        elevation: 1.0,
                        child: Text(Translations.of(context).translate('retry'),
                            style: textStyle.smallTSBasic
                                .copyWith(color: globalColor.white)),
                        color: Theme.of(context).accentColor,
                      ),
                    ],
                  ),
                ),
              );
            }
            if (state is OfferDoneState) {
              if (state.offer!.bottomTwoHome != null &&
                  state.offer!.bottomTwoHome.isNotEmpty) {
                return Container(
                  height: globalSize.setWidthPercentage(60, context),
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.offer!.bottomTwoHome.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return ItemOfferBottomWidget2(
                            height: height,
                            offerItem: state.offer!.bottomTwoHome[index],
                            width: globalSize.setWidthPercentage(47, context));
                      }),
                );
              } else {
                return Container();
              }
            }

            return Container(
              width: width,
              height: 90.h,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    EdgeMargin.small, 0.0, EdgeMargin.small, 0.0),
                child: HomeAdsItemShimmer(
                  height: 90.h,
                  width: width,
                ),
              ),
            );
          }),
    );
  }

  _buildCategoriesHome({required BuildContext context1, required double width, required double height}) {
    return BlocListener<CategoryBloc, CategoryState>(
      bloc: _categoriesBloc,
      listener: (BuildContext context, state) async {
        if (state is OfferDoneState) {
          // _navigateTo(context, state.extraGlassesEntity);
        }
      },
      child: BlocBuilder<CategoryBloc, CategoryState>(
          bloc: _categoriesBloc,
          builder: (BuildContext context, state) {
            if (state is CategoryFailureState) {
              return Container(
                width: width,
                height: 134.h,
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                            (state.error is ConnectionError)
                                ? Translations.of(context)
                                    .translate('err_connection')
                                : Translations.of(context)
                                    .translate('err_unexpected'),
                            style: textStyle.normalTSBasic
                                .copyWith(color: globalColor.accentColor)),
                      ),
                      RaisedButton(
                        onPressed: () {
                          _categoriesBloc.add(
                              SetupCategoryEvent(cancelToken: _cancelToken));
                        },
                        elevation: 1.0,
                        child: Text(Translations.of(context).translate('retry'),
                            style: textStyle.smallTSBasic
                                .copyWith(color: globalColor.white)),
                        color: Theme.of(context).accentColor,
                      ),
                    ],
                  ),
                ),
              );
            }
            if (state is CategoryDoneState) {
              return ListView.builder(
                itemCount: state.categories!.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return _buildProductsCategorySection(
                      item: state.categories![index],
                      context: context1,
                      width: width,
                      height: height);
                },
              );
            }
            return Container(
              width: width,
              height: 184.h,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    EdgeMargin.small, 0.0, EdgeMargin.small, 0.0),
                child: HomeAdsItemShimmer(
                  height: 184,
                  width: width,
                ),
              ),
            );
          }),
    );
  }
}

class GetDrawer extends StatelessWidget {
  final state;
  final height;
  Function getListMaterialResideMenuItem;

  GetDrawer(this.state, this.height, this.getListMaterialResideMenuItem);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Translations.of(context).translate("menuAppBar"),
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: new Container(
        padding: new EdgeInsets.only(left: 5, right: 5),
        child: Container(
          child: new ListView(
            physics: const BouncingScrollPhysics(),
            // itemExtent: 40.0,
            shrinkWrap: true,
            children: getListMaterialResideMenuItem(state),
          ),
        ),
      ),
    );
  }
}

enum MenuSpecItem {
  HomePage,
  ProfilePage,
  BrandPage,
  OrderPage,
  SectionPage,
  WalletPage,
  FavoritePage,
  ReviewsPage,
  OffersPage,
  SettingsPage,
  RETRIVEPAGE,
  SignInPage,
  SignOut
}
