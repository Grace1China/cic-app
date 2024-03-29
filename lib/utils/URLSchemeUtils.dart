
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

      Uri u = Uri.parse(request.url);
      String target = u.queryParameters["target"];
      if(target == "_blank"){ //_blank新页面，_self是自己，不写null也是自己。
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BaseWebViewWidget(url: request.url,)),
        );
        print('blocking navigation to $request}');
        return false;
      }

      //_self是自己，不写也是自己。
      print('allowing navigation to $request');
      return true;
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

    print('allowing navigation to $request');
    return true;
  }
}
