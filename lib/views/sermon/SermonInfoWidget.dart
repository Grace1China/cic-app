import 'package:church_platform/pdf/PDFViewerWidget.dart';
import 'package:church_platform/vedio/VideofijkplayerWidget.dart';
import 'package:flutter/material.dart';


class SermonInfoWidget extends StatefulWidget {

  String showTitle;
  String vedioUrlStr;
  String pdfUrlStr;

  SermonInfoWidget({Key key,this.showTitle, this.vedioUrlStr, this.pdfUrlStr}) : super(key: key);

  @override
  _SermonInfoWidgetState createState() => _SermonInfoWidgetState();
}

class _SermonInfoWidgetState extends State<SermonInfoWidget> {
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
        title: Text(widget.showTitle),
        elevation:
        (Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0),

      ),
      body: Container(
//        color: Colors.greenAccent,
//        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.width/16*9,
              child:  VideofijkplayerWidget(url: widget.vedioUrlStr,),
            ),

//            Container(
//              padding: const EdgeInsets.all(5),
//              color: Colors.grey,
//              child:  Text("讲道稿",
////              softWrap: true,
//                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//              ),
//            ),
//            widget.pdfUrlStr != null ?
            Expanded(
                child:Container(
//                color: Colors.amberAccent,
//                  child: PDFViewerWidget(url: "http://www.pdf995.com/samples/pdf.pdf"),
                  child: PDFViewerWidget(url: widget.pdfUrlStr),
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