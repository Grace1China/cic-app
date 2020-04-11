
import 'package:church_platform/net/common/GenerateUtils.dart';

class NetResult{
  NetResult();
  NetResult.fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson(){
    return null;
  }
}

class NetResponse<T extends NetResult>{
  String detail;
  String errCode;
  String msg;
  T data;

  String get errMsg{
    return detail + msg;
  }
  NetResponse({this.detail, this.errCode, this.msg, this.data});

  NetResponse.fromJson(Map<String, dynamic> json) {
    detail = json['detail'];
    errCode = json['errCode'];
    msg = json['msg'];
    data = json['data'] != null ?  GenerateUtils.classFromJson<T>(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['errCode'] = this.errCode;
    data['msg'] = this.msg;
    data['detail'] = this.detail;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}
