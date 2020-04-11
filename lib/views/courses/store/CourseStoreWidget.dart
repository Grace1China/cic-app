import 'package:church_platform/net/common/API.dart';
import 'package:church_platform/net/common/NetResponseWithPage.dart';
import 'package:church_platform/net/models/Page.dart';
import 'package:church_platform/net/results/Course.dart';
import 'package:church_platform/views/courses/CourseDetailsWidget.dart';
import 'package:church_platform/views/courses/store/CourseStoreItem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../../../utils/LoggerUtils.dart';

class CourseStoreWidget extends StatefulWidget {
  @override
  _CourseStoreWidgetState createState() => _CourseStoreWidgetState();
}


class _CourseStoreWidgetState extends State<CourseStoreWidget> {

  //  Future<CourseResponse> courseResponse;
  List<Course> courses;

  String errmsg = "";

  //Refresh
  EasyRefreshController _controller = EasyRefreshController();
  bool isFirstLoad = true;
  bool isloading = true;
  bool isRefreshLoading = false; //刷新时候的loading，显示ui。
  Page page = Page();

  //Search
  Widget _appBarTitle = new Text('课程');
  Icon _searchIcon = Icon(Icons.search);
  final TextEditingController _filter = new TextEditingController();
  String searchKeyword = null;
  FocusNode searchNode = FocusNode();

  //横向选择索引
  List<String> segmentTitles = <String>["综合","销量","已购"];
  int segmentIndex = 0;
  //最左边筛选竖向选择索引
  bool showItemSelectedView = false;
  List<String> itemTitles = <String>["综合","价格降序","价格升序"];
  int itemIndex = 0;

  //排序规则
  String requestOrderBy = null;
  bool requestAsc = false;
  bool requestBought = false;

  _CourseStoreWidgetState(){
//    _filter.addListener(() {
//      if (_filter.text.isEmpty) {
//        setState(() {
//          _searchText = "";
//          filteredNames = names;
//        });
//      } else {
//        setState(() {
//          _searchText = _filter.text;
//        });
//      }
//    });
  }

  @override
  void initState() {
    super.initState();
    refresh(isFirst:true);
  }

  //计算排序规则
  void calculateOrderRules(){
    requestOrderBy = null;
    requestAsc = false;
    requestBought = false;

    if(segmentIndex == 0){
      if(itemIndex == 0){
        requestOrderBy = null;
      }else if(itemIndex == 1){
        requestOrderBy = API.RequestCourseOrderByPrice;
        requestAsc = false;
      }else if(itemIndex == 2){
        requestOrderBy = API.RequestCourseOrderByPrice;
        requestAsc = true;
      }
    }else if(segmentIndex == 1){
      requestOrderBy = API.RequestCourseOrderBySale;
      requestAsc = false;
    }else{
      requestOrderBy = null;
      requestBought = true;
    }
  }
  //TODO:刷新完后滚动到起始位置。
  void refresh({bool isFirst = false}) async{
    try{
      calculateOrderRules();
//      if(isFirst){
//        setState(() {
//          isloading = true;
//        });
//      }else{
//        setState(() {
//          isRefreshLoading = true;
//        });
//      }
      NetResponseWithPage<Course> response = await API().getCourseList(page: 1,pagesize: page.pageSize,keyword: searchKeyword,orderby: requestOrderBy,asc: requestAsc,bought: requestBought);
      setState(() {
        isloading = false;
        page = response.getPage();
        if(courses == null){
          courses = response.data;
        }else{
          courses.clear();
          courses.addAll(response.data);
        }

        _controller.finishRefresh(success: true);
        _controller.finishLoad(success: true,noMore: !page.hasNext());

        isRefreshLoading = false;
      });

    }catch (e) {
//      if(isFirst){
        setState(() {
          isloading = false;
          errmsg = "$e";

          _controller.finishRefresh(success: true);
          _controller.finishLoad(success: true,noMore: !page.hasNext());

          isRefreshLoading = false;
        });
//      }
    }
  }

  void loadMore() async{
    try {
      calculateOrderRules();
//      setState(() {
//        isRefreshLoading = true;
//      });
      NetResponseWithPage<Course> r = await API().getCourseList(page: page.page + 1, pagesize: page.pageSize,keyword: searchKeyword,orderby: requestOrderBy,asc: requestAsc,bought: requestBought);
      setState(() {
        page.page += 1;
        courses += r.data;
        _controller.finishLoad(success: true,noMore: !page.hasNext());

        isRefreshLoading = false;
      });
    }catch(e){

      setState(() {
        _controller.finishLoad(success: true,noMore: !page.hasNext());

        isRefreshLoading = false;
      });

    }

  }


