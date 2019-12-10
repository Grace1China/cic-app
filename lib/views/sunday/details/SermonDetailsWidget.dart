import 'package:church_platform/net/API.dart';
import 'package:church_platform/net/Sermon.dart';
import 'package:church_platform/pdf/PDFViewerWidget.dart';
import 'package:church_platform/vedio/VedioPlayerWidget.dart';
import 'package:church_platform/vedio/test/VedioPlayerNativeWidget.dart';
import 'package:church_platform/views/sunday/Sunday.dart';
import 'package:flutter/material.dart';


class SermonDetailsWidget extends StatefulWidget {

  SermonDetailsWidget({Key key}) : super(key: key);

  @override
  _SermonDetailsWidgetState createState() => _SermonDetailsWidgetState();
}

class _SermonDetailsWidgetState extends State<SermonDetailsWidget> {
  Future<Sermon> sermon;

  @override
  void initState() {
    super.initState();
    sermon = API().getSermon();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("主日信息"),
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
//                    color: Colors.grey,
                    child:  Text("敬拜",
                      textAlign: TextAlign.left,
//                              softWrap: true,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),

                  VedioPlayerWidget(url: snapshot.data.worshipvideo,),
                  VedioPlayerNativeWidget(url:snapshot.data.worshipvideo,),
                  Container(
                    padding: const EdgeInsets.all(5),
//                    color: Colors.grey,
                    child:  Text("主持",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),

                  VedioPlayerWidget(url: snapshot.data.mcvideo,),

                  Container(
                    padding: const EdgeInsets.all(5),
//                    color: Colors.grey,
                    child:  Text("讲道",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  VedioPlayerWidget(url: snapshot.data.sermonvideo,),

                  Container(
                    padding: const EdgeInsets.all(5),
//                    color: Colors.grey,
                    child:  Text("奉献",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  VedioPlayerWidget(url: snapshot.data.givingvideo,),

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