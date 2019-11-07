import 'package:church_platform/home/VideoPlayerScreen.dart';
import 'package:church_platform/sunday/Sunday.dart';
import 'package:church_platform/sunday/SundayItem.dart';
import 'package:church_platform/sunday/details/SundayDetailsWidget.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';


class SundayWidget extends StatefulWidget {
  @override
  _SundayWidgetState createState() => _SundayWidgetState();
}


class _SundayWidgetState extends State<SundayWidget> {
  int pageIndex = 1;
  List<Sunday> modules = [Sunday("讲道1",1,"信息名字","cover","讲员名字","datetime",'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4'),
    Sunday("讲道2",2,"信息名字2","cover2","讲员名字2","datetime2",'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4')];

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
        title: Text('讲道'),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        children: modules.map((Sunday sunday) {
          return GestureDetector(
            child:  SundayItem(
              sundy: sunday,
              onTaped: (_) {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => new SundayDetailsWidget(sunday: sunday),
                  ),
                );
              },
            ),
          );
        }).toList(),
      ),
//      body:Container(
//        child: RefreshIndicator(
//          onRefresh: fetchData,
//          child: ListView.builder(
//            itemCount: modules.length,
//            itemBuilder: (BuildContext context, int index) {
//              return SundayItem(modules[index],onCartChanged:_handleTap);
//            },
//          ),
//        ),
//      ) ,
    );
  }
}
