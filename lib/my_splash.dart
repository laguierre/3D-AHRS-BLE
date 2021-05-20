import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wise/funtions.dart';
import 'HomePage/homepage_prev.dart';
import 'constants.dart';

const double sizeSplash = 50;
const double scaleIcon = 7;

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(
        Duration(milliseconds: delaySplash),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => StreamHomePage())));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Center(
      child: FractionallySizedBox(
        alignment: Alignment.center,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(45.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MonserratFont(string: '3d', size: 40, color: kPrimaryColor),
                    MonserratFontBold(
                        string: 'AHRS', size: 55, color: kPrimaryColor),
                    MonserratFont(
                        string: 'BLE ', size: 40, color: kPrimaryColor),
                  ],
                ),
              ),
              SizedBox(
                height: sizeSplash -20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icons/gyroscope.png',
                    scale: scaleIcon,
                    color: kPrimaryColor,
                  ),
                ],
              ),
              SizedBox(
                height: sizeSplash,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icons/compass.png',
                    scale: scaleIcon,
                    color: kPrimaryColor,
                  ),
                  SizedBox(
                    width: 3 * sizeSplash,
                  ),
                  Image.asset(
                    'assets/icons/rotate.png',
                    scale: scaleIcon,
                    color: kPrimaryColor,
                  ),
                ],
              ),
              SizedBox(
                height: sizeSplash,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icons/surface.png',
                    scale: scaleIcon,
                    color: kPrimaryColor,
                  ),
                ],
              ),
              SizedBox(
                height: 3 * sizeSplash,
              ),
              MonserratFontBold(
                  string: 'Loading...', size: 20, color: kPrimaryColor),
              SizedBox(
                height: 5,
              ),
              CircularProgressIndicator(backgroundColor: kPrimaryColor),
            ],
          ),
        ),
      ),
    )));
  }
}
