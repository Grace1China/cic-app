import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:church_platform/net/API.dart';
import 'package:church_platform/net/CourseResponse.dart';
import 'package:church_platform/utils/AlertDialogUrils.dart';
import 'package:church_platform/utils/IAPUnCompletePurchaseStore.dart';
import 'package:church_platform/utils/IAPUtils.dart';
import 'package:church_platform/utils/LoggerUtils.dart';
import 'package:church_platform/utils/SharedPreferencesUtils.dart';
import 'package:church_platform/views/account/LoginWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter/foundation.dart';

import 'dart:async';
import 'dart:io';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

const String coursejson = """{
    "id": 59,
    "church": {
        "id": 3,
        "name": "L3",
        "code": "L3",
        "venue": [],
        "description": "L3平台",
        "promot_cover": "https://s3.ap-northeast-1.amazonaws.com/video-transcoding-061-source-9bbsedar323y/media/private/l3eweekly_7OoGDK5.png?AWSAccessKeyId=AKIA5YH7P4SOQO6ZMJHM&Signature=5ePNj4ML63H54B5ZDFGmqcntfXw%3D&Expires=1582107293",
        "promot_video": null
    },
    "speaker": {
        "id": 7,
        "name": "BILL HAB",
        "title": "Pastor",
        "introduction": "Willow",
        "create_time": "2020-01-20T19:51:21.093783+08:00",
        "update_time": "2020-01-20T19:51:21.093783+08:00",
        "churchs": [
            3
        ]
    },
    "title": "L3/BillHybels-Disc1_Title2.mp4",
    "description": "",
    "content": "",
    "price": "0.00",
    "iap_charge": {
        "product_id": "com.silverlinings.ios.NobelPrize.c.1",
        "price_code": "Alternate Tier A",
        "desc": "12元课程",
        "price": "1.00"
    },
    "medias": [
        {
            "kind": 3,
            "title": "",
            "video": "L3/BillHybels-Disc1_Title2.mp4",
            "video_status": 1,
            "SHD_URL": "http://bicf-media-destination.oss-cn-beijing.aliyuncs.com/L3%2Fmp4-hd%2FBillHybels-Disc1_Title2.mp4?OSSAccessKeyId=LTAI4Fd1JMHM3WSUN4vrHcj8&Expires=1582190093&Signature=NTHNQteW%2BeC6AkTAlb0wxKxQumE%3D",
            "HD_URL": "http://bicf-media-destination.oss-cn-beijing.aliyuncs.com/L3%2Fmp4-sd%2FBillHybels-Disc1_Title2.mp4?OSSAccessKeyId=LTAI4Fd1JMHM3WSUN4vrHcj8&Expires=1582190093&Signature=P6Qb4CEHjkO9AvW1V%2BsIv01PMk0%3D",
            "SD_URL": "http://bicf-media-destination.oss-cn-beijing.aliyuncs.com/L3%2Fmp4-ld%2FBillHybels-Disc1_Title2.mp4?OSSAccessKeyId=LTAI4Fd1JMHM3WSUN4vrHcj8&Expires=1582190093&Signature=0nGnJz4y8h%2Bvm0Hc4euHkVyl0o4%3D",
            "audio": "",
            "image": "http://bicf-media-destination.oss-cn-beijing.aliyuncs.com/L3/BillHybels-Disc1_Title2.jpg",
            "pdf": "",
            "content": ""
        }
    ],
    "create_time": "2020-01-20T19:55:16.947458+08:00",
    "update_time": "2020-01-20T19:55:16.947458+08:00"
}""";

const bool kAutoConsume = true;
const String ConsumableId = 'com.silverlinings.ios.NobelPrize.c.12';
////const String _kConsumableId = 'com.churchplatform.churchplatform.iap.c.tier2';


void main() {
  // For play billing library 2.0 on Android, it is mandatory to call
  // [enablePendingPurchases](https://developer.android.com/reference/com/android/billingclient/api/BillingClient.Builder.html#enablependingpurchases)
  // as part of initializing the app.
  InAppPurchaseConnection.enablePendingPurchases();

 var c = Course.fromJson(json.decode(coursejson));
  runApp(MaterialApp(
    title: 'IAP Demo',
    themeMode: ThemeMode.light,
    home: CourseDetailsWidget(course: c),
  ));
}

