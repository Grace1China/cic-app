
import 'package:church_platform/video/VideoPlayerWidget.dart';
import 'package:church_platform/views/common/BaseWebViewWidget.dart';
import 'package:church_platform/views/courses/CourseDetailsWidget.dart';
import 'package:church_platform/views/lordday/details/LorddayDetailsWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class URLSchemeUtils{
  BuildContext context;

  URLSchemeUtils({@required this.context}) : super();

  bool canNavigation(NavigationRequest request){

    if (request.url.startsWith('http://') || request.url.startsWith('https://')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BaseWebViewWidget(url: request.url,)),
      );
      print('blocking navigation to $request}');
      return false;
    }

    if (request.url.startsWith('churchplatform://js2native')) {
      Uri u = Uri.parse(request.url);
      String type = u.queryParameters["type"];
      switch(type){
        case "ShowCourseDetail":
          String courseid = u.queryParameters["courseid"];
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CourseDetailsWidget(courseid: int.parse(courseid))),
          );

          break;
        case "ShowSermonDetail":
          String sermonid = u.queryParameters["sermonid"];
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LorddayDetailsWidget(sermonid: int.parse(sermonid))),
          );
          break;
        case "PlayVideo":
          String videourl = u.queryParameters["videourl"];
          String title = u.queryParameters["title"] ?? "";
          String imageurl = u.queryParameters["imageurl"] ?? "";

//          videourl = "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4";
//          title = "标题";
//          imageurl = "http://api.bicf.org/mediabase/L3/20191006CC-560.jpg";
//          title = "";
//          imageurl = "";

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VideoPlayerWidget(videourl: videourl,title: title,imageurl: imageurl,)),
          );
          break;
        default:
      }

      print('blocking navigation to $request}');
      return false;
    }
//            String arg1 = u.queryParameters['arg1'];
//            String arg2 = u.queryParameters['arg2'];
//
//            Scaffold.of(context).showSnackBar(
//              SnackBar(content: Text(request.url + ",参数1：" + arg1 + ",参数2:" + arg2)),
//            );

    print('allowing navigation to $request');
    return true;
  }
}
