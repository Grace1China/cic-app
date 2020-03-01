class OrderResponse {
  String errCode;
  OrderResult data;

  OrderResponse({this.errCode, this.data});

  OrderResponse.fromJson(Map<String, dynamic> json) {
    errCode = json['errCode'];
    data = json['data'] != null ? new OrderResult.fromJson(json['data']) : null;
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

class OrderResult {
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