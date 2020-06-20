import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class LanuchAdvertisementWidget extends StatefulWidget {
  LanuchAdvertisementWidget({Key key}) : super(key: key){
  }
  @override
  _LanuchAdvertisementWidgetState createState() => _LanuchAdvertisementWidgetState();
}

class _LanuchAdvertisementWidgetState extends State<LanuchAdvertisementWidget> {

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
    return Scaffold(
      body: PageView(
//        scrollDirection: Axis.vertical,
        children: <Widget>[
          Image.asset(
            'images/1 b.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.fill,
          ),
          Image.asset(
            'images/2 b.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.fill,
          ),
          Image.asset(
            'images/3 b.pngg',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.fill,
          ),
        ],
        onPageChanged: (int index){
        },
      ),
    );
  }
}