import 'package:dio/dio.dart';

void submitApplication(map) async {
  try{
    FormData formData;
    formData = FormData.fromMap(map);
    print(formData);
    Dio dio = new Dio();
    Response response = await dio.post<String>('http://47.102.213.188:5000/api/application/submitapplication',data: formData);
    print(response);
  }catch(e){
    print(e);
  }
}