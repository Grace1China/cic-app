
//  https://i3.community/swagger/

import 'dart:convert';
import 'dart:io';

import 'package:church_platform/net/CourseResponse.dart';
import 'package:church_platform/net/LoginResponse.dart';
import 'package:church_platform/net/LorddayInfoResponse.dart';
import 'package:church_platform/net/OrderResponse.dart';
import 'package:church_platform/net/RegisterResponse.dart';
import 'package:church_platform/net/WeaklyReport.dart';
import 'package:church_platform/net/models/Church.dart';
import 'package:church_platform/utils/LoggerUtils.dart';
import 'package:church_platform/utils/SharedPreferencesUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'ChurchResponse.dart';


class API {

//  static final String HOST_NAME = "192.168.43.196:8000";
  static final String HOST_NAME = "192.168.1.101:8000";

//  static final String HOST_NAME = "127.0.1.101:8000";
//  static final String HOST_NAME = "13.231.255.163";//"""http://l3.community";
  static final String HOST = "http://" + HOST_NAME; //"""http://l3.community";
  static final String APIS = "/rapi";

  HttpClient _httpClient = HttpClient();

  Future<Church> getChurch() async {
    final token = await SharedPreferencesUtils.getToken();
    final response = await http.get(HOST + APIS + "/getmychurch",
      headers: {HttpHeaders.authorizationHeader: "Bearer " + token},
    );

    debugPrint("网络请求：" + response.request.toString() + "，Header:" +
        response.request.headers.toString() + ",Response:" + response.body,
        wrapWidth: 1024);
    if (response.statusCode == 200) {
      final baseResponse = ChurchResponse.fromJson(json.decode(response.body));
      if (baseResponse.errCode == "0") {
        return baseResponse.data;
      }
      throw Exception('没有教会信息');
    } else {
      throw Exception(response.statusCode.toString() + ":" + response.body);
    }
  }

  Future<WeaklyReport> getWeaklyReportL3() async {
    final token = await SharedPreferencesUtils.getToken();
    final response = await http.get(HOST + APIS + "/eweekly/l3",
      headers: {HttpHeaders.authorizationHeader: "Bearer " + token},
    );

    debugPrint("网络请求：" + response.request.toString() + "，Header:" +
        response.request.headers.toString() + ",Response:" + response.body);
    if (response.statusCode == 200) {
      final baseResponse = BaseResponse.fromJson(json.decode(response.body));

      if (baseResponse.errCode == "0") {
        return baseResponse.data;
      }
      throw Exception('没有日报');
    } else {
      throw Exception(response.statusCode.toString() + ":" + response.body);
    }
  }

  // curl -X GET "http://l3.community/rapi/eweekly/0" -H "accept: application/json" -H "authoriztion:bear eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNTc1NzgzNjA1LCJqdGkiOiIzMjYyYTJlMzU4MDQ0ZTFhYmY1M2VlZTQwZjJkYjMyMSIsInVzZXJfaWQiOjM3fQ.x0nprlwJqxnZdnltRaU7r0gciUTCZoq4wzfbrijLZZw " -d "{ \"username\": \"aa\", \"password\": \"aa_123456\"}"
  Future<WeaklyReport> getWeaklyReport() async {
    final token = await SharedPreferencesUtils.getToken();
    final response = await http.get(HOST + APIS + "/eweekly/0",
      headers: {HttpHeaders.authorizationHeader: "Bearer " + token},
    );

    debugPrint("网络请求：" + response.request.toString() + "，Header:" +
        response.request.headers.toString() + ",Response:" + response.body,
        wrapWidth: 1024);
    if (response.statusCode == 200) {
      final baseResponse = BaseResponse.fromJson(json.decode(response.body));
      if (baseResponse.errCode == "0") {
        return baseResponse.data;
      }
      throw Exception('没有日报');
    } else {
      if (response.statusCode == 401) {
        print("token过期");
        //todo
//        SharedPreferencesUtils.logout();
//        MyApp.myTabbedPageKey.currentState.changeIndex(4);
//        Navigator.of(context).pop();
      }
      throw Exception(response.statusCode.toString() + ":" + response.body);
    }
  }

  Future<LorddayInfo> getLorddayInfo() async {
    final token = await SharedPreferencesUtils.getToken();
    final response = await http.get(HOST + APIS + "/lorddayinfo",
      headers: {HttpHeaders.authorizationHeader: "Bearer " + token,},
    );

    if (response.statusCode == 200) {
      final baseResponse = LorddayInfoResponse.fromJson(
          json.decode(response.body));
      if (baseResponse.errCode == "0") {
        return baseResponse.data;
      }
      throw Exception('没有主日信息');
    } else {
      throw Exception(response.statusCode.toString() + ":" + response.body);
    }
  }

  Future<LorddayInfo> getLorddayInfoL3() async {
    final response = await http.get(HOST + APIS + "/lorddayinfo/l3");

    if (response.statusCode == 200) {
      final baseResponse = LorddayInfoResponse.fromJson(
          json.decode(response.body));
      if (baseResponse.errCode == "0") {
        return baseResponse.data;
      }
      throw Exception('没有主日信息');
    } else {
      throw Exception(response.statusCode.toString() + ":" + response.body);
    }
  }

