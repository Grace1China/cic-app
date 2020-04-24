import 'dart:convert';
import 'dart:io';

import 'package:church_platform/net/common/NetResponseWithPage.dart';
import 'package:church_platform/net/common/NetClient.dart';
import 'package:church_platform/net/common/NetConfigure.dart';
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
import 'package:church_platform/utils/CryptoUtils.dart';
import 'package:church_platform/utils/SharedPreferencesUtils.dart';
import 'package:http/http.dart' as http;

import '../results/Sermon.dart';

class API {

  HttpClient _httpClient = HttpClient();

  //----------账户--------------
  Future<String> login(String email, String pwd) async {
    Map<String,String> params = {'email': email.trim(), 'password': CryptoUtils.convertSha256(pwd.trim())};
    final baseResponse = await NetClient<LoginResult>().request(method: NetMethod.POST, url: "/users/login",params:params);
    if (baseResponse.data.access != null) {
      SharedPreferencesUtils.saveToken(baseResponse.data.access);
      return baseResponse.data.access;
    }
    throw Exception('没有token');
  }

  Future<bool> register({String churchCode, String username, String email,String verify_code,
      String pwd,String confirmpwd}) async {

    Map<String,String> params = {'username': username.trim(),
      'email': email.trim(),
      'church_code': churchCode.trim(),
      'verify_code': verify_code.trim(),
      'password': CryptoUtils.convertSha256(pwd.trim()),
      'confirmpwd': CryptoUtils.convertSha256(confirmpwd.trim())
    };
    final baseResponse = await NetClient<RegisterResult>().request(method: NetMethod.POST, url: "/users/register",params:params);
    return true;
  }

  Future<String> generateVerifyCode({String email,bool modifypwd = false}) async {
    Map<String,String> params = {'email': email.trim(),'modifypwd':modifypwd.toString()};
    final baseResponse = await NetClient<VerifyCodeResult>().request(method: NetMethod.POST, url: "/users/generateverifycode",params:params);
    if (baseResponse.data.msg != null) {
      return baseResponse.data.msg;
    }
    throw Exception('生成验证码失败。');
  }


  Future<CustomUser> getUserInfo() async {
    final baseResponse = await NetClient<CustomUser>().request(url: "/users/getuserinfo");
    return baseResponse.data;
  }

  Future<CustomUser> updateUserInfo(String username) async {
    Map<String,String> params = {'username': username.trim()};
    final baseResponse = await NetClient<CustomUser>().request(method: NetMethod.POST, url: "/users/updateuserinfo",params:params);
    return baseResponse.data;
  }

  Future<bool> updateUserPWD(String email,String verifyCode,String newpwd,String confirmpwd) async {
    Map<String,String> params = {'email': email.trim(),
      'verify_code': verifyCode.trim(),
      'newpwd':CryptoUtils.convertSha256(newpwd.trim()),
      'confirmpwd':CryptoUtils.convertSha256(confirmpwd.trim())};
    final baseResponse = await NetClient<CustomUser>().request(method: NetMethod.POST, url: "/users/updateuserpwd",params:params);
    return true;
  }

  //----------教会，周报----------
  Future<Church> getChurch() async { //token根据token有无，返回不同教会。
    final baseResponse = await NetClient<Church>().request(url: "/getmychurch");
    return baseResponse.data;
  }

  Future<WeaklyReport> getWeaklyReportL3() async { //token不需要
    final baseResponse = await NetClient<WeaklyReport>().request(url: "/eweekly/l3", needToken: false);
    return baseResponse.data;
  }

  // curl -X GET "http://l3.community/rapi/eweekly/0" -H "accept: application/json" -H "authoriztion:bear eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNTc1NzgzNjA1LCJqdGkiOiIzMjYyYTJlMzU4MDQ0ZTFhYmY1M2VlZTQwZjJkYjMyMSIsInVzZXJfaWQiOjM3fQ.x0nprlwJqxnZdnltRaU7r0gciUTCZoq4wzfbrijLZZw " -d "{ \"username\": \"aa\", \"password\": \"aa_123456\"}"
  Future<WeaklyReport> getWeaklyReport() async {
      final baseResponse = await NetClient<WeaklyReport>().request(url: "/eweekly",needToken: true);
      return baseResponse.data;
  }

  //---------主日-----------
  Future<Sermon> getLorddayInfo() async {
    final baseResponse = await NetClient<Sermon>().request(url: "/lorddayinfo");
    return baseResponse.data;
  }

  Future<Sermon> getLorddayInfoL3() async {
    final baseResponse = await NetClient<Sermon>().request(url: "/lorddayinfo/l3");
    return baseResponse.data;
  }

  Future<NetResponseWithPage<Sermon>> getLorddayInfoList({int page, int pagesize = 20}) async {
    Map<String,String> params = {
      "pagesize": pagesize.toString(),
      "page": page.toString(),
    };
    final baseResponse = await NetClient<Sermon>().requestPage(url: "/lorddayinfos/list",params: params);
    return baseResponse;
  }

  Future<Sermon> getLorddayInfoByID(int sermonID) async {
    final baseResponse = await NetClient<Sermon>().request(url: "/lorddayinfos/" + sermonID.toString());
    return baseResponse.data;
  }

  //------------课程-----------
  static const String RequestCourseOrderByPrice = "price";
  static const String RequestCourseOrderBySale = "sales_num";
  Future<NetResponseWithPage<Course>> getCourseList(
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


    var uri = Uri.http(NetConfigure.HOST_NAME, NetConfigure.APIS + "/courses", queryParameters);
    final response = await http.get(uri,
      headers: token != null && token.isNotEmpty ? {
        HttpHeaders.authorizationHeader: "Bearer " + token,
      } : {},
    );

    if (response.statusCode == 200) {
      final baseResponse = NetResponseWithPage<Course>.fromJson(json.decode(response.body));
      if (baseResponse.errCode == "0") {
        return baseResponse;
      }
      throw Exception('没有课程信息');
    } else {
      throw Exception(response.statusCode.toString() + ":" + response.body);
    }
  }


//-----------支付-------------
  Future<String> iapCreateOrder(int courseID) async {
    final baseResponse = await NetClient<OrderResult>().request(method: NetMethod.POST, url: "/payments/orders",params: {'course_id': courseID});
    return baseResponse.data.order_no;
  }

  //内购验证
  Future<IAPVerifyResult> iapVerify(String receipt,String orderNO) async {

    final baseResponse = await NetClient<IAPVerifyResult>().request(method: NetMethod.POST, url: "/payments/iap/verifyreceipt",params: {'receipt': receipt,"order_no":orderNO});
    return baseResponse.data;

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
    final baseResponse = await NetClient<OrderResult>().request(method: NetMethod.POST, url: "/payments/paypal/client_token",params: {'course_id': courseID});
    return baseResponse.data;
  }

  Future<PaypalResult> paypalPostNonce(String nonce,String orderNO,String deviceData) async {
    Map<String,String> params = {'payment_method_nonce': nonce, "order_no": orderNO,"device_data":deviceData};
    final baseResponse = await NetClient<PaypalResult>().request(method: NetMethod.POST, url: "/payments/paypal/methon_nonce",params:params);
    return baseResponse.data;
  }
}
