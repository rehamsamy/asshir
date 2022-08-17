import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart' as Get;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ojos_app/core/appConfig.dart';
import 'package:ojos_app/core/datasources/concrete_core_remote_data_source.dart';
import 'package:ojos_app/core/localization/translations.dart';
import 'package:ojos_app/core/params/no_params.dart';
import 'package:ojos_app/core/repositories/core_repository.dart';
import 'package:ojos_app/core/res/app_assets.dart';
import 'package:ojos_app/core/res/edge_margin.dart';
import 'package:ojos_app/core/res/global_color.dart';
import 'package:ojos_app/core/res/screen/horizontal_padding.dart';
import 'package:ojos_app/core/res/screen/vertical_padding.dart';
import 'package:ojos_app/core/res/text_style.dart';
import 'package:ojos_app/core/res/utils.dart';
import 'package:ojos_app/core/res/width_height.dart';
import 'package:ojos_app/core/ui/button/arrow_back_button_widget.dart';
import 'package:ojos_app/core/ui/widget/image/image_caching.dart';
import 'package:ojos_app/core/usecases/get_cities.dart';
import 'package:ojos_app/features/cart/data/models/retrieve_page_arguments.dart';
import 'package:ojos_app/features/cart/presentation/pages/order_products.dart';
import 'package:ojos_app/features/cart/presentation/pages/retrieve_page.dart';
import 'package:ojos_app/features/order/data/models/order_detaill.dart';
import 'package:ojos_app/features/order/data/models/order_products_arguments.dart';
import 'package:ojos_app/features/order/domain/entities/city_order_entity.dart';
import 'package:ojos_app/features/order/domain/entities/general_order_item_entity.dart';
import 'package:ojos_app/features/order/domain/entities/pop_result.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../main.dart';
import '../../domain/entities/order_item_entity.dart';

Set<Marker> markers = {};

/// initial position
CameraPosition _initialLocation = CameraPosition(
    target: LatLng(34.80207500000000209183781407773494720458984375,
        38.996814999999998008206603117287158966064453125),
    zoom: 13);

Completer<GoogleMapController> _mapController = Completer();

///
Map<PolylineId, Polyline> polylines = {};
BitmapDescriptor? pinLocationIcon;

///
GoogleMapController? mapController;

///
Position? _currentPosition;
String? _currentAddress;

