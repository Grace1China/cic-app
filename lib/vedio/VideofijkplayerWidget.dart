import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';

class VideofijkplayerWidget extends StatefulWidget {
  final String url;

  VideofijkplayerWidgetState selfState;

  VideofijkplayerWidget({Key key, @required this.url}) : super(key: key);

  @override
  VideofijkplayerWidgetState createState(){
    selfState = VideofijkplayerWidgetState();
    return selfState;
  }

}

class VideofijkplayerWidgetState extends State<VideofijkplayerWidget> {
  final FijkPlayer player = FijkPlayer();

  VideofijkplayerWidgetState();

  @override
  void initState(){
    super.initState();
    preparePlayer();
  }

  Future<void> preparePlayer() async{
      await player.setDataSource(widget.url, autoPlay: false);
      player.prepareAsync();
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

  void start(){
    player.start();
  }

  void pause(){
    player.pause();
  }

  void stop(){
    player.stop();
  }

  FijkState state(){
    return player.state;
  }

}