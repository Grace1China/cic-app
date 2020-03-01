
class IAPVerifyResponse {
  String errCode;
  IAPVerifyResult data;

  IAPVerifyResponse({this.errCode, this.data});

  IAPVerifyResponse.fromJson(Map<String, dynamic> json) {
    errCode = json['errCode'];
    data = json['data'] != null ? new IAPVerifyResult.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errCode'] = this.errCode;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class IAPVerifyResult {
  String order_no;
  int course_id;

  IAPVerifyResult(
      {this.order_no,
        this.course_id,
      });

  IAPVerifyResult.fromJson(Map<String, dynamic> json) {
    order_no = json['order_no'];
    course_id = json['course_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_no'] = this.order_no;
    data['course_id'] = this.course_id;
    return data;
  }
}