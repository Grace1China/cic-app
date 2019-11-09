import 'package:church_platform/course/Course.dart';
import 'package:church_platform/sunday/Sunday.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:transparent_image/transparent_image.dart';

class CourseItem extends StatelessWidget {
  CourseItem({Course course})
      : course = course,
        super(key: ObjectKey(course));

  final Course course;

  @override
  Widget build(BuildContext context) {
    return
      SingleChildScrollView(
        child:Container(
            color: Colors.yellow[400],
            height: 300,
            margin: EdgeInsets.all(10.0),
//      padding: EdgeInsets.all(5.0),
            child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: 'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
                      //            width: 600,
                      //            height: 240,
                      fit: BoxFit.cover,
                    ),
                    Text(course.name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),maxLines: 2,),
                    Divider(),
                    Container(
                      margin: EdgeInsets.all(10.0),
                      child: Center(
                        child: Row(
                          children: <Widget>[
                            Text("￥5"),
                            Spacer(),
                            Expanded(
                              child:Text("999已售",overflow: TextOverflow.ellipsis,maxLines: 1),
                            ),
                          ],
                        ),
                      ),
                    ),

                  ],
                ),

      )

//        child: GridTile(
//          header: Text(
//            '$course.name',
//            textAlign: TextAlign.center,
//          ),
//          child: FadeInImage.memoryNetwork(
//            placeholder: kTransparentImage,
//            image: 'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
////            width: 600,
////            height: 240,
//            fit: BoxFit.cover,
//          ),
//          footer: Text(
//            '$course.preacher',
//            textAlign: TextAlign.center,
//          ),
//        ),
      ),

    );

  }
}