import 'dart:async';
import 'dart:convert' show utf8;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vector_math/vector_math.dart' as VMath;

import '../constants.dart';
import '../funtions.dart';

class DevicePage extends StatefulWidget {
  final BluetoothDevice device;

  const DevicePage({Key key, this.device}) : super(key: key);

  @override
  _DevicePageState createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  bool isReady;
  bool isReadyTx;
  bool isReadyBatt;
  Stream<List<int>> stream; //Servicio de Rx
  Stream<List<int>> BattLevel;
  BluetoothCharacteristic characteristicDeviceTx; //Servicio de Tx
  double x, y, z;
  int Font = 16;
  String Pitch, Roll, Yaw;
  String LabelX = "Pitch", LabelY = "Roll", LabelZ = "Yaw";
  String Units = "[DEG]";
  String Mode = "AHRS";
  Object _pcb = Object(
      position: Vector3(0, 0, 0),
      fileName: fileName3D,
      backfaceCulling: true,
      scale: Vector3(kSizeOBJ, kSizeOBJ, kSizeOBJ));

  _DevicePageState();

  @override
  void initState() {
    super.initState();
    isReady = false;
    isReadyTx = false;
    isReadyBatt = false;
    connectToDevice();
  }

  connectToDevice() async {
    if (widget.device == null) {
      _Pop();
      return;
    }

    new Timer(const Duration(seconds: 15), () {
      if (!isReady) {
        disconnectFromDevice();
        _Pop();
      }
    });

    await widget.device.connect();
    discoverServices();
  }

  disconnectFromDevice() {
    if (widget.device == null) {
      _Pop();
      return;
    }
    widget.device.disconnect();
  }

  discoverServices() async {
    if (widget.device == null) {
      Navigator.of(context).pop(true); //_Pop();
      return;
    }
    isReadyBatt = false;
    List<BluetoothService> services = await widget.device.discoverServices();
    print(services);
    services.forEach((service) {
      if (service.uuid.toString().toUpperCase() == SERVICE_UUID) {
        service.characteristics.forEach((characteristic) {
          if (characteristic.uuid.toString().toUpperCase() ==
              CHARACTERISTIC_UUID_RX) {
            characteristic.setNotifyValue(!characteristic.isNotifying);
            stream = characteristic.value;
            setState(() {
              isReady = true;
            });
          }
          if (characteristic.uuid.toString().toUpperCase() ==
              CHARACTERISTIC_UUID_TX) {
            characteristicDeviceTx = characteristic;
            setState(() {
              isReadyTx = true;
            });
          }
        });
      }
      if (service.uuid.toString().toUpperCase() == SERVICE_UUID_BATTERY) {
        service.characteristics.forEach((characteristic) {
          if (characteristic.uuid.toString().toUpperCase() ==
              CHARACTERISTIC_UUID_BATTERY) {
            characteristic.setNotifyValue(!characteristic.isNotifying);
            BattLevel = characteristic.value;
            setState(() {
              isReadyBatt = true;
            });
          }
        });
      }
    });
    if (!isReady) {
      Navigator.of(context).pop(true); //_Pop();
    }
  }

  _Pop() {
    Navigator.of(context).pop(true);
  }

  String Batt;
  VMath.Vector3 _dataParser(List<int> dataFromDevice) {
    var eulerString = utf8.decode(dataFromDevice);
    var eulerList = eulerString.split(',');
    if (eulerList.length == 3) {
      x = double.tryParse(eulerList[0]) ?? 0; //pitch
      y = double.tryParse(eulerList[1]) ?? 0; //roll
      z = double.tryParse(eulerList[2]) ?? 0; //heading
      Pitch = x.toStringAsFixed(2);
      Yaw = z.toStringAsFixed(2);
      Roll = y.toStringAsFixed(2);
      _pcb.rotation.setValues(-x, z, y);
      _pcb.updateTransform();

      return VMath.Vector3(x, y, z);
    } else {
      _pcb.rotation.setValues(0, 0, 0);
      _pcb.updateTransform();
      return VMath.Vector3.zero();
    }
  }

