
//  https://i3.community/swagger/

import 'dart:convert';
import 'dart:io';

import 'package:church_platform/net/common/BaseResponse.dart';
import 'package:church_platform/net/common/BaseResponseWithPage.dart';
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
import 'package:church_platform/utils/SharedPreferencesUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../results/Sermon.dart';

class API {

  //测试环境
//  static final String HOST_NAME = "13.231.255.163:8201";
//  static final String HOST_NAME = "172.20.10.3:8000";
  static final String HOST_NAME = "192.168.0.101:8000";


//  static final String HOST_NAME = "13.231.255.163";//"""http://l3.community";
  static final String HOST = "http://" + HOST_NAME; //"""http://l3.community";
  static final String APIS = "/rapi";

  HttpClient _httpClient = HttpClient();

  //----------账户--------------
  Future<String> login(String email, String pwd) async {
    var body = json.encode({'email': email, 'password': pwd});
    final response = await http.post(HOST + APIS + "/users/login",
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json'},
        body: body);

    if (response.statusCode == 200) {
      final baseResponse = BaseResponse<LoginResult>.fromJson(json.decode(response.body));
      if (baseResponse.data.access != null) {
        SharedPreferencesUtils.saveToken(baseResponse.data.access);
        return baseResponse.data.access;
      }
      throw Exception('没有token');
    } else {
      throw Exception(response.statusCode.toString() + ":" + response.body); //eg: 401,details
    }
  }

