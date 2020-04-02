
import 'package:cached_network_image/cached_network_image.dart';
import 'package:church_platform/vedio/VideofijkplayerWidget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../net/results/Course.dart';


class CoursePlayWidget extends StatefulWidget {
  Course course;
  CoursePlayWidget({Key key,this.course,}) : super(key: key){
  }
  @override
  _CoursePlayWidgetState createState() => _CoursePlayWidgetState();
}

class _CoursePlayWidgetState extends State<CoursePlayWidget> {

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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.course.title),
        elevation:
        (Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0),

      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          widget.course.medias.length > 0 && widget.course.medias[0].hDURL != null && widget.course.medias[0].hDURL.isNotEmpty ?
          Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.width/16*9,
              child:  VideofijkplayerWidget(url: widget.course.medias[0].hDURL)):
          CachedNetworkImage(
            imageUrl: widget.course.medias[0].image,
            imageBuilder: (context, imageProvider) => Stack(alignment: AlignmentDirectional.center,
              children: <Widget>[
                Image(image: imageProvider,fit: BoxFit.cover,),
              ],),
            placeholder: (context, url) =>
                Container(
                  decoration:  BoxDecoration(
                    border:  Border.all(width: 2.0, color: Colors.black12),// 边色与边宽度
                    color: Colors.black26,//底色
                    borderRadius: const BorderRadius.all(const Radius.circular(2.0)),
                              ),
                  child:
                  Center(child: CircularProgressIndicator(),
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

          )
        ],
      ),
    );
  }
}