import 'package:church_platform/views/account/AccountWidget.dart';
import 'package:church_platform/views/old/course/Course.dart';
import 'package:church_platform/views/old/course/CourseItem.dart';
import 'package:church_platform/vedio/test/VedioPlayerNativeScreen.dart';
import 'package:church_platform/views/old/sunday/Sunday.dart';
import 'package:church_platform/views/old/sunday/SundayItem.dart';
import 'package:church_platform/views/old/sunday/details/SundayDetailsWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import 'details/CourseDetailsWidget.dart';


class CourseWidget extends StatefulWidget {
  @override
  _CourseWidgetState createState() => _CourseWidgetState();
}


class _CourseWidgetState extends State<CourseWidget> {
  int pageIndex = 1;
  List<Course> modules = [Course("课程1",1,"信息名字","cover","讲员名字","datetime",
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
  99.99,"RMB",8677,1),
    Course("课程2",1,"信息名字2","cover","讲员名字2","datetime",
        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
        49.99,"RMB",10000,0)];

  @override
  void initState() {
    super.initState();
//    post = fetchPost();
  }

//  void _handleTap(Sunday sunday) {
//    Navigator.push(
//                context,
//                SundayDetailsWidget(sunday: sunday)
//              );
//  }

  Future<void> fetchData() async {
//    try {
//      var action;
//      switch (this.widget.type) {
//        case HomeListType.excellent:
//          action = 'home_excellent';
//          break;
//        case HomeListType.female:
//          action = 'home_female';
//          break;
//        case HomeListType.male:
//          action = 'home_male';
//          break;
//        case HomeListType.cartoon:
//          action = 'home_cartoon';
//          break;
//        default:
//          break;
//      }
//      var responseJson = await Request.get(action: action);
//      List moduleData = responseJson['module'];
//      List<HomeModule> modules = [];
//      moduleData.forEach((data) {
//        modules.add(HomeModule.fromJson(data));
//      });
//
//      setState(() {
//        this.modules = modules;
//        this.carouselInfos = carouselInfos;
//      });
//    } catch (e) {
//      Toast.show(e.toString());
//    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('课程'),
        //centerTitle: true,
elevation:
(Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0),
//        actions: <Widget>[
//          IconButton(icon: Icon(Icons.account_circle),
//              onPressed: (){
//                 Navigator.of(context).push(
//                    CupertinoPageRoute(
//                        fullscreenDialog: true,
//                        builder: (context) => AccountWidget()
//                    )
//                );
//              })
//        ],
      ),
      backgroundColor: Colors.black12,
      body: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75),
          itemCount:modules.length,
          itemBuilder: (context,index){
            //如果显示到最后一个并且Icon总数小于200时继续获取数据
            if (index == modules.length - 1 && modules.length < 200) {
//              _retrieveIcons();
            }
            return GestureDetector(
              child: CourseItem(
                course: modules[index]
              ),
              onTap: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => new CourseDetailsWidget(course: modules[index])
                  ),
                );
              },
            );
          }),
    );
  }
}
