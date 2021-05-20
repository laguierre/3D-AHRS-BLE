import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:wise/constants.dart';
import 'package:wise/funtions.dart';

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key key, this.state}) : super(key: key);

  final BluetoothState state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: kPrimaryColor,
            ),
            SizedBox(height: 10,),
            MonserratFontBold(string: 'Bluetooth Adapter is ${state.toString().substring(15)}.', size: 20, color: kPrimaryColor),
          ],
        ),
      ),
    );
  }
}