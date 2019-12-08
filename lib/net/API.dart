
//  https://i3.community/swagger/

import 'dart:convert';
import 'dart:io';
import 'package:church_platform/net/Sermon.dart';
import 'package:http/http.dart' as http;
import 'package:church_platform/net/WeaklyReport.dart';


///rapi/auth/jwt/create/ 登陆
///
/// {
//  "refresh": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTU3NTc5NjY1NSwianRpIjoiMDg2Y2E4N2RkMjExNGYwNmI1OGI0YzEzOGZhNGIzMjIiLCJ1c2VyX2lkIjoxM30.vDDXnY8vX5ElntVjzwm2TRMqcQbtfz9oyCQnKW9KAb0",
//  "access": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNTc1NzEwNTU1LCJqdGkiOiJjZDlhN2U1NzhlNmI0OTg5OTRjN2JkMDlkNzNlZTZjOSIsInVzZXJfaWQiOjEzfQ.6RXfeb33gcncjg_Deo7sdEGsFkSIYLu6TVN3Xf0OBd4"
//}

//{
//"detail": "No active account found with the given credentials"
//}

///rapi/auth/users/注册
///
/// 参数
/// {
//  "email": "2008zkapie@163.com",
//  "username": "kevin42",
//  "password": "111aa3333"
//}
// 成功返回
//{
//"email": "2008zkapie@163.com",
//"username": "kevin42",
//"id": 15
//}
//错误返回
//{
//  "username": [
//    "已存在一位使用该名字的用户。"
//  ]
//}


///rapi/sermon/{id} //0 最新讲道。
///
///

class API{
  // curl -X GET "http://l3.community/rapi/eweekly/0" -H "accept: application/json" -H "authoriztion:bear eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNTc1NzgzNjA1LCJqdGkiOiIzMjYyYTJlMzU4MDQ0ZTFhYmY1M2VlZTQwZjJkYjMyMSIsInVzZXJfaWQiOjM3fQ.x0nprlwJqxnZdnltRaU7r0gciUTCZoq4wzfbrijLZZw " -d "{ \"username\": \"aa\", \"password\": \"aa_123456\"}"
  Future<WeaklyReport> getWeaklyReport() async {


    final response = await http.get("http://l3.community/rapi/eweekly/0",
      headers: {HttpHeaders.authorizationHeader: "bear eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNTc1NzgzNjA1LCJqdGkiOiIzMjYyYTJlMzU4MDQ0ZTFhYmY1M2VlZTQwZjJkYjMyMSIsInVzZXJfaWQiOjM3fQ.x0nprlwJqxnZdnltRaU7r0gciUTCZoq4wzfbrijLZZw"},
    );

    if (response.statusCode == 200) {

      final baseResponse = BaseResponse.fromJson(json.decode(response.body));
      if(baseResponse.errCode == "0"){
        return baseResponse.data;
      }
      throw Exception('没有日报');
    } else {
      throw Exception('请求没有返回200');
    }
  }

   Future<Sermon> getSermon() async {
    final response = await http.get("http://l3.community/rapi/sermon/0",
      headers: {HttpHeaders.authorizationHeader: "bear eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNTc1NzgzNjA1LCJqdGkiOiIzMjYyYTJlMzU4MDQ0ZTFhYmY1M2VlZTQwZjJkYjMyMSIsInVzZXJfaWQiOjM3fQ.x0nprlwJqxnZdnltRaU7r0gciUTCZoq4wzfbrijLZZw"},
    );

    if (response.statusCode == 200) {

      final baseResponse = BaseResponse2.fromJson(json.decode(response.body));
      if(baseResponse.errCode == "0"){
        return baseResponse.data;
      }
      throw Exception('没有讲道');
    } else {
      throw Exception('请求没有返回200');
    }
  }
}
