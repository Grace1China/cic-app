import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(new MaterialApp(home: new VideofijkPlayerTest(url: "http://d30szedwfk6krb.cloudfront.net/20191117IMS_Ve4x3lFTEST.m3u8")));
}

class VideofijkPlayerTest extends StatefulWidget {
  final String url;

  VideofijkPlayerTest({@required this.url});

  @override
  _VideofijkPlayerTestState createState() => _VideofijkPlayerTestState();
}

class _VideofijkPlayerTestState extends State<VideofijkPlayerTest> {
  final FijkPlayer player = FijkPlayer();

  _VideofijkPlayerTestState();

  @override
  void initState() {
    super.initState();
    player.setDataSource(widget.url, autoPlay: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Fijkplayer Example")),
        body: Container(
          alignment: Alignment.center,
          child: FijkView(
            player: player,
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
    player.release();
  }
}