class CourseDetailsWidget extends StatefulWidget {
  Course course;
  CourseDetailsWidget({Key key, this.course}) : super(key: key);

  @override
  _CourseDetailsWidgetState createState() => _CourseDetailsWidgetState();
}

class _CourseDetailsWidgetState extends State<CourseDetailsWidget> {
  String order_no;
  String _kConsumableId = ConsumableId; //当前产品的id
  bool _isPurchased = false; //是否已购买

  //苹果内购相关。
  final InAppPurchaseConnection _connection = InAppPurchaseConnection.instance;
  StreamSubscription<List<PurchaseDetails>> _subscription;
  ProductDetails _product; //查到的产品
  bool _loading = false;

  @override
  void initState() {

    _kConsumableId = widget.course.iapCharge.productId;

    _listenToPurchaseStart();
    
    _initStoreInfo();

    super.initState();
  }

  Future<void> _initStoreInfo() async {

    //查询产品
    bool isAvailable = await _connection.isAvailable();
    Log.i("Log.i连接是否可用： isAvailable = ${isAvailable == true}");
    if (!isAvailable) {
      return;
    }

    ProductDetailsResponse productDetailResponse = await _connection.queryProductDetails([_kConsumableId].toSet());
    if (productDetailResponse.error != null) {
      Log.i("查询产品错误：" + productDetailResponse.error.message);
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      Log.i("未查询到产品：${_kConsumableId.toString()}");
      return;
    }

    productDetailResponse.productDetails.forEach((p){
      Log.i("查询到产品：${p.id} ${p.title}");
    });
    setState(() {
      _product = productDetailResponse.productDetails.first;
      _loading = false;
    });

    //重新进行上一次未完成的充值。
    Map<String,Map<String,String>> unComplete = await IAPUnCompletePurchaseStore.loadMap();
    if(unComplete.length > 0){

      //同步编程失败。现在用户每次只能进行一个未完成的购买。
      for (var entry in unComplete.entries) {
//2      await Future.forEach(unComplete.entries, (MapEntry entry) async {
        String key = entry.key;
        Map<String,String> courseMap = entry.value;

//      unComplete.forEach((key,courseMap) async {
        if(Platform.isIOS){
          String purchaseid = key.replaceAll(IAPUnCompletePurchaseStore.PREFIX,"");
          int lastCourseID = int.parse(courseMap["courseid"]);
          String lastCourseName = courseMap["coursename"];
          String lastCoursePrice = courseMap["courseprice"];

          AlertDialogUtils.show(context,
              title:"你有一笔交易还未完成",
              content:"花费${lastCoursePrice}元，购买课程${lastCourseName}。若已经扣款，则不会重复扣款。",
              canCancel:false,
              okTitle:"继续",
              okHandler: () async {

            bool valid = await _verifyPurchaseLast(lastCourseID);
            if(valid){
              IAPUnCompletePurchaseStore.remove(purchaseid);
              Log.i("购买成功");
              hideLoading();
              AlertDialogUtils.show(context, title:"提示", content:"购买成功");
              await InAppPurchaseConnection.instance.completePurchaseWithID(purchaseid);
              if(widget.course.id == lastCourseID){
                setState(() {
                  _isPurchased = true;
                });
              }
            } else {
              Log.i("购买验证不合法：" + purchaseid);
              hideLoading();
              AlertDialogUtils.show(context, title:"提示", content:"购买验证失败，请重试。");
            }
          });
          return; //只进行一条购买就返回。
        }
      }
    }
  }

  void tapPurchase() async{
    //有产品才会可点击。
    try{
      if(!await SharedPreferencesUtils.isLogin()){
        Navigator.push(context, CupertinoPageRoute(
            fullscreenDialog: true,
            builder: (context) => LoginWidget()
        ));
        return;
      }

      showLoading();
      order_no = await API().createOrder(widget.course.id);
      PurchaseParam purchaseParam = PurchaseParam( productDetails: _product,applicationUserName: null,sandboxTesting: true);
      _connection.buyConsumable(purchaseParam: purchaseParam,autoConsume: kAutoConsume || Platform.isIOS);
    }catch(e){
      hideLoading();
      AlertDialogUtils.show(context, title:"提示", content:e.toString());
    }
  }

  void showLoading() {
    setState(() {
      _loading = true;
    });
  }

