import 'dart:async';

import 'package:church_platform/HomeTabBarWidget.dart';
import 'package:church_platform/demo/SearchDemo.dart';
import 'package:church_platform/main.dart';
import 'package:church_platform/views/common/AsperctRaioImage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: LaunchAdvertisementWidget()));

class LaunchAdvertisementWidget extends StatefulWidget {
  LaunchAdvertisementWidget({Key key}) : super(key: key){
  }
  @override
  _LaunchAdvertisementWidgetState createState() => _LaunchAdvertisementWidgetState();
}

class _LaunchAdvertisementWidgetState extends State<LaunchAdvertisementWidget> {

  List<LauncModel> models = [
    LauncModel(bgColor:Color.fromRGBO(244,187,127,1),imageWidth:224,imageHeight:182, bgImage:"images/1b.png",centerImage: "images/1t.png",logoImage: "images/imslogo.png",title: "异象",subTitle:"成为当代华语教会复兴运动的灯台" ),
    LauncModel(bgColor:Color.fromRGBO(174,195,170,1),imageWidth:290,imageHeight:206, bgImage:"images/2b.png",centerImage: "images/2t.png",logoImage: "images/imslogo.png",title: "植堂",subTitle:"建立本地教会" ),
    LauncModel(bgColor:Color.fromRGBO(255,113,97,1),imageWidth:286,imageHeight:200, bgImage:"images/3b.png",centerImage: "images/3t.png",logoImage: "images/imslogo.png",title: "中央厨房",subTitle:"装备本地交会，复制健康教会模式" ),];

//  List<Widget> images = List<Widget>();
  @override
  void initState() {
    super.initState();
//    for(int i = 0; i< models.length; i ++){
//      images.add(Image.asset(
//        models[i].bgImage,
//        width: double.infinity,
//        height: double.infinity,
//        fit: BoxFit.fill,
//      ));
//    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget buildItem(BuildContext context,LauncModel model){
    int index = models.indexOf(model);
    return Stack(
//      fit: StackFit.expand,
      children: <Widget>[
        Container(
          width: double.infinity,
          height: double.infinity,
          color: models[index].bgColor,),
        Image.asset(
          model.bgImage,
          width: MediaQuery.of(context).size.width,//double.infinity,
          height: MediaQuery.of(context).size.height,//double.infinity,
          fit: BoxFit.fill,
        ),
//      Align(alignment: Alignment(0,-0.2),
////        child: FractionallySizedBox(
////          alignment: Alignment.bottomCenter,
////          widthFactor: 0.55,
//////          heightFactor: 1,
////          child: Image.asset(
////            model.centerImage,
////            fit: BoxFit.fill,
////          ),
////        ),
////        child: Container(
//////            padding: EdgeInsets.all(0),
//////            color: Colors.blueAccent,
////            width: 224,
////            height: 182,
////            child: Image.asset(
////              model.centerImage,
////              fit: BoxFit.fill,
////            ),
////          ),
//            child: AsperctRaioImage.asset(
//              model.centerImage,
//              builder: (context, snapshot, url) {
//                return
//                  Container(
//                    width: snapshot.data.width.toDouble() / 3,
//                    height: snapshot.data.height.toDouble() / 3,
//                    decoration: BoxDecoration(
//                      image: DecorationImage(
//                          image: AssetImage(url), fit: BoxFit.cover),
//                    ),
//                  );
//              },
//            )
//
//      ),
//
////      Align(alignment: Alignment(0,1),
////        child: Center(
////          child: AsperctRaioImage.asset(
////            model.centerImage,
////            builder: (context, snapshot, url) {
////              return
////                  Container(
////                    width: snapshot.data.width.toDouble() / 5,
////                    height: snapshot.data.height.toDouble() / 5,
////                    decoration: BoxDecoration(
////                      image: DecorationImage(
////                          image: AssetImage(url), fit: BoxFit.cover),
////                    ),
////                  );
////            },
////          ),
////        ),),
      Align(alignment: Alignment(0,0.5),
          child:Container(
//            color: Colors.blueAccent,
            width: MediaQuery.of(context).size.width,
            height: 520,
            child: Column(children: <Widget>[
//              AsperctRaioImage.asset(
//                model.centerImage,
//                builder: (context, snapshot, url) {
//                  return
//                    Container(
//                      width: snapshot.data.width.toDouble() / 3,
//                      height: snapshot.data.height.toDouble() / 3,
//                      decoration: BoxDecoration(
//                        image: DecorationImage(
//                            image: AssetImage(url), fit: BoxFit.cover),
//                      ),
//                    );
//                },
//              ),
              Image.asset(
                model.centerImage,
//                width: model.imageWidth,
//                height: model.imageHeight,
                width: 235,//285,
                height: 182,//200,
                fit: BoxFit.fill,
              ),
              SizedBox(height: 80,),
              Text(model.title,style: TextStyle(color:Colors.white,fontSize:26,fontWeight: FontWeight.bold),),
              SizedBox(height: 8,),
              Text(model.subTitle,style: TextStyle(color:Colors.white,fontSize:17),),
              SizedBox(height: 40,),
              AsperctRaioImage.asset(
                model.logoImage,
                builder: (context, snapshot, url) {
                  return  Container(
                    width: snapshot.data.width.toDouble() / 3,
                    height: snapshot.data.height.toDouble() / 3,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(url), fit: BoxFit.cover),
                    ),
                  );
                },
              ),
              SizedBox(height: 5,),
              Container(
//                  color: Colors.blueAccent,
                width: 100,
                height: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      width: 24,
                      height: 3,
                      child: Image.asset(
                        index == 0 ? "images/bar_selected.png" : "images/bar_normal.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                    Container(
                      width: 24,
                      height: 3,
                      child: Image.asset(
                        index == 1 ? "images/bar_selected.png" : "images/bar_normal.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                    Container(
                      width: 24,
                      height: 3,
                      child: Image.asset(
                        index == 2 ? "images/bar_selected.png" : "images/bar_normal.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                  ],),
              ),
              SizedBox(height: 40,),
              index == 2 ? Container(
//                padding:EdgeInsets.all(5) ,
                height: 34,
                decoration:  BoxDecoration(
                  border:  Border.all(width: 1.0, color: Colors.white),// 边色与边宽度
//                  color: Colors.black26,//底色
                  borderRadius: const BorderRadius.all(const Radius.circular(5.0)),
                ),
                child: FlatButton(onPressed: (){
                  Navigator.pushNamedAndRemoveUntil(context, RouteNames.HOME, (route) => false);
                },child: Text("立即体验",style: TextStyle(fontSize:15,color: Colors.white),),),
              ) : Container(),
            ],),
          ),
        ),

    ],);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
//        scrollDirection: Axis.vertical,
        children:models.map((m) => buildItem(context, m)).toList(),
        onPageChanged: (int index){
        },
      ),
    );
  }
}

class LauncModel{
  Color bgColor; //解决加载图片慢的问题。
  double imageWidth;  //解决加载图片慢的问题。
  double imageHeight;
  String bgImage;
  String centerImage;
  String logoImage;
  String title;
  String subTitle;

  LauncModel(
      {this.bgColor,
        this.imageWidth,
        this.imageHeight,
        this.bgImage,
        this.centerImage,
        this.logoImage,
        this.title,
        this.subTitle});
}