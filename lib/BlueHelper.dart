import 'dart:io';

import 'package:flutter_blue/flutter_blue.dart';

class BlueHelper{

  static void starScan(dynamic fun){
    FlutterBlue flutterBlue = FlutterBlue.instance;
    flutterBlue.startScan(timeout: Duration(seconds: 5));
    if(Platform.isIOS){

    }
    // Listen to scan results
    var subscription = flutterBlue.scanResults.listen((results) {
      if(null != results && results.length > 0) {
        fun(results);
      }
    });

    // Stop scanning
    //flutterBlue.stopScan();
  }

}