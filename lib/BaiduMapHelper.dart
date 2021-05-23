import 'dart:io';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';

class BaiduMapHelper{
  String androidKey = "pjdpWMc83eMySOUztCNEhkoCYhv4sQEl";
  String iosKey = "pjdpWMc83eMySOUztCNEhkoCYhv4sQEl";

  static init(){

    if (Platform.isIOS) {
      BMFMapSDK.setApiKeyAndCoordType(
          'VGtYqXAMquUFPbx0fk1oZhviGlQTMYcI', BMF_COORD_TYPE.BD09LL);
    } else if (Platform.isAndroid) {
      // Android 目前不支持接口设置Apikey,
      // 请在主工程的Manifest文件里设置，详细配置方法请参考官网(https://lbsyun.baidu.com/)demo
      BMFMapSDK.setCoordType(BMF_COORD_TYPE.BD09LL);
    }
  }
}