import 'package:cached_network_image/cached_network_image.dart';
import 'package:church_platform/main.dart';
import 'package:church_platform/net/common/API.dart';
import 'package:church_platform/net/results/Sermon.dart';
import 'package:church_platform/net/models/Medias.dart';
import 'package:church_platform/utils/SharedPreferencesUtils.dart';
import 'package:church_platform/vedio/VideoPlayerManager.dart';
import 'package:church_platform/vedio/VideofijkplayerWidget.dart';
import 'package:church_platform/views/account/AccountWidget.dart';
import 'package:church_platform/views/account/LoginWidget.dart';
import 'package:church_platform/views/lordday/LorddayInfoDetailsWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(new MaterialApp(home: new LorddayInfoMainWidget()));
}

class RefreshLorddayWidgetNotifier with ChangeNotifier{
  bool needRefresh = false;

  refresh(){
    needRefresh = true;
    notifyListeners();
  }

  refreshEnd(){
    needRefresh = false;
  }
}

class LorddayInfoMainWidget extends StatefulWidget {
  static final myLorddayInfoWidgetKey = new GlobalKey<_LorddayInfoMainWidgetState>();

  LorddayInfoMainWidget({Key key}) : super(key: key);

  @override
  _LorddayInfoMainWidgetState createState() => _LorddayInfoMainWidgetState();
}

class _LorddayInfoMainWidgetState extends State<LorddayInfoMainWidget> with WidgetsBindingObserver
{
  AppLifecycleState state;
  Future<Sermon> lorddayInfo;

  List<Medias> canShowMedias;
  List<Medias> canPlayMedias;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    VideoPlayerManager().clean();
    refreshRemoteData();


  }

  void refreshRemoteData() async{
    bool isLogin = await SharedPreferencesUtils.isLogin();

    setState(() {
      if(isLogin){
        lorddayInfo = API().getLorddayInfo();
      }else{
        lorddayInfo = API().getLorddayInfoL3();
      }
    });

  }

//  @override
//  void didUpdateWidget(LorddayInfoWidget oldWidget) {
//    super.didUpdateWidget(oldWidget);
//    print("didupdatewidget");
//
//  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    this.state = state;
    debugPrint("状态：" + state.toString());
    if(state == AppLifecycleState.resumed){
      print("resume");
    }else if(state == AppLifecycleState.inactive){
      // app is inactive
    }else if(state == AppLifecycleState.paused){
      // user is about quit our app temporally
    }else if(state == AppLifecycleState.detached){
      // app detached (not used in iOS)
    }
  }

