import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:church_platform/main.dart';
import 'package:church_platform/net/common/API.dart';
import 'package:church_platform/net/common/NetConfigure.dart';
import 'package:church_platform/net/results/Course.dart';
import 'package:church_platform/net/results/IAPVerifyResult.dart';
import 'package:church_platform/net/results/OrderResult.dart';
import 'package:church_platform/net/results/PaypalResult.dart';
import 'package:church_platform/utils/AlertDialogUrils.dart';
import 'package:church_platform/utils/IAPUnCompletePurchaseStore.dart';
import 'package:church_platform/utils/IAPUtils.dart';
import 'package:church_platform/utils/LoggerUtils.dart';
import 'package:church_platform/utils/SharedPreferencesUtils.dart';
import 'package:church_platform/vedio/VideofijkplayerWidget.dart';
import 'package:church_platform/views/courses/CoursePlayWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:flutter_html/flutter_html.dart';
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
//  InAppPurchaseConnection.enablePendingPurchases();

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

//  String client_token;
  String _kConsumableId = ConsumableId; //当前产品的id

  //苹果内购相关。
  InAppPurchaseConnection _connection;
  StreamSubscription<List<PurchaseDetails>> _subscription;
  ProductDetails _product; //查到的产品
  bool _loading = false;
  bool _payLoading = false;
  bool isBuySuccess; //是否在该页完成一次购买。

  _CourseDetailsWidgetState() {
    if (Platform.isIOS) {
//      InAppPurchaseConnection.enablePendingPurchases();
      _connection = InAppPurchaseConnection.instance;
      Log.i("ios");
    } else {
      Log.i("android");
    }
  }

  @override
  void initState() {
    if (Platform.isIOS) {
      _kConsumableId = widget.course.iapCharge != null
          ? widget.course.iapCharge.productId
          : "";

      _listenToPurchaseStart();

      _initStoreInfo();
    } else {
      setState(() {
        _product = null;
      });
    }

    super.initState();
  }

  Future<void> _initStoreInfo() async {
    //查询产品
    bool isAvailable = await _connection.isAvailable();
    Log.i("Log.i连接是否可用： isAvailable = ${isAvailable == true}");
    if (!isAvailable) {
      return;
    }

    ProductDetailsResponse productDetailResponse =
        await _connection.queryProductDetails([_kConsumableId].toSet());
    if (productDetailResponse.error != null) {
      Log.i("查询产品错误：" + productDetailResponse.error.message);
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      Log.i("未查询到产品：${_kConsumableId.toString()}");
      return;
    }

    productDetailResponse.productDetails.forEach((p) {
      Log.i("查询到产品：${p.id} ${p.title}");
    });
    setState(() {
      _product = productDetailResponse.productDetails.first;
      _loading = false;
    });

    //重新进行上一次未完成的充值。
    await doLastPurchase();
  }

  Future<bool> hasLastPurchase() async {
    Map<String, Map<String, String>> unComplete =
        await IAPUnCompletePurchaseStore.loadMap();
    return unComplete.length > 0;
  }

  Future<void> doLastPurchase() async {
    Map<String, Map<String, String>> unComplete =
        await IAPUnCompletePurchaseStore.loadMap();
    if (unComplete.length > 0) {
      //同步编程失败。现在用户每次只能进行一个未完成的购买。
      for (var entry in unComplete.entries) {
//2      await Future.forEach(unComplete.entries, (MapEntry entry) async {
        String key = entry.key;
        Map<String, String> courseMap = entry.value;

//      unComplete.forEach((key,courseMap) async {
        if (Platform.isIOS) {
          String purchaseid =
              key.replaceAll(IAPUnCompletePurchaseStore.PREFIX, "");
          int lastCourseID = int.parse(courseMap["courseid"]);
          String lastCourseName = courseMap["coursename"];
          String lastCoursePrice = courseMap["courseprice"];

          AlertDialogUtils.show(context,
              title: "你有一笔交易还未完成",
              content:
                  "花费${lastCoursePrice}元，购买课程${lastCourseName}。若已经扣款，则不会重复扣款。",
              canCancel: false,
              okTitle: "继续", okHandler: () async {
            try {
              bool valid = await _verifyPurchaseLast(lastCourseID);
              IAPUnCompletePurchaseStore.remove(purchaseid);
              Log.i("购买成功");
              isBuySuccess = true;
              hideLoading();
              AlertDialogUtils.show(context, title: "提示", content: "购买成功");
              await InAppPurchaseConnection.instance
                  .completePurchaseWithID(purchaseid);
              if (widget.course.id == lastCourseID) {
                setState(() {
                  widget.course.is_buy = true;
                });
              }
            } catch (e) {
              Log.i("购买验证不合法：purchaseid: " + purchaseid);
              hideLoading();
              AlertDialogUtils.show(context,
                  title: "提示", content: "购买验证失败，请重试。${e}");
            }
          });
          return; //只进行一条购买就返回。
        }
      }
    }
  }

  Future<void> tapPurchase() async {
    //有产品才会可点击。
    try {
      if (!await SharedPreferencesUtils.isLogin()) {
        Navigator.pushNamed(context, RouteNames.LOGIN);
        return;
      }

      if (await hasLastPurchase()) {
        await doLastPurchase();
      } else {
        await doPurchase();
      }
    } catch (e) {
      hideLoading();
      AlertDialogUtils.show(context, title: "提示", content: e.toString());
    }
  }

  Future<void> doPurchase() async {
    try {
      showLoading();
      order_no = await API().iapCreateOrder(widget.course.id);
      PurchaseParam purchaseParam = PurchaseParam(
          productDetails: _product,
          applicationUserName: null,
          sandboxTesting: NetConfigure.IS_SANDBOX);
      _payLoading = true;
      bool success = await _connection.buyConsumable(
          purchaseParam: purchaseParam,
          autoConsume: kAutoConsume || Platform.isIOS);
      print("doPurchase buyConsumable ${success}");
    } catch (e) {
      hideLoading();
      if(e is PlatformException && e.code == "storekit_duplicate_product_object"){
          await InAppPurchaseConnection.instance.completePurchaseWithID(_product.id);
          tapPurchase();
      }else{
          AlertDialogUtils.show(context, title: "提示", content: e.toString());
      }
    }
  }

  void showLoading() {
    setState(() {
      _loading = true;
    });
  }

  void hideLoading() {
    setState(() {
      _loading = false;
      _payLoading = false;
    });
  }

  //验证凭证
  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    if (Platform.isIOS) {
      try {
        showLoading();
        if (order_no == null) {
          order_no = await API().iapCreateOrder(widget.course.id);
        }
        //此处会输入密码，显示支付完成。--- 操作完成。----等待很长时间。
        PurchaseVerificationData receiptData = await InAppPurchaseConnection
            .instance
            .refreshPurchaseVerificationData();
        Log.i("待验证数据" + receiptData.localVerificationData);

        IAPVerifyResult result = await API().iapVerify(receiptData.localVerificationData, order_no);
        return Future<bool>.value(true);
      } catch (e) {
        throw e;
      }
    }
  }

  Future<bool> _verifyPurchaseLast(int lastCourseID) async {
    if (Platform.isIOS) {
      try {
        showLoading();
        String order_no = await API().iapCreateOrder(lastCourseID);
        PurchaseVerificationData receiptData = await InAppPurchaseConnection
            .instance
            .refreshPurchaseVerificationData();
        IAPVerifyResult result = await API().iapVerify(receiptData.localVerificationData, order_no);
        return Future<bool>.value(true);
      } catch (e) {
        throw e;
      }
    }
  }

  //成功失败监听
  void _purchaseError(IAPError error, PurchaseDetails purchaseDetails) async {
//    await ConsumableStore.save(purchaseDetails.purchaseID);
    Log.i("购买错误：errpr: ${error}, " +
        (purchaseDetails != null ? IAPUtils.description(purchaseDetails) : ""));
    hideLoading();
    AlertDialogUtils.show(context,
        title: "提示", content: "购买失败，请重试。${error.message}");
  }

  void _purchaseInvalid(Exception e, PurchaseDetails purchaseDetails) async {
//    await ConsumableStore.save(purchaseDetails.purchaseID);
    Log.i("购买验证不合法：" +
        (purchaseDetails != null ? IAPUtils.description(purchaseDetails) : ""));
    hideLoading();
    AlertDialogUtils.show(context,
        title: "提示", content: "购买验证失败，请重试。${e.toString()}");
  }

  void _purchaseSuccess(PurchaseDetails purchaseDetails) async {
//    await ConsumableStore.remove(purchaseDetails.purchaseID);
    Log.i("购买成功：" +
        (purchaseDetails != null ? IAPUtils.description(purchaseDetails) : ""));
    isBuySuccess = true;
    hideLoading();
    AlertDialogUtils.show(context, title: "提示", content: "购买成功");
    setState(() {
      widget.course.is_buy = true;
    });
    _finishPurchase(purchaseDetails);
  }

  void _finishPurchase(PurchaseDetails purchaseDetails) async {
    if (Platform.isIOS) {
      if (purchaseDetails.pendingCompletePurchase) {
        await InAppPurchaseConnection.instance.completePurchase(purchaseDetails);
      }
    }
  }

  //监听逻辑
  //TODO: 中途断掉后，没有保存IAPUnCompletePurchaseStore，是有未完成的购买。但是_listenToPurchaseUpdated监听不到，而无法finish。
  void _listenToPurchaseStart() {
    //购买payment状况的监听
    Stream purchaseUpdated = InAppPurchaseConnection.instance.purchaseUpdatedStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      Log.i("------购买监听-----个数${purchaseDetailsList.length.toString()}");
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      Log.i("------购买完成-----: done");
      _subscription.cancel();
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

      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
//          showLoading();
          break;
        case PurchaseStatus.error:
          _purchaseError(purchaseDetails.error, purchaseDetails);
          break;
        case PurchaseStatus.purchased:
//          //测试：强制完成。
//          _finishPurchase(purchaseDetails);
//          break;

          IAPUnCompletePurchaseStore.save(purchaseDetails.purchaseID,
              widget.course.id.toString(), widget.course.title, _product.price);

          try {
            bool valid = await _verifyPurchase(purchaseDetails);

            IAPUnCompletePurchaseStore.remove(purchaseDetails.purchaseID);
            _purchaseSuccess(purchaseDetails);
          } catch (e) {
            _purchaseInvalid(e, purchaseDetails);
          }

          break;
      }
    });
  }

  //--------------paypal支付相关----------
  Future<void> tapPurchase4Paypal() async {
    //有产品才会可点击。

    if (!await SharedPreferencesUtils.isLogin()) {
      Navigator.pushNamed(context, RouteNames.LOGIN);
      return;
    }

    //1、提示文案
    AlertDialogUtils.show(context,
        title: "确认支付",
        content:
            "您是否花费\$${widget.course.price_usd}，购买课程《${widget.course.title}》？",
        canCancel: true,
        okTitle: "继续", okHandler: () async {
      await _doPaypalPurchase();
    });
  }

  Future<void> _doPaypalPurchase() async {
    try {
      showLoading();
      //2、请求server, get client_token
      OrderResult orderResult =
          await API().paypalGetClientToken(widget.course.id);
//        order_no = orderResult.order_no;
      String client_token = orderResult.client_token;
      hideLoading();

      //3、显示dropIn。请求braintree server，get nonce
      var request = BraintreeDropInRequest(
//          tokenizationKey: tokenizationKey,
        clientToken: client_token,
        collectDeviceData: true,
//          googlePaymentRequest: BraintreeGooglePaymentRequest(
//            totalPrice: '4.20',
//            currencyCode: 'USD',
//            billingAddressRequired: false,
//          ),
        paypalRequest: BraintreePayPalRequest(
          amount: widget.course.price_usd.toString(), //'4.20'
          displayName: 'BICF国际教会',
        ),
      );

      BraintreeDropInResult result = await BraintreeDropIn.start(request);

      //有结果。
      if (result != null) {
        showLoading();
        BraintreePaymentMethodNonce nonce = result.paymentMethodNonce;
        String deviceData = result.deviceData;

        Log.i(
            "Noce:${nonce.nonce}, Type label:${nonce.typeLabel}, Description:${nonce.description}. DeviceData:${deviceData}");

        //4、请求server，支付
        PaypalResult paypalResult = await API()
            .paypalPostNonce(nonce.nonce, orderResult.order_no, deviceData);
//          if(paypalResult.course_id == widget.course.id){
        setState(() {
          widget.course.is_buy = true;
        });
        Log.i("购买成功：课程id：${widget.course.id}，订单no：${orderResult.order_no}");
        isBuySuccess = true;
        hideLoading();
        AlertDialogUtils.show(context, title: "提示", content: "购买成功");
//          }

        //点空白处，dropin消失
      } else {
        hideLoading();
      }
    } catch (e) {
      hideLoading();
      AlertDialogUtils.show(context, title: "提示", content: e.toString());
    }
  }

  @override
  void dispose() {
    if (_subscription != null) {
      _subscription.cancel();
    }
    super.dispose();
  }

  Widget buildPayBtn(BuildContext context) {
    var circle = Container();

    return RaisedButton(
        onPressed: Platform.isIOS && !widget.course.is_buy && _product == null
            ? null
            : () {
                if (widget.course.is_buy) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CoursePlayWidget(
                              course: widget.course,
                            )),
                  );
                } else {
                  if (Platform.isIOS) {
                    tapPurchase();
                  } else {
                    tapPurchase4Paypal();
                  }
                }
              },
        child: Stack(
          children: <Widget>[
            Center(
                child: Text(widget.course.is_buy ? '去观看' : '去支付',
                    style: TextStyle(color: Colors.white))),
            Platform.isIOS &&
                    _product == null &&
                    _kConsumableId != "" &&
                    !widget.course.is_buy
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(),
          ],
        ),
        color: Theme.of(context).buttonColor,
        disabledColor: Colors.grey);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        Navigator.pop(context, isBuySuccess);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.course.title),
          //centerTitle: true,
          elevation:
              (Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0),
        ),
        body: ModalProgressHUD(
          inAsyncCall: _loading,
          opacity: 0.5,
          progressIndicator: _payLoading ? Container(
                  child:Center(child:Column(crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:<Widget>[CircularProgressIndicator(),SizedBox(height: 20),Text("请耐心等待，不要退出应用")])),
                 ):CircularProgressIndicator(),

          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
//          VedioPlayerWidget(url:widget.course.video),
//          VedioPlayerWidget(url:widget.course.medias[0].hDURL),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1.0, color: Colors.black12),
                    // 边色与边宽度
//                color: Colors.black26,//底色
                    borderRadius:
                        const BorderRadius.all(const Radius.circular(2.0)),
                    // boxShadow: [BoxShadow(color: Color(0x99FFFF00), offset: Offset(5.0, 5.0), blurRadius: 10.0, spreadRadius: 2.0), BoxShadow(color: Color(0x9900FF00), offset: Offset(1.0, 1.0)), BoxShadow(color: Color(0xFF0000FF))],
                  ),
                  child:
