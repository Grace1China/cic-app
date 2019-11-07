import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'VideoPlayerScreen.dart';
import 'VideoPlayerWidgetTest.dart';

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}


class _HomeWidgetState extends State<HomeWidget> {
//  Future<Post> post;

  @override
  void initState() {
    super.initState();
//    post = fetchPost();
  }

  @override
  Widget build(BuildContext context) {

    Widget textSection = Container(
      padding: const EdgeInsets.all(5),
      child: Text(
        '凡耶稣基督所吩咐我们的，都教训他们遵守”。 我们的异象是“在基督里建立一个充满活力、不断倍增的社群，使他能为基督拥抱和转变万国的人们去影响他们的城市、他们的国家、乃至全世界”。北京国际基督教教会希望为你提供一个安全的居所，在这里与神建立更亲密关系，与其他同生活在北京的人建立紧密的联系。请继续的了解更多关于这个教会的信息及如何在BICF这个大家庭中一同服侍神。',
        style: TextStyle(fontSize: 14),
        softWrap: true,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('教会'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(0),

        children: [
          Container(
            padding: const EdgeInsets.all(5),
            child: Text(
              'IMS',
//              softWrap: true,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),

          textSection,
          Text("崇拜时间",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Container(
            padding: const EdgeInsets.all(5),
            child: Text(
              '每周日上午11:00',
              softWrap: true,
            ),
          ),
          Text("地点",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
          Container(
            padding: const EdgeInsets.all(5),
            child: Text(
              '21世纪剧院主礼堂',
              softWrap: true,
            ),
          ),
          Text("宣传画",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
//          Image(
//            image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
//          ),
          Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              Center(child: CircularProgressIndicator()),
              Center(
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: 'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
//                  width: 600,
//                  height: 240,
//                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
//          FadeInImage.memoryNetwork(
//            placeholder: kTransparentImage,
//            image: 'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
//          )
//          Image.asset(
//            'images/church1.png',
//            width: 600,
//            height: 240,
//            fit: BoxFit.cover,
//          ),
          Text("宣传视频",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
          VideoPlayerWidgetTest(),
//          RaisedButton(
//            child: Text('播放视频'),
//            onPressed: () {
//              Navigator.push(
//                context,
//                MaterialPageRoute(builder: (context) => VideoPlayerScreen(),),
//              );
//            },
//          ),
        ],
      ),
    );
  }
}
