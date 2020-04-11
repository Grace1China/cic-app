import 'package:cached_network_image/cached_network_image.dart';
import 'package:church_platform/HomeTabBarWidget.dart';
import 'package:church_platform/net/common/API.dart';
import 'package:church_platform/net/models/Church.dart';
import 'package:church_platform/views/account/AccountWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DonateWidget extends StatefulWidget {
  static final DonateWidgetKey = new GlobalKey<_DonateWidgetState>();
  DonateWidget({Key key}) : super(key: key);
  @override
  _DonateWidgetState createState() => _DonateWidgetState();
}

class _DonateWidgetState extends State<DonateWidget> {
  bool isRefreshLoading = true;
  String errmsg;
  Church church;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  void refresh() async{

    try{
      Church c = await API().getChurch();
      setState(() {
        isRefreshLoading = false;
        church = c;
        errmsg = null;
      });
    }catch(e){
      setState(() {
        isRefreshLoading = false;
        church = null;
        errmsg = e.toString();
      });
    }
  }

  Widget buildContent(BuildContext context){
    if(errmsg != null){
      return Text(errmsg);
//    }else if(church == null){
//      return Container();
    }else{
      return Center(
          child: Column(
            children: <Widget>[
              Spacer(),
              Container(
                width: 300,
                height: 300,
                child: CachedNetworkImage(
                  imageUrl: church != null && church.giving_qrcode != null && church.giving_qrcode.isNotEmpty ? church.giving_qrcode:"",
                  imageBuilder: (context, imageProvider) => Stack(alignment: AlignmentDirectional.center,
                    children: <Widget>[
                      Image(image: imageProvider,
                        fit: BoxFit.cover,),
                    ],),
                  placeholder: (context, url) => Container(
                      decoration:  BoxDecoration(
                        border:  Border.all(width: 1.0, color: Colors.black12),// 边色与边宽度
                        color: Colors.black26,//底色
                        borderRadius: const BorderRadius.all(const Radius.circular(2.0)),
                       ),
                      child: Center(child: CircularProgressIndicator(),),
                    ),
                  errorWidget: (context, url, error) => Container(//灰色边框
                    decoration:  BoxDecoration(
                      border:  Border.all(width: 1.0, color: Colors.black12),// 边色与边宽度
                      color: Colors.black12,//底色
                      borderRadius: const BorderRadius.all(const Radius.circular(2.0)),
                    ),
                  ),
                ),
              ),
//              Image.asset(
//                'images/receive.png',
//                width: 300,
//                height: 300,
//                fit: BoxFit.cover,
//              ),
              Text("请使用微信或者支付宝扫码支付",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              Spacer()
            ],
          )
      );
    }
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('奉献'),
        //centerTitle: true,
        elevation:
        (Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0),

        actions: <Widget>[
          IconButton(icon: Icon(Icons.account_circle),
              onPressed: (){
                HomeTabBarWidget.myTabbedPageKey.currentState.tryShowAccount();
              })
        ],
      ),
      body: buildContent(context),
    );;
  }
}