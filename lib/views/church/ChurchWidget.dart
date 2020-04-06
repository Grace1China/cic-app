import 'package:cached_network_image/cached_network_image.dart';
import 'package:church_platform/HomeTabBarWidget.dart';
import 'package:church_platform/net/common/API.dart';
import 'package:church_platform/net/results/WeaklyReport.dart';
import 'package:church_platform/net/models/Church.dart';
import 'package:church_platform/vedio/VideofijkplayerWidget.dart';
import 'package:church_platform/views/account/AccountWidget.dart';
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

class _ChurchWidgetState extends State<ChurchWidget> {
  bool isRefreshLoading = true;

  Church church;
  String errmsg;

  Future<WeaklyReport> weaklyl3;
  Future<WeaklyReport> weaklyReport;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  void refresh() async{
    setState(() {
      isRefreshLoading = true;
    });

    try{
      Church c = await API().getChurch();
      setState(() {
        isRefreshLoading = false;
        church = c;
        errmsg = null;
      });
    }catch(e){
      setState(() {
        isRefreshLoading = false;
        church = null;
        errmsg = e.toString();
      });
    }

    weaklyl3 = API().getWeaklyReportL3();
    weaklyReport = API().getWeaklyReport();
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
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                  style: TextStyle(fontSize: 14),
                  softWrap: true,
                ),
              ),
              Text("崇拜",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

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
//            VedioPlayerNativeWidget(url:"https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"),
//            VedioPlayerWidget(
//                url: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"),
//            Container(
//              width: double.infinity,
//              height: MediaQuery.of(context).size.width/16*9,
//              child:  VideofijkplayerWidget(url:"http://d30szedwfk6krb.cloudfront.net/20191117IMS_Ve4x3lFTEST.m3u8",),
//            ),

              FutureBuilder<WeaklyReport>(
                future: weaklyl3,
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
                              child: Text("L3 EWeekly",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ),
                            Container(
                              padding: const EdgeInsets.all(5),
                              child: Text(snapshot.data.title,
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ),

//                        Image(image: NetworkImage(snapshot.data.image),),
                            snapshot.data.image != null ?
                            FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image: snapshot.data.image,
                              fit: BoxFit.cover,
                            ):Container(),
//                        HtmlWidget(snapshot.data.content,webView: true,),
                            Html(data: snapshot.data.content,)
                          ],
                        ));
                  } else if (snapshot.hasError) {
                    return Container(); //Text("${snapshot.error}");
                  }

                  // By default, show a loading spinner.
                  return Container(); //Center(child: CircularProgressIndicator(),);
                },
              ),

              FutureBuilder<WeaklyReport>(
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
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ),
                            Container(
                              padding: const EdgeInsets.all(5),
                              child: Text(snapshot.data.title,
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ),

//                        Image(image: NetworkImage(snapshot.data.image),),
                          snapshot.data.image != null ?
                            FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image: snapshot.data.image,
                              fit: BoxFit.cover,
                            ):Container(),
//                        HtmlWidget(snapshot.data.content,webView: true,),
                            Html(data: snapshot.data.content,)
                          ],
                        ));
                  } else if (snapshot.hasError) {
                    return Container();//Text("${snapshot.error}");
                  }

                  // By default, show a loading spinner.
                  return Container();//Center(child: CircularProgressIndicator(),);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
