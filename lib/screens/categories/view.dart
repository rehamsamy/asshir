import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';
import 'package:ojos_app/helpers/server_error_widget.dart';
import 'package:ojos_app/screens/categories/bloc/events.dart';
import 'package:ojos_app/screens/categories/bloc/states.dart';
import 'bloc/bloc.dart';

class CategoriesView extends StatefulWidget {
  const CategoriesView({Key? key}) : super(key: key);

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  final _categoriesBloc = KiwiContainer().resolve<CategoriesBloc>();

  @override
  void initState() {
    super.initState();
    _categoriesBloc.add(CategoriesEventStart());
  }

  @override
  void dispose() {
    super.dispose();
    _categoriesBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         title: Text("categories",style: TextStyle(color: Colors.black),),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: _categories()),
    );
  }

  Widget _categories() {
    return Center(
      child: BlocBuilder(
        bloc: _categoriesBloc,
        builder: (context, state) {
          if (state is CategoriesStateStart) {
            return CupertinoActivityIndicator(
              radius: 30,
            );
          } else if (state is CategoriesStateSuccess) {
            return state.data!.isEmpty
                ? Text(
                    "No data found",
                  )
                : ListView.builder(
                    itemCount: state.data!.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, int index) {
                      return Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: ListTile(
                            title: Text(state.data![index].name),
                            subtitle: Text(state.data![index].description),
                          ));
                    });
          } else if (state is CategoriesStateFailed) {
            return ServerErrorWidget(state.msg, state.statusCode);
          } else {
            return CupertinoActivityIndicator(
              radius: 30,
            );
          }
        },
      ),
    );
  }
}
