
import 'package:church_platform/net/common/BaseResponse.dart';

class OrderResult extends BaseResult {
  String order_no;
  String client_token; //paypal专有

  OrderResult(
      {this.order_no,
        this.client_token
      });

  OrderResult.fromJson(Map<String, dynamic> json) {
    order_no = json['order_no'];
    client_token = json['client_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_no'] = this.order_no;
    data['client_token'] = this.client_token;
    return data;
  }
}