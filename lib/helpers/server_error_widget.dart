 import 'package:flutter/material.dart';

class ServerErrorWidget extends StatelessWidget {
  final String? errorType;

  final int? statusCode;

  const ServerErrorWidget(this.errorType, this.statusCode);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () {
          // if (statusCode == 401) {
          //   visitorDialog(context);
          // }
        },
        child: Container(
          // width: MediaQuery.of(context).size.width * .7,
          height: MediaQuery.of(context).size.height * .8,
          child: Column(
            children: [
              Image.asset(statusCode == 0
                  ? "assets/images/no-connection.png"
                  : statusCode == 401
                  ? "assets/images/401.png"
                  : "assets/images/error.png"),
              SizedBox(
                height: 10,
              ),
              Text(
                errorType!,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                   letterSpacing: 2,
                  wordSpacing: 1,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ServerErrorText extends StatelessWidget {
  final String errorType;
  final int statusCode;

  const ServerErrorText(this.errorType, this.statusCode);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () {},
        child: Text(
          errorType,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
             letterSpacing: 2,
            wordSpacing: 1,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
