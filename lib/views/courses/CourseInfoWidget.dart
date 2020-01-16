import 'package:cached_network_image/cached_network_image.dart';
import 'package:church_platform/net/CourseResponse.dart';
import 'package:church_platform/vedio/VedioPlayerWidget.dart';
import 'package:church_platform/vedio/VideofijkplayerWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';


class CourseInfoWidget extends StatefulWidget {
  Course course;
  CourseInfoWidget({Key key, this.course}) : super(key: key);

  @override
  _CourseInfoWidgetState createState() => _CourseInfoWidgetState();
}

class _CourseInfoWidgetState extends State<CourseInfoWidget> {

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
        title: Text(widget.course.title),
        //centerTitle: true,
        elevation:
        (Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0),
      ),
      // Use a FutureBuilder to display a loading spinner while waiting for the
      // VideoPlayerController to finish initializing.
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
//          VedioPlayerWidget(url:widget.course.video),
//          VedioPlayerWidget(url:widget.course.medias[0].hDURL),
//          Container(
//              width: double.infinity,
//              height: MediaQuery.of(context).size.width/16*9,
//              child:  VideofijkplayerWidget(url: widget.course.medias[0].hDURL)),
            Stack(alignment: AlignmentDirectional.center,
              children: <Widget>[
//              Offstage(
//                offstage: true,
//                child: Container(
//                    width: MediaQuery.of(context).size.width*0.8,
//                    height: MediaQuery.of(context).size.width*0.8/16*9,
//                    child: VideofijkplayerWidget(url: widget.course.medias[0].hDURL)),
//              ),
                CachedNetworkImage(
                    imageUrl: widget.course.medias[0].image ?? 'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
                    imageBuilder: (context, imageProvider) => Stack(alignment: AlignmentDirectional.center,
                      children: <Widget>[
                        Image(image: imageProvider,
                          fit: BoxFit.cover,),

                      ],),
                    placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                    errorWidget: (context, url, error) => Center(child: Image.asset(
                      'images/church1.png',
                      fit: BoxFit.cover,
                    ),) //Center(child: Icon(Icons.error),),
                ),
//              Center(child:
//              FloatingActionButton(
//                heroTag: "btn${widget.course.id}",
////                            onPressed: () {},
//                child:  Icon(Icons.play_arrow,),),
//              ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(5),
              child: Text(
                widget.course.title,
//              softWrap: true,
                style: TextStyle(fontSize: 20),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(5),
              child: Text(
                "￥" + widget.course.price,
//              softWrap: true,
                style: TextStyle(fontSize: 18,color: Colors.red),
              ),
            ),
            Offstage(
              offstage: widget.course.medias[0].hDURL == null || widget.course.medias[0].hDURL.isEmpty,
              child: Container(
                  width: MediaQuery.of(context).size.width*0.8,
                  height: MediaQuery.of(context).size.width*0.8/16*9,
                  child: VideofijkplayerWidget(url: widget.course.medias[0].hDURL)),
            ),
            widget.course.content != null ? Html(data: """<div name='例题5'>
          <h5>例题5-列表做调查问卷</h5>
          <div>
              <ol>
                  <li>你喜欢的cp是哪一个？
                      <ol start='1' type='A'>
                          <li>南硕</li>
                          <li>糖锡</li>
                          <li>国旻</li>
                          <li>珍锡</li>
                      </ol>
                  </li>
                  <li>为什么喜欢这个cp？
                      <ol start='2' type='A'>
                              <li>长得好</li>
                              <li>比较真</li>
                              <li>太无聊</li>
                              <li>没理由</li>
                      </ol>
                  </li>
              </ol>
          </div>""") : Container(),
            Container(
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                  onPressed: () {

                  },
                  child: Text('去支付',
                      style: TextStyle(
                          color: Colors.white)),
                  color: Theme.of(context).buttonColor
              ),
//              margin: new EdgeInsets.only(
//                  top: 20.0
//              ),
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );;
  }
}