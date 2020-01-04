import 'package:church_platform/net/API.dart';
import 'package:church_platform/net/LorddayInfoResponse.dart';
import 'package:church_platform/net/Sermon.dart';
import 'package:church_platform/pdf/PDFViewerWidget.dart';
import 'package:church_platform/utils/SharedPreferencesUtils.dart';
import 'package:church_platform/vedio/VedioPlayerWidget.dart';
import 'package:church_platform/vedio/VedioPlayerNativeWidget.dart';
import 'package:church_platform/vedio/VideoPlayerManager.dart';
import 'package:church_platform/vedio/VideofijkplayerWidget.dart';
import 'package:church_platform/views/account/AccountWidget.dart';
import 'package:church_platform/views/lordday/LorddayInfoDetailsWidget.dart';
import 'package:church_platform/views/lordday/VideoSpeedTestWidget.dart';
import 'package:church_platform/views/sermon/SermonShowWidget.dart';
import 'package:church_platform/views/sunday/Sunday.dart';
import 'package:church_platform/views/sunday/details/SermonDetailsWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:church_platform/vedio/VideofijkplayerWidget.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:cached_network_image/cached_network_image.dart';


void main() {
  runApp(new MaterialApp(home: new LorddayInfoWidget()));
}

class LorddayInfoWidget extends StatefulWidget {

  LorddayInfoWidget({Key key}) : super(key: key);

  @override
  _LorddayInfoWidgetState createState() => _LorddayInfoWidgetState();
}

class _LorddayInfoWidgetState extends State<LorddayInfoWidget> {
  Future<LorddayInfo> lorddayInfo;

  List<Medias> canShowMedias;
  List<Medias> canPlayMedias;

  @override
  void initState() {
    super.initState();
    VideoPlayerManager().clean();
    refreshRemoteData();
  }

  void refreshRemoteData() async{
//    bool isLogin = await SharedPreferencesUtils.isLogin();
//    if(isLogin){
      lorddayInfo = API().getLorddayInfo();
//    }else{
//      lorddayInfo = API().getLorddayInfoL3();
//    }
  }

  @override
  void dispose() {
    super.dispose();
  }

//  返回一个item元素的list
  List<Widget> itemWidgets(LorddayInfo lorddayInfo,Medias media,int index){
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

    if(media.sDURL.isNotEmpty){
      widgets.add(GestureDetector(
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LorddayInfoDetailsWidget(lorddayInfo: lorddayInfo, medias:canPlayMedias , selectedIndex: canPlayMedias.indexOf(media),)),
          );
        },
        child: Stack(
          children: <Widget>[
            Offstage(
              offstage: true,
              child: Container(
                  width: MediaQuery.of(context).size.width*0.8,
                  height: MediaQuery.of(context).size.width*0.8/16*9,
                  child:  MediaTypeFromInt(media.kind) != MediaType.sermon ? VideofijkplayerWidget(url: media.sHDURL):Container()),
            ),
//              Image.network(
//                media.imagePresignedUrl ?? defaultimageurl,
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
                imageUrl: media.imagePresignedUrl,
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
                errorWidget: (context, url, error) => Center(child: Image.asset(
                  'images/church1.png',
                  fit: BoxFit.cover,
                ),) //Center(child: Icon(Icons.error),),
            ),
          ],
        ),
      ));
    }else if(media.content.isNotEmpty){
      widgets.add(Center(child: Text(media.content,textAlign: TextAlign.center,)));
    }


    return widgets;
  }

  List<Widget> contentWidgets(LorddayInfo lorddayInfo){
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
              onPressed: () {
                //效果同等
//              Navigator.push(context,
//                  MaterialPageRoute(builder: (context) => DonateWidget(), fullscreenDialog: true));
                Navigator.of(context).push(CupertinoPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => AccountWidget()));
              })
        ],
      ),
      // Use a FutureBuilder to display a loading spinner while waiting for the
      // VideoPlayerController to finish initializing.
      body: FutureBuilder<LorddayInfo>(
        future: lorddayInfo,
        builder: (context, snapshot) {
          if (snapshot.hasData) {


            canShowMedias = List<Medias>();
            snapshot.data.medias.forEach((Medias m){
              if(m.sHDURL.isNotEmpty || m.content.isNotEmpty){
                canShowMedias.add(m);
              }
            });

            canPlayMedias = List<Medias>();
            snapshot.data.medias.forEach((Medias m){
              if(m.sDURL.isNotEmpty){
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
    );;
  }
}