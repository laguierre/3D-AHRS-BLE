import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:wise/DevicesPage/devices_page.dart';
import 'package:wise/widgets/widgets.dart';

import '../constants.dart';
import '../funtions.dart';

class BodyHome extends StatelessWidget {
  const BodyHome({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: size.height * 0.07,
              decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: new BorderRadius.only(
                      bottomRight:
                          const Radius.circular(kRadiusHomeContainer))),
            ),
            Row(
              children: [
                SizedBox(
                  width: 10,
                  height: 40,
                ),
                SizedBox(width: 5),
                Image.asset("assets/icons/bluetooth-searching-signal-indicator.png", scale: 19, color: kTextColor,),
                MonserratFont(
                  string: ' Search',
                  size: kFontSizeHome,
                  color: kTextColor,
                ),
                SizedBox(width: 3),
                MonserratFontBold(
                  string: 'Devices',
                  size: kFontSizeHome,
                  color: kTextColor,
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 10,),
        StreamBuilder<List<ScanResult>>(
          stream: FlutterBlue.instance.scanResults,
          initialData: [],
          builder: (c, snapshot) => Column(
            children: snapshot.data
                .map(
                  (r) => ScanResultTile(
                    result: r,
                    onTap: () => Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      r.device.connect();
                      return DevicePage(device: r.device);
                    })),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
