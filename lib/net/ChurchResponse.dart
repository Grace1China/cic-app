import 'package:church_platform/net/models/Church.dart';

class ChurchResponse {
  String errCode;
  String errMsg;
  String detail;
  Church data;

  ChurchResponse({this.errCode, this.detail,this.errMsg, this.data});

  ChurchResponse.fromJson(Map<String, dynamic> json) {
    errCode = json['errCode'];
    errMsg = json['errMsg'];
    detail = json['detail'];
    data = json['data'] != null ? new Church.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errCode'] = this.errCode;
    data['errMsg'] = this.errMsg;
    data['detail'] = this.detail;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}
