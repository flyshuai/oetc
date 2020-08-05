import 'package:dio/dio.dart';

Future<Map> submitExitPhoto(map) async {
  Map returnMap = new Map();
  try{
    map['file'] =  await MultipartFile.fromFile(map['imageFilePath']);
    FormData formData = FormData.fromMap(map);
    Dio dio = new Dio();
    Response response = await dio.post('http://172.31.73.155:5000/api/application/submitexitphoto',data: formData);
    returnMap['success'] = false;
    if(response.data['success']){
      returnMap['success'] = true;
    }else{
      returnMap['msg'] = response.data['msg'];
    }
    return returnMap;
  }catch(e){
    print(e);
    return returnMap;
  }
}