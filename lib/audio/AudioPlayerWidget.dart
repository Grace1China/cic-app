import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'player_widget.dart';

typedef void OnError(Exception exception);

void main() {
  runApp(MaterialApp(
      home: Scaffold(
          body: AudioPlayerWidget(
              url: 'https://luan.xyz/files/audio/ambient_c_motion.mp3')
          )
      ));
}

class AudioPlayerWidget extends StatefulWidget {
  final String title;
  String url;
  AudioPlayerWidget({this.title = '音频播放器',this.url});
  
  @override
  _AudioPlayerWidgetState createState() => new _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {

  @override
  Widget build(BuildContext context) {
    return Center(
            child:  PlayerWidget(url:widget.url),
          );

  }
}
