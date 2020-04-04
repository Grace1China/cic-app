
import 'package:church_platform/net/common/NetBaseResponse.dart';

class CustomUser extends NetResult{
  int id;
  String email;
  String username;

  CustomUser({this.id, this.email, this.username});

  CustomUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['username'] = this.username;
    return data;
  }
}