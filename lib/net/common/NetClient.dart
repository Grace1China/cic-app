import 'dart:convert';
import 'dart:io';
import 'package:church_platform/HomeTabBarWidget.dart';
import 'package:church_platform/main.dart';
import 'package:church_platform/net/common/NetBaseResponse.dart';
import 'package:church_platform/utils/AlertDialogUrils.dart';
import 'package:church_platform/utils/SharedPreferencesUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class NetConfigure {
  //测试环境Ø
//  static final String HOST_NAME = "13.231.255.163:8201";
//  static final String HOST_NAME = "172.20.10.3:8000";
  static final String HOST_NAME = "192.168.0.101:8000";

//  static final String HOST_NAME = "13.231.255.163";//"""http://l3.community";
  static final String HOST = "http://" + HOST_NAME; //"""http://l3.community";
  static final String APIS = "/rapi";
}

class NetAPI {
  String subApi;

  NetAPI(String subApi) {
    this.subApi = subApi;
  }

  String get fullPath {
    return NetConfigure.HOST + NetConfigure.APIS + subApi;
  }

  String get host {
    return NetConfigure.HOST;
  }

  String get host_name{
    return NetConfigure.HOST_NAME;
  }

  String get relativePath {
    return NetConfigure.APIS + subApi;
  }
}

enum Method { GET, POST }

class NetClient<T extends NetResult> {
  Future<NetResponse<T>> request(
      {Method method = Method.GET,
      String url,
      Map<String, Object> params,
      Map<String, String> headers,
      bool needToken = true}) async {

    //headers
    Map<String, String> requestheaders = Map<String, String>();
    if(headers != null && headers.length > 0){
      requestheaders.addAll(headers);
    }
    if (needToken) {
      final token = await SharedPreferencesUtils.getToken();
      if (token != null && token.isNotEmpty) {
        requestheaders[HttpHeaders.authorizationHeader] = "Bearer " + token;
      }
    }

    //params
    Map<String, Object> requestParams = Map<String, Object>();
    if(params != null && params.length > 0){
      requestParams.addAll(params);
    }

    //GET,POST --- headers,params.
    http.Response response;
    switch (method) {
      case Method.GET:
        {
//                Map<String, String> queryParams = params.cast<String, String>();
          Map<String, String> queryParams = Map<String, String>.from(requestParams);
          var api = NetAPI(url);
          var uri = Uri.http(api.host_name, api.relativePath, queryParams);
          response = await http.get(uri, headers: requestheaders);
        }
        break;
      case Method.POST:
        {
          requestheaders[HttpHeaders.contentTypeHeader] = 'application/json';
          var body = json.encode(requestParams);

          response = await http.post(NetAPI(url).fullPath,
              headers: requestheaders, body: body);
        }
        break;
    }

    debugPrint(
        "网络请求：" +
            response.request.toString() +
            "，Header:" +
            response.request.headers.toString() +
            ",Response:" +
            response.body,
        wrapWidth: 1024);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final baseResponse = NetResponse<T>.fromJson(json.decode(response.body));
      if (baseResponse.errCode == "0") {
        return baseResponse;
      }
      if(baseResponse.msg != null){
        throw Exception(baseResponse.msg);
      }
      throw Exception("请求失败");
    } else {
      //eg: 401,details
      if(response.statusCode == 401){
        HomeTabBarWidget.myTabbedPageKey.currentState.showLogout();
      }

      throw Exception(response.statusCode.toString() + ":" + response.body);
    }
  }
}
