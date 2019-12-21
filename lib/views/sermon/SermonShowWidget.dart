import 'package:church_platform/net/Sermon.dart';
import 'package:church_platform/pdf/PDFViewerVerticalWidget.dart';
import 'package:church_platform/pdf/PDFViewerWidget.dart';
import 'package:church_platform/vedio/VideofijkplayerWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/foundation.dart';
import 'package:date_format/date_format.dart';

enum SermonType {
  warship,
  mc,
  sermon,
  giving,
}

String getNameFromSermonType(SermonType type){
  switch (type){
    case SermonType.warship:return "敬拜";
    case SermonType.mc:return "主持";
    case SermonType.sermon:return "讲道";
    case SermonType.giving:return "奉献";
    default:
  }
}

class SermonShowWidget extends StatefulWidget {

  SermonType selectedSermonType;
  Sermon sermon;
  List<SermonType> canShowTypes;
  List<VideofijkplayerWidget> players;
  Map<SermonType,VideofijkplayerWidget> playerMap = Map<SermonType,VideofijkplayerWidget>();
//  Map<SermonType,Key> playerKeys = Map<SermonType,Key>();
//  GlobalKey<VideofijkplayerWidgetState> key1 = GlobalKey<VideofijkplayerWidgetState>(debugLabel: "key1");
//  GlobalKey<VideofijkplayerWidgetState> key2 = GlobalKey<VideofijkplayerWidgetState>(debugLabel: "key2");
//  GlobalKey<VideofijkplayerWidgetState> key3 = GlobalKey<VideofijkplayerWidgetState>(debugLabel: "key3");
//  GlobalKey<VideofijkplayerWidgetState> key4 = GlobalKey<VideofijkplayerWidgetState>(debugLabel: "key4");

  SermonShowWidget({Key key,this.sermon, this.selectedSermonType}) : super(key: key){
    canShowTypes = sermon.canShowTypes();
//    playerKeys[SermonType.warship] = key1;
//    playerKeys[SermonType.mc] = key2;
//    playerKeys[SermonType.sermon] = key3;
//    playerKeys[SermonType.giving] = key4;

    players = canShowTypes.map((SermonType type){
//      playerKeys[type] = Key(type.toString());
      playerMap[type] = VideofijkplayerWidget(url: sermon.getUrl(type));
      return playerMap[type];
    }).toList();

  }

  void switchPlayer(SermonType type){

    debugPrint("选择了 ${type.toString()} 类型");

    playerMap.forEach((type,player){
//      if(selectedSermonType != type){
//      key.currentState.pause();
//      }
      player.selfState.pause();
    });

//    playerMap[selectedSermonType].selfState.start();
  }

  @override
  _SermonShowWidgetState createState() => _SermonShowWidgetState();
}

class _SermonShowWidgetState extends State<SermonShowWidget> {

  @override
  void initState() {
    super.initState();
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
        elevation:
        (Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0),

      ),
      body: Container(
//        color: Colors.greenAccent,
//        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Stack(
              children: widget.canShowTypes.map((type){
                return Offstage(
                          offstage: widget.selectedSermonType != type,
                          child: Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.width/16*9,
                            child:  widget.playerMap[type] ),
                      );
                }).toList(),
            ),

            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment:MainAxisAlignment.spaceAround,
                children: <Widget>[

                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: widget.canShowTypes.map((type){
                            return GestureDetector(
                              onTap: (){
                                widget.switchPlayer(type);

                                setState(() {
                                  widget.selectedSermonType = type;
                                });
                              },
                              child: Container(
                                  margin: EdgeInsets.all(1),
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(color: type == widget.selectedSermonType ? Colors.grey:Colors.white,
                                                            border: Border.all(color: Colors.grey,
                                                                width: 0.5), // 边色与边宽度
                                    borderRadius: BorderRadius.circular(2.0), // 圆角度
//                            borderRadius: new BorderRadius.vertical(top: Radius.elliptical(20, 50))
                                  ), // 也可控件一边圆角大小),
                                  child: Text(getNameFromSermonType(type),style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),))
                            );
                          }
                          ).toList(),
                        ),
                        Text(formatDate(DateTime.parse(widget.sermon.date) ,[yyyy,'年',mm,'月',dd,'日'])),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(widget.sermon.title, textAlign: TextAlign.right, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text(("讲员：" + widget.sermon.speaker.toString())),
                      ],
                    ),
                  )
                ],
              ),
            ),

//            widget.pdfUrlStr != null ?
            Expanded(
                child:Container(
//                color: Colors.amberAccent,
//                  child: PDFViewerWidget(url: "http://www.pdf995.com/samples/pdf.pdf"),
                  child: PDFViewerVerticalWidget(url: widget.sermon.pdf),
                )
            )
//           : Expanded(
//                 child: Container(),
//               )
          ],
        ),
      ),);
  }
}