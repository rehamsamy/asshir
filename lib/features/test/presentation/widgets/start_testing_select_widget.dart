import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ojos_app/core/entities/extra_glasses_item_entity.dart';
import 'package:ojos_app/core/localization/translations.dart';
import 'package:ojos_app/core/res/edge_margin.dart';
import 'package:ojos_app/core/res/global_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ojos_app/core/res/text_style.dart';
import 'package:ojos_app/core/ui/widget/normal_assets_image.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class StartTestingSelectWidget extends StatefulWidget {
  final Function(int) onSelected;
  final double width;
  final double height;
  final List<ExtraGlassesItemEntity> items;

  const StartTestingSelectWidget({required this.height, required this.width, required this.onSelected, required this.items});
  @override
  _HomeSelectStyleWidgetState createState() => _HomeSelectStyleWidgetState();
}

class _HomeSelectStyleWidgetState extends State<StartTestingSelectWidget> {
  //StyleSelected _selected=StyleSelected.MAN;

  int? selectedStyle;
  // final _controllerListOfStyle = ItemScrollController();
  // bool _isStyleEmpty = false;

  @override
  void initState() {
    super.initState();

    //
    //  gender = BlocProvider.of<ApplicationBloc>(context)?.state?.extraGlasses?.gender??[];
    // print('gender length ${BlocProvider.of<ApplicationBloc>(context)?.state?.extraGlasses?.toJson()}');
    // checkSelectedStyle();
  }
  //
  // void checkSelectedStyle() async{
  // //  final selected= await CoreRepository.selectedGenderStyle;
  //   int selected=-1111;
  //   await appSharedPrefs.selectedGenderStyle.then((value) {
  //     print( 'omar gender cached style in checkSelectedStyle fun is =  $value');
  //     selected=value;
  //     print( 'omar selected in checkSelectedStyle fun is =  $selected');
  //
  //   });
  //   if(selected == null || selected == -1111){
  //     if(gender!=null&& gender.isNotEmpty)
  //       appSharedPrefs.persistSelectedGenderStyle(gender[0].id).then((value) {
  //
  //         if(value){
  //           if(mounted)
  //             setState(() {
  //               selectedStyle=gender[0].id;
  //             });
  //
  //         }
  //       });
  //   }else{
  //    // selectedStyle =selected;
  //     print('omar here');
  //     if(mounted)
  //       setState(() {
  //         selectedStyle =selected;
  //       });
  //   }
  //   if(widget.onSelected!=null){
  //     widget.onSelected(selectedStyle);
  //   }
  //
  //   print('omar selectedStyle in checkSelectedStyle fun is  $selectedStyle');
  // }

  @override
  Widget build(BuildContext context) {
    return widget.items.isNotEmpty
        ? Container(
            width: widget.width,
            height: widget.height,
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 1,
                  childAspectRatio: widget.width * .475 / 149.h,
                ),
                padding: const EdgeInsets.only(left: EdgeMargin.subSubMin, right: EdgeMargin.subSubMin),
                itemCount: widget.items.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) => _buildItem(
                    context: context,
                    height: widget.height * .3,
                    width: widget.width * .475,
                    image: widget.items[index].image!,
                    title: widget.items[index].name!,
                    isSelected: selectedStyle == widget.items[index].id,
                    selected: widget.items[index].id!)),
          )
        : Container();
  }

  jumpToIndex(int index) {
    int indexOfList = 0;
    for (int i = 0; i < widget.items.length; i++) {
      if (widget.items[i].id == index) indexOfList = i;
    }

    return indexOfList;
  }

  _buildItem(
      {required String title,
      required bool isSelected,
      required String image,
      required double width,
      required double height,
      required BuildContext context,
      required int selected}) {
    return Container(
        decoration: BoxDecoration(
          color: globalColor.white,
          borderRadius: BorderRadius.circular(12.0.w),
        ),
        // padding: const EdgeInsets.all(2.0),
        width: width,
        height: height,
        margin: const EdgeInsets.only(left: EdgeMargin.sub, right: EdgeMargin.sub),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(EdgeMargin.sub),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(12.0.w)),
                  child: NormalAssetsImage(
                    imageUrl: image,
                    fit: BoxFit.fill,
                    width: width,
                    height: height * .15,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(
                      title,
                      style: textStyle.smallTSBasic.copyWith(color: globalColor.black),
                      maxLines: 1,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: InkWell(
                      hoverColor: globalColor.transparent,
                      splashColor: globalColor.transparent,
                      highlightColor: globalColor.transparent,
                      onTap: () {
                        if (mounted)
                          setState(() {
                            selectedStyle = selected;
                            // selectedStyle = selected;
                            // CoreRepository.persistSelectedGenderStyle(selectedStyle);
                            //  appSharedPrefs.persistSelectedGenderStyle(selected).then((value) {
                            //
                            //    if(value){
                            //      print( 'omar value in persistSelectedGenderStyle fun is =  $value');
                            //      print( 'omar value in persistSelectedGenderStyle fun is =  $selected');
                            //      if(mounted)
                            //        setState(() {
                            //          selectedStyle = selected;
                            //        });
                            //
                            //    }
                            //  });
                            // CoreRepository.persistSelectedGenderStyle(selected).then((value) {
                            //
                            //   if(value){
                            //     selectedStyle = selected;
                            //   }
                            // });
                            // CoreRepository.selectedGenderStyle.then((value) => print('chached gender $value'));
                          });
                        widget.onSelected(selected);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: globalColor.white,
                            borderRadius: BorderRadius.circular(12.0.w),
                            border: Border.all(width: .5, color: globalColor.grey.withOpacity(0.3))),
                        child: Padding(
                          padding: const EdgeInsets.all(EdgeMargin.sub),
                          child: FittedBox(
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 2.h,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: isSelected ? globalColor.primaryColor : globalColor.transparent,
                                      borderRadius: BorderRadius.circular(14.0),
                                      border: Border.all(
                                          width: isSelected ? 0.5 : 0,
                                          color: isSelected ? globalColor.primaryColor.withOpacity(0.3) : globalColor.transparent)),
                                  child: CircleAvatar(
                                    child: isSelected
                                        ? Icon(
                                            Icons.check,
                                            color: globalColor.black,
                                            size: 12,
                                          )
                                        : Container(),
                                    radius: 10,
                                    backgroundColor: isSelected ? globalColor.goldColor : globalColor.grey.withOpacity(0.3),
                                  ),
                                ),
                                SizedBox(
                                  width: 5.h,
                                ),
                                Text(
                                  Translations.of(context).translate('choose'),
                                  style: textStyle.minTSBasic.copyWith(color: globalColor.black),
                                ),
                                SizedBox(
                                  width: 5.h,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}

enum StyleSelected { MAN, WOMAN }
