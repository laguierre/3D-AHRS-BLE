import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'constants.dart';

class MonserratFont extends StatelessWidget {
  const MonserratFont({
    // ignore: non_constant_identifier_names
    Key key,
    @required this.string,
    @required this.size,
    @required this.color,
  }) : super(key: key);

  final String string;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(string,
        style: TextStyle(
          fontFamily: 'Monserrat',
          color: color,
          fontSize: size,
        ));
  }
}

class MonserratFontBold extends StatelessWidget {
  const MonserratFontBold({
    // ignore: non_constant_identifier_names
    Key key,
    @required this.string,
    @required this.size,
    @required this.color,
  }) : super(key: key);

  final String string;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      string,
      style: TextStyle(
          fontFamily: 'Monserrat',
          color: color,
          fontSize: size,
          fontWeight: FontWeight.bold),
    );
  }
}

void ShowToast(String Msg) {
  Fluttertoast.showToast(
    msg: Msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.lightBlue,
    textColor: Colors.white,
    fontSize: 12.0,
  );
}
