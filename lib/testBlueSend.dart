
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class testBlueSendPage extends StatefulWidget{
  testBlueSendPage(BluetoothCharacteristic this._char);

  BluetoothCharacteristic _char;

  @override
  testBlueSendState createState() => testBlueSendState();
}

class testBlueSendState extends State<testBlueSendPage>{

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), (){
      readMsg(widget._char);
    });
  }

  //发送框的控制器
  TextEditingController sendController = TextEditingController();

  List<String> receiveData = [];

  String coding = "Utf8";

  readMsg(BluetoothCharacteristic chart) async{
    if(chart.properties.notify){
      print('开始准备接受消息');

      await chart.setNotifyValue(true);
      Utf8Codec decode = new Utf8Codec();
      chart.value.listen((val) {
        print('接受到消息:${val}');
        List<int> list2 = val.map((e) => e as int).toList();
        String msg;
        switch(this.coding){
          case 'Hex':break;
          case 'Utf8':
            msg = String.fromCharCodes(list2);
            break;
          case 'GBK':

            break;
        }

        setState(() {
          this.receiveData.add(msg);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Blue Page"),
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    ElevatedButton(
                      child: Text('Hex'),
                      onPressed: () => {this.coding = 'Hex'},
                    ),
                    SizedBox(width: 5,),
                    ElevatedButton(
                      child: Text('Utf8'),
                      onPressed: () => {this.coding = 'Utf8'},
                    ),
                    SizedBox(width: 5,),
                    ElevatedButton(
                      child: Text('GBK'),
                      onPressed: () => {this.coding = 'GBK'},
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  child: Text('编码：${coding}'),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                          children: <Widget>[
                            ElevatedButton(
                              child: Text('发送'),
                              onPressed: () {
                                print("发送消息");

                                List<int> msg;
                                switch (this.coding) {
                                  case 'Hex':
                                    break;
                                  case 'Utf8':
                                    msg = utf8.encode(
                                        sendController.value.text);
                                    break;
                                  case 'GBK':
                                    break;
                                }

                                widget._char.write(msg, withoutResponse: true);
                              },
                            ),
                            Expanded(child:
                            TextField(
                              controller: sendController,
                            )
                            )
                          ]
                      ),
                      Container(
                        margin: EdgeInsets.all(5),
                        child: Text("接收"),
                      ),
                      SingleChildScrollView(
                        child: ListView.separated(
                          itemBuilder: (BuildContext context, int index) {
                            return  Text(receiveData[index]??'');
                          },
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: receiveData.length,
                          separatorBuilder: (BuildContext context,
                              int index) =>
                              Padding(
                                  padding: EdgeInsets.only(
                                      top: 5,
                                      bottom: 5),
                                  child: Divider(
                                    height: 1,
                                    color: Colors.black,
                                  )),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        )
    );
  }
}