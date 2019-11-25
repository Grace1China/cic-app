import 'package:church_platform/views/sunday/Sunday.dart';
import 'package:church_platform/vedio/VedioPlayerWidget.dart';
import 'package:church_platform/vedio/test/VedioPlayerNativeWidget.dart';
import 'package:flutter/material.dart';


class SundayDetailsWidget extends StatefulWidget {
  Sunday sunday;
  SundayDetailsWidget({Key key, this.sunday}) : super(key: key);

  @override
  _SundayDetailsWidgetState createState() => _SundayDetailsWidgetState();
}

class _SundayDetailsWidgetState extends State<SundayDetailsWidget> {

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
        title: Text(widget.sunday.name),
      ),
      // Use a FutureBuilder to display a loading spinner while waiting for the
      // VideoPlayerController to finish initializing.
      body: ListView(
        children: <Widget>[
//          VedioPlayerWidget(url:widget.sunday.video),
          VedioPlayerWidget(url:widget.sunday.video),
          Container(
            padding: const EdgeInsets.all(5),
            child: Text(
              widget.sunday.name,
//              softWrap: true,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );;
  }
}