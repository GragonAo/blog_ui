import 'dart:convert';
import 'package:hive/hive.dart';

import '../utils/storage.dart';
import 'index.dart';

class SearchHttp {
  static Box setting = GStrorage.setting;

  static Future<Map<String, dynamic>> ab2cWithPic(
      {int? aid, String? bvid}) async {
    // Map<String, dynamic> data = {};
    // if (aid != null) {
    //   data['aid'] = aid;
    // } else if (bvid != null) {
    //   data['bvid'] = bvid;
    // }
    // final dynamic res =
    //     await Request().get(Api.ab2c, data: <String, dynamic>{...data});
    // return {
    //   'cid': res.data['data'].first['cid'],
    //   'pic': res.data['data'].first['first_frame'],
    // };
    return {};
  }
}

class Data {
  List<dynamic> list;

  Data({this.list = const []});
}
