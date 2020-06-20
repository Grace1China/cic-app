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
import 'package:church_platform/utils/URLSchemeUtils.dart';
import 'package:church_platform/video/VideoPlayerWidget.dart';
import 'package:church_platform/views/common/BaseWebViewWidget.dart';
import 'package:church_platform/views/courses/CourseDetailsWidget.dart';
import 'package:church_platform/views/lordday/details/LorddayDetailsWidget.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:webview_flutter/webview_flutter.dart';

const String kNavigationExamplePage = '''
<table border="0" cellpadding="0" cellspacing="0" style="width:100%">
	<tbody>
		<tr>
			<td style="width:25%">
			<p><a href="https://www.baidu.com"><img src="https://api.bicf.org/mediabase/L3/default/c225a6ba-3417-6ce6-e577-eccabed61f3e" style="width:100%" /></a></p>
			</td>
			<td style="width:25%">
			<p><a href="http://localhost:8000/blog/tuwen/5"><img src="https://api.bicf.org/mediabase/L3/default/d7bbf96a-8d6c-a8b0-6740-3ffacb30e1a1" style="width:100%" /></a></p>
			</td>
			<td style="width:25%">
			<p><img src="https://api.bicf.org/mediabase/L3/default/613ca59b-5391-0f8b-2ee0-bf6359725dcb?x-oss-process=style" style="width:100%" /></p>
			</td>
			<td style="width:25%">
			<p><img src="https://api.bicf.org/mediabase/L3/default/9b95fb88-0fb6-9459-128e-d5a04c3d9704?x-oss-process=style" style="width:100%" /></p>
			</td>
		</tr>
		

	</tbody>
</table>

<p>&nbsp;</p>
<button onclick="callFlutter()">通道字符串</button>
<button onclick="callFlutter2()">通道json</button>
<button onclick="callFlutter3()">url跳转课程详情</button>
<button onclick="callFlutter4()">url跳转主日详情</button>
<button onclick="callFlutter5()">url跳转视频</button>
<p>&nbsp;</p>
<script>
    function callFlutter(){
       ChurchPlatformJs2Native.postMessage("JS调用了Flutter");
    }
    function callFlutter2(){
       ChurchPlatformJs2Native.postMessage("{\\"name\\":\\"value\\"}"); /* json没有调适成功 */
    }
    function callFlutter3(){
      document.location = "churchplatform://js2native?type=ShowCourseDetail&courseid=58";
    }
    function callFlutter4(){
      document.location = "churchplatform://js2native?type=ShowSermonDetail&sermonid=45";
    }
    function callFlutter5(){
      document.location = "churchplatform://js2native?type=PlayVideo&videourl=https://abc.mp4&title=titlename&imageurl=http://aaa.com";
    }
</script>
''';

void main() => runApp(MaterialApp(home: WeeklyWidget()));

class WeeklyWidget extends StatefulWidget {
  static final WeeklyWidgetKey = GlobalKey<_WeeklyWidgetState>();

  WeeklyWidget({Key key}) : super(key: key);

  @override
  _WeeklyWidgetState createState() => _WeeklyWidgetState();
}

class _WeeklyWidgetState extends State<WeeklyWidget> {
//  GlobalKey<BaseWebViewWidgetState> _webViewKey = GlobalKey<BaseWebViewWidgetState>();

  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  bool isRefreshLoading = true;
  String errmsg;
  WeeklyReport weeklyReport;
  String url = "";

  @override
  void initState() {
    super.initState();
    refresh(isFirst: true);
  }

  void _reloadHtmlContent() async{
    if(weeklyReport != null && weeklyReport.content != null && weeklyReport.content.isNotEmpty){
//      String htmlcontent = kNavigationExamplePage;
      String htmlcontent = weeklyReport.content;
      final String contentBase64 = base64Encode(const Utf8Encoder().convert(htmlcontent));
      url = 'data:text/html;base64,$contentBase64';
      await _controller.future.then((value) => value.loadUrl(url));
//      _controller.future.then((value) => value.reload());
    }else{
      await _controller.future.then((value) => value.loadUrl("about:blank"));
    }
  }

  void refresh({bool isFirst = false}) async{
    if(isFirst){
      setState(() {
        isRefreshLoading = true;
        errmsg = null;
        weeklyReport = null;
      });
      _reloadHtmlContent();
    }else{
      setState(() {
        isRefreshLoading = false;
        errmsg = null;
        weeklyReport = null;
      });
      _reloadHtmlContent();
    }

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
          return URLSchemeUtils(context: context).canNavigation(request) ? NavigationDecision.navigate : NavigationDecision.prevent;
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
