import 'package:church_platform/net/common/NetBaseResponse.dart';
import 'package:church_platform/net/models/Church.dart';
import 'package:church_platform/net/models/IAPCharge.dart';
import 'package:church_platform/net/models/Medias.dart';
import 'package:flutter/foundation.dart';

class Course extends NetResult {
  int id;
  Church church;
//  Speaker speaker;
  String title;
  String description;
  String content;
  String price;
  String price_usd;
  int sales_num;
  bool is_buy;
  IapCharge iapCharge;
  List<Medias> medias;
  String createTime;
  String updateTime;

  Course(
      {this.id,
        this.church,
//        this.speaker,
        this.title,
        this.description,
        this.content,
        this.price,
        this.price_usd,
        this.sales_num,
        this.is_buy,
        this.iapCharge,
        this.medias,
        this.createTime,
        this.updateTime});

  String platformPrice(){
    if(defaultTargetPlatform == TargetPlatform.iOS){
      if(iapCharge != null){
        return iapCharge.price;
      }
    }else{

    }
    return price;
  }

  Course.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    church =
    json['church'] != null ? new Church.fromJson(json['church']) : null;
    iapCharge = json['iap_charge'] != null
        ? new IapCharge.fromJson(json['iap_charge'])
        : null;
//    speaker =
//    json['speaker'] != null ? new Speaker.fromJson(json['speaker']) : null;
    title = json['title'];
    description = json['description'];
    content = json['content'];
    price = json['price'];
    price_usd = json['price_usd'];
    sales_num = json['sales_num'];
    is_buy = json['is_buy'];
    if (json['medias'] != null) {
      medias = new List<Medias>();
      json['medias'].forEach((v) {
        medias.add(new Medias.fromJson(v));
      });
    }
    createTime = json['create_time'];
    updateTime = json['update_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.church != null) {
      data['church'] = this.church.toJson();
    }
    if (this.iapCharge != null) {
      data['iap_charge'] = this.iapCharge.toJson();
    }
//    if (this.speaker != null) {
//      data['speaker'] = this.speaker.toJson();
//    }
    data['title'] = this.title;
    data['description'] = this.description;
    data['content'] = this.content;
    data['price'] = this.price;
    data['price_usd'] = this.price_usd;
    data['sales_num'] = this.sales_num;
    data['is_buy'] = this.is_buy;
    if (this.medias != null) {
      data['medias'] = this.medias.map((v) => v.toJson()).toList();
    }
    data['create_time'] = this.createTime;
    data['update_time'] = this.updateTime;
    return data;
  }
}