class OrderDetailsPage extends StatefulWidget {
  static const routeName = '/order/pages/OrderDetailsPage';

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<OrderDetailsPage> {
  double latitude = 0.0;
  double longitude = 0.0;
  final args = Get.Get.arguments as GeneralOrderItemEntity;

  @override
  void initState() {
    super.initState();
    latitude = args.user_address!.latitude ?? 0.0;
    longitude = args.user_address!.longitude ?? 0.0;
  }

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var _cancelToken = CancelToken();

  ///===========================================================================

  Permission _permission = Permission.location;
  PermissionStatus _permissionStatus = PermissionStatus.denied;

  // Method for retrieving the current location
  _getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        _currentPosition = Position(
          latitude: latitude,
          longitude: longitude,
          timestamp: null,
          accuracy: 0.0,
          altitude: 0.0,
          heading: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0,
          floor: 0,
          isMocked: false,
        );
        print('CURRENT POS: $_currentPosition');
        mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(latitude, longitude),
              // target: LatLng(40.732128, -73.999619),
              zoom: 13.0,
            ),
          ),
        );

        markers.add(Marker(
            markerId: MarkerId('current_Postion'),
            infoWindow: InfoWindow(title: 'Current Position'),
            position: LatLng(position.latitude, position.longitude),
            icon: pinLocationIcon!));
      });
      await _getAddress();
    }).catchError((e) {
      print(e);
    });
  }

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), AppAssets.location_png);
  }

  // Method for retrieving the address
  _getAddress() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          _currentPosition!.latitude, _currentPosition!.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
        // startAddressController.text = _currentAddress;
        // _startAddress = _currentAddress;
      });
    } catch (e) {
      print(e);
    }
  }

  ConcreteCoreRemoteDataSource remoteDataSource =
      ConcreteCoreRemoteDataSource();

  void _listenForPermissionStatus() async {
    final status = await _permission.status;
    setState(() => _permissionStatus = status);
    if (_permissionStatus.isGranted) {
      await _getCurrentLocation();
    } else {
      requestPermission(_permission);
    }
  }

  Future<void> requestPermission(Permission permission) async {
    final status = await permission.request();

    setState(() {
      print(status);
      _permissionStatus = status;
      print(_permissionStatus);
    });
    if (_permissionStatus.isGranted) {
      await _getCurrentLocation();
    }
  }

  ///===========================================================================
  @override
  void dispose() {
    _cancelToken.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //=========================================================================
    AppBar appBar = AppBar(
      backgroundColor: globalColor.appBar,
      brightness: Brightness.light,
      elevation: 0,
      leading: ArrowIconButtonWidget(
        iconColor: globalColor.black,
      ),
      title: Text(
        Translations.of(context).translate('order_details'),
        style: textStyle.middleTSBasic.copyWith(color: globalColor.black),
      ),
      centerTitle: true,
    );

    double width = globalSize.setWidthPercentage(100, context);
    double height = globalSize.setHeightPercentage(100, context) -
        appBar.preferredSize.height -
        MediaQuery.of(context).viewPadding.top;

    return Scaffold(
        appBar: appBar,
        key: _scaffoldKey,
        body: Container(
            height: height,
            child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                  child: Column(
                    children: [
                      _buildOrderInfoWidget(
                          context: context,
                          name: args.paymentmehtod!,
                          height: height,
                          width: width,
                          price: args.total.toString(),
                          orderNumber: args.order_number!,
                          date: args.order_date!),
                      VerticalPadding(
                        percentage: 2.0,
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                            left: EdgeMargin.min, right: EdgeMargin.min),
                        child: _buildMap(
                            width: width,
                            height: height,
                            context: context,
                            args: args),
                      ),
                      VerticalPadding(
                        percentage: 2.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          EdgeMargin.subMin,
                          EdgeMargin.verySub,
                          EdgeMargin.subMin,
                          EdgeMargin.verySub,
                        ),
                        child: InkWell(
                          onTap: () {
                            // Get.Get.toNamed(OrderProducts.routeName,
                            //     arguments: OrderProductsArguments(
                            //         products: args.order_items));
                            Navigator.of(context).pushNamed(OrderProducts.routeName,arguments:
                            OrderProductsArguments(products: args.order_items, orderId : args.id)).then((results) {
                              if (results is PopWithResults) {
                                PopWithResults popResult = results;
                                if (popResult.toPage == RetrievePage.routeName) {
                                    Get.Get.toNamed(RetrievePage.routeName, arguments: RetrievePageArguments(
                                      product_id: results.results['product_id'],
                                      order_id: results.results['order_id']
                                    ));
                                } else {
                                  // pop to previous page
                                  Navigator.of(context).pop(results);
                                }
                              }
                            });
                          },
                          child: Container(
                            width: width,
                            alignment: Alignment.topRight,
                            decoration: BoxDecoration(
                              color: globalColor.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.w)),
                              border: Border.all(
                                  color: globalColor.grey.withOpacity(0.3),
                                  width: 0.5),
                            ),
                            padding: const EdgeInsets.fromLTRB(
                              EdgeMargin.subMin,
                              EdgeMargin.verySub,
                              EdgeMargin.subMin,
                              EdgeMargin.verySub,
                            ),
                            child: Text(
                              Translations.of(context)
                                  .translate('all_products'),
                            ),
                          ),
                        ),
                      ),
                      VerticalPadding(
                        percentage: 2.0,
                      ),
                      _buildPaymentMethodWidget(
                          width: width,
                          height: height,
                          context: context,
                          name: args.paymentmehtod ?? ''),
                      _orderStatus(
                          width: width,
                          height: height,
                          context: context,
                          status: args.status!),
                      _buildPriceSummeryWidget(
                          width: width,
                          height: height,
                          context: context,
                          order: args),
                      Container(
                          alignment: AlignmentDirectional.center,
                          padding: const EdgeInsets.only(
                              left: EdgeMargin.min, right: EdgeMargin.min),
                          child: Text(
                            '${Translations.of(context).translate('all_prices_include')} ${args.tax?.toString()} ${Translations.of(context).translate('from_value_tax')} \n ${Translations.of(context).translate('the_number_of_products')} ${_getCount(args.order_items ?? []) ?? ''}',
                            style: textStyle.smallTSBasic.copyWith(
                                color: globalColor.black,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          )),
                      VerticalPadding(
                        percentage: 4.0,
                      ),
                    ],
                  ),
                ))));
  }
}

