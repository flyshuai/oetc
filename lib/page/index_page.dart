import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

import 'enter_application_page.dart';
import 'exit_photo_page.dart';
final List<Map> menuLists = [
  {
    "name": "进入申请",
    "url":new EnterApplication()
  },
  {
    "name": "退出拍照",
    "url":new ExitPhoto()
  },
];
List<Container> _buildGridTileList(int count,context) {

  return new List<Container>.generate(
      count,
          (int index) =>
      new Container(
        child: Container(
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                new MaterialPageRoute(builder: (context) =>menuLists[index]['url']),
              );
            },
            child: Container(
//              width: ScreenUtil().setWidth(500),
              color: Colors.white,
              padding: EdgeInsets.all(5.0),
              margin: EdgeInsets.only(bottom: 3.0),
              child: Column(
                children: <Widget>[
                  Text(menuLists[index]['name']),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              ),
            ),
          ),
        ),
      )
  );
}

Widget buildGrid(List<Map> menuLists,context) {
  return new GridView.extent(
      maxCrossAxisExtent: 150.0,
      padding: const EdgeInsets.all(4.0),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
      children: _buildGridTileList(menuLists.length,context));
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: buildGrid(menuLists,context),
      ),
    );
  }
}