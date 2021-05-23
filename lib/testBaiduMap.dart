import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_baidu_mapapi_search/flutter_baidu_mapapi_search.dart';
import 'package:flutter_blue_map/BaiduMapHelper.dart';

class testBaiduMapPage extends StatefulWidget{

  testBaiduMapPage();

  @override
  testBaiduMapState createState() => testBaiduMapState();
}

class testBaiduMapState extends State<testBaiduMapPage> {

  BMFMapController dituController;

  @override
  void initState() {
    super.initState();
    BaiduMapHelper.init();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    BMFMapOptions mapOptions = BMFMapOptions(
        center: BMFCoordinate(39.917215, 116.380341),
        zoomLevel: 12,
        changeCenterWithDoubleTouchPointEnabled:true,
        gesturesEnabled:true ,
        scrollEnabled:true ,
        zoomEnabled: true ,
        rotateEnabled :true,
        compassPosition :BMFPoint(0,0) ,
        showMapScaleBar:false ,
        maxZoomLevel:15,
        minZoomLevel:8,);


    return Scaffold(
        appBar: AppBar(
          title: Text("flutter baidu map demo"),
        ),
        body:Container(
            width: screenSize.width,
            height: screenSize.height,
            child: BMFMapWidget(
              onBMFMapCreated: (controller) {
                dituController = controller;
                controller.setMapDidLoadCallback(callback:(){
                  print('mapDidLoad-地图加载完成');
                  search();
                });
              },
              mapOptions: mapOptions,
            ),
            //child:Text('baidu map')
          ),
    );
  }

  void search() async{
    BMFPoiNearbySearchOption poiNearbySearchOption =
    BMFPoiNearbySearchOption(
        keywords: <String>['小吃', '酒店'],
        location: BMFCoordinate(39.917215, 116.380341),
        radius: 1000,
        scope: BMFPoiSearchScopeType.DETAIL_INFORMATION);
    // 检索实例
    BMFPoiNearbySearch nearbySearch = BMFPoiNearbySearch();
    // 检索回调
    nearbySearch.onGetPoiNearbySearchResult(callback:(BMFPoiSearchResult result, BMFSearchErrorCode errorCode) {

      if (errorCode != BMFSearchErrorCode.NO_ERROR) {
        var error = "检索失败" + "errorCode:${errorCode.toString()}";
        print(error);
        return;
      }
      print('poi周边检索回调 errorCode = ${errorCode}  \n result = ${result.toMap()}');
      // 解析reslut，具体参考demo

      /// 检索结果标注
      List<BMFMarker> markers = [];
      for (BMFPoiInfo poiInfo in result.poiInfoList) {
        BMFMarker marker = BMFMarker(
          position: poiInfo.pt,
          title: poiInfo.name,
          subtitle: poiInfo.address,
          icon: "images/park2x.png",
        );
        markers.add(marker);
      }

      print('cleanAllMarkers');
      dituController?.cleanAllMarkers();
      print('addMarkers');
      dituController?.addMarkers(markers);
      print('setCenterCoordinate');
      dituController?.setCenterCoordinate( BMFCoordinate(markers[0].position.latitude ,markers[0].position.longitude ), true ,animateDurationMs: 1000);
      print('finish');
    });
    // 发起检索
    bool flag = await nearbySearch.poiNearbySearch(poiNearbySearchOption);
    if (flag) {
      print("发起检索成功");
    } else {
      print("发起检索失败");
    }

  }

  void fromAsset()
  {


  }
}