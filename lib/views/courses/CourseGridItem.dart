import 'package:cached_network_image/cached_network_image.dart';
import 'package:church_platform/net/CourseResponse.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:transparent_image/transparent_image.dart';

class CourseGridItem extends StatelessWidget {
  CourseGridItem({Course course})
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
            margin: EdgeInsets.all(10.0),
//            padding: EdgeInsets.all(10.0),
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(0.0),
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
                      padding: EdgeInsets.all(5),
                      height: 176,
                      child: CachedNetworkImage(
                          imageUrl: course.medias[0].image,
                          imageBuilder: (context, imageProvider) => Stack(alignment: AlignmentDirectional.center,
                            children: <Widget>[
                              Image(image: imageProvider,
                                fit: BoxFit.cover,),
                            ],),
                          placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                          errorWidget: (context, url, error) =>
                              Center(child: Image.asset(
                                'images/church1.png',
                                fit: BoxFit.cover,
                              ),)
//                              Center(child: Icon(Icons.error),),
                      ),
                    ),
                    Text(course.title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),maxLines: 1,),
                    Divider(),
                    Container(
                      margin: EdgeInsets.all(5.0),
                      child: Center(
                        child: Row(
                          children: <Widget>[
                            Text("￥${course.price}"),
                            Spacer(),
                            Expanded(
                              child:Text("999已售",overflow: TextOverflow.ellipsis,maxLines: 1,textAlign: TextAlign.end,),
                            ),
                          ],
                        ),
                      ),
                    ),

                  ],
                ),

              ),
            )

      );

  }
}