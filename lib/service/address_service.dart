import 'package:dio/dio.dart';
// ignore: missing_return
///获取所有的门禁地址信息
Future<List<Map>> getAddress() async {
  try {
    Dio dio = new Dio();
    Response response = await Dio().get("http://172.31.73.155:5000/api/address");
    List<Map> list = new List<Map>();
    response.data.forEach((v) {
      Map map = new Map();
      map["addressName"] = v["addressName"];
      map["code"] = v["code"];
      list.add(map);
    });
//    print(list);
    return list;
  } catch (e) {
    print(e);
  }
}