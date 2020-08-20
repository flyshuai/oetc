import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oetc/model/LoadingDialog.dart';
import 'package:oetc/service/exit_service.dart';


class ExitPhoto extends StatefulWidget {
  @override
  _ExitPhotoState createState() => _ExitPhotoState();
}

class _ExitPhotoState extends State<ExitPhoto> {
  String _code;//
  File _imageFile;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: new AppBar(
            title: new Text('退出拍照')
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
              key: _formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    TextFormField(
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          filled: true,
                          icon: Icon(Icons.person),
                          labelText: '申请码'
                      ),
                      validator:(value){
                        if (value.isEmpty) {
                          return '请输入申请码';
                        }
                        return null;
                      },
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
                          if (_formKey.currentState.validate()) {
                            if(_imageFile == null ){
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return SimpleDialog(
                                      children: <Widget>[
                                        Container(
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.only(top: 10),
                                          child: Text("请先选择图片",
                                            style: TextStyle(color: Colors.red),),
                                        ),
                                      ],
                                    );
                                  });
                            }
                            else{
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return new LoadingDialog(
                                      text: "提交申请中",
                                    );
                                  });
                              Map<String,dynamic> map = new Map();
                              map['recordCode'] = _code;
                              map['imageFilePath'] = _imageFile.path;
                              Map isSuccess = await submitExitPhoto(map);
                              print(isSuccess);
                              if(isSuccess['success']){
                                Navigator.pop(context);
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
                                Navigator.pop(context);
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
                          }
                        }
                    )
                  ]
              ),
          )
          

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
