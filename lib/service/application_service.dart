import 'package:dio/dio.dart';

Future<Map> submitApplication(map) async {
  Map returnMap = new Map();
  try{
    map['file'] =  await MultipartFile.fromFile(map['imageFilePath']);
    FormData formData = FormData.fromMap(map);
    print(formData);
    Dio dio = new Dio();
    Response response = await dio.post('http://47.102.213.188:5000/api/application/submitapplication',data: formData);
//    print(response);
    returnMap['success'] = false;
    if(response.data['success']){
      returnMap['success'] = true;
      returnMap['code'] = response.data['data']['recordCode'];
      return returnMap;
    }else{
      return returnMap;
    }
  }catch(e){
    print(e);
    return returnMap;
  }
}