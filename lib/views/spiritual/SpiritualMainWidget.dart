import 'package:church_platform/audio/AudioPlayerWidget.dart';
import 'package:church_platform/views/account/AccountWidget.dart';
import 'package:church_platform/views/spiritual/SpiritualDetailsWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';


class SpiritualMainWidget extends StatefulWidget {
  @override
  _SpiritualMainWidgetState createState() => _SpiritualMainWidgetState();
}


class _SpiritualMainWidgetState extends State<SpiritualMainWidget> {

  @override
  void initState() {
    super.initState();
//    post = fetchPost();
  }
  

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('L3'),
        elevation:
        (Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.account_circle),
              onPressed: (){
                Navigator.of(context).push(
                    CupertinoPageRoute(
                        fullscreenDialog: true,
                        builder: (context) => AccountWidget()
                    )
                );
              })
        ],
      ),
      body: Center(
//        width: MediaQuery.of(context).size.width,
        child: RaisedButton(
            onPressed: () {
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) => new SpiritualDetailsWidget(),
                ),
              );
            },
            child: Text('去灵修',
                style: new TextStyle(
                    color: Colors.white)),
            color: Theme.of(context).accentColor
        ),

      ),

    );
  }
}