  Future<CourseResponse> getCourseList(
      {int page, int pagesize, String keyword = null}) async {
    final token = await SharedPreferencesUtils.getToken();
    var queryParameters = {
      "pagesize": pagesize.toString(),
      "page": page.toString(),
    };

    if (keyword != null && keyword.isNotEmpty) {
      queryParameters["keyword"] = keyword;
    }

    var uri = Uri.http(HOST_NAME, APIS + "/courses", queryParameters);
    final response = await http.get(uri,
      headers: token != null && token.isNotEmpty ? {
        HttpHeaders.authorizationHeader: "Bearer " + token,
      } : {},
    );

    if (response.statusCode == 200) {
      final baseResponse = CourseResponse.fromJson(json.decode(response.body));
      if (baseResponse.errCode == "0") {
        return baseResponse;
      }
      throw Exception('没有课程信息');
    } else {
      throw Exception(response.statusCode.toString() + ":" + response.body);
    }

/*    var url = HOST + APIS + "/courses/pagesize/$pagesize/page/$page";
    _httpClient.getUrl(Uri.parse(url)).then((HttpClientRequest request) {
          if(token.isNotEmpty){
            request.headers.add(HttpHeaders.authorizationHeader, "Bearer " + token);
          }
          return request.close();
    }).then((HttpClientResponse response) {

      if (response.statusCode == 200) {

        final baseResponse = CourseResponse.fromJson(json.decode(response.body));
        if(baseResponse.errCode == "0"){
          return baseResponse;
        }
        throw Exception('没有课程信息');
      } else {
        throw Exception(response.statusCode.toString() + ":" + response.body);
      }

//      if (response.statusCode == 200) {
//        response.transform(utf8.decoder).join().then((String string) {
//          print(string);
//        });
//      } else {
//        print("error");
//      }
    });*/


  }

  Future<String> login(String email, String pwd) async {
    var body = json.encode({'email': email, 'password': pwd});
//    var body = {'username':username, 'password':pwd};


    final response = await http.post(HOST + APIS + "/auth/jwt/create",
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json'},
        body: body);

    if (response.statusCode == 200) {
      final baseResponse = LoginResponse.fromJson(json.decode(response.body));
      if (baseResponse.access != null) {
        SharedPreferencesUtils.saveToken(baseResponse.access);
        return baseResponse.access;
      }
      throw Exception('没有token');
    } else {
      throw Exception(response.statusCode.toString() + ":" + response.body);
    }
  }

  Future<bool> register(String churchCode, String username, String email,
      String pwd) async {
    var body = json.encode({'username': username,
      'email': email,
      'church_code': churchCode,
      'password': pwd,
      'role': "2",
    });

    final response = await http.post(HOST + APIS + "/user_create",
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json'},
        body: body);

    if (response.statusCode == 200) {
      final baseResponse = RegisterResponse.fromJson(
          json.decode(response.body));
      if (baseResponse.errCode == "0") {
        return true;
      }
      throw Exception('注册失败');
    } else {
      throw Exception(
          response.statusCode.toString() + ":" + response.reasonPhrase + "." +
              response.body);
    }

//    if (response.statusCode == 201) {
//      final baseResponse = RegisterResponse.fromJson(json.decode(response.body));
//      if(baseResponse != null){
//        return true;
//      }
//      throw Exception('注册失败');
//    } else {
//      throw Exception(response.statusCode.toString() + ":" + response.reasonPhrase + "." + response.body);
//    }
  }

  Future<String> createOrder(int courseID) async {
    final token = await SharedPreferencesUtils.getToken();
    var body = json.encode({'course_id': courseID});

    final response = await http.post(HOST + APIS + "/payments/orders",
        headers: {
          HttpHeaders.contentTypeHeader:'application/json',
          HttpHeaders.authorizationHeader: "Bearer " + token,},
        body:body);

    if (response.statusCode == 200) {

      final baseResponse = OrderResponse.fromJson(json.decode(response.body));
      if(baseResponse.errCode == "0"){
        return baseResponse.data.order_no;
      }
      throw Exception('创建订单失败。${response.statusCode},${response.reasonPhrase},${response.body}');
    } else {
      throw Exception('创建订单失败。状态码：${response.statusCode},${response.reasonPhrase},${response.body}');
    }
  }

  //内购验证
  Future<bool> iapVerify(String receipt,String orderNO) async {
    final token = await SharedPreferencesUtils.getToken();
    var body = json.encode({'receipt': receipt,"order_no":orderNO});

    final response = await http.post(HOST + APIS + "/payments/iap/verifyreceipt",
        headers: {
          HttpHeaders.contentTypeHeader:'application/json',
          HttpHeaders.authorizationHeader: "Bearer " + token,},
        body:body);

    if (response.statusCode == 200) {

      final baseResponse = RegisterResponse.fromJson(json.decode(response.body));
      if(baseResponse.errCode == "0"){
        return true;
      }
      throw Exception('验证失败。');
    } else {
      throw Exception(response.statusCode.toString() + ":" + response.reasonPhrase + "." + response.body);
    }

//    var url = HOST + APIS + "/payments/iap/verify";
//    _httpClient.postUrl(Uri.parse(url)).then((HttpClientRequest request) {
//      if (token != null && token.isNotEmpty) {
//        request.headers.add(HttpHeaders.authorizationHeader, "Bearer " + token);
//      }
//      request.headers.add(HttpHeaders.contentTypeHeader, 'application/json');
//      request.headers.contentType = ContentType.json;
//      request.write(body);
//      return request.close();
//    }).then((HttpClientResponse response) {
//      if (response.statusCode == HttpStatus.ok) {
//        //接收服务器write的信息
//        response.transform(utf8.decoder).listen((String contents) {
//          print(contents);
//        });
//
//      } else {
//
//        print("error" + response.toString());
//      }
//    });
  }
}
