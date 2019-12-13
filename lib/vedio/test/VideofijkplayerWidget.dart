import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';

class VideofijkplayerWidget extends StatefulWidget {
  final String url;

  VideofijkplayerWidget({@required this.url});

  @override
  _VideofijkplayerWidgetState createState() => _VideofijkplayerWidgetState();
}

class _VideofijkplayerWidgetState extends State<VideofijkplayerWidget> {
  final FijkPlayer player = FijkPlayer();

  _VideofijkplayerWidgetState();

  @override
  void initState() {
    super.initState();
    player.setDataSource(widget.url, autoPlay: true);
  }

  @override
  Widget build(BuildContext context) {
    return FijkView(
            player: player,
            fit: FijkFit.cover,
            fsFit: FijkFit.cover,
            color: Colors.black,
        );
  }

  @override
  void dispose() {
    super.dispose();
    player.release();
  }
}