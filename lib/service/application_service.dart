import 'package:dio/dio.dart';

Future<bool> submitApplication(map) async {
  try{
    map['file'] =  await MultipartFile.fromFile(map['imageFilePath']);
    FormData formData = FormData.fromMap(map);
    print(formData);
    Dio dio = new Dio();
    Response response = await dio.post('http://172.31.73.155:5000/api/application/submitapplication',data: formData);
    print(response);
    if(response.data['success']){
      return true;
    }else{
      return false;
    }
  }catch(e){
    print(e);
    return false;
  }
}