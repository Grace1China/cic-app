import 'package:church_platform/video/VideoPlayerManager.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';


//https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4
//https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4

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

    initPlayer();
  }

  void initPlayer(){
    player = VideoPlayerManager().getPlayer(widget.url);
    player.addListener(playerListener);
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        FijkView(
          player: player,
          fit: FijkFit.cover,
          fsFit: FijkFit.cover,
          color: Colors.black,
        ),
        player.value.exception != null && player.value.exception.code != 0 ? Positioned(top:0,left: 0,bottom: 0,right: 0,child: Container(child: Text(""),)):Container(),
        player.value.exception != null && player.value.exception.code != 0 ?
            Align(alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: RaisedButton(onPressed: (){
                  playerRefresh();
                },child: Text("刷新"),),
              ),)
            :
            Container()
      ],
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

  void playerListener(){
    setState(() {
      debugPrint("player:" + this.toString() + "事件监听：state：" + player.value.state.toString() + ",exception:" +player.value.exception.toString());
    });

  }

  void playerRefresh() async{
    await player.reset();
    await player.setDataSource(widget.url);
//    await player.prepareAsync();
    await player.start();
    setState(() {
//      player.removeListener(playerListener);
//      VideoPlayerManager().removePlayer(widget.url);
//      initPlayer();

      debugPrint("player:" + this.toString() + "刷新");
    });
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