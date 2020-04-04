
import 'package:church_platform/net/common/NetBaseResponse.dart';

class PaypalResult extends NetResult {
  String order_no;
  int course_id;

  PaypalResult(
      {this.order_no,
        this.course_id,
      });

  PaypalResult.fromJson(Map<String, dynamic> json) {
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