//              VideofijkplayerWidget(url: widget.course.medias[0].hDURL)),
                      Stack(
                    alignment: AlignmentDirectional.center,
                    children: <Widget>[
                      widget.course.medias.length > 0 &&
                              widget.course.medias[0].hDURL != null &&
                              widget.course.medias[0].hDURL.isNotEmpty &&
                              widget.course.is_buy
                          ? Offstage(
                              offstage: true,
                              child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  height: MediaQuery.of(context).size.width *
                                      0.8 /
                                      16 *
                                      9,
                                  child: VideofijkplayerWidget(
                                      url: widget.course.medias[0].hDURL)),
                            )
                          : Container(),
                      CachedNetworkImage(
                        imageUrl: widget.course.medias[0].image,
                        imageBuilder: (context, imageProvider) => Stack(
                          alignment: AlignmentDirectional.center,
                          children: <Widget>[
                            Image(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                        placeholder: (context, url) => Container(
                          //color: Colors.grey,
                          decoration: BoxDecoration(
                            border:
                                Border.all(width: 2.0, color: Colors.black12),
                            // 边色与边宽度
                            color: Colors.black26,
                            //底色
                            borderRadius: const BorderRadius.all(
                                const Radius.circular(2.0)),
                            // boxShadow: [BoxShadow(color: Color(0x99FFFF00), offset: Offset(5.0, 5.0), blurRadius: 10.0, spreadRadius: 2.0), BoxShadow(color: Color(0x9900FF00), offset: Offset(1.0, 1.0)), BoxShadow(color: Color(0xFF0000FF))],
                          ),
                          child: Center(
                            child: CircularProgressIndicator(),
//                              Center(child: Container(),
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            //灰色边框
                            Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 1.0, color: Colors.black12), // 边色与边宽度
                            color: Colors.black12, //底色
                            borderRadius: const BorderRadius.all(
                                const Radius.circular(2.0)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //名字
                Container(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    widget.course.title,
//              softWrap: true,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                //价格
                Container(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    _product != null
                        ? _product.price
                        : "￥" + widget.course.platformPrice(),
//              softWrap: true,
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  ),
                ),
                //详情
                widget.course.content != null
                    ? Html(data: widget.course.content)
                    : Container(),
                //支付/观看
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: buildPayBtn(context),
//              margin: new EdgeInsets.only(
//                  top: 20.0
//              ),
                ),
              ],
            ),
          ),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