  writeData(String Data) async {
    if (characteristicDeviceTx == null) {
      return;
    }
    List<int> bytes = utf8.encode(Data);
    characteristicDeviceTx.write(bytes);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          extendBody: true,
          appBar: AppBar(
            elevation: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MonserratFontBold(
                    string: widget.device.name, size: 23, color: kTextColor),
                Image.asset(
                  "assets/icons/bluetooth-connected.png",
                  scale: 23,
                  color: kTextColor,
                ),
              ],
            ),
          ),
          body: Container(
              child: !isReady
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MonserratFontBold(
                            size: 32,
                            string: "Waiting...",
                            color: kPrimaryColor,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          CircularProgressIndicator(
                              backgroundColor: kPrimaryColor),
                        ],
                      ),
                    )
                  : Container(
                      child: StreamBuilder<List<int>>(
                          stream: stream,
                          builder: (BuildContext context,
                              AsyncSnapshot<List<int>> snapshot) {
                            if (snapshot.hasError)
                              return Text('Error: ${snapshot.error}');
                            if (snapshot.connectionState ==
                                ConnectionState.active) {
                              //var currentValue = _dataParser(snapshot.data);
                              _dataParser(snapshot.data);
                              return Center(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Stack(
                                      children: [
                                        Container(
                                          height: size.height * 0.10,
                                          decoration: BoxDecoration(
                                              color: kPrimaryColor,
                                              borderRadius: new BorderRadius
                                                      .only(
                                                  bottomRight: const Radius
                                                          .circular(
                                                      kRadiusHomeContainer))),
                                        ),
                                        CurrentValues(),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 16, top: 45),
                                          child: Text(
                                              '$LabelX: $Pitch $Units\t\t$LabelY: $Roll $Units\t\t$LabelZ: $Yaw $Units',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  color: kTextColor)),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Column(
                                          children: [
                                            IconButton(
                                                iconSize: 60,
                                                icon: Image.asset(
                                                  "assets/icons/rotate.png",
                                                  color: kPrimaryColor,
                                                ),
                                                onPressed: () {
                                                  _AHRSClick(snapshot);
                                                }),
                                            MonserratFontBold(
                                              string: "AHRS",
                                              color: kPrimaryColor,
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            IconButton(
                                                iconSize: 60,
                                                icon: Image.asset(
                                                  "assets/icons/gyroscope.png",
                                                  color: kPrimaryColor,
                                                ),
                                                onPressed: () {
                                                  _GyroClick(snapshot);
                                                }),
                                            MonserratFontBold(
                                              string: "GYRO",
                                              color: kPrimaryColor,
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            IconButton(
                                                iconSize: 60,
                                                icon: Image.asset(
                                                  "assets/icons/surface.png",
                                                  color: kPrimaryColor,
                                                ),
                                                onPressed: () {
                                                  _AccClick(snapshot);
                                                }),
                                            MonserratFontBold(
                                              string: "ACC",
                                              color: kPrimaryColor,
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            IconButton(
                                                iconSize: 60,
                                                icon: Image.asset(
                                                  "assets/icons/compass.png",
                                                  color: kPrimaryColor,
                                                ),
                                                onPressed: () {
                                                  _MAGClick(snapshot);
                                                }),
                                            MonserratFontBold(
                                              string: "MAG",
                                              color: kPrimaryColor,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Flexible(
                                        fit: FlexFit.tight,
                                        child: Cube(
                                          interactive: false,
                                          onSceneCreated: (Scene scene) {
                                            scene.world.add(_pcb);
                                            scene.update();
                                          },
                                        )),
                                  ],
                                ),
                              );
                            } else {
                              return Text('Check the stream');
                            }
                          }))),
          bottomNavigationBar: BottomAppBar(
            color: Colors.transparent,
            child: Container(
              height: size.height * 0.07,
              decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(45))),
              child: Row(
                children: [
                  const SizedBox(width: 30),
                  SvgPicture.asset("assets/icons/battery.svg",
                      color: Colors.black54, height: 35),
                  StreamBuilder(
                      stream: BattLevel,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<int>> snapshotBatt) {
                        Batt = "N/A";
                        if (snapshotBatt.hasError)
                          return Text('Error: ${snapshotBatt.error}');
                        if (snapshotBatt.connectionState ==
                            ConnectionState.active) {
                          if (snapshotBatt.data.length == 1)
                            Batt = snapshotBatt.data[0].toString();
                          print(Batt);
                        }
                        return MonserratFontBold(
                          string: Batt + "%",
                          color: kTextColor,
                          size: kFontBottomDevices,
                        );
                      }),
                  SizedBox(
                    width: size.width - 240,
                  ),
                  MonserratFont(
                      string: "Mode: ",
                      color: kTextColor,
                      size: kFontBottomDevices),
                  MonserratFontBold(
                      string: Mode,
                      color: kTextColor,
                      size: kFontBottomDevices),
                ],
              ),
            ),
          ),
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  child: Image.asset(
                    "assets/icons/power.png",
                    color: kPrimaryColor,
                    scale: 10,
                  ),
                  onPressed: () {
                    _OffDevices(isReadyTx);
                  }),
              MonserratFontBold(
                string: "PWR OFF",
                color: kPrimaryColor,
                size: 12,
              ),
            ],
          ),
        ));
  }

  void _AHRSClick(var snapshot) {
    if (snapshot.connectionState == ConnectionState.active) {
      if (isReadyTx) {
        setState(() {
          Units = "[DEG]";
          LabelX = "Pitch";
          LabelY = "Roll";
          LabelZ = "Yaw";
          Mode = "AHRS";
        });
        writeData("@T");
        //ShowToast("AHRS Mode Sending...");
      }
    }
  }

  void _AccClick(var snapshot) {
    if (snapshot.connectionState == ConnectionState.active) {
      if (isReadyTx) {
        setState(() {
          Units = "[G]";
          LabelX = "X";
          LabelY = "Y";
          LabelZ = "Z";
          Mode = "ACC";
        });
        //ShowToast("ACC Mode Sending...");
        writeData("@A");
      }
    }
  }

  void _GyroClick(var snapshot) {
    if (snapshot.connectionState == ConnectionState.active) {
      if (isReadyTx) {
        setState(() {
          Units = "[DEG/S]";
          LabelX = "X";
          LabelY = "Y";
          LabelZ = "Z";
          Mode = "GYRO";
        });
        writeData("@G");
        //ShowToast("Gyro Mode Sending...");
      }
    }
  }

  void _MAGClick(var snapshot) {
    if (snapshot.connectionState == ConnectionState.active) {
      if (isReadyTx) {
        setState(() {
          Units = "[Gauss]";
          LabelX = "X";
          LabelY = "Y";
          LabelZ = "Z";
          Mode = "MAG";
        });
        writeData("@M");
        //ShowToast("MAG Mode Sending...");
      }
    }
  }

  Future<bool> _onWillPop() {
    return showDialog(
        context: context,
        builder: (context) =>
            ShowAlertDialog(context, "Are you sure?",
                "Do you want to disconnect device and go back", false) ??
            false);
  }

  void _OffDevices(bool isReadyTx) {
    if (isReadyTx) {
      showDialog(
          context: context,
          builder: (context) => ShowAlertDialog(context, "Are you sure?",
              "Do you want to turn off device and go back?", true));
    }
  }

  AlertDialog ShowAlertDialog(
      BuildContext context, String title, String content, bool OnOff) {
    return new AlertDialog(
      elevation: 50,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      title: MonserratFontBold(
        string: title,
        color: kTextColorAlert,
        size: 19,
      ),
      content: MonserratFont(
        string: content,
        color: kTextColorAlert,
        size: 14,
      ),
      actions: <Widget>[
        new TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text(
              'No',
              style: TextStyle(color: Colors.black, fontSize: 18),
            )),
        new TextButton(
          child: new Text(
            'Yes',
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
          onPressed: () {
            if (OnOff) {
              writeData("@O");
            }
            disconnectFromDevice();
            _Pop();
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}

class CurrentValues extends StatelessWidget {
  const CurrentValues({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const SizedBox(height: 50, width: 15),
        MonserratFont(
          string: 'Current Values',
          size: kFontDevicePageCurrent,
          color: kTextColor,
        ),
        const SizedBox(width: 5),
        MonserratFontBold(
          string: 'from Sensor',
          size: kFontDevicePageCurrent,
          color: kTextColor,
        ),
      ],
    );
  }
}
