class IapCharge {
  String productId;
  String priceCode;
  String desc;
  String price;

  IapCharge({this.productId, this.priceCode, this.desc, this.price});

  IapCharge.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    priceCode = json['price_code'];
    desc = json['desc'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['price_code'] = this.priceCode;
    data['desc'] = this.desc;
    data['price'] = this.price;
    return data;
  }
}
