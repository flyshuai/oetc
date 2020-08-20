import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oetc/model/LoadingDialog.dart';
import 'package:oetc/service/address_service.dart';
import 'package:oetc/service/application_service.dart';

class EnterApplication extends StatefulWidget {
  @override
  _EnterApplicationState createState() => _EnterApplicationState();
}

class _EnterApplicationState extends State<EnterApplication> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  String _name;//使用人
  String _phoneNumber;//使用人电话号码
  String _address;//门禁地址
  String _purpose;//进机房目的
  File _imageFile;
  List<Map> addressList;//所有门禁地址
  List<Widget> addressOptionList = new List<Widget>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    getAddress().then((value) {
      addressList = value;
      addressList.forEach((element) {
        SimpleDialogOption simpleDialogOption = new SimpleDialogOption(
            child: new Text(element['addressName']),
            onPressed: () {
//              _address = element['addressName'];
              setState(() {
                _address = element['addressName'];
              });
              Navigator.of(context).pop();
            }
        );
        addressOptionList.add(simpleDialogOption);
      });

//      print(addressList);
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
          title: new Text('进入申请')
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
                    labelText: '使用人'
                ),
                validator:(value){
                  if (value.isEmpty) {
                    return '请输入用户名';
                  }
                  return null;
                },
                onChanged: (String value){
                  this._name = value;
                },
              ),
              SizedBox(height: 15.0),
              TextFormField(
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  filled: true,
                  icon: Icon(Icons.phone),
                  labelText: '号码',
                ),
                validator:(value){
                  RegExp reg = new RegExp(r'^\d{11}$');
                  if (!reg.hasMatch(value)) {
                    return '请输入11位手机号码';
                  }
                  return null;
                },
                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],//只允许输入数字
                keyboardType: TextInputType.number,
                onChanged: (String value){
                  this._phoneNumber = value;
                },
              ),
              SizedBox(height: 15.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  MaterialButton(
                    color: Colors.blue,
                    child: new Text('门禁地址'),
                    onPressed: (){
                      showDialog(
                          context: context,
                          builder:(BuildContext context){
                            return SimpleDialog(
                              title: Text('选择门禁地址'),
                              children:addressOptionList,
                            );
                          }
                      );
                    },
                  ),
                  Text(_address==null?'':_address),
                ],
              ),
              SizedBox(height: 15.0),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '进机房目的',
                ),
                validator:(value){
                  if (value.isEmpty) {
                    return '请输入进机房目的';
                  }
                  return null;
                },
                maxLines: 3,
                onChanged: (String value){
                  this._purpose = value;
                },
              ),
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
                child: new Text('提交申请'),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    if (_address == null) {
                      setState(() {
                        _address = "请选择门禁地址";
                      });
                    }else if (_imageFile == null) {
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
                  }else {
                    Map<String,dynamic> map = new Map();
                    map['name']=_name;
                    map['phoneNumber']=_phoneNumber;
                    map['address']=_address;
                    map['purpose']=_purpose;
                    map['imageFilePath']=_imageFile.path;
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return new LoadingDialog(
                            text: "提交申请中",
                          );
                        });
                    Map isApplication = await submitApplication(map);
                    if(isApplication['success']){
                      Navigator.pop(context);
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return new AlertDialog(
                              title: new Text('标题'),
                              content: new SingleChildScrollView(
                                child: new ListBody(
                                  children: <Widget>[
                                    new Text('申请进入成功,您的申请码为:'+ isApplication['code']+"  请等待管理员批复"),
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
                },
              )
            ],
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
