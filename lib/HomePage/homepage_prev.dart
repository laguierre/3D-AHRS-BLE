import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import '../btoff_screen.dart';
import 'homepage.dart';

class StreamHomePage extends StatelessWidget {
  const StreamHomePage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BluetoothState>(
        stream: FlutterBlue.instance.state,
        initialData: BluetoothState.unknown,
        builder: (c, snapshot) {
          final state = snapshot.data;
          if (state == BluetoothState.on) {
            return HomePage();
          }
          return BluetoothOffScreen(state: state);
        });
  }
}