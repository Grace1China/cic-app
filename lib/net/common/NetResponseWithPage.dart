
import 'package:church_platform/net/common/GenerateUtils.dart';
import 'package:church_platform/net/common/NetResponse.dart';
import 'package:church_platform/net/models/Page.dart';
import 'package:church_platform/net/results/Course.dart';

// 参考
// https://stackoverflow.com/questions/56271651/how-to-pass-a-generic-type-as-a-parameter-to-a-future-in-flutter

class NetResponseWithPage<T extends NetResult>{
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

    data = json['data'] != null ?  GenerateUtils.listFromJson<T>(json['data']) : null;
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
