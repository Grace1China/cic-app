import 'package:chewie/chewie.dart';
import 'package:chewie/src/chewie_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';


void main() {
  runApp(new MaterialApp(home: new VideoPlayerWidgetTest()));
}

class VideoPlayerWidgetTest extends StatefulWidget {
  String url;
  VideoPlayerWidgetTest({this.title = '播放器',this.url});

  final String title;

  @override
  State<StatefulWidget> createState() {
    return _VideoPlayerWidgetTestState();
  }
}

class _VideoPlayerWidgetTestState extends State<VideoPlayerWidgetTest> {
  TargetPlatform _platform;
  VideoPlayerController _videoPlayerController1;
  ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController1 = VideoPlayerController.network(
        widget.url);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      aspectRatio: 3 / 2,
      autoPlay: true,
      looping: false,
      // Try playing around with some of these other options:

      // showControls: false,
      // materialProgressColors: ChewieProgressColors(
      //   playedColor: Colors.red,
      //   handleColor: Colors.blue,
      //   backgroundColor: Colors.grey,
      //   bufferedColor: Colors.lightGreen,
      // ),
      // placeholder: Container(
      //   color: Colors.grey,
      // ),
      // autoInitialize: true,
    );
  }

  @override
  void dispose() {
    _videoPlayerController1.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
//              child: Theme(
//                data: ThemeData.light().copyWith(platform: TargetPlatform.android),
                child: Chewie(
                  controller: _chewieController,
                ),
//              )
    );

  }
}
