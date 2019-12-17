
class RegisterResponse {
  String errCode;
  RegisterResult data;

  RegisterResponse({this.errCode, this.data});

  RegisterResponse.fromJson(Map<String, dynamic> json) {
    errCode = json['errCode'];
    data = json['data'] != null ? new RegisterResult.fromJson(json['data']) : null;
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

class RegisterResult {
  String email;
  String username;
  String password;
  String church_code;


  RegisterResult(
      {this.email,
        this.username,
        this.password,
        this.church_code,
   });

  RegisterResult.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    username = json['username'];
    password = json['password'];
    church_code = json['church_code'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['username'] = this.username;
    data['password'] = this.password;
    data['church_code'] = this.church_code;
    return data;
  }
}