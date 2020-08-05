import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oetc/service/exit_service.dart';


class ExitPhoto extends StatefulWidget {
  @override
  _ExitPhotoState createState() => _ExitPhotoState();
}

class _ExitPhotoState extends State<ExitPhoto> {
  String _code;//
  File _imageFile;
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: new AppBar(
            title: new Text('退出拍照')
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 20.0),
              TextField(
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,
                    icon: Icon(Icons.person),
                    labelText: '申请码'
                ),
                onChanged: (String value){
                  this._code = value;
                },
              ),
              SizedBox(height: 15.0),
              Column(
                children: <Widget>[
                  ButtonBar(
                    children: <Widget>[
                      Text('请上传进机房前图片'),
                      IconButton(
                        icon: Icon(Icons.photo_camera),
                        onPressed: ()async => await _pickImageFromCamera(),
                      ),
                      IconButton(
                        icon: Icon(Icons.photo),
                        onPressed: ()async => await _pickImageFromGallery(),
                      )
                    ],
                  ),
                  this._imageFile == null ?Placeholder(fallbackHeight: 300,fallbackWidth: 300,):Image.file(this._imageFile),
                ],
              ),
              SizedBox(height: 15.0),
              MaterialButton(
                  color: Colors.blue,
                  height: 60,
                  minWidth: 800,
                  textColor: Colors.white,
                  child: new Text('提交'),
                  onPressed: () async {
                    Map<String,dynamic> map = new Map();
                    map['recordCode']=_code;
                    map['imageFilePath']=_imageFile.path;
                    Map isSuccess = await submitExitPhoto(map);
                    print(isSuccess);
                    if(isSuccess['success']){
                      showDialog(
                          context: context,
                          builder: (BuildContext context){
                            return AlertDialog(
                              title: new Text('标题'),
                              content: new SingleChildScrollView(
                                child: new ListBody(
                                  children: <Widget>[
                                    new Text('照片上传成功'),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                new FlatButton(
                                  child: new Text('确定'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          }
                      );
                    }else{
                      showDialog(
                          context: context,
                          builder: (BuildContext context){
                            return AlertDialog(
                              title: new Text('标题'),
                              content: new SingleChildScrollView(
                                child: new ListBody(
                                  children: <Widget>[
                                    new Text(isSuccess['msg']),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                new FlatButton(
                                  child: new Text('确定'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          }
                      );
                    }
                  }
              )
            ]
          ),
      ),
    );
  }
  Future<Null> _pickImageFromGallery() async{
    final File imageFile =
    await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      this._imageFile = imageFile;
    });
  }
  Future<Null> _pickImageFromCamera() async{
    final File imageFile =
    await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      this._imageFile = imageFile;
    });
  }
}
