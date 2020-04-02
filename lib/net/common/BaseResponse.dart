
import 'package:church_platform/net/results/IAPVerifyResult.dart';
import 'package:church_platform/net/results/LoginResult.dart';
import 'package:church_platform/net/results/OrderResult.dart';
import 'package:church_platform/net/results/PaypalResult.dart';
import 'package:church_platform/net/results/Sermon.dart';

class BaseResult{
  BaseResult();
  BaseResult.fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson(){
    return null;
  }
}

class BaseResponse<T extends BaseResult> {
  String detail;
  String errCode;
  String msg;
  T data;

  BaseResponse({this.detail, this.errCode, this.msg, this.data});

  BaseResponse.fromJson(Map<String, dynamic> json) {
    detail = json['detail'];
    errCode = json['errCode'];
    msg = json['msg'];
    data = json['data'] != null ?  baseFromJson<T>(json['data']) : null;
  }

  static T baseFromJson<T extends BaseResult>(dynamic json) {

    if (T == BaseResult) {
      return BaseResult.fromJson(json) as T;
    }else if (T == LoginResult) {
      return LoginResult.fromJson(json) as T;
    }else if (T == LoginResult) {
      return IAPVerifyResult.fromJson(json) as T;
    }else if (T == LoginResult) {
      return Sermon.fromJson(json) as T;
    }else if (T == LoginResult) {
      return OrderResult.fromJson(json) as T;
    }else if (T == LoginResult) {
      return PaypalResult.fromJson(json) as T;
    } else {
      throw Exception("Unknown class");
    }
  }

//  static T genericFromJson<T, K>(dynamic json) {
//    if (json is Iterable) {
//      return _genericFromJsonList<K>(json) as T;
//    } else if (T == LoginDetails) {
//      return LoginDetails.fromJson(json) as T;
//    } else if (T == UserDetails) {
//      return UserDetails.fromJson(json) as T;
//    } else if (T == Message) {
//      return Message.fromJson(json) as T;
//    } else {
//      throw Exception("Unknown class");
//    }
//  }
//
//  static List<K> _genericFromJsonList<K>(List jsonList) {
//    if (jsonList == null) {
//      return null;
//    }
//
//    List<K> output = List();
//
//    for (Map<String, dynamic> json in jsonList) {
//      output.add(genericFromJson(json));
//    }
//
//    return output;
//  }

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