//  返回一个item元素的list
  List<Widget> itemWidgets(Sermon lorddayInfo,Medias media,int index){
    List<Widget> widgets = List<Widget>();
    widgets.add(Container(
      padding: const EdgeInsets.all(5),
//                    color: Colors.grey,
      child:  Text( MediaTypeToName(MediaTypeFromInt(media.kind)),
        textAlign: TextAlign.left,
//                              softWrap: true,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    ));

    if(media.hDURL.isNotEmpty){
      widgets.add(GestureDetector(
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LorddayInfoDetailsWidget(lorddayInfo: lorddayInfo, medias:canPlayMedias , selectedIndex: canPlayMedias.indexOf(media),)),
          );
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width/16*9,
          child: Stack(
            children: <Widget>[
              //如果测试，把Offstage，宽高设为0.8比例，就可以看到
              Offstage(
                offstage: true,
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width/16*9,
                    child:  MediaTypeFromInt(media.kind) != MediaType.sermon ? VideofijkplayerWidget(url: media.hDURL):Container()),
              ),
//              Image.network(
//                media.image ?? defaultimageurl,
//                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
//                  //加载速度快，但是无法区分没加载  和 加载完。
//                  if (loadingProgress == null)
//                    return Stack(alignment: AlignmentDirectional.center,
//                      children: <Widget>[
////                        Image(image: child,
////                          fit: BoxFit.cover,),
//                        child,
//                        Center(child:
//                        FloatingActionButton(
//                          heroTag: "btn$index",
////                            onPressed: () {},
//                          child:  Icon(Icons.play_arrow,),),
//                        ),
//                      ],);
//
//                  return Center(
//                    child: CircularProgressIndicator(
//                      value: loadingProgress.expectedTotalBytes != null
//                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
//                          : null,
//                    ),
//                  );
//                },
//              ),

              CachedNetworkImage(
                  imageUrl: media.image,
                  imageBuilder: (context, imageProvider) => Stack(alignment: AlignmentDirectional.center,
                    children: <Widget>[
                      Image(image: imageProvider,
                        fit: BoxFit.cover,),
                      Center(child:
                      FloatingActionButton(
                        heroTag: "btn0${index}",
//                            onPressed: () {},
                        child:  Icon(Icons.play_arrow,),),
                      ),
                    ],),
                  placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                  errorWidget: (context, url, error) =>
                      Container(
                        decoration:  BoxDecoration(
                          border:  Border.all(width: 1.0, color: Colors.black12),// 边色与边宽度
                          color: Colors.black12,//底色
                          borderRadius: const BorderRadius.all(const Radius.circular(2.0)),
    //                              boxShadow: [BoxShadow(color: Color(0x99FFFF00), offset: Offset(5.0, 5.0), blurRadius: 10.0, spreadRadius: 2.0), BoxShadow(color: Color(0x9900FF00), offset: Offset(1.0, 1.0)), BoxShadow(color: Color(0xFF0000FF))],
                        ),
                      ), //Center(child: Icon(Icons.error),),
              ),
            ],
          ),
        ),
      ));
    }else if(media.content.isNotEmpty){
      widgets.add(Center(child: Text(media.content,textAlign: TextAlign.center,)));
    }


    return widgets;
  }

  List<Widget> contentWidgets(Sermon lorddayInfo){
    List<Widget> contentWidgets = List<Widget>();
    //                  RaisedButton(
//                      onPressed: () {
//                        Navigator.push(
//                          context,
//                          new MaterialPageRoute(
//                            builder: (context) => VideoSpeedTestWidget(medias:snapshot.data.medias),
//                          ),
//                        );
//                      },
//                      child: Text('视频测试',
//                          style: new TextStyle(
//                              color: Colors.white)),
//                      color: Theme.of(context).accentColor
//                  ),

    //标题
    contentWidgets.add(Container(
      padding: const EdgeInsets.all(5),
      width:MediaQuery.of(context).size.width,
//                    color: Colors.grey,
      child:  Text(lorddayInfo.title,
        textAlign: TextAlign.center,
//                              softWrap: true,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    ));

    canShowMedias.asMap().forEach((index,media){
      contentWidgets.addAll(itemWidgets(lorddayInfo, media, index));
    });


    //                  List.generate(canShowMedias.length, (index) => itemWidget(snapshot.data, canShowMedias[index],index)),

//    ListView.builder(
//      itemCount: canShowMedias.length,
//      shrinkWrap:true,
//      itemBuilder: (context, index) {
//        return itemWidget(snapshot.data, canShowMedias[index],index);
//      },
//    ),

/*
//                  Expanded(
//                      child:
                  Container(
                    width:MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width,
//                color: Colors.amberAccent,
//                        child: PDFViewerWidget(url: "http://www.pdf995.com/samples/pdf.pdf"),
                    child: PDFViewerWidget(url: snapshot.data.pdf),
                  )
//                  )

 */
    return contentWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("主日"),
        //centerTitle: true,
        elevation:
        (Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0),

        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () async{
                //效果同等
//              Navigator.push(context,
//                  MaterialPageRoute(builder: (context) => DonateWidget(), fullscreenDialog: true));
                bool isLogin = await SharedPreferencesUtils.isLogin();
                Navigator.of(context).pushNamed(RouteNames.LOGIN);


              })
        ],
      ),
      // Use a FutureBuilder to display a loading spinner while waiting for the
      // VideoPlayerController to finish initializing.
      body: FutureBuilder<Sermon>(
        future: lorddayInfo,
        builder: (context, snapshot) {
          if (snapshot.hasData) {


            canShowMedias = List<Medias>();
            snapshot.data.medias.forEach((Medias m){
              if(m.hDURL.isNotEmpty || m.content.isNotEmpty){
                canShowMedias.add(m);
              }
            });

            canPlayMedias = List<Medias>();
            snapshot.data.medias.forEach((Medias m){
              if(m.hDURL.isNotEmpty){
                canPlayMedias.add(m);
              }
            });

            return Container(
//        color: Colors.greenAccent,
//        margin: EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: contentWidgets(snapshot.data),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner.
          return Center(child:CircularProgressIndicator());
        },
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}