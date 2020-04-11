import 'package:church_platform/net/common/NetResponse.dart';

class IAPVerifyResult extends NetResult {
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