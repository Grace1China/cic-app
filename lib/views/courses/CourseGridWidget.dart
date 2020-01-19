import 'package:church_platform/net/API.dart';
import 'package:church_platform/net/CourseResponse.dart';
import 'package:church_platform/net/models/Page.dart';
import 'package:church_platform/views/courses/CourseGridItem.dart';
import 'package:church_platform/views/courses/CourseInfoWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';



class CourseGridWidget extends StatefulWidget {
  @override
  _CourseGridWidgetState createState() => _CourseGridWidgetState();
}


class _CourseGridWidgetState extends State<CourseGridWidget> {
  EasyRefreshController _controller = EasyRefreshController();
  bool isFirstLoad = true;
  bool isloading = true;
  String errmsg = "";
  Page page = Page.fromDefault();

//  Future<CourseResponse> courseResponse;
  List<Course> courses;

  @override
  void initState() {
    super.initState();
//    courseResponse = API().getCourseList(page: page,pagesize: pageSize);
    refresh(isFirst:true);
  }

//  void _handleTap(Sunday sunday) {
//    Navigator.push(
//                context,
//                SundayDetailsWidget(sunday: sunday)
//              );
//  }

  void refresh({bool isFirst = false}) async{
    try{
      CourseResponse response = await API().getCourseList(page: 1,pagesize: page.pageSize);
      setState(() {
        isloading = false;
        page = Page(page: response.page,totalPage: response.totalPage);
        courses = response.data;
        _controller.finishLoad(success: true,noMore: !page.hasNext());
      });

    }catch (e) {
      if(isFirst){
        setState(() {
          isloading = false;
          errmsg = "$e";
        });
      }
    }
  }

  void loadMore() async{
    try {
      CourseResponse r = await API().getCourseList(
          page: page.page + 1, pagesize: page.pageSize);
      setState(() {
        page.page += 1;
        courses += r.data;
        _controller.finishLoad(success: true,noMore: !page.hasNext());
      });
    }catch(e){
    }

  }

  Widget buildBody(BuildContext context){

        if (isloading) {
          return Center(child: CircularProgressIndicator());
        }else if(errmsg != null && errmsg.isNotEmpty) {
          return Text(errmsg);
        }else{
          return  EasyRefresh(
            controller: _controller,
//            enableControlFinishRefresh: true,
            enableControlFinishLoad: true,
            onRefresh:() async {this.refresh();},
            onLoad:() async {this.loadMore();},
            child: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75),
                itemCount:courses.length,
                itemBuilder: (context,index){
/*                  //如果显示到最后一个并且Icon总数小于200时继续获取数据
                  if (index == courses.length - 1 && courses.length < 200) {
//              _retrieveIcons();
                  }*/
                  return GestureDetector(
                    child: CourseGridItem(
                        course: courses[index]
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => CourseInfoWidget(course: courses[index])
                        ),
                      );
                    },
                  );
                }),
          );
        }

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
//        backgroundColor: Colors.black12,
        body:buildBody(context),

    );
  }

  /*
  //FetureBuilder版本
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
      body:FutureBuilder<CourseResponse>(
        future: courseResponse,
        builder: (context, snapshot) {
          if (snapshot.hasData) {

            return  EasyRefresh(
              onRefresh: () async {
//                await Future.delayed(Duration(seconds: 2), () {
//                  setState(() {
//                    _gridCount = 30;
//                  });
//                });
              },
              onLoad: () async {
//                await Future.delayed(Duration(seconds: 2), () {
//                  setState(() {
//                    _gridCount += 10;
//                  });
//                });
              },
              child: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75),
                  itemCount:snapshot.data.data.length,
                  itemBuilder: (context,index){
                    //如果显示到最后一个并且Icon总数小于200时继续获取数据
                    if (index == snapshot.data.data.length - 1 && snapshot.data.data.length < 200) {
//              _retrieveIcons();
                    }
                    return GestureDetector(
                      child: CourseGridItem(
                          course: snapshot.data.data[index]
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => CourseInfoWidget(course: snapshot.data.data[index])
                          ),
                        );
                      },
                    );
                  }),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          return Center(child:CircularProgressIndicator());
        },
      )

    );
  }*/
}
