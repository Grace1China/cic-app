class UserResponse {
  String errCode;
  String msg;
  CustomUser data;

  UserResponse({this.errCode, this.msg, this.data});

  UserResponse.fromJson(Map<String, dynamic> json) {
    errCode = json['errCode'];
    msg = json['msg'];
    data = json['data'] != null ? new CustomUser.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errCode'] = this.errCode;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class CustomUser {
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