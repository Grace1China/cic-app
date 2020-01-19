import 'package:cached_network_image/cached_network_image.dart';
import 'package:church_platform/net/API.dart';
import 'package:church_platform/net/WeaklyReport.dart';
import 'package:church_platform/net/models/Church.dart';
import 'package:church_platform/vedio/VideofijkplayerWidget.dart';
import 'package:church_platform/views/account/AccountWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {

  Future<Church> church;
  Future<WeaklyReport> weaklyl3;
  Future<WeaklyReport> weaklyReport;

  @override
  void initState() {
    super.initState();
    church = API().getChurch();
    weaklyl3 = API().getWeaklyReportL3();
    weaklyReport = API().getWeaklyReport();
  }

  @override
  Widget build(BuildContext context) {
    Widget textSection = Container(
      padding: const EdgeInsets.all(5),
      child: Text(
        '凡耶稣基督所吩咐我们的，都教训他们遵守”。 我们的异象是“在基督里建立一个充满活力、不断倍增的社群，使他能为基督拥抱和转变万国的人们去影响他们的城市、他们的国家、乃至全世界”。北京国际基督教教会希望为你提供一个安全的居所，在这里与神建立更亲密关系，与其他同生活在北京的人建立紧密的联系。请继续的了解更多关于这个教会的信息及如何在BICF这个大家庭中一同服侍神。',
        style: TextStyle(fontSize: 14),
        softWrap: true,
      ),
    );

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
                //效果同等
//              Navigator.push(context,
//                  MaterialPageRoute(builder: (context) => DonateWidget(), fullscreenDialog: true));
                Navigator.of(context).push(CupertinoPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => AccountWidget()));
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            FutureBuilder<Church>(
              future: church,
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
                            child: Text(
                              snapshot.data.name,
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ),

                          //只有加载完成才显示。
                          Offstage(
                            offstage: snapshot.data.promotCover == null || snapshot.data.promotCover.isEmpty,
                            child: CachedNetworkImage(
                                imageUrl: snapshot.data.promotCover,
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
//                                  image: snapshot.data.promotCover,
//                                ),
//                              ),
//                            ],
//                          ),
                          Offstage(
                            offstage: snapshot.data.promotVideo == null || snapshot.data.promotVideo.isEmpty,
                            child: Container(
                                width: double.infinity,
                                height: MediaQuery.of(context).size.width/16*9,
                                child:  VideofijkplayerWidget(url: snapshot.data.promotVideo)),
                          ),
                          Container(
                            padding: const EdgeInsets.all(5),
                            child: Text(snapshot.data.description,
                              style: TextStyle(fontSize: 14),
                              softWrap: true,
                            ),
                          ),
                          Text("崇拜",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

                           ListView.builder(
                                 itemCount: snapshot.data.venue.length,
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
                                           "每周日" + snapshot.data.venue[index].time,
                                         ),
                                         SizedBox(
                                           width: 40,
                                         ),
                                         Text(
                                           snapshot.data.venue[index].address,
                                         ),
                                       ],
                                     ),
                                   );
                                 },
                               ),

                          snapshot.data.promotVideo != null ?
                          Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.width/16*9,
                            child:  VideofijkplayerWidget(url:snapshot.data.promotVideo,),
                          ) : Container(),
                        ],
                      ));
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                // By default, show a loading spinner.
                return Center(child: CircularProgressIndicator(),);
              },
            ),

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
    );
  }
}
