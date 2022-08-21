import 'package:flutter/material.dart';
import 'package:ojos_app/core/res/shared_preference_utils/shared_preferences.dart';
import 'package:ojos_app/core/res/width_height.dart';
import 'package:ojos_app/screens/home/widgetes/app_bar.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    double width = globalSize.setWidthPercentage(100, context);
    double height = globalSize.setHeightPercentage(100, context) -
        homeAppBar(context, appSharedPrefs.getToken() == '' ? false : true)
            .preferredSize
            .height -
        MediaQuery.of(context).viewPadding.top;

    return Scaffold(
      appBar: homeAppBar(
        context,
        appSharedPrefs.getToken() == '' ? false : true,
      ),
      body: Container(
          height: height,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [],
            ),
          )),
    );
  }
}
