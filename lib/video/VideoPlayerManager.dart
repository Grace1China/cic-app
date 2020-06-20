import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/cupertino.dart';

class VideoPlayerManager {
  static final VideoPlayerManager _singleton = VideoPlayerManager._internal();

  factory VideoPlayerManager() {
    return _singleton;
  }

  VideoPlayerManager._internal();

  Map<String,FijkPlayer> _playerMap = Map<String,FijkPlayer>();


  Map<String,FijkPlayer> getAllPlayer(){
    return _playerMap;
  }

  FijkPlayer getPlayer(String url){

    if(_playerMap[url] == null){
      FijkPlayer p = FijkPlayer();
      debugPrint("创建播放器player ${p} ${url}");

      _setPlayer(url, p);
      _preparePlayer(url,p);
    }
    
    return _playerMap[url];
  }

  void removePlayer(String url){
    if(_playerMap[url] != null){
      _playerMap[url].release();
    }
    _playerMap[url] = null;
  }

  void clean(){
    _playerMap.forEach((key,player){
      player.release();
    });
    _playerMap = Map<String,FijkPlayer>();
  }

  FijkPlayer _setPlayer(String url,FijkPlayer player){
    _playerMap[url] = player;
  }

  Future<void> _preparePlayer(String url,FijkPlayer player) async{
    await player.setDataSource(url, autoPlay: false);
    player.prepareAsync();
  }
}