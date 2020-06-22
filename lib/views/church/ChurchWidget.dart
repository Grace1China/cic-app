import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:church_platform/HomeTabBarWidget.dart';
import 'package:church_platform/net/common/API.dart';
import 'package:church_platform/net/models/Church.dart';
import 'package:church_platform/net/results/WeaklyReport.dart';
import 'package:church_platform/utils/SharedPreferencesUtils.dart';
import 'package:church_platform/video/VideofijkplayerWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:transparent_image/transparent_image.dart';

class ChurchWidget extends StatefulWidget {
  static final ChurchWidgetKey = new GlobalKey<_ChurchWidgetState>();

  ChurchWidget({Key key}) : super(key: key);

  @override
  _ChurchWidgetState createState() => _ChurchWidgetState();
}

const String kNavigationExamplePage = '''
<!DOCTYPE html><html>
<head><title>Navigation Delegate Example</title></head>
<body>
<p>
The navigation delegate is set to block navigation to the youtube website.
</p>
<ul>
<ul><a href="https://www.youtube.com/">https://www.youtube.com/</a></ul>
<ul><a href="https://www.baidu.com/">https://www.baidu.com/</a></ul>
</ul>
</body>
</html>
''';

class _ChurchWidgetState extends State<ChurchWidget> {
  bool isRefreshLoading = true;

  Church church;
  String errmsg;

  Future<WeeklyReport> weaklyReport;
  WeeklyReport weaklyl3;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  void refresh() async{
    setState(() {
      isRefreshLoading = true;
      church = null;
      weaklyReport = null;
      weaklyl3 = null;
      errmsg = null;
    });

    bool isLogin = await SharedPreferencesUtils.isLogin();

    if(isLogin) {
      _refreshLogin();
    }else{
      _refreshNoLogin();
    }
  }

  void _refreshLogin() async{
    _refreshChurch();
    weaklyReport = API().getWeeklyReport();
    _refreshWeeklyl3();
  }

  void _refreshNoLogin() async{
    _refreshWeeklyl3();
  }

  void _refreshChurch() async{
    try {
      Church c = await API().getChurch();
      setState(() {
        church = c;
      });
    } catch (e) {
      setState(() {
        church = null;
      });
    }
  }

  void _refreshWeeklyl3() async{
    try {
      WeeklyReport l3 = await API().getWeeklyReportL3();

      setState(() {
        isRefreshLoading = false;
        weaklyl3 = l3;
        errmsg = null;
      });
    } catch (e) {
      if(church == null && weaklyReport == null){
        setState(() {
          isRefreshLoading = false;
          weaklyl3 = null;
          errmsg = e.toString();
        });
      }else{
        setState(() {
          isRefreshLoading = false;
          weaklyl3 = null;
          errmsg = null;
        });
      }

    }
  }

