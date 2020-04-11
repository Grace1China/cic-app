import 'package:church_platform/net/common/NetResponse.dart';
import 'package:church_platform/net/common/NetClient.dart';
import 'package:church_platform/net/models/Church.dart';
import 'package:church_platform/net/models/CustomUser.dart';
import 'package:church_platform/net/results/Course.dart';
import 'package:church_platform/net/results/IAPVerifyResult.dart';
import 'package:church_platform/net/results/LoginResult.dart';
import 'package:church_platform/net/results/OrderResult.dart';
import 'package:church_platform/net/results/PaypalResult.dart';
import 'package:church_platform/net/results/RegisterResult.dart';
import 'package:church_platform/net/results/Sermon.dart';
import 'package:church_platform/net/results/WeaklyReport.dart';

class GenerateUtils{
  static T classFromJson<T extends NetResult>(dynamic json) {

    if (T == NetResult) {
      return NetResult.fromJson(json) as T;
    }else if (T == LoginResult) {
      return LoginResult.fromJson(json) as T;
    }else if (T == RegisterResult) {
      return RegisterResult.fromJson(json) as T;
    }else if (T == CustomUser) {
      return CustomUser.fromJson(json) as T;
    }else if (T == Church) {
      return Church.fromJson(json) as T;
    }else if (T == WeaklyReport) {
      return WeaklyReport.fromJson(json) as T;
    }else if (T == Sermon) {
      return Sermon.fromJson(json) as T;
    }else if (T == Course) {
      return Course.fromJson(json) as T;
    }else if (T == IAPVerifyResult) {
      return IAPVerifyResult.fromJson(json) as T;
    }else if (T == PaypalResult) {
      return PaypalResult.fromJson(json) as T;
    }else if (T == OrderResult) {
      return OrderResult.fromJson(json) as T;
    } else {
      throw Exception("Unknown class");
    }
  }

  static List<T> listFromJson<T extends NetResult>(dynamic json) {
    if (json is Iterable) {
      return _listFromJson<T>(json);
    } else {
      throw Exception("Unknown class");
    }
  }

  static List<K> _listFromJson<K extends NetResult>(List jsonList) {
    if (jsonList == null) {
      return null;
    }
    List<K> output = List();
    for (Map<String, dynamic> json in jsonList) {
      output.add(GenerateUtils.classFromJson(json));
    }
    return output;
  }
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
}