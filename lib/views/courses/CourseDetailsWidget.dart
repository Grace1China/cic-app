import 'package:cached_network_image/cached_network_image.dart';
import 'package:church_platform/net/CourseResponse.dart';
import 'package:church_platform/vedio/VedioPlayerWidget.dart';
import 'package:church_platform/vedio/VideofijkplayerWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';


class CourseDetailsWidget extends StatefulWidget {
  Course course;
  CourseDetailsWidget({Key key, this.course}) : super(key: key);

  @override
  _CourseDetailsWidgetState createState() => _CourseDetailsWidgetState();
}

class _CourseDetailsWidgetState extends State<CourseDetailsWidget> {

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
        title: Text(widget.course.title),
        //centerTitle: true,
        elevation:
        (Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0),
      ),
      // Use a FutureBuilder to display a loading spinner while waiting for the
      // VideoPlayerController to finish initializing.
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
//          VedioPlayerWidget(url:widget.course.video),
//          VedioPlayerWidget(url:widget.course.medias[0].hDURL),
          Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.width,
              decoration:  BoxDecoration(
                border:  Border.all(width: 1.0, color: Colors.black12),// 边色与边宽度
//                color: Colors.black26,//底色
                borderRadius: const BorderRadius.all(const Radius.circular(2.0)),
                // boxShadow: [BoxShadow(color: Color(0x99FFFF00), offset: Offset(5.0, 5.0), blurRadius: 10.0, spreadRadius: 2.0), BoxShadow(color: Color(0x9900FF00), offset: Offset(1.0, 1.0)), BoxShadow(color: Color(0xFF0000FF))],
              ),
              child:
//              VideofijkplayerWidget(url: widget.course.medias[0].hDURL)),
            Stack(alignment: AlignmentDirectional.center,
              children: <Widget>[
//              Offstage(
//                offstage: true,
//                child: Container(
//                    width: MediaQuery.of(context).size.width*0.8,
//                    height: MediaQuery.of(context).size.width*0.8/16*9,
//                    child: VideofijkplayerWidget(url: widget.course.medias[0].hDURL)),
//              ),
                CachedNetworkImage(
                    imageUrl: widget.course.medias[0].image,
                    imageBuilder: (context, imageProvider) => Stack(alignment: AlignmentDirectional.center,
                      children: <Widget>[
                        Image(image: imageProvider,
                          fit: BoxFit.cover,),

                      ],),
                    placeholder: (context, url) =>
                        Container(
                          //                            color: Colors.grey,
                          decoration:  BoxDecoration(
                            border:  Border.all(width: 2.0, color: Colors.black12),// 边色与边宽度
                            color: Colors.black26,//底色
                            borderRadius: const BorderRadius.all(const Radius.circular(2.0)),
                            // boxShadow: [BoxShadow(color: Color(0x99FFFF00), offset: Offset(5.0, 5.0), blurRadius: 10.0, spreadRadius: 2.0), BoxShadow(color: Color(0x9900FF00), offset: Offset(1.0, 1.0)), BoxShadow(color: Color(0xFF0000FF))],
                          ),
                          child:
                            Center(child: CircularProgressIndicator(),
//                              Center(child: Container(),
                            ),
                        ),
                    errorWidget: (context, url, error) =>
                    //灰色边框
                      Container(
                        decoration:  BoxDecoration(
                          border:  Border.all(width: 1.0, color: Colors.black12),// 边色与边宽度
                          color: Colors.black12,//底色
                          borderRadius: const BorderRadius.all(const Radius.circular(2.0)),
                        ),
                      ),

                ),
//              Center(child:
//              FloatingActionButton(
//                heroTag: "btn${widget.course.id}",
////                            onPressed: () {},
//                child:  Icon(Icons.play_arrow,),),
//              ),
              ],
            ),
          ),
            Container(
              padding: const EdgeInsets.all(5),
              child: Text(
                widget.course.title,
//              softWrap: true,
                style: TextStyle(fontSize: 20),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(5),
              child: Text(
                "￥" + widget.course.price,
//              softWrap: true,
                style: TextStyle(fontSize: 18,color: Colors.red),
              ),
            ),

            widget.course.content != null ? Html(data: widget.course.content) : Container(),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: RaisedButton(
                  onPressed: () {

                  },
                  child: Text('去支付',
                      style: TextStyle(
                          color: Colors.white)),
                  color: Theme.of(context).buttonColor
              ),
//              margin: new EdgeInsets.only(
//                  top: 20.0
//              ),
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );;
  }
}