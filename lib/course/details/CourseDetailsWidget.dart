import 'package:church_platform/home/VideoPlayerScreen.dart';
import 'package:church_platform/sunday/Sunday.dart';
import 'package:church_platform/sunday/details/VedioPlayerWidget.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:church_platform/course/Course.dart';


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
        title: Text(widget.course.name),
      ),
      // Use a FutureBuilder to display a loading spinner while waiting for the
      // VideoPlayerController to finish initializing.
      body: ListView(
        children: <Widget>[
          VedioPlayerWidget(url:widget.course.video),
          Container(
            padding: const EdgeInsets.all(5),
            child: Text(
              widget.course.name,
//              softWrap: true,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );;
  }
}