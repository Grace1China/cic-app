import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';

void main() {
  String s = "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4";
//  s = "http://d30szedwfk6krb.cloudfront.net/20191117IMS_Ve4x3lFTEST.m3u8";
  runApp(new MaterialApp(home: new VideofijkPlayerTest(url: s)));
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
    preparePlayer();
  }

  Future<void> preparePlayer() async{
    await player.setDataSource(widget.url, autoPlay: false);
    await player.prepareAsync();
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