import 'package:church_platform/net/API.dart';
import 'package:church_platform/net/Sermon.dart';
import 'package:church_platform/pdf/PDFViewerWidget.dart';
import 'package:church_platform/vedio/VedioPlayerWidget.dart';
import 'package:church_platform/vedio/VedioPlayerNativeWidget.dart';
import 'package:church_platform/views/sunday/Sunday.dart';
import 'package:flutter/material.dart';


class SundayDetailsWidget extends StatefulWidget {

  Sunday sunday;
  SundayDetailsWidget({Key key, this.sunday}) : super(key: key);

  @override
  _SundayDetailsWidgetState createState() => _SundayDetailsWidgetState();
}

class _SundayDetailsWidgetState extends State<SundayDetailsWidget> {
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
        title: Text("主日"),
        //centerTitle: true,
        elevation:
        (Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0),
        
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
              child: Column(
                children: <Widget>[
                  VedioPlayerWidget(url: snapshot.data.worshipvideo,),
//                  VedioPlayerWidget(url:widget.sunday.video),
                  Container(
                    padding: const EdgeInsets.all(5),
              color: Colors.grey,
                    child:  Text(snapshot.data.title,
//              softWrap: true,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),

                  Expanded(
                      child:Container(
//                color: Colors.amberAccent,
//                        child: PDFViewerWidget(url: "http://www.pdf995.com/samples/pdf.pdf"),
                        child: PDFViewerWidget(url: snapshot.data.pdf),
                      )
                  )
                ],
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