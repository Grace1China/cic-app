import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:church_platform/HomeTabBarWidget.dart';
import 'package:church_platform/net/common/API.dart';
import 'package:church_platform/net/models/Church.dart';
import 'package:church_platform/utils/AlertDialogUrils.dart';
import 'package:church_platform/views/account/AccountWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_pickers/image_pickers.dart';

//TODO: 长按图片保存，扫码支付。
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
  GlobalKey globalImageKey;

  @override
  void initState() {
    super.initState();
    globalImageKey = GlobalKey();
    refresh();
  }

  void refresh() async{

    try{
      setState(() {
        isRefreshLoading = true;
        church = null;
        errmsg = null;
      });
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
              GestureDetector(
                onLongPress: () async{
                  if(church != null && church.giving_qrcode != null && church.giving_qrcode.isNotEmpty){
                    print('开始保存');
//                    String albumName ='Media';
//                    GallerySaver.saveImage(church.giving_qrcode, albumName: albumName).then((bool success) {
//
//                      print('Image is saved' + success.toString());
//                      AlertDialogUtils.show(context,title:"已保存到相册",content:"请使用微信或支付宝[扫一扫]，从相册中选择保存的二维码奉献。");
//
////                      setState(() {
////                        print('Image is saved');
////                        AlertDialogUtils.show(context,title:"已保存到相册",content:"请使用微信或支付宝[扫一扫]，从相册中选择保存的二维码奉献。");
////                      });
//                    });

//                    Future<String> future = ImagePickers.saveImageToGallery("http://i1.sinaimg.cn/ent/d/2008-06-04/U105P28T3D2048907F326DT20080604225106.jpg");
//                    future.then((path){
//                      print("保存图片路径："+ path);
//                      AlertDialogUtils.show(context,title:"已保存到相册",content:"请使用微信或支付宝[扫一扫]，从相册中选择保存的二维码奉献。");
//                    });

                    RenderRepaintBoundary boundary = globalImageKey.currentContext.findRenderObject();
                    ui.Image image = await boundary.toImage(pixelRatio: 3);
                    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
                    Uint8List data = byteData.buffer.asUint8List();

                    String dataImagePath = await ImagePickers.saveByteDataImageToGallery(data,);
                    print("保存图片 = "+ dataImagePath);

                    AlertDialogUtils.show(context,title:"二维码已保存到相册",content:"请使用微信或支付宝[扫一扫]，从相册中选择保存的二维码奉献。");
                  }

                },
                child: RepaintBoundary(
                  key: globalImageKey,
                  child: Container(
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
                ),
              ),
//              Image.asset(
//                'images/receive.png',
//                width: 300,
//                height: 300,
//                fit: BoxFit.cover,
//              ),
              SizedBox(height: 8,),
              Text("请使用微信或者支付宝扫码支付",style: Theme.of(context).textTheme.subhead,),
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