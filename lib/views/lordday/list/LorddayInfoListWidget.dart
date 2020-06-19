import 'package:cached_network_image/cached_network_image.dart';
import 'package:church_platform/HomeTabBarWidget.dart';
import 'package:church_platform/net/common/API.dart';
import 'package:church_platform/net/common/NetResponseWithPage.dart';
import 'package:church_platform/net/models/Page.dart';
import 'package:church_platform/net/results/Sermon.dart';
import 'package:church_platform/views/lordday/details/LorddayDetailsWidget.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../../../utils/LoggerUtils.dart';

class LorddayInfoListWidget extends StatefulWidget {
  static final myLorddayInfoListWidgetKey =  GlobalKey<_LorddayInfoListWidgetState>();
  LorddayInfoListWidget({Key key}) : super(key: key);
  @override
  _LorddayInfoListWidgetState createState() => _LorddayInfoListWidgetState();
}


class _LorddayInfoListWidgetState extends State<LorddayInfoListWidget> {


  List<Sermon> sermons = List<Sermon>();
  NetPage page = NetPage();

  String errmsg = "";

  //Refresh
  EasyRefreshController _controller = EasyRefreshController();
  bool isFirstLoad = true;
  bool isloading = true;
  bool isRefreshLoading = false; //刷新时候的loading，显示ui。

  _LorddayInfoListWidgetState(){
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

  //TODO:刷新完后滚动到起始位置。
  void refresh({bool isFirst = false}) async{
    try{
      if(isFirst){
        setState(() {
          isloading = true;
        });
      }else{
        setState(() {
          isRefreshLoading = true;
        });
      }
      NetResponseWithPage<Sermon> response = await API().getLorddayInfoList(page: 1);
      setState(() {
        isloading = false;
        page = response.getPage();
        if(sermons == null){
          sermons = response.data;
        }else{
          sermons.clear();
          sermons.addAll(response.data);
        }

        _controller.finishRefresh(success: true);
        _controller.finishLoad(success: true,noMore: !page.hasNext());

        isRefreshLoading = false;
      });

    }catch (e) {
      setState(() {
        isloading = false;
        errmsg = e.toString();

        _controller.finishRefresh(success: true);
        _controller.finishLoad(success: true,noMore: !page.hasNext());

        isRefreshLoading = false;
      });
    }
  }

  void loadMore() async{
    try {
//      setState(() {
//        isRefreshLoading = true;
//      });
      NetResponseWithPage<Sermon> r = await API().getLorddayInfoList(page: page.page + 1);
      setState(() {
        page.page += 1;
        sermons += r.data;
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

  Widget itemWidget(Sermon lorddayInfo,int index){
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LorddayDetailsWidget(sermonid: lorddayInfo.id,)),
        );
      },
      child: Container(
        padding: EdgeInsets.all(8),
          decoration:  BoxDecoration(
            border:  Border.all(width: 1.0, color: Colors.black12),// 边色与边宽度
//            color: Colors.black12,//底色
            borderRadius: const BorderRadius.all(const Radius.circular(2.0)),
            //                              boxShadow: [BoxShadow(color: Color(0x99FFFF00), offset: Offset(5.0, 5.0), blurRadius: 10.0, spreadRadius: 2.0), BoxShadow(color: Color(0x9900FF00), offset: Offset(1.0, 1.0)), BoxShadow(color: Color(0xFF0000FF))],
          ),
        width: MediaQuery.of(context).size.width,
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 92,
              height: 92,
              child: CachedNetworkImage(
                imageUrl: lorddayInfo.imageUrl(),
                imageBuilder: (context, imageProvider) => Stack(alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    Image(image: imageProvider,
                      fit: BoxFit.cover,),
                  ],),
                placeholder: (context, url) => Container(
                  decoration:  BoxDecoration(
                    border:  Border.all(width: 1.0, color: Colors.black12),// 边色与边宽度
                    color: Colors.black26,//底色
                    borderRadius: const BorderRadius.all(const Radius.circular(2.0)),
                  ),
                  child: Center(child: Container(width:30,height: 30,
//                                                child: CircularProgressIndicator()
                                                  child: Container(),
                                                ),
                          ),
                ),
                errorWidget: (context, url, error) => Container(//灰色边框
                  decoration:  BoxDecoration(
                    border:  Border.all(width: 1.0, color: Colors.black12),// 边色与边宽度
                    color: Colors.black12,//底色
                    borderRadius: const BorderRadius.all(const Radius.circular(2.0)),
                  ),
                ),
              ),
            ),
            Container(width: 8,height: 8,),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,

                children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                  child: Text(lorddayInfo.title + lorddayInfo.title + lorddayInfo.title,textAlign: TextAlign.left, maxLines:2,style: TextStyle(fontSize: 16)),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                  Text(lorddayInfo.speaker.title, maxLines:1),
                  Text(sermons[index].formatPubtime() ,maxLines:1)
                ],),
              ],),
            ),
//            Container(width: 8,height: 8,),
          ],
        )
      ),
    );
  }

  Widget buildContent(BuildContext context){

    if (isloading) {
      return Center(child: CircularProgressIndicator());
    }else if(errmsg != null && errmsg.isNotEmpty) {
      return Text(errmsg);
    }else{
      return  ModalProgressHUD(
        inAsyncCall: isRefreshLoading,
        opacity: 0.5,
        progressIndicator: CircularProgressIndicator(),
        child: EasyRefresh(
          controller: _controller,
          enableControlFinishRefresh: true,
          enableControlFinishLoad: true,
          onRefresh:() async {this.refresh();},
          onLoad:() async {this.loadMore();},
          child: ListView.builder(
            itemCount: sermons.length,
            itemBuilder: (BuildContext context, int index) {
              return itemWidget(sermons[index], index);
            },

          ),
        ),
      );
    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("主日"),
        //centerTitle: true,
        elevation:
        (Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () async{
                HomeTabBarWidget.myTabbedPageKey.currentState.tryShowAccount();

              })
        ],
      ),
//        backgroundColor: Colors.black12,
      body:buildContent(context),


    );
  }

}
