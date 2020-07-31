import 'package:dio/dio.dart';
// ignore: missing_return
///获取所有的门禁地址信息
Future<List<Map>> getAddress() async {
  try {
    Response response = await Dio().get("http://47.102.213.188:5000/api/address");
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