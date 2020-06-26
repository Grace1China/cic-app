// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:convert';
import 'package:church_platform/HomeTabBarWidget.dart';
import 'package:church_platform/net/common/API.dart';
import 'package:church_platform/net/common/NetConfigure.dart';
import 'package:church_platform/net/results/WeaklyReport.dart';
import 'package:church_platform/utils/SharedPreferencesUtils.dart';
import 'package:church_platform/utils/URLSchemeUtils.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(MaterialApp(home: TabWebViewMainWidget()));

enum TabType {
  CHURCH,
  LORDINFO,
}

class TabWebViewMainWidget extends StatefulWidget {
  static final ChurchMainWidgetKey = GlobalKey<_TabWebViewMainWidgetState>();
  static final LordDayMainWidgetKey = GlobalKey<_TabWebViewMainWidgetState>();

  TabType tabType;
  String subUrl = ""; ///blog/AppHome   //blog/LordDay
  String title = ""; //教会  //主日
  
  TabWebViewMainWidget({Key key,this.tabType}):super(key: key){
    switch(this.tabType){
      case TabType.CHURCH:
        subUrl = "/blog/AppHome";
        title = "教会";
        break;
      case TabType.LORDINFO:
        subUrl = "/blog/LordDay";
        title = "主日";
        break;
    }
  }

  @override
  _TabWebViewMainWidgetState createState() => _TabWebViewMainWidgetState();
}

class _TabWebViewMainWidgetState extends State<TabWebViewMainWidget> {

  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  bool isRefreshLoading = true;
  String errmsg;
  String url = "_blank";

  @override
  void initState() {
    super.initState();
    refresh(isFirst: true);
  }

  void refresh({bool isFirst = false}) async{
    if(isFirst){
      setState(() {
        isRefreshLoading = true;
        errmsg = null;
        url = "_blank";
      });
    }else{
      setState(() {
        isRefreshLoading = false;
        errmsg = null;
        url = "_blank";
      });
    }

    try{
      String urltemp = NetConfigure.HOST + widget.subUrl;
      final token = await SharedPreferencesUtils.getToken();
      if (token != null && token.isNotEmpty) {
        urltemp += "?token=" + token;
      }
      setState(() {
        this.url = urltemp;
        isRefreshLoading = false;
        errmsg = null;
      });
      _reloadWebViewURL();
    }catch(e){
      setState(() {
        this.url = "_blank";
        isRefreshLoading = false;
        errmsg = e.toString();
      });
      _reloadWebViewURL();
    }


  }

  void _reloadWebViewURL() async{
    String urltemp = NetConfigure.HOST + widget.subUrl;
    final token = await SharedPreferencesUtils.getToken();
    if (token != null && token.isNotEmpty) {
      Map<String, String> headers = {"Authorization": "Bearer " + token};
      urltemp += "?token=" + token;
      setState(() {
        url = urltemp;
      });
      await _controller.future.then((value) => value.loadUrl(url,headers: headers));
    }else{
      setState(() {
        url = urltemp;
      });
      await _controller.future.then((value) => value.loadUrl(url));
    }
  }

//  void _reloadURL(WebViewController webViewController) async{
//    String urltemp = NetConfigure.HOST + "/blog/AppHome";
//    final token = await SharedPreferencesUtils.getToken();
//    if (token != null && token.isNotEmpty) {
//      Map<String, String> headers = {"Authorization": "Bearer " + token};
//      urltemp += "?token=" + token;
//      url = urltemp;
//      webViewController.loadUrl(urltemp);
////      webViewController.loadUrl(urltemp, headers: headers);
//    }else{
//      url = urltemp;
////      webViewController.loadUrl(urltemp);
//    }
//  }

  Widget buildEWeekly(BuildContext context){
    if(errmsg != null){
      return Text("${errmsg}");
    }else {
      return WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
//            _reloadHtmlContent();
//          _reloadURL(webViewController);  //必须reload。否则只改变url靠state无效。
        },
//        javascriptChannels: <JavascriptChannel>[
//          _toasterJavascriptChannel(context),
//        ].toSet(),
        navigationDelegate: (NavigationRequest request) {
          if (request.url == url){
            print('allowing navigation to $request');
            return NavigationDecision.navigate;
          }
          return URLSchemeUtils(context: context).canNavigation(request) ? NavigationDecision.navigate : NavigationDecision.prevent;
        },
        onPageStarted: (String url) {
          print('Page started loading: $url');
        },
        onPageFinished: (String url) {
          print('Page finished loading: $url');
          setState(() {
            isRefreshLoading = false;
            errmsg = null;
          });
        },
        gestureNavigationEnabled: false,
      );

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
//        backgroundColor: Color(0xFFFF1744), //背景色，在theme优先级之上
          //centerTitle: true, //ios默认居中，android需要制定为true。
          elevation:
          (Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0),
          actions: <Widget>[
//          Offstage(
//            offstage: true,
//            child:NavigationControls(_controller.future),
//          ),
            IconButton(
                icon: Icon(Icons.account_circle),
                onPressed: () {
                  HomeTabBarWidget.myTabbedPageKey.currentState.tryShowAccount();
                })
          ],
        ),
        body: ModalProgressHUD(
          inAsyncCall: isRefreshLoading,
          opacity: 0.5,
          progressIndicator: CircularProgressIndicator(),
          child: buildEWeekly(context),
        )
    );
  }

//  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
//    return JavascriptChannel(
//        name: 'Toaster',
//        onMessageReceived: (JavascriptMessage message) {
//          Scaffold.of(context).showSnackBar(
//            SnackBar(content: Text(message.message)),
//          );
//        });
//  }
}

class NavigationControls extends StatelessWidget {
  const NavigationControls(this._webViewControllerFuture)
      : assert(_webViewControllerFuture != null);

  final Future<WebViewController> _webViewControllerFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _webViewControllerFuture,
      builder: (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        final bool webViewReady = snapshot.connectionState == ConnectionState.done;
        final WebViewController controller = snapshot.data;
        return Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.replay),
              onPressed: !webViewReady
                  ? null
                  : () {
                controller.reload();
              },
            ),
          ],
        );
      },
    );
  }
}
