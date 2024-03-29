import 'package:cached_network_image/cached_network_image.dart';
import 'package:church_platform/net/results/Course.dart';
import 'package:church_platform/utils/CPTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CourseStoreItem extends StatelessWidget {
  CourseStoreItem({Course course})
      : course = course,
        super(key: ObjectKey(course));

  final Course course;

  @override
  Widget build(BuildContext context) {
    return
      Container(
//            color: Colors.black12,
            height: 275,
//        decoration: BoxDecoration(border: Border.all()),
          decoration:  BoxDecoration(
            border:  Border.all(width: 1.0, color: Colors.black12),// 边色与边宽度
            color: Colors.black12,//底色
            borderRadius: const BorderRadius.all(const Radius.circular(2.0)),
            //                              boxShadow: [BoxShadow(color: Color(0x99FFFF00), offset: Offset(5.0, 5.0), blurRadius: 10.0, spreadRadius: 2.0), BoxShadow(color: Color(0x9900FF00), offset: Offset(1.0, 1.0)), BoxShadow(color: Color(0xFF0000FF))],
          ),
            margin: EdgeInsets.all(5.0),
//            padding: EdgeInsets.all(10.0),
            child: Container(
              padding: EdgeInsets.all(5.0),
              color: isDarkMode(context) ? Colors.black12 : Colors.white,
              child: Column(
                children: <Widget>[
//                    FadeInImage.memoryNetwork(
//                      placeholder: kTransparentImage,
//                      image: 'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
////                                  width: 300,
//                                  height: 176,
//                      fit: BoxFit.cover,
//                    ),
                  Container(
//                    margin: EdgeInsets.all(5),
//                      padding: EdgeInsets.all(5),
//                      width: 200,
                    height: 170,
                    child: CachedNetworkImage(
                        imageUrl: course.medias[0].image,
                        imageBuilder: (context, imageProvider) => Stack(alignment: AlignmentDirectional.center,
                          children: <Widget>[
                            Image(image: imageProvider,
                              fit: BoxFit.cover,),
                          ],),
                        placeholder: (context, url) =>
//                              Center(child: CircularProgressIndicator(),),
                              Container(
        //                            color: Colors.grey,
                                decoration:  BoxDecoration(
                                  border:  Border.all(width: 1.0, color: Colors.black12),// 边色与边宽度
                                  color: Colors.black26,//底色
                                  borderRadius: const BorderRadius.all(const Radius.circular(2.0)),
        //                              boxShadow: [BoxShadow(color: Color(0x99FFFF00), offset: Offset(5.0, 5.0), blurRadius: 10.0, spreadRadius: 2.0), BoxShadow(color: Color(0x9900FF00), offset: Offset(1.0, 1.0)), BoxShadow(color: Color(0xFF0000FF))],
                                ),
//                                child: Center(child: CircularProgressIndicator(),),
                                child: Center(child: Container(),),
                              ),
                        errorWidget: (context, url, error) =>
                          //灰色边框
                            Container(
//                            color: Colors.grey,
                              decoration:  BoxDecoration(
                                border:  Border.all(width: 1.0, color: Colors.black12),// 边色与边宽度
                                color: Colors.black12,//底色
                                borderRadius: const BorderRadius.all(const Radius.circular(2.0)),
//                              boxShadow: [BoxShadow(color: Color(0x99FFFF00), offset: Offset(5.0, 5.0), blurRadius: 10.0, spreadRadius: 2.0), BoxShadow(color: Color(0x9900FF00), offset: Offset(1.0, 1.0)), BoxShadow(color: Color(0xFF0000FF))],
                              ),
                            ),
                              //默认图
//                              Center(child: Image.asset(
//                                'images/church1.png',
//                                fit: BoxFit.cover,
//                              ),)
                              //error小图
//                              Center(child: Icon(Icons.error),),
                    ),
                  ),
                  Text(course.title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),maxLines: 1,),
                  Divider(),
                  Container(
//                    margin: EdgeInsets.all(5.0),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
//                          Text("￥${course.platformPrice()}"),
                          Text("￥${course.price}"),
                          Expanded(
                            child:Text("${course.sales_num}已售",overflow: TextOverflow.ellipsis,maxLines: 1,textAlign: TextAlign.end,),
                          ),
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            )

      );

  }
}