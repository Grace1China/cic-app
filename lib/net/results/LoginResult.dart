import 'package:church_platform/net/common/BaseResponse.dart';

class LoginResult extends BaseResult {
  String refresh;
  String access;

  LoginResult({this.refresh, this.access});

  LoginResult.fromJson(Map<String, dynamic> json) {
    refresh = json['refresh'];
    access = json['access'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['refresh'] = this.refresh;
    data['access'] = this.access;
    return data;
  }
}