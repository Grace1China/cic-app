import 'package:church_platform/views/account/AccountWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DonateWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('奉献'),
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
          child: Column(
            children: <Widget>[
              Spacer(),
              Image.asset(
              'images/receive.png',
              width: 300,
              height: 300,
              fit: BoxFit.cover,
              ),
              Text("请使用微信或者支付宝扫码支付",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              Spacer()
            ],
          )
      ),
    );
  }
}