  Widget buildChurch(BuildContext context){
    if(errmsg != null){
//      return Text("${errmsg}"); 不显示错误了。因为后两个周报接口可能会成功。
      return Container();
    }else if(church == null) {
      return Container();
    }else{
      return Container(
//                    color: Colors.yellow,
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(5),
                child: Text(
                  church.name,
                  style: Theme.of(context).textTheme.headline,
                ),
              ),

              //只有加载完成才显示。
              Offstage(
                offstage: church.promotCover == null || church.promotCover.isEmpty,
                child: CachedNetworkImage(
                    imageUrl: church.promotCover != null && church.promotCover.isNotEmpty ? church.promotCover : "",
                    imageBuilder: (context, imageProvider) => Stack(alignment: AlignmentDirectional.center,
                      children: <Widget>[
                        Image(image: imageProvider,
                          fit: BoxFit.cover,),
                      ],),
                    placeholder: (context, url) => Container(),
                    errorWidget: (context, url, error) => Container() //Center(child: Icon(Icons.error),),
                ),
              ),
//加loading的图片。
//                          Stack(
//                            alignment: AlignmentDirectional.center,
//                            children: <Widget>[
//                              Center(child: CircularProgressIndicator()),
//                              Center(
//                                child: FadeInImage.memoryNetwork(
//                                  placeholder: kTransparentImage,
//                                  image: church.promotCover,
//                                ),
//                              ),
//                            ],
//                          ),
              Offstage(
                offstage: church.promotVideo == null || church.promotVideo.isEmpty,
                child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.width/16*9,
                    child:  VideofijkplayerWidget(url: church.promotVideo)), //传入null无影响
              ),
              Container(
                padding: const EdgeInsets.all(5),
                child: Text(church.description,
                  softWrap: true,
                ),
              ),
              Text("崇拜",
                  style: Theme.of(context).textTheme.subhead),

              ListView.builder(
                itemCount: church.venue.length,
                shrinkWrap:true,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(5),
                    child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          "每周日" + church.venue[index].time,
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        Text(
                          church.venue[index].address,
                        ),
                      ],
                    ),
                  );
                },
              ),

              church.promotVideo != null ?
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.width/16*9,
                child:  VideofijkplayerWidget(url:church.promotVideo,),
              ) : Container(),
            ],
          ));
    }
  }

  Widget buildEWeeklyl3(BuildContext context){
    if(errmsg != null){
//      return Text("${errmsg}"); //不显示错误了。因为后两个周报接口可能会成功。
      return Container();
    }else if(weaklyl3 == null) {
      return Container();
    }else{
      return Container(
//                    color: Colors.yellow,
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(5),
                child: Text("L3 EWeekly",
                    style: Theme.of(context).textTheme.subhead),
              ),
              Container(
                padding: const EdgeInsets.all(5),
                child: Text(weaklyl3.title,
                    style: Theme.of(context).textTheme.subhead),
              ),

//                        Image(image: NetworkImage(snapshot.data.image),),
              weaklyl3.image != null ?
              FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: weaklyl3.image,
                fit: BoxFit.cover,
              ):Container(),
              Html(data: weaklyl3.content,),
    Expanded(child:
              Container(
                width: MediaQuery.of(context).size.width,
//                height: 300,
//                child: BaseWebViewContainer(htmlContent: weaklyl3.content,), //TODO:显示webview
              )
    ),

            ],
          ));
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
//        automaticallyImplyLeading: false,
//        leading: Text(""),
        title: Text('教会'),
//        backgroundColor: Color(0xFFFF1744), //背景色，在theme优先级之上
        //centerTitle: true, //ios默认居中，android需要制定为true。
        elevation:
        (Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0),
        actions: <Widget>[
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              buildChurch(context),
//          Image(
//            image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
//          ),
//          Stack(
//            alignment: AlignmentDirectional.center,
//            children: <Widget>[
//              Center(child: CircularProgressIndicator()),
//              Center(
//                child: FadeInImage.memoryNetwork(
//                  placeholder: kTransparentImage,
//                  image: 'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
//                ),
//              ),
//            ],
//          ),
//          FadeInImage.memoryNetwork(
//            placeholder: kTransparentImage,
//            image: 'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
//          )
//            Image.asset(
//              'images/church1.png',
////            width: 600,
////            height: 240,
////            fit: BoxFit.cover,
//            ),
//            Container(
//              width: double.infinity,
//              height: MediaQuery.of(context).size.width/16*9,
//              child:  VideofijkplayerWidget(url:"http://d30szedwfk6krb.cloudfront.net/20191117IMS_Ve4x3lFTEST.m3u8",),
//            ),

              FutureBuilder<WeeklyReport>(
                future: weaklyReport,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
//                    color: Colors.yellow,
                        padding: const EdgeInsets.only(top: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.all(5),
                              child: Text("IMS EWeekly",
                                  style: Theme.of(context).textTheme.subhead),
                            ),
                            Container(
                              padding: const EdgeInsets.all(5),
                              child: Text(snapshot.data.title,
                                  style: Theme.of(context).textTheme.subhead),
                            ),

//                        Image(image: NetworkImage(snapshot.data.image),),
                            snapshot.data.image != null ?
                            FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image: snapshot.data.image,
                              fit: BoxFit.cover,
                            ):Container(),
                            Html(data: snapshot.data.content,),
//                            BaseWebViewContainer(htmlContent: snapshot.data.content,),
                          ],
                        ));
                  } else if (snapshot.hasError) {
                    return Container();//Text("${snapshot.error}");
                  }

                  // By default, show a loading spinner.
                  return Container();//Center(child: CircularProgressIndicator(),);
                },
              ),

              buildEWeeklyl3(context),
            ],
          ),
        ),
      ),
    );
  }
}
