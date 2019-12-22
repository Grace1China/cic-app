import 'package:church_platform/vedio/VideoPlayerManager.dart';
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

  FijkPlayer player;

  VideofijkplayerWidgetState();

  @override
  void initState(){
    debugPrint("创建播放器state ${this} ${widget.url}");
    super.initState();

    player = VideoPlayerManager().getPlayer(widget.url);
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
    debugPrint("释放播放器 ${this} ${widget.url}");
    super.dispose();

    // 不再释放资源，统一管理。使用暂停。
//    player.release();
    player.pause();

  }

//  void start(){
//    player.start();
//  }
//
//  void pause(){
//    player.pause();
//  }
//
//  void stop(){
//    player.stop();
//  }
//
//  FijkState state(){
//    return player.state;
//  }

}