_getCount(List<OrderItemEntity> list) {
  int count = 0;
  if (list != null && list.isNotEmpty) {
    for (OrderItemEntity item in list) {
      if (item.quantity != null && item.quantity != 0) {
        count += item.quantity!;
      }
    }
  }
  return count;
}

_buildOrderInfoWidget(
    {required BuildContext context,
    required double width,
    required double height,
    required String name,
    required String orderNumber,
    required String price,
    required String date}) {
  return Container(
    padding: const EdgeInsets.fromLTRB(
      EdgeMargin.subMin,
      EdgeMargin.verySub,
      EdgeMargin.subMin,
      EdgeMargin.verySub,
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(12.w)),
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          0,
          EdgeMargin.verySub,
          0,
          EdgeMargin.verySub,
        ),
        decoration: BoxDecoration(
          color: globalColor.white,
          borderRadius: BorderRadius.all(Radius.circular(12.w)),
          border:
              Border.all(color: globalColor.grey.withOpacity(0.3), width: 0.5),
        ),
        //   margin: const EdgeInsets.only(left: EdgeMargin.verySub,),
        width: width,

        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    EdgeMargin.subMin,
                    EdgeMargin.verySub,
                    EdgeMargin.subMin,
                    EdgeMargin.verySub,
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 15.w,
                            height: 15.w,
                            decoration: BoxDecoration(
                                color: globalColor.primaryColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    width: 1.0,
                                    color: globalColor.primaryColor)),
                            child: Icon(
                              Icons.check,
                              color: globalColor.white,
                              size: 10.w,
                            ),
                          ),
                          HorizontalPadding(
                            percentage: 1.0,
                          ),
                          Text(
                            name,
                            style: textStyle.middleTSBasic.copyWith(
                                color: globalColor.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            Translations.of(context).translate('order_no') +
                                ':',
                            style: textStyle.minTSBasic
                                .copyWith(color: globalColor.black),
                          ),
                          HorizontalPadding(
                            percentage: 1.0,
                          ),
                          Text(
                            orderNumber,
                            style: textStyle.minTSBasic
                                .copyWith(color: globalColor.primaryColor),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            Translations.of(context).translate('order_date') +
                                ':',
                            style: textStyle.minTSBasic
                                .copyWith(color: globalColor.black),
                          ),
                          HorizontalPadding(
                            percentage: 1.0,
                          ),
                          Text(
                            date,
                            style: textStyle.minTSBasic
                                .copyWith(color: globalColor.primaryColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: 1.0,
              color: globalColor.grey.withOpacity(0.3),
            ),
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.fromLTRB(
                  EdgeMargin.subMin,
                  EdgeMargin.verySub,
                  EdgeMargin.subMin,
                  EdgeMargin.verySub,
                ),
                alignment: AlignmentDirectional.center,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    HorizontalPadding(
                      percentage: 1.0,
                    ),
                    Text(
                      price,
                      style: textStyle.bigTSBasic.copyWith(
                          color: globalColor.primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                    HorizontalPadding(
                      percentage: 1.0,
                    ),
                    Text(
                      '${Translations.of(context).translate('rail')}',
                      style: textStyle.middleTSBasic
                          .copyWith(color: globalColor.primaryColor),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

_buildMap(
    {required BuildContext context,
    required double width,
    required double height,
    required GeneralOrderItemEntity args}) {
  return ClipRRect(
    borderRadius: BorderRadius.all(Radius.circular(12.w)),
    child: Container(
      decoration: BoxDecoration(
        color: globalColor.white,
        borderRadius: BorderRadius.all(Radius.circular(12.w)),
        border:
            Border.all(color: globalColor.grey.withOpacity(0.3), width: 0.5),
      ),
      //   margin: const EdgeInsets.only(left: EdgeMargin.verySub,),
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          VerticalPadding(
            percentage: 0.5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    EdgeMargin.subMin,
                    EdgeMargin.verySub,
                    EdgeMargin.subMin,
                    EdgeMargin.verySub,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        Translations.of(context)
                            .translate('cart_txt_delivery_location'),
                        style: textStyle.smallTSBasic.copyWith(
                            color: globalColor.black,
                            fontWeight: FontWeight.bold),
                      ),
                      HorizontalPadding(
                        percentage: 1.0,
                      ),
                      // Text(
                      //   Translations.of(context)
                      //       .translate('cart_txt_automatic_GPS_selections'),
                      //   style: textStyle.smallTSBasic.copyWith(
                      //       color: globalColor.primaryColor,
                      //       fontWeight: FontWeight.bold),
                      // ),
                    ],
                  ),
                ),
              ),
              Container(
                child: Icon(
                  utils.getLang() != 'ar'
                      ? Icons.keyboard_arrow_right
                      : Icons.keyboard_arrow_left,
                  color: globalColor.black,
                ),
              ),
            ],
          ),
          VerticalPadding(
            percentage: 0.5,
          ),
          Container(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    EdgeMargin.subMin,
                    EdgeMargin.verySub,
                    EdgeMargin.subMin,
                    EdgeMargin.verySub,
                  ),
                  child: _buildLocatinText(args)))
        ],
      ),
    ),
  );
}

_buildLocatinText(GeneralOrderItemEntity args) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Text(
        '- ${args.cityname} , ${args.neighborhood} ',
        style: textStyle.middleTSBasic.copyWith(color: globalColor.black),
      ),
      SizedBox(height: 5),
      Text(
        '- ${args.deliveryto} ${args.dest_name == null ? '' : args.dest_name}',
        style: textStyle.middleTSBasic.copyWith(color: globalColor.black),
      ),
      SizedBox(height: 5),
      (args.load_product != null && args.quantity_name != null)
          ? Text(
              '- ${args.load_product} ${args.quantity_name == null ? '' : args.quantity_name}',
              style: textStyle.middleTSBasic.copyWith(color: globalColor.black),
            )
          : Container(),
      SizedBox(height: 5),
      (args.guard_number != null)
          ? Text(
              '- ${args.guard_number}',
              style: textStyle.middleTSBasic.copyWith(color: globalColor.black),
            )
          : Container()
    ],
  );
}

_buildPaymentMethodWidget({
  required BuildContext context,
  required double width,
  required double height,
  required String name,
}) {
  return Container(
    padding: const EdgeInsets.fromLTRB(
      EdgeMargin.subMin,
      EdgeMargin.verySub,
      EdgeMargin.subMin,
      EdgeMargin.verySub,
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(12.w)),
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          EdgeMargin.min,
          EdgeMargin.min,
          EdgeMargin.min,
          EdgeMargin.min,
        ),
        decoration: BoxDecoration(
          color: globalColor.white,
          borderRadius: BorderRadius.all(Radius.circular(12.w)),
          border:
              Border.all(color: globalColor.grey.withOpacity(0.3), width: 0.5),
        ),
        //   margin: const EdgeInsets.only(left: EdgeMargin.verySub,),
        width: width,

        child: Row(
          children: [
            Text(
              Translations.of(context).translate('payment_method'),
              style: textStyle.smallTSBasic.copyWith(
                  color: globalColor.black, fontWeight: FontWeight.bold),
            ),
            HorizontalPadding(
              percentage: 3.0,
            ),
            Expanded(
              flex: 5,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    EdgeMargin.subMin,
                    EdgeMargin.verySub,
                    EdgeMargin.subMin,
                    EdgeMargin.verySub,
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 15.w,
                            height: 15.w,
                            decoration: BoxDecoration(
                                color: globalColor.primaryColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    width: 1.0,
                                    color: globalColor.primaryColor)),
                            child: Icon(
                              Icons.check,
                              color: globalColor.white,
                              size: 10.w,
                            ),
                          ),
                          HorizontalPadding(
                            percentage: 1.0,
                          ),
                          Text(
                            name,
                            style: textStyle.middleTSBasic.copyWith(
                                color: globalColor.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

_orderStatus({
  required BuildContext context,
  required double width,
  required double height,
  required String status,
}) {
  return Container(
    padding: const EdgeInsets.fromLTRB(
      EdgeMargin.subMin,
      EdgeMargin.verySub,
      EdgeMargin.subMin,
      EdgeMargin.verySub,
    ),
    height: 41.h,
    child: ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(12.w)),
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          0,
          0,
          0,
          0,
        ),
        decoration: BoxDecoration(
          color: globalColor.white,
          borderRadius: BorderRadius.all(Radius.circular(12.w)),
          border:
              Border.all(color: globalColor.grey.withOpacity(0.3), width: 0.5),
        ),
        //   margin: const EdgeInsets.only(left: EdgeMargin.verySub,),
        width: width,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(12.w)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(
                      left: EdgeMargin.subMin, right: EdgeMargin.subMin),
                  child: Text(
                    '${Translations.of(context).translate('order_status')}',
                    style: textStyle.smallTSBasic.copyWith(
                        color: globalColor.black, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
              Container(
                //margin: const EdgeInsets.only(left:EdgeMargin.min,right: EdgeMargin.min),
                width: 148.w,
                height: 41.h,
                color: globalColor.scaffoldBackGroundGreyColor,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: _getColorStatus(
                                  context: context, status: status) ??
                              globalColor.green,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: globalColor.grey.withOpacity(0.2),
                              width: 1.0)),
                      width: 12.w,
                      height: 12.w,
                    ),
                    HorizontalPadding(
                      percentage: 1,
                    ),
                    Text(
                      //'${Translations.of(context).translate('delivery_stage')}',
                      _getStrStatus(context: context, status: status),
                      style: textStyle.minTSBasic
                          .copyWith(color: globalColor.primaryColor),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

_buildOrderSummeryWidget({
  required BuildContext context,
  required double width,
  required double height,
  required OrderDetails order,
}) {
  return order.result.orderItems != null && order.result.orderItems.isNotEmpty
      ? Container(
          padding: const EdgeInsets.fromLTRB(
            EdgeMargin.subMin,
            EdgeMargin.verySub,
            EdgeMargin.subMin,
            EdgeMargin.verySub,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Translations.of(context).translate('order_details'),
                style: textStyle.smallTSBasic.copyWith(
                    color: globalColor.black, fontWeight: FontWeight.bold),
              ),
              Container(
                child: ListView.builder(
                  itemCount: order.result.orderItems.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {},
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(12.w)),
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(
                            EdgeMargin.min,
                            EdgeMargin.min,
                            EdgeMargin.min,
                            EdgeMargin.min,
                          ),
                          decoration: BoxDecoration(
                            color: globalColor.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.w)),
                            border: Border.all(
                                color: globalColor.grey.withOpacity(0.3),
                                width: 0.5),
                          ),
                          //   margin: const EdgeInsets.only(left: EdgeMargin.verySub,),
                          width: width,

                          child: Row(
                            children: [
                              Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: globalColor.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  border: Border.all(
                                      color: globalColor.primaryColor,
                                      width: 0.5),
                                ),
                                padding: const EdgeInsets.all(
                                  EdgeMargin.verySub,
                                ),
                                child: ImageCacheWidget(
                                  imageUrl:
                                      order.result.orderItems[index].image,
                                  imageWidth: 30,
                                  imageHeight: 30,
                                  imageBorderRadius: 4,
                                ),
                              ),
                              HorizontalPadding(
                                percentage: 3.0,
                              ),
                              Text(
                                order.result.orderItems[index].name,
                                style: textStyle.smallTSBasic
                                    .copyWith(color: globalColor.primaryColor),
                              ),
                              HorizontalPadding(
                                percentage: 3.0,
                              ),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      EdgeMargin.subMin,
                                      EdgeMargin.verySub,
                                      EdgeMargin.subMin,
                                      EdgeMargin.verySub,
                                    ),
                                    child: FittedBox(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            Translations.of(context)
                                                .translate('product_info'),
                                            style: textStyle.smallTSBasic
                                                .copyWith(
                                                    color: globalColor.black),
                                          ),
                                          HorizontalPadding(
                                            percentage: 1.0,
                                          ),
                                          Text(
                                            order.result.orderItems[index].price
                                                .toString() //??"0"
                                            // ?.priceAfterDiscount
                                            ,
                                            style: textStyle.smallTSBasic
                                                .copyWith(
                                                    color: globalColor
                                                        .primaryColor,
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ),
                                          Text(
                                            '${Translations.of(context).translate('rail')}',
                                            style: textStyle.smallTSBasic
                                                .copyWith(
                                                    color: globalColor
                                                        .primaryColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        )
      : Container();
}

_buildPriceSummeryWidget({
  required BuildContext context,
  required double width,
  required double height,
  required GeneralOrderItemEntity order,
}) {
  // print('order is ======================${order.delivery_fee5.toString()}');
  // print("Ammmmmmmmmmmmmmmmmro${order.delivery_fee}");
  return order.order_items != null && order.order_items!.isNotEmpty
      ? Container(
          padding: const EdgeInsets.fromLTRB(
            EdgeMargin.subMin,
            EdgeMargin.verySub,
            EdgeMargin.subMin,
            EdgeMargin.verySub,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Translations.of(context).translate('price'),
                style: textStyle.smallTSBasic.copyWith(
                    color: globalColor.black, fontWeight: FontWeight.bold),
              ),
              _buildPriceItem(
                width: width,
                height: height,
                context: context,
                title: Translations.of(context).translate('order_value'),
                value: order.orginal_price.toString(),
              ),
              _buildPriceItem(
                  width: width,
                  height: height,
                  context: context,
                  title:
                      Translations.of(context).translate('order_delivery_fee'),
                  value: order.delivery_fee != null
                      ? order.delivery_fee!.toDouble().toString()
                      : '0'),
              order.discount==null ||order.discount==0?SizedBox(): _buildPriceItem(
                width: width,
                height: height,
                context: context,
                title: Translations.of(context).translate('order_discount'),
                value: order.discount.toString(),
              ),
              _buildPriceItem(
                  width: width,
                  height: height,
                  context: context,
                  title: Translations.of(context).translate('order_total'),
                  value: getTotal(order)),
            ],
          ),
        )
      : Container();
}

getTotal(GeneralOrderItemEntity order) {
  if (order.orginal_price == null) order.orginal_price = 0;
  if (order.delivery_fee == null) order.delivery_fee = 0;
  if (order.discount == null) order.discount = 0;
  if (order.shipping_fee == null) order.shipping_fee = 0;

  return ((order.orginal_price! + order.delivery_fee! + order.shipping_fee!) -
          order.discount!)
      .abs()
      .toString();
}

_buildPriceItem(
    {required BuildContext context,
    required double width,
    required double height,
    required String title,
    required String value}) {
  return ClipRRect(
    borderRadius: BorderRadius.all(Radius.circular(12.w)),
    child: Container(
      padding: const EdgeInsets.fromLTRB(
        EdgeMargin.min,
        EdgeMargin.min,
        EdgeMargin.min,
        EdgeMargin.min,
      ),
      decoration: BoxDecoration(
        color: globalColor.white,
        borderRadius: BorderRadius.all(Radius.circular(12.w)),
        border:
            Border.all(color: globalColor.grey.withOpacity(0.3), width: 0.5),
      ),
      //   margin: const EdgeInsets.only(left: EdgeMargin.verySub,),
      width: width,

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: textStyle.smallTSBasic.copyWith(color: globalColor.black),
          ),
          HorizontalPadding(
            percentage: 3.0,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: textStyle.smallTSBasic.copyWith(
                    color: globalColor.primaryColor,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                '${Translations.of(context).translate('rail')}',
                style: textStyle.smallTSBasic
                    .copyWith(color: globalColor.primaryColor),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

_getStrStatus({required BuildContext context, required String status}) {
  switch (status) {
    case "pending":
      return Translations.of(context).translate('pending');
      break;
    case "accepted":
      return Translations.of(context).translate('accepted');
      break;

    case "shipped":
      return Translations.of(context).translate('shipped');
      break;

    case "completed":
      return Translations.of(context).translate('completed');
      break;

    case "canceled":
      return Translations.of(context).translate('canceled');
      break;
  }
}

_getColorStatus({required BuildContext context, required String status}) {
  switch (status) {
    case "pending":
      return globalColor.buttonColorOrange;
      break;

    case "accepted":
      return globalColor.buttonColorOrange;
      break;

    case "shipping":
      return globalColor.buttonColorOrange;
      break;

    case "canceled":
      return globalColor.red;
      break;

    case "completed":
      return globalColor.green;
      break;
  }
}
/*
else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
 */
