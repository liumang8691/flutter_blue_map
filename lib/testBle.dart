import 'dart:convert';

import 'package:ble/DeviceBle.dart';
import 'package:ble/ble.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';


class testBlePage extends StatefulWidget {
  testBlePage();

  @override
  testBleState createState() => testBleState();
}

class testBleState extends State<testBlePage> implements DeviceListener {
  int _counter = 0;
  bool isBleOn = false;
  List<DeviceBle> devices = [];



  @override
  void initState() {
    super.initState();
    Ble.getInstance().isEnabled.then((value){
      if (value) {
        print('蓝牙状态为开启');
        isBleOn = true;
      } else{
        print('蓝牙状态为关闭');
        isBleOn = false;
      }
    });

    Ble.getInstance().setDeviceListener(this);
    requestLocation();
  }

  requestLocation () async{
    if(await Permission.locationAlways.request().isGranted)
    {
      print('权限已开启');
    }
    else{
      print('蓝牙搜索需要开启位置权限');
    }
  }

  Widget _buildBlueDevice(BuildContext context, int index){
    DeviceBle model = devices[index];
    return Padding(
        padding: EdgeInsets.only(
            left: 25, right: 25),
        child: Row(
          children: <Widget>[
            Text(model.rssi.toString()),
            SizedBox(width: 20,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(model.address),
                Text("name: ${model.name}"),
              ],
            ),
            Expanded(
              child: Text(''),
            ),
            RaisedButton(
              child: Text('connect'),
              onPressed: ()=>connectToBlueDevice(model),
            )
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ble Page"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ListView.separated(
                itemBuilder: _buildBlueDevice,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: devices.length,
                separatorBuilder: (BuildContext context, int index) =>
                    Padding(
                        padding: EdgeInsets.only(
                            top: 20,
                            bottom: 20),
                        child: Divider(
                          height: 1,
                          color: Colors.black,
                        )),
              ),
            ],
          ),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: searchBlue,
        tooltip: '扫描蓝牙设备',
        child: Icon(Icons.search),
      ),

    );
  }


  //扫描蓝牙设备
  void searchBlue(){

    if(!isBleOn) {
      print("手机蓝牙未打开，请打开后再扫描设备");
      return;
    }

    print("开始扫描设备...");
    Ble.getInstance().startScanBluetooth;
    print("扫描设备中...");
  }

  void connectToBlueDevice(DeviceBle model){
    Ble.getInstance().connect(model.address);
  }

  // 发现蓝牙设备
  @override
  void onFoundDevice(List<DeviceBle> devices) {
    this.devices.clear();
    for(var d in devices) {
      print('${d.address} ,${d.name} ,${d.rssi}');
    }
    setState(() {
      this.devices = devices;
    });
  }

  @override
  void onBluetoothOff() {
    // TODO: implement onBluetoothOff
  }

  @override
  void onBluetoothOn() {
    // TODO: implement onBluetoothOn
  }

  @override
  void onConnectionStateChange(int status) {
    print("flutter插件监听到蓝牙状态发送改变："+(status==4?"蓝牙连接上了":"蓝牙断开了"));
    switch(status){
      case 4:
        //Ble.getInstance().sendCommend('command');
        break;

    }
    Ble.getInstance().stopScanBluetooth;
  }

  @override
  void onReConnected() {
    // TODO: implement onReConnected
  }

  @override
  void onReceivedDataListener(List byteData) {
    // TODO: implement onReceivedDataListener
    print("BlePage*****onReceivedDataListener");
    print(byteData);
    List<String> list = byteData.map((e) => e.toString()).toList();
    List<int> list2 = byteData.map((e) => e as int).toList();
    String data = "";
    try{
      // ASCALL码转换为字符串
      data = String.fromCharCodes(list2);
    }catch(e){
      data = "--";
    }
    print("data******"+list.toString());
    print("add**********"+byteData.toString().length.toString());
    String byteStr = byteData.toList().toString();
    print("byteStr*****"+jsonEncode(byteData));
    String tempStr = (data + "( ") + json.encode(byteStr);
    print("all********"+tempStr.length.toString());
    print("all********"+tempStr);
    // 这个地方不用json.encode编码显示不出来
    //content.add(data + "(" + json.encode(byteData.toString()));
    setState(() {});
  }

  @override
  void onScanStart() {
    // TODO: implement onScanStart
  }

  @override
  void onScanStop() {
    // TODO: implement onScanStop
  }

  @override
  void onServiceCharac(Map data) {
    // TODO: implement onServiceCharac
    print("blepage******************");
    print(data);
    Map serviceAndCharac = data;
    int charactsSize = 0;
    List writeCharactS = [];
    List notifyCharacts = [];
    writeCharactS.clear();
    notifyCharacts.clear();
    for (String key in serviceAndCharac.keys.toList()) {
      List characts = serviceAndCharac[key];
      for (int i = 0; i < characts.length; i++) {
        charactsSize++;
        if (characts[i]["type"].toString().contains("Write")) {
          writeCharactS.add(characts[i]);
        }
        if (characts[i].toString().contains('Notify')) {
          notifyCharacts.add(characts[i]);
        }
      }
    }
    Ble.getInstance().setWriteCharator(writeCharactS[0]["uuid"]);
    Ble.getInstance().sendCommend("command");
  }

  @override
  void onServicesDiscovered() {
    // TODO: implement onServicesDiscovered
  }

  @override
  void onServicesNotSupport() {
    // TODO: implement onServicesNotSupport
  }
}

