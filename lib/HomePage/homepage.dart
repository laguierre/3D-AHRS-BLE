import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wise/HomePage/body_homepage.dart';
import 'package:wise/constants.dart';

import '../funtions.dart';
import 'fab_search_devices.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBody: true,
      appBar: buildAppBar(),
      body: BodyHome(size: size),
      floatingActionButton: FABSearchDevices(),
      bottomNavigationBar: BottomAppBarHome(size: size),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      actions: [
        //Icon(Icons.bluetooth, size: 50,),
        Row(
          children: [
            MonserratFontBold(string: "Help", size: 18, color: kTextColor),
            const SizedBox(width: 2),
            IconButton(
              padding: EdgeInsets.only(right: 10),
              icon: SvgPicture.asset(
                "assets/icons/help-file.svg",
                height: 35,
                color: kTextColor,
              ),
              onPressed: () {
                _showModalBottomMenu(context);
              },
            ),
          ],
        ),
      ],
    );
  }
}

class BottomAppBarHome extends StatelessWidget {
  const BottomAppBarHome({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.transparent,
      elevation: 0,
      //shape: CircularNotchedRectangle(),
      child: Container(
        height: size.height * 0.06,
        decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(45))),
      ),
    );
  }
}

void _showModalBottomMenu(BuildContext ctx) {
  showModalBottomSheet(
    isScrollControlled: true,
    elevation: 5,
    context: ctx,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    builder: (ctx) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            const SizedBox(width: 10, height: 50),
            MonserratFont(
              string: 'Data',
              size: kFontBottomMenu,
              color: kColorBottomMenu,
            ),
            const SizedBox(width: 3),
            MonserratFontBold(
                string: 'Format',
                size: kFontBottomMenu,
                color: kColorBottomMenu),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MonserratFont(
              string:
                  'Pitch (double) + "," + Roll (double) + "," + Yaw (double) + "LR"',
              size: 13,
              color: kColorBottomMenu,
            ),
          ],
        ),
        const SizedBox(height: 15),
      ],
    ),
  );
}