  Future<bool> register(String churchCode, String username, String email,
      String pwd,String confirmpwd) async {
    var body = json.encode({'username': username,
      'email': email,
      'church_code': churchCode,
      'password': pwd,
      'confirmpwd': confirmpwd
    });

    final response = await http.post(HOST + APIS + "/user_create",
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json'},
        body: body);

    if (response.statusCode == 200) {
      final baseResponse = BaseResponse<RegisterResult>.fromJson(
          json.decode(response.body));
      if (baseResponse.errCode == "0") {
        return true;
      }
      throw Exception('注册失败:' + baseResponse.msg);
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
//      throw Exception(response.statusCode.toString() + ":" + response.reasonPhrase + "." + json.decode(response.body));
//    }
  }

  Future<CustomUser> getUserInfo() async {
    final token = await SharedPreferencesUtils.getToken();
    final response = await http.get(HOST + APIS + "/users/getuserinfo",
      headers: token != null && token.isNotEmpty ? {
        HttpHeaders.authorizationHeader: "Bearer " + token,
      } : {},
    );

    debugPrint("网络请求：" + response.request.toString() + "，Header:" +
        response.request.headers.toString() + ",Response:" + response.body,
        wrapWidth: 1024);
    if (response.statusCode == 200) {
      final baseResponse = UserResponse.fromJson(json.decode(response.body));
      if (baseResponse.errCode == "0") {
        return baseResponse.data;
      }
      throw Exception('没有用户信息:' + baseResponse.msg);
    } else {
      throw Exception(response.statusCode.toString() + ":" + response.body);
    }
  }

  Future<CustomUser> updateUserInfo(String username) async {
    final token = await SharedPreferencesUtils.getToken();
    var body = json.encode({'username': username});

    final response = await http.post(HOST + APIS + "/users/updateuserinfo",
        headers: {
          HttpHeaders.contentTypeHeader:'application/json',
          HttpHeaders.authorizationHeader: "Bearer " + token,},
        body:body);

    debugPrint("网络请求：" + response.request.toString() + "，Header:" +
        response.request.headers.toString() + ",Response:" + response.body,
        wrapWidth: 1024);
    if (response.statusCode == 200) {
      final baseResponse = UserResponse.fromJson(json.decode(response.body));
      if (baseResponse.errCode == "0") {
        return baseResponse.data;
      }
      throw Exception('修改失败:' + baseResponse.msg);
    } else {
      throw Exception(response.statusCode.toString() + ":" + response.body);
    }
  }

  Future<bool> updateUserPWD(String oldpwd,String newpwd,String confirmpwd) async {
    final token = await SharedPreferencesUtils.getToken();
    var body = json.encode({'oldpwd': oldpwd,'newpwd':newpwd,'confirmpwd':confirmpwd});

    final response = await http.post(HOST + APIS + "/users/updateuserpwd",
        headers: {
          HttpHeaders.contentTypeHeader:'application/json',
          HttpHeaders.authorizationHeader: "Bearer " + token,},
        body:body);

    debugPrint("网络请求：" + response.request.toString() + "，Header:" +
        response.request.headers.toString() + ",Response:" + response.body,
        wrapWidth: 1024);
    if (response.statusCode == 200) {
      final baseResponse = UserResponse.fromJson(json.decode(response.body));
      if (baseResponse.errCode == "0") {
        return true;
      }
      throw Exception('修改失败:' + baseResponse.msg);
    } else {
      throw Exception(response.statusCode.toString() + ":" + response.body);
    }
  }

  //----------教会，周报----------
  Future<Church> getChurch() async {
    final token = await SharedPreferencesUtils.getToken();
    final response = await http.get(HOST + APIS + "/getmychurch",
      headers: token != null && token.isNotEmpty ? {
        HttpHeaders.authorizationHeader: "Bearer " + token,
      } : {},
    );

    debugPrint("网络请求：" + response.request.toString() + "，Header:" +
        response.request.headers.toString() + ",Response:" + response.body,
        wrapWidth: 1024);
    if (response.statusCode == 200) {
      final baseResponse = BaseResponse<Church>.fromJson(json.decode(response.body));
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
      headers: token != null && token.isNotEmpty ? {
        HttpHeaders.authorizationHeader: "Bearer " + token,
      } : {},
    );

    debugPrint("网络请求：" + response.request.toString() + "，Header:" +
        response.request.headers.toString() + ",Response:" + response.body);
    if (response.statusCode == 200) {
      final baseResponse = BaseResponse<WeaklyReport>.fromJson(json.decode(response.body));

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
      headers: token != null && token.isNotEmpty ? {
        HttpHeaders.authorizationHeader: "Bearer " + token,
      } : {},
    );

    debugPrint("网络请求：" + response.request.toString() + "，Header:" +
        response.request.headers.toString() + ",Response:" + response.body,
        wrapWidth: 1024);
    if (response.statusCode == 200) {
      final baseResponse = BaseResponse<WeaklyReport>.fromJson(json.decode(response.body));
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

  //---------主日-----------
  Future<Sermon> getLorddayInfo() async {
    final token = await SharedPreferencesUtils.getToken();
    final response = await http.get(HOST + APIS + "/lorddayinfo",
      headers: token != null && token.isNotEmpty ? {
      HttpHeaders.authorizationHeader: "Bearer " + token,
      } : {},
    );

    if (response.statusCode == 200) {
      final baseResponse = BaseResponse<Sermon>.fromJson(
          json.decode(response.body));
      if (baseResponse.errCode == "0") {
        return baseResponse.data;
      }
      throw Exception('没有主日信息');
    } else {
      throw Exception(response.statusCode.toString() + ":" + response.body);
    }
  }

  Future<Sermon> getLorddayInfoL3() async {
    final response = await http.get(HOST + APIS + "/lorddayinfo/l3");

    if (response.statusCode == 200) {
      final baseResponse = BaseResponse<Sermon>.fromJson(
          json.decode(response.body));
      if (baseResponse.errCode == "0") {
        return baseResponse.data;
      }
      throw Exception('没有主日信息');
    } else {
      throw Exception(response.statusCode.toString() + ":" + response.body);
    }
  }

  //------------课程-----------
  static const String RequestCourseOrderByPrice = "price";
  static const String RequestCourseOrderBySale = "sales_num";
  Future<BaseResponseWithPage<Course>> getCourseList(
      {int page, int pagesize, String keyword = null,String orderby = null,bool asc = false,bool bought = false}) async {
    final token = await SharedPreferencesUtils.getToken();
    var queryParameters = {
      "pagesize": pagesize.toString(),
      "page": page.toString(),
    };

    if (keyword != null && keyword.isNotEmpty) {
      queryParameters["keyword"] = keyword;
    }

    if(orderby != null && orderby.isNotEmpty){
      if(asc){
        queryParameters["orderby"] = orderby + " asc";
      }else{
        queryParameters["orderby"] = orderby + " desc";
      }
    }

    //已购
    queryParameters["bought"] = bought.toString();


    var uri = Uri.http(HOST_NAME, APIS + "/courses", queryParameters);
    final response = await http.get(uri,
      headers: token != null && token.isNotEmpty ? {
        HttpHeaders.authorizationHeader: "Bearer " + token,
      } : {},
    );

    if (response.statusCode == 200) {
      final baseResponse = BaseResponseWithPage<Course>.fromJson(json.decode(response.body));
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


//-----------支付-------------
  Future<String> iapCreateOrder(int courseID) async {
    final token = await SharedPreferencesUtils.getToken();
    var body = json.encode({'course_id': courseID});

    final response = await http.post(HOST + APIS + "/payments/orders",
        headers: {
          HttpHeaders.contentTypeHeader:'application/json',
          HttpHeaders.authorizationHeader: "Bearer " + token,},
        body:body);

    if (response.statusCode == 200) {

      final baseResponse = BaseResponse<OrderResult>.fromJson(json.decode(response.body));
      if(baseResponse.errCode == "0"){
        return baseResponse.data.order_no;
      }
      throw Exception('创建订单失败。${response.statusCode},${response.reasonPhrase},${response.body}');
    } else {
      throw Exception('创建订单失败。状态码：${response.statusCode},${response.reasonPhrase},${response.body}');
    }
  }

  //内购验证
  Future<IAPVerifyResult> iapVerify(String receipt,String orderNO) async {
    final token = await SharedPreferencesUtils.getToken();
    var body = json.encode({'receipt': receipt,"order_no":orderNO});

    final response = await http.post(HOST + APIS + "/payments/iap/verifyreceipt",
        headers: {
          HttpHeaders.contentTypeHeader:'application/json',
          HttpHeaders.authorizationHeader: "Bearer " + token,},
        body:body);

    if (response.statusCode == 200) {

      final baseResponse = BaseResponse<IAPVerifyResult>.fromJson(json.decode(response.body));
      if(baseResponse.errCode == "0"){
        return baseResponse.data;
      }
      throw Exception('验证失败。${response.statusCode},${response.reasonPhrase},${response.body}');
    } else {
      throw Exception('验证失败。状态码：${response.statusCode},${response.reasonPhrase},${response.body}');
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

  Future<OrderResult> paypalGetClientToken(int courseID) async {
    final token = await SharedPreferencesUtils.getToken();
    var body = json.encode({'course_id': courseID});

    final response = await http.post(HOST + APIS + "/payments/paypal/client_token",
        headers: {
          HttpHeaders.contentTypeHeader:'application/json',
          HttpHeaders.authorizationHeader: "Bearer " + token,},
        body:body);

    if (response.statusCode == 200) {

      final baseResponse = BaseResponse<OrderResult>.fromJson(json.decode(response.body));
      if(baseResponse.errCode == "0"){
        return baseResponse.data;
      }

      throw Exception('创建订单失败。${response.statusCode},${response.reasonPhrase},${json.decode(response.body)}');
    } else {
      throw Exception('创建订单失败。状态码：${response.statusCode},${response.reasonPhrase},${json.decode(response.body)}');
    }
  }

  Future<PaypalResult> paypalPostNonce(String nonce,String orderNO,String deviceData) async {
    final token = await SharedPreferencesUtils.getToken();
    var body = json.encode({'payment_method_nonce': nonce, "order_no": orderNO,"":deviceData});

    final response = await http.post(
        HOST + APIS + "/payments/paypal/methon_nonce",
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: "Bearer " + token,},
        body: body);

    if (response.statusCode == 200) {
      final baseResponse = BaseResponse<PaypalResult>.fromJson(json.decode(response.body));
      if (baseResponse.errCode == "0") {
        return baseResponse.data;
      }
      throw Exception('验证失败。');
    } else {
      throw Exception(
          response.statusCode.toString() + ":" + response.reasonPhrase + "." +
              json.decode(response.body));
    }
  }
}