  void hideLoading(){
    setState(() {
      _loading = false;
    });
  }

  //验证凭证
  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    if(Platform.isIOS){
      try{
        showLoading();
        if(order_no == null){
          order_no = await API().createOrder(widget.course.id);
        }
        //此处会输入密码，显示支付完成。--- 操作完成。----等待很长时间。
        PurchaseVerificationData receiptData = await InAppPurchaseConnection.instance.refreshPurchaseVerificationData();
        Log.i("待验证数据" + receiptData.localVerificationData);

        bool valid = await API().iapVerify(receiptData.localVerificationData,order_no);
        return Future<bool>.value(valid);
      }catch(e){
        return Future<bool>.value(false);
      }
    }
  }

  Future<bool> _verifyPurchaseLast(int lastCourseID) async {
    if(Platform.isIOS){
      try{
        showLoading();
        String order_no = await API().createOrder(lastCourseID);
        PurchaseVerificationData receiptData = await InAppPurchaseConnection.instance.refreshPurchaseVerificationData();
        bool valid = await API().iapVerify(receiptData.localVerificationData,order_no);
        return Future<bool>.value(valid);
      }catch(e){
        return Future<bool>.value(false);
      }
    }
  }

  //成功失败监听
  void _purchaseError(IAPError error,PurchaseDetails purchaseDetails) async{
//    await ConsumableStore.save(purchaseDetails.purchaseID);
    Log.i("购买错误：errpr: ${error}, " + (purchaseDetails != null ? IAPUtils.description(purchaseDetails) : ""));
    hideLoading();
    AlertDialogUtils.show(context, title:"提示", content:"购买失败，请重试。${error.details}");
  }

  void _purchaseInvalid(PurchaseDetails purchaseDetails) async{
//    await ConsumableStore.save(purchaseDetails.purchaseID);
    Log.i("购买验证不合法：" + (purchaseDetails != null ? IAPUtils.description(purchaseDetails) : ""));
    hideLoading();
    AlertDialogUtils.show(context, title:"提示", content:"购买验证失败，请重试。");
  }

  void _purchaseSuccess(PurchaseDetails purchaseDetails) async {
//    await ConsumableStore.remove(purchaseDetails.purchaseID);
    Log.i("购买成功：" + (purchaseDetails != null ? IAPUtils.description(purchaseDetails) : ""));
    hideLoading();
    AlertDialogUtils.show(context, title:"提示", content:"购买成功");
    setState(() {
      _isPurchased = true;
    });
    _finishPurchase(purchaseDetails);
  }

  void _finishPurchase(PurchaseDetails purchaseDetails) async{
    if (Platform.isAndroid) {
      if (!kAutoConsume && purchaseDetails.productID == _kConsumableId) {
        await InAppPurchaseConnection.instance.consumePurchase(purchaseDetails);
      }
    }
    if (purchaseDetails.pendingCompletePurchase) {
      await InAppPurchaseConnection.instance.completePurchase(purchaseDetails);
    }
  }

  //监听逻辑
  void _listenToPurchaseStart(){
    //购买payment状况的监听
    Stream purchaseUpdated = InAppPurchaseConnection.instance.purchaseUpdatedStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {

//      Log.i("------购买监听-----个数${purchaseDetailsList.length.toString()}");
      _listenToPurchaseUpdated(purchaseDetailsList);

    }, onDone: () {

      Log.i("------购买完成-----: done");
//      _subscription.cancel();
      hideLoading();
      //TODO:_purchaseSuccess();???
    }, onError: (error) {

      Log.i("------购买错误-----:" + error.toString());
      _purchaseError(error, null);
    });
  }
  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      Log.i("购买监听：${IAPUtils.description(purchaseDetails)}");

      switch (purchaseDetails.status){
        case PurchaseStatus.pending:
//          showLoading();
          break;
        case PurchaseStatus.error:
          _purchaseError(purchaseDetails.error,purchaseDetails);
          break;
        case PurchaseStatus.purchased:
          IAPUnCompletePurchaseStore.save(purchaseDetails.purchaseID, widget.course.id.toString(), widget.course.title, _product.price);

          bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            IAPUnCompletePurchaseStore.remove(purchaseDetails.purchaseID);
            _purchaseSuccess(purchaseDetails);
          } else {
            _purchaseInvalid(purchaseDetails);
          }
          break;
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      appBar: AppBar(
        title: Text(widget.course.title),
        //centerTitle: true,
        elevation:
        (Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0),
      ),
      // Use a FutureBuilder to display a loading spinner while waiting for the
      // VideoPlayerController to finish initializing.
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        // demo of some additional parameters
        opacity: 0.5,
        progressIndicator: CircularProgressIndicator(),

        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
