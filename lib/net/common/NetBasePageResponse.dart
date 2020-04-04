
import 'package:church_platform/net/common/NetBaseResponse.dart';
import 'package:church_platform/net/models/Page.dart';
import 'package:church_platform/net/results/Course.dart';

// 参考
// https://stackoverflow.com/questions/56271651/how-to-pass-a-generic-type-as-a-parameter-to-a-future-in-flutter

class NetResponseWithPage<T extends NetResult> {
  String detail;
  String errCode;
  String msg;

  int pageNum;
  int totalPage;

  List<T> data;

  NetResponseWithPage({this.detail, this.errCode, this.msg, this.data, this.pageNum, this.totalPage});

  NetResponseWithPage.fromJson(Map<String, dynamic> json) {
    detail = json['detail'];
    errCode = json['errCode'];
    msg = json['msg'];

    pageNum = json['page'];
    totalPage = json['totalPage'];

    data = json['data'] != null ?  listFromJson<T>(json['data']) : null;
  }

  static List<T> listFromJson<T extends NetResult>(dynamic json) {
    if (json is Iterable) {
      return _listFromJson<T>(json);
    } else {
      throw Exception("Unknown class");
    }
  }

  static List<K> _listFromJson<K extends NetResult>(List jsonList) {
    if (jsonList == null) {
      return null;
    }
    List<K> output = List();
    for (Map<String, dynamic> json in jsonList) {
      output.add(classFromJson(json));
    }
    return output;
  }

  static T classFromJson<T extends NetResult>(dynamic json) {

    if (T == NetResult) {
      return NetResult.fromJson(json) as T;
    }else if (T == Course) {
      return Course.fromJson(json) as T;
    } else {
      throw Exception("Unknown class");
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errCode'] = this.errCode;
    data['msg'] = this.msg;
    data['detail'] = this.detail;
    data['page'] = this.pageNum;
    data['totalPage'] = this.totalPage;

    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }

    return data;
  }

  Page getPage(){
    return Page(page: pageNum,totalPage: totalPage);
  }

}
