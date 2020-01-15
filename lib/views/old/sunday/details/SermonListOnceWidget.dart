import 'package:church_platform/net/API.dart';
import 'package:church_platform/net/Sermon.dart';
import 'package:church_platform/pdf/PDFViewerWidget.dart';
import 'package:church_platform/vedio/VedioPlayerWidget.dart';
import 'package:church_platform/vedio/VedioPlayerNativeWidget.dart';
import 'package:church_platform/vedio/VideofijkplayerWidget.dart';
import 'package:church_platform/views/account/AccountWidget.dart';
import 'package:church_platform/views/old/sunday/Sunday.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:church_platform/vedio/VideofijkplayerWidget.dart';


class SermonListOnceWidget extends StatefulWidget {

  SermonListOnceWidget({Key key}) : super(key: key);

  @override
  _SermonListOnceWidgetState createState() => _SermonListOnceWidgetState();
}

class _SermonListOnceWidgetState extends State<SermonListOnceWidget> {
  Future<Sermon> sermon;


  VedioPlayerNativeWidget worshipPlayer;
  VedioPlayerNativeWidget mcPlayer;
  VedioPlayerNativeWidget sermonPlayer;
  VedioPlayerNativeWidget givingPlayer;

  @override
  void initState() {
    super.initState();
    sermon = API().getSermon();
    //如何异步获取？？？
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("主日"),
        //centerTitle: true,
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
      // Use a FutureBuilder to display a loading spinner while waiting for the
      // VideoPlayerController to finish initializing.
      body: FutureBuilder<Sermon>(
        future: sermon,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
//        color: Colors.greenAccent,
//        margin: EdgeInsets.all(10),
              child: SingleChildScrollView(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(5),
                    width:MediaQuery.of(context).size.width,
//                    color: Colors.grey,
                    child:  Text(snapshot.data.title,
                      textAlign: TextAlign.center,
//                              softWrap: true,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),


                  Container(
                    padding: const EdgeInsets.all(5),
                    child:  Text("fijk HLS",textAlign: TextAlign.left,style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.width/16*9,
                    child:  VideofijkplayerWidget(url:"http://d30szedwfk6krb.cloudfront.net/20191117IMS_Ve4x3lFTEST.m3u8",),
                  ),

                  Container(
                    padding: const EdgeInsets.all(5),
                    child:  Text("native HLS",textAlign: TextAlign.left,style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  VedioPlayerNativeWidget(url:"http://d30szedwfk6krb.cloudfront.net/20191117IMS_Ve4x3lFTEST.m3u8",),




//                  Container(
//                    padding: const EdgeInsets.all(5),
////                    color: Colors.grey,
//                    child:  Text("敬拜",
//                      textAlign: TextAlign.left,
////                              softWrap: true,
//                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                    ),
//                  ),
//
//                  VedioPlayerNativeWidget(url: snapshot.data.worshipvideo),
//                  VideofijkplayerWidget(url: snapshot.data.worshipvideo,),
//
//                  Container(
//                    padding: const EdgeInsets.all(5),
////                    color: Colors.grey,
//                    child:  Text("主持",
//                      textAlign: TextAlign.left,
//                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                    ),
//                  ),
//
//                  VedioPlayerNativeWidget(url: snapshot.data.mcvideo,),
//
//                  Container(
//                    padding: const EdgeInsets.all(5),
////                    color: Colors.grey,
//                    child:  Text("讲道",
//                      textAlign: TextAlign.left,
//                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                    ),
//                  ),
//                  VedioPlayerNativeWidget(url: snapshot.data.sermonvideo,),
//
//                  Container(
//                    padding: const EdgeInsets.all(5),
////                    color: Colors.grey,
//                    child:  Text("奉献",
//                      textAlign: TextAlign.left,
//                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                    ),
//                  ),
//                  VedioPlayerNativeWidget(url: snapshot.data.givingvideo,),

//                  Expanded(
//                      child:
                  Container(
                    width:MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width,
//                color: Colors.amberAccent,
//                        child: PDFViewerWidget(url: "http://www.pdf995.com/samples/pdf.pdf"),
                    child: PDFViewerWidget(url: snapshot.data.pdf),
                  )
//                  )
                ],
              ),
              ),
            ) ;
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner.
          return Center(child:CircularProgressIndicator());
        },
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );;
  }
}