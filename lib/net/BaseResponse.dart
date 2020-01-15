//
//abstract class BaseResult{
//  BaseResult();
//  BaseResult.fromJson(Map<String, dynamic> json);
//  Map<String, dynamic> toJson();
//}
//
//class BaseResponse<T extends BaseResult> {
//  String errCode;
//  String errMsg;
//  T data;
//
//  BaseResponse({this.errCode, this.errMsg, this.data});
//
//  fromJson(Map<String, dynamic> json) {
//    errCode = json['errCode'];
//    errMsg = json['errMsg'];
//    data = json['data'] != null ?  T().fromJson(json['data']) : null;
//  }
//
//  Map<String, dynamic> toJson() {
//    final Map<String, dynamic> data =  Map<String, dynamic>();
//    data['errCode'] = this.errCode;
//    data['errMsg'] = this.errMsg;
//    if (this.data != null) {
//      data['data'] = this.data.toJson();
//    }
//    return data;
//  }
//}