  Widget buildBody(BuildContext context){
//    List<Widget> widgets = List<Widget>();
//    widgets.add(buildContent(context));
//    if(showItemSelectedView){
//      widgets.add(Container(
//        color: Color(0x4d000000),
//      ));
//
//    }
    return Column(
      children: <Widget>[
        buildTabBar(context),
        Expanded(
          child: Stack(
            children: <Widget>[
              buildContent(context),
              showItemSelectedView ? GestureDetector(
                child: Container(
                  color: Color(0x4d000000),
                ),onTap: (){
                  setState(() {
                    showItemSelectedView = false;
                  });
              },
              ):Container(),
              showItemSelectedView ? Container(
                height: 60.0 * 3,
                color: Colors.white,
                child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {

                    return ListTile(
                      title: Text(itemTitles[index]),
                      selected: index == itemIndex,
                      trailing: index == itemIndex ? IconButton(icon: Icon(Icons.check,color:Theme.of(context).primaryColor),) : null,
                      onTap: () {
                        Log.i("${index}");
                        setState(() {
                          if(itemIndex != index){
                            segmentIndex = 0;
                            itemIndex = index;
                            isRefreshLoading = true;
                            refresh();
                          }
                          showItemSelectedView = false;
                        });
                      },
                    );
                  },
                  itemCount: 3,
                ),
              ):Container(),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildTabBar(BuildContext context){

    return Row(mainAxisAlignment:MainAxisAlignment.spaceAround,children: segmentTitles.asMap().keys.map((index){
      String segmentTitle = segmentTitles[index];

      if(index == 0){
        segmentTitle = itemTitles[itemIndex];
      }

      Text text = Text(segmentTitle,style: TextStyle(color: (segmentIndex == index ? Theme.of(context).primaryColor : Colors.black),));

      VoidCallback onPressed = (){
        setState(() {
          if(index == 0){

            if(segmentIndex == index){

              showItemSelectedView = !showItemSelectedView;
            }else{
              showItemSelectedView = !showItemSelectedView;
            }
          }else{
            showItemSelectedView = false;

            //刷新
            if(segmentIndex != index){

              segmentIndex = index;
              isRefreshLoading = true;
              refresh();
            }
          }

        });
      };

      if(index == 0){
        return FlatButton(child:Container(width:80,
                    child: Row(mainAxisAlignment:MainAxisAlignment.center,children: <Widget>[
                      text,
                      Icon( showItemSelectedView ? Icons.arrow_drop_up : Icons.arrow_drop_down, color: segmentIndex == 0 ? Theme.of(context).primaryColor :Colors.black ,),
                    ],)) ,onPressed:onPressed);
      }else{
        return FlatButton(child:Container(width:80,child: Center(child: text)) ,onPressed:onPressed);
      }

    }).toList());
  }

  Widget buildItemSelected(BuildContext content){

  }
  Widget buildContent(BuildContext context){

    if (isloading) {
      return Center(child: CircularProgressIndicator());
    }else if(errmsg != null && errmsg.isNotEmpty) {
      return Text(errmsg);
    }else{
      return  ModalProgressHUD(
        inAsyncCall: isRefreshLoading,
        // demo of some additional parameters
        opacity: 0.5,
        progressIndicator: CircularProgressIndicator(),
        child: EasyRefresh(
          controller: _controller,
          enableControlFinishRefresh: true,
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
                  child: CourseStoreItem(
                      course: courses[index]
                  ),
                  onTap: () async {
                    bool isBuySuccess = await Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => CourseDetailsWidget(course: courses[index])
                      ),
                    );
                    if(isBuySuccess){
                      isRefreshLoading = true;
                      refresh();
                    }
                  },
                );
              }),
        ),
      );
    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: _appBarTitle,
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
        actions: <Widget>[
          segmentIndex != 2 ? IconButton(
            icon: _searchIcon,
            onPressed: (){
              setState(() {
                if (this._searchIcon.icon == Icons.search) {
//                  //已购情况，禁用查询。
//                  if(segmentIndex == 2){
//                    return;
//                  }
                  this._searchIcon = Icon(Icons.close);
                  this._appBarTitle = TextField(
                    autofocus: true,
//                    focusNode: searchNode,
                    controller: _filter,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search,color: Colors.white,),
                        hintText: 'Search...',
                        hintStyle: TextStyle(color: Colors.white),
                    ),
                    onEditingComplete: (){
                      Log.d(searchKeyword);
                    },
                    onChanged: (searchText){
                      searchKeyword = searchText;
                    },
                    onSubmitted: (String searchText){
                      searchKeyword = searchText;
                      print(searchText);
                      FocusScope.of(context).requestFocus(FocusNode());
                      setState(() {
                        isRefreshLoading = true;
                      });
                      refresh();
                    },
                  );
                  showItemSelectedView = false;
//                  FocusScope.of(context).requestFocus(searchNode);
                  //handleSearchStart();
                } else {
                  this._searchIcon = Icon(Icons.search);
                  this._appBarTitle = Text('课程');
                  _filter.clear();
                  searchKeyword = null;
                  FocusScope.of(context).requestFocus(FocusNode());
                  //handleSearchEnd();
                }
              });
            },

          ):Container()
        ],
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
