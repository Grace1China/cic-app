
import 'package:church_platform/net/results/Sermon.dart';
import 'package:church_platform/net/models/Medias.dart';
import 'package:church_platform/pdf/PDFViewerVerticalWidget.dart';
import 'package:church_platform/video/VideoPlayerManager.dart';
import 'package:church_platform/video/VideofijkplayerWidget.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';



class LorddayDetailsPlayerWidget extends StatefulWidget {

  Sermon lorddayInfo;
  int selectedIndex;
  List<Medias> medias;

//  PDFViewerVerticalWidget pdfWidget;

  LorddayDetailsPlayerWidget({Key key,this.lorddayInfo,this.medias, this.selectedIndex,}) : super(key: key){

//    pdfWidget = PDFViewerVerticalWidget(url:media.pdf);

//    players = canShowTypes.map((SermonType type){
////      playerKeys[type] = Key(type.toString());
//      playerMap[type] = VideofijkplayerWidget(url: sermon.getUrl(type));
//      return playerMap[type];
//    }).toList();

  }

  void switchPlayer(MediaType type){

    debugPrint("选择了 ${type.toString()} 类型");

    VideoPlayerManager().getAllPlayer().forEach((type,player){
      player.pause();
    });
  }

  @override
  _LorddayDetailsPlayerWidgetState createState() => _LorddayDetailsPlayerWidgetState();
}

class _LorddayDetailsPlayerWidgetState extends State<LorddayDetailsPlayerWidget> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

//  Widget pdfWidget(BuildContext context) {
//    if(MediaQuery.of(context).orientation == Orientation.portrait)
//    {
//      return widget.pdfWidget;
//    }
//    else {
//      return Container();
//    }
//  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("主日"),
        elevation:
        (Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0),

      ),
      body: widget.lorddayInfo == null? Center(child: CircularProgressIndicator(),): Container(
//        color: Colors.greenAccent,
//        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Stack(
              children: widget.medias.map((media){
                return Offstage(
                  offstage: widget.selectedIndex != widget.medias.indexOf(media),
                  child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.width/16*9,
                      child:  VideofijkplayerWidget(url: media.hDURL)),
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
                          children: widget.medias.map((media){
                            return GestureDetector(
                                onTap: (){
                                  widget.switchPlayer(MediaTypeFromInt(media.kind));

                                  setState(() {
                                    widget.selectedIndex = widget.medias.indexOf(media);
                                  });
                                },
                                child: Container(
                                    margin: EdgeInsets.all(1),
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(color: widget.selectedIndex == widget.medias.indexOf(media) ? Colors.grey:Colors.white,
                                      border: Border.all(color: Colors.grey,
                                          width: 0.5), // 边色与边宽度
                                      borderRadius: BorderRadius.circular(2.0), // 圆角度
//                            borderRadius: new BorderRadius.vertical(top: Radius.elliptical(20, 50))
                                    ), // 也可控件一边圆角大小),
                                    child: Text(MediaTypeToName(MediaTypeFromInt(media.kind)),style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),))
                            );
                          }
                          ).toList(),
                        ),
                        Text(widget.lorddayInfo.formatPubtime()),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(widget.lorddayInfo.title, textAlign: TextAlign.right, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text(("讲员：" + widget.lorddayInfo.speaker.name)),
                      ],
                    ),
                  )
                ],
              ),
            ),

            (widget.medias[widget.selectedIndex].pdf.isNotEmpty &&
            MediaQuery.of(context).orientation == Orientation.portrait) ?
            Expanded(
                child:
                Container(
//                color: Colors.amberAccent,
//                  child: PDFViewerVerticalWidget(url: "http://www.pdf995.com/samples/pdf.pdf"),
//                  child: PDFViewerWidget(url:widget.sermon.pdf),
//                  child: widget.pdfWidget,
                  child: PDFViewerVerticalWidget(url: widget.medias[widget.selectedIndex].pdf,),
                )
            ):Container()

          ],
        ),
      ),);
  }
}