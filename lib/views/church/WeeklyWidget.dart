// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:convert';
import 'package:church_platform/HomeTabBarWidget.dart';
import 'package:church_platform/net/common/API.dart';
import 'package:church_platform/net/results/WeaklyReport.dart';
import 'package:church_platform/utils/SharedPreferencesUtils.dart';
import 'package:church_platform/views/common/BaseWebViewWidget.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(MaterialApp(home: WeeklyWidget()));

class WeeklyWidget extends StatefulWidget {
  static final WeeklyWidgetKey = new GlobalKey<_WeeklyWidgetState>();

  WeeklyWidget({Key key}) : super(key: key);

  @override
  _WeeklyWidgetState createState() => _WeeklyWidgetState();
}

class _WeeklyWidgetState extends State<WeeklyWidget> {
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  bool isRefreshLoading = true;
  String errmsg;
  WeeklyReport weeklyReport;
  String url = "";

  @override
  void initState() {
    super.initState();
    refresh();
  }

  void _reloadHtmlContent() async{
    if(weeklyReport.content != null && weeklyReport.content.isNotEmpty){
      final String contentBase64 = base64Encode(const Utf8Encoder().convert(weeklyReport.content));
      url = 'data:text/html;base64,$contentBase64';
      await _controller.future.then((value) => value.loadUrl(url));
    }else{
      _controller.future.then((value) => value.loadUrl(""));
    }
  }

  void refresh() async{
    setState(() {
      isRefreshLoading = true;
      errmsg = null;
      weeklyReport = null;
    });
    _reloadHtmlContent();

    try {
      bool isLogin = await SharedPreferencesUtils.isLogin();

      WeeklyReport weakly;
      if(isLogin) {
        weakly = await API().getWeeklyReport();
      }else{
        weakly = await API().getWeeklyReportL3();
      }
      setState(() {
        isRefreshLoading = false;
        errmsg = null;
        weeklyReport = weakly;
      });
      _reloadHtmlContent();

    } catch (e) {
      setState(() {
        isRefreshLoading = false;
        errmsg = e.toString();
        weeklyReport = null;
      });
      _reloadHtmlContent();
    }
  }

  Widget buildEWeekly(BuildContext context){
    if(errmsg != null){
      return Text("${errmsg}");
    }else if(weeklyReport == null) {
      return Container();
    }else {
      return WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
//            _reloadHtmlContent();
        },
        javascriptChannels: <JavascriptChannel>[
          _toasterJavascriptChannel(context),
        ].toSet(),
        navigationDelegate: (NavigationRequest request) {
          if (request.url == url){
            print('allowing navigation to $request');
            return NavigationDecision.navigate;
          }

          if (request.url.startsWith('http://') || request.url.startsWith('https://')) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BaseWebViewWidget(url: request.url,)),
            );
            print('blocking navigation to $request}');
            return NavigationDecision.prevent;
          }

          print('allowing navigation to $request');
          return NavigationDecision.navigate;
        },
        onPageStarted: (String url) {
          print('Page started loading: $url');
        },
        onPageFinished: (String url) {
          print('Page finished loading: $url');
        },
        gestureNavigationEnabled: false,
      );

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('教会'),
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

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }
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
