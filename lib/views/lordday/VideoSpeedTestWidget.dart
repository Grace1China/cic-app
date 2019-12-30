
import 'package:church_platform/net/LorddayInfoResponse.dart';
import 'package:church_platform/net/Sermon.dart';
import 'package:church_platform/pdf/PDFViewerVerticalWidget.dart';
import 'package:church_platform/pdf/PDFViewerWidget.dart';
import 'package:church_platform/vedio/VideoPlayerManager.dart';
import 'package:church_platform/vedio/VideofijkplayerWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/foundation.dart';
import 'package:date_format/date_format.dart';



class VideoSpeedTestWidget extends StatefulWidget {

  List<Medias> medias;


  VideoSpeedTestWidget({Key key,this.medias}) : super(key: key){
  //
  }


  @override
  _VideoSpeedTestWidgetState createState() => _VideoSpeedTestWidgetState();
}

class _VideoSpeedTestWidgetState extends State<VideoSpeedTestWidget> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("视频测试"),
        elevation:
        (Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0),

      ),
      body: Container(
//        color: Colors.greenAccent,
//        margin: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[

              Container(
                padding: const EdgeInsets.all(5),
                child:  Text("video:  " + widget.medias[2].video),
                ),
              Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.width/16*9,
                  child:  VideofijkplayerWidget(url: widget.medias[2].video),
              ),


              Container(
                padding: const EdgeInsets.all(5),
                child:  Text("SHD_URL:  " + widget.medias[2].sHDURL),
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.width/16*9,
                child:  VideofijkplayerWidget(url: widget.medias[2].sHDURL),
              ),

              Container(
                padding: const EdgeInsets.all(5),
                child:  Text("HD_URL:  " + widget.medias[2].hDURL)
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.width/16*9,
                child:  VideofijkplayerWidget(url: widget.medias[2].hDURL),
              ),

              Container(
                padding: const EdgeInsets.all(5),
                child:  Text("SD_URL:  " + widget.medias[2].sDURL),
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.width/16*9,
                child:  VideofijkplayerWidget(url: widget.medias[2].sDURL),
              ),

            ],
          ),
        ),
      ),);
  }
}