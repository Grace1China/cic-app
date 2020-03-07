import 'package:church_platform/audio/AudioPlayerWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class SpiritualDetailsWidget extends StatefulWidget {
  @override
  _SpiritualDetailsWidgetState createState() => _SpiritualDetailsWidgetState();
}


class _SpiritualDetailsWidgetState extends State<SpiritualDetailsWidget> {

  @override
  void initState() {
    super.initState();
//    post = fetchPost();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('灵修'),

        //centerTitle: true,
        elevation:
        (Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(10),
            child: Text(
              '顺服神话语系列|顺服中得胜',
//              softWrap: true,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          AudioPlayerWidget(
              url: 'http://www.largesound.com/ashborytour/sound/AshboryBYU.mp3'),
        ],
      )

    );
  }
}
