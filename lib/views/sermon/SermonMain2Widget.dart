import 'package:church_platform/net/API.dart';
import 'package:church_platform/net/Sermon.dart';
import 'package:church_platform/pdf/PDFViewerWidget.dart';
import 'package:church_platform/vedio/VedioPlayerWidget.dart';
import 'package:church_platform/vedio/VedioPlayerNativeWidget.dart';
import 'package:church_platform/vedio/VideofijkplayerWidget.dart';
import 'package:church_platform/views/account/AccountWidget.dart';
import 'package:church_platform/views/sermon/SermonShowWidget.dart';
import 'package:church_platform/views/sunday/Sunday.dart';
import 'package:church_platform/views/sunday/details/SermonDetailsWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:church_platform/vedio/VideofijkplayerWidget.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:cached_network_image/cached_network_image.dart';


void main() {
  runApp(new MaterialApp(home: new SermonMain2Widget()));
}

class SermonMain2Widget extends StatefulWidget {

  SermonMain2Widget({Key key}) : super(key: key);

  @override
  _SermonMain2WidgetState createState() => _SermonMain2WidgetState();
}

class _SermonMain2WidgetState extends State<SermonMain2Widget> {
  Future<Sermon> sermon;


  List<SermonType> canShowTypes;

  @override
  void initState() {
    super.initState();
    sermon = API().getSermon();
  }


  @override
  void dispose() {
    super.dispose();
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
      body: FutureBuilder<Sermon>(
        future: sermon,
        builder: (context, snapshot) {
          if (snapshot.hasData) {

            canShowTypes = snapshot.data.canShowTypes();

            return Container(
//        color: Colors.greenAccent,
//        margin: EdgeInsets.all(10),
              child: SingleChildScrollView(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(5),
                    width:MediaQuery.of(context).size.width,
//                    color: Colors.grey,
                    child:  Text(snapshot.data.title,
                      textAlign: TextAlign.center,
//                              softWrap: true,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),


                  Container(
                    padding: const EdgeInsets.all(5),
//                    color: Colors.grey,
                    child:  Text("敬拜",
                      textAlign: TextAlign.left,
//                              softWrap: true,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),

                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SermonShowWidget(sermon: snapshot.data, selectedSermonType: SermonType.warship,)),
                      );
                    },
                    child: Stack(
                      children: <Widget>[
                        Offstage(
                          offstage: true,
                          child: Container(
                              width: MediaQuery.of(context).size.width*0.8,
                              height: MediaQuery.of(context).size.width*0.8/16*9,
                              child:  VideofijkplayerWidget(url: snapshot.data.getUrl(SermonType.warship))),
                        ),
                        CachedNetworkImage(
                          imageUrl: snapshot.data.cover,
                          imageBuilder: (context, imageProvider) => Stack(alignment: AlignmentDirectional.center,
                            children: <Widget>[
                              Image(image: imageProvider,
                                fit: BoxFit.cover,),
                              Center(child:
                              FloatingActionButton(
                                heroTag: "btn0",
//                            onPressed: () {},
                                child: snapshot.data.worshipvideo != null ? Icon(Icons.play_arrow,) : Icon(Icons.stop,),),
                              ),
                            ],),
                          placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                          errorWidget: (context, url, error) => Center(child: Icon(Icons.error),),
                        ),

                      ],
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.all(5),
//                    color: Colors.grey,
                    child:  Text("主持",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SermonShowWidget(sermon: snapshot.data, selectedSermonType:SermonType.mc, )),
                      );
                    },
                    child: Stack(
                      children: <Widget>[
                        Offstage(
                          offstage: true,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width/16*9,
                            child:  VideofijkplayerWidget(url: snapshot.data.getUrl(SermonType.mc)),),
                        ),
                        CachedNetworkImage(
                          imageUrl: snapshot.data.cover,
                          imageBuilder: (context, imageProvider) => Stack(alignment: AlignmentDirectional.center,
                            children: <Widget>[
                              Image(image: imageProvider,
                                fit: BoxFit.cover,),
                              Center(child:FloatingActionButton(
                                heroTag: "btn1",
//                            onPressed: () {},
                                child: snapshot.data.mcvideo != null ? Icon(Icons.play_arrow,) : Icon(Icons.stop,),
                              ),),
                            ],),
                          placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                          errorWidget: (context, url, error) => Center(child: Icon(Icons.error),),
                        ),

                      ],
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.all(5),
//                    color: Colors.grey,
                    child:  Text("讲道",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),

                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SermonShowWidget(sermon: snapshot.data,selectedSermonType: SermonType.sermon,)),
                      );
                    },
                    child: Stack(
                      children: <Widget>[
                        Offstage(
                          offstage: true,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width/16*9,
                            child:  VideofijkplayerWidget(url: snapshot.data.getUrl(SermonType.giving)),),
                        ),
                        CachedNetworkImage(
                          imageUrl: snapshot.data.cover,
                          imageBuilder: (context, imageProvider) => Stack(alignment: AlignmentDirectional.center,
                            children: <Widget>[
                              Image(image: imageProvider,
                                fit: BoxFit.cover,),
                              Center(child:FloatingActionButton(
                                heroTag: "btn2",
//                            onPressed: () {},
                                child: snapshot.data.sermonvideo != null ? Icon(Icons.play_arrow,) : Icon(Icons.stop,),
                              ),),
                            ],),
                          placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                          errorWidget: (context, url, error) => Center(child: Icon(Icons.error),),
                        ),
                      ],
                    ),
                  ),



//                   Image.network(
//                         snapshot.data.cover,
//                          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
//                                       if (loadingProgress == null)
//                                         return child;
//
//                                       return Center(
//                                         child: CircularProgressIndicator(
//                                           value: loadingProgress.expectedTotalBytes != null
//                                               ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
//                                               : null,
//                                         ),
//                                       );
//                                     },
//                       ),


                  Container(
                    padding: const EdgeInsets.all(5),
//                    color: Colors.grey,
                    child:  Text("奉献",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SermonShowWidget(sermon: snapshot.data, selectedSermonType: SermonType.giving, )),
                      );
                    },
                    child: Stack(
                      children: <Widget>[
                        Offstage(
                          offstage: true,
                          child: Container(
                            width: MediaQuery.of(context).size.width*0.8,
                            height: MediaQuery.of(context).size.width*0.8/16*9,
                            child:  VideofijkplayerWidget(url: snapshot.data.getUrl(SermonType.mc)),),
                        ),
                        CachedNetworkImage(
                          imageUrl: snapshot.data.cover,
                          imageBuilder: (context, imageProvider) => Stack(alignment: AlignmentDirectional.center,
                            children: <Widget>[
                              Image(image: imageProvider,
                                fit: BoxFit.cover,),
                              Center(child:FloatingActionButton(
                                heroTag: "btn3",
//                            onPressed: () {},
                                child: snapshot.data.givingvideo != null ? Icon(Icons.play_arrow,) : Icon(Icons.stop,),
                              ),),
                            ],),
                          placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                          errorWidget: (context, url, error) => Center(child: Icon(Icons.error),),
                        ),
                      ],
                    ),
                  ),

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
                ],
              ),
              ),
            ) ;
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