//          VedioPlayerWidget(url:widget.course.video),
//          VedioPlayerWidget(url:widget.course.medias[0].hDURL),
            Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.width,
                decoration:  BoxDecoration(
                  border:  Border.all(width: 1.0, color: Colors.black12),// 边色与边宽度
//                color: Colors.black26,//底色
                  borderRadius: const BorderRadius.all(const Radius.circular(2.0)),
                  // boxShadow: [BoxShadow(color: Color(0x99FFFF00), offset: Offset(5.0, 5.0), blurRadius: 10.0, spreadRadius: 2.0), BoxShadow(color: Color(0x9900FF00), offset: Offset(1.0, 1.0)), BoxShadow(color: Color(0xFF0000FF))],
                ),
                child:
//              VideofijkplayerWidget(url: widget.course.medias[0].hDURL)),
              Stack(alignment: AlignmentDirectional.center,
                children: <Widget>[
//              Offstage(
//                offstage: true,
//                child: Container(
//                    width: MediaQuery.of(context).size.width*0.8,
//                    height: MediaQuery.of(context).size.width*0.8/16*9,
//                    child: VideofijkplayerWidget(url: widget.course.medias[0].hDURL)),
//              ),
                  CachedNetworkImage(
                      imageUrl: widget.course.medias[0].image,
                      imageBuilder: (context, imageProvider) => Stack(alignment: AlignmentDirectional.center,
                        children: <Widget>[
                          Image(image: imageProvider,
                            fit: BoxFit.cover,),

                        ],),
                      placeholder: (context, url) =>
                          Container(
                            //color: Colors.grey,
                            decoration:  BoxDecoration(
                              border:  Border.all(width: 2.0, color: Colors.black12),// 边色与边宽度
                              color: Colors.black26,//底色
                              borderRadius: const BorderRadius.all(const Radius.circular(2.0)),
                              // boxShadow: [BoxShadow(color: Color(0x99FFFF00), offset: Offset(5.0, 5.0), blurRadius: 10.0, spreadRadius: 2.0), BoxShadow(color: Color(0x9900FF00), offset: Offset(1.0, 1.0)), BoxShadow(color: Color(0xFF0000FF))],
                            ),
                            child:
                              Center(child: CircularProgressIndicator(),
//                              Center(child: Container(),
                              ),
                          ),
                      errorWidget: (context, url, error) =>
                      //灰色边框
                        Container(
                          decoration:  BoxDecoration(
                            border:  Border.all(width: 1.0, color: Colors.black12),// 边色与边宽度
                            color: Colors.black12,//底色
                            borderRadius: const BorderRadius.all(const Radius.circular(2.0)),
                          ),
                        ),

                  ),
//              Center(child:
//              FloatingActionButton(
//                heroTag: "btn${widget.course.id}",
////                            onPressed: () {},
//                child:  Icon(Icons.play_arrow,),),
//              ),
                ],
              ),
            ),
              Container(
                padding: const EdgeInsets.all(5),
                child: Text(
                  widget.course.title,
//              softWrap: true,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(5),
                child: Text( _product != null ?
                  _product.price : "￥" + widget.course.platformPrice(),
//              softWrap: true,
                  style: TextStyle(fontSize: 18,color: Colors.red),
                ),
              ),

              widget.course.content != null ? Html(data: widget.course.content) : Container(),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: RaisedButton(
                    onPressed:_product != null ? () {
                      if(_isPurchased){

                      }else{
                        tapPurchase();
                      }
                    } : null,
                    child: Stack(
                      children: <Widget>[
                        Center(child: Text(_isPurchased ? '去观看' : '去支付',style: TextStyle(color: Colors.white))),
                        _product != null ? Container() : Center(child: CircularProgressIndicator(),),
                      ],
                    ),
                    color:Theme.of(context).buttonColor,
                    disabledColor: Colors.grey
                ),
//              margin: new EdgeInsets.only(
//                  top: 20.0
//              ),
              ),
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }


}