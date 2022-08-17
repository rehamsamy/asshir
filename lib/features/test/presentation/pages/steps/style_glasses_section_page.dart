import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ojos_app/core/bloc/application_bloc.dart';
import 'package:ojos_app/core/entities/extra_glasses_item_entity.dart';
import 'package:ojos_app/core/localization/translations.dart';
import 'package:ojos_app/core/res/edge_margin.dart';
import 'package:ojos_app/core/res/global_color.dart';
import 'package:ojos_app/core/res/screen/horizontal_padding.dart';
import 'package:ojos_app/core/res/text_style.dart';
import 'package:ojos_app/core/res/width_height.dart';
import 'package:ojos_app/core/ui/widget/button/rounded_button.dart';
import 'package:ojos_app/features/test/presentation/widgets/style_glasses_select_widget.dart';

class StyleGlassesSectionPage extends StatefulWidget {
  // static const routeName =
  //     '/features/add_car/presentation/pages/AddNewCarStep1';

  final PageController controller;
  final double? height;
  final double? width;
  final Function(int, String, int)? onSelect;

  const StyleGlassesSectionPage({
    required this.controller,
    required this.width,
    required this.height,
    required this.onSelect,
  });

  @override
  _StyleGlassesSectionPageState createState() =>
      _StyleGlassesSectionPageState();
}

class _StyleGlassesSectionPageState extends State<StyleGlassesSectionPage> {
  bool? _isSelected;
  int? _styleSelected;
  List<ExtraGlassesItemEntity>? gender;
  @override
  void initState() {
    super.initState();
    gender =
        BlocProvider.of<ApplicationBloc>(context).state.extraGlasses?.gender ??
            [];
    _isSelected = false;
  }

  @override
  Widget build(BuildContext context) {
    double widthC = widget.width ?? globalSize.setWidthPercentage(100, context);
    double heightC =
        widget.height ?? globalSize.setHeightPercentage(100, context);

    return Scaffold(
        backgroundColor: globalColor.scaffoldBackGroundGreyColor,
        body: Container(
            width: widthC,
            height: heightC,
            // color: globalColor.white,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            alignment: AlignmentDirectional.centerStart,
                            padding: const EdgeInsets.only(
                                left: EdgeMargin.min, right: EdgeMargin.min),
                            child: Text(
                              Translations.of(context)
                                  .translate('select_the_style_of_the glasses'),
                              style: textStyle.middleTSBasic.copyWith(
                                  color: globalColor.black,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          StyleGlassesSelectWidget(
                            onSelected: _onSelectedStyle,
                            items: gender!,
                            width: widthC,
                            height: heightC - 83.h,
                          ),
                        ],
                      )),
                ),
                _buildButtonsWidget(
                    height: heightC, context: context, widthC: widthC),
              ],
            )));
  }

  _buildButtonsWidget(
      {required BuildContext context,
      required double widthC,
      required double height}) {
    return Container(
      height: 80.h,
      width: widthC,
      color: globalColor.white,
      child: Center(
        child: Container(
          height: 50.h,
          padding: const EdgeInsets.only(
              left: EdgeMargin.min, right: EdgeMargin.min),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  child: RoundedButton(
                height: 50.h,
                width: widthC * .35,
                color: globalColor.primaryColor,
                onPressed: _styleSelected == null
                    ? () {}
                    : () {
                        if (widget.onSelect != null) {
                          widget.onSelect!(2, 'face_size', _styleSelected!);
                          widget.controller.nextPage(
                              duration: kTabScrollDuration, curve: Curves.ease);
                        }
                      },
                borderRadius: 8.w,
                child: Container(
                  child: Center(
                    child: Text(
                      Translations.of(context).translate('continue'),
                      style: textStyle.smallTSBasic
                          .copyWith(color: globalColor.white),
                    ),
                  ),
                ),
              )),
              HorizontalPadding(
                percentage: 4.0,
              ),
              Container(
                  child: RoundedButton(
                height: 50.h,
                width: widthC * .35,
                color: globalColor.backgroundLightPrim,
                onPressed: () {},
                borderRadius: 8.w,
                child: Container(
                  child: Center(
                    child: Text(
                      Translations.of(context).translate('cancel'),
                      style: textStyle.smallTSBasic
                          .copyWith(color: globalColor.black),
                    ),
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  _onSelectedStyle(int selected) {
    if (mounted)
      setState(() {
        _styleSelected = selected;
      });
    print('style selected is ${_styleSelected.toString()}');
  }
}
