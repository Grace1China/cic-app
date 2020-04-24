import 'dart:convert';
import 'dart:io';

import 'package:church_platform/HomeTabBarWidget.dart';
import 'package:church_platform/net/common/NetResponseWithPage.dart';
import 'package:church_platform/net/common/NetResponse.dart';
import 'package:church_platform/net/common/NetConfigure.dart';
import 'package:church_platform/utils/SharedPreferencesUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class NetClient<T extends NetResult> {
  Future<NetResponse<T>> request(
      {NetMethod method = NetMethod.GET,
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
      case NetMethod.GET:
        {
//                Map<String, String> queryParams = params.cast<String, String>();
          Map<String, String> queryParams = Map<String, String>.from(requestParams);
          var api = NetAPI(url);
          var uri;
          if(queryParams.length > 0){
            uri = Uri.http(api.host_name, api.relativePath, queryParams);
          }else{
            uri = Uri.http(api.host_name, api.relativePath);
          }
          if(requestheaders.length > 0){
            response = await http.get(uri, headers: requestheaders);
          }else{
            response = await http.get(uri);
          }


        }
        break;
      case NetMethod.POST:
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
      throw Exception("没有数据");
    } else {
      //eg: 401,details
      if(response.statusCode == 401){
        HomeTabBarWidget.myTabbedPageKey.currentState.logout();
      }

      throw Exception("${response.statusCode},${response.reasonPhrase},${response.body}");
    }
  }

  //与 Future<NetResponse<T>> request 相同。只有NetResponseWithPage差别
  Future<NetResponseWithPage<T>> requestPage(
      {NetMethod method = NetMethod.GET,
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
      case NetMethod.GET:
        {
//                Map<String, String> queryParams = params.cast<String, String>();
          Map<String, String> queryParams = Map<String, String>.from(requestParams);
          var api = NetAPI(url);
          var uri;
          if(queryParams.length > 0){
            uri = Uri.http(api.host_name, api.relativePath, queryParams);
          }else{
            uri = Uri.http(api.host_name, api.relativePath);
          }
          if(requestheaders.length > 0){
            response = await http.get(uri, headers: requestheaders);
          }else{
            response = await http.get(uri);
          }


        }
        break;
      case NetMethod.POST:
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
      final baseResponse = NetResponseWithPage<T>.fromJson(json.decode(response.body));
      if (baseResponse.errCode == "0") {
        return baseResponse;
      }
      if(baseResponse.msg != null){
        throw Exception(baseResponse.msg);
      }
      throw Exception("没有数据");
    } else {
      //eg: 401,details
      if(response.statusCode == 401){
        HomeTabBarWidget.myTabbedPageKey.currentState.logout();
        throw Exception("${response.statusCode},${response.reasonPhrase},${response.body}");
      }else if(response.statusCode == 404){

        throw Exception("${response.statusCode},地址错误${response.request.url.toString()}");
      }

      throw Exception("${response.statusCode},${response.reasonPhrase},${response.body}");
    }
  }
}
