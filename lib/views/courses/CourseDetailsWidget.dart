import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:church_platform/net/CourseResponse.dart';
import 'package:church_platform/vedio/VedioPlayerWidget.dart';
import 'package:church_platform/vedio/VideofijkplayerWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter/foundation.dart';

import 'dart:async';
import 'dart:io';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'consumable_store.dart';

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

  //苹果内购相关。
  final InAppPurchaseConnection _connection = InAppPurchaseConnection.instance;
  StreamSubscription<List<PurchaseDetails>> _subscription;
  List<String> _notFoundIds = [];
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  List<String> _consumables = [];
  bool _isAvailable = false;  //是否可以连接到商店
  bool _purchasePending = false;
  bool _loading = true;
  String _queryProductError; //是否查询产品错误

  String _kConsumableId = ConsumableId; //当前产品的id

  @override
  void initState() {

    _kConsumableId = widget.course.iapCharge.productId;

    //购买payment状况的监听
    Stream purchaseUpdated = InAppPurchaseConnection.instance.purchaseUpdatedStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      print("------支付监听-----个数${purchaseDetailsList.lenght}");
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      print("------支付完成-----: done");
      _subscription.cancel();
    }, onError: (error) {
      // handle error here.
      print("------支付错误-----:" + error);
    });
    
    initStoreInfo();

    super.initState();
  }

  Future<void> initStoreInfo() async {

    final bool isAvailable = await _connection.isAvailable();
    print("print连接是否可用： isAvailable = ${isAvailable == true}");
    debugPrint("debugprint连接是否可用： isAvailable = ${isAvailable == true}");
    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
        _products = [];
        _purchases = [];
        _notFoundIds = [];
        _consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    ProductDetailsResponse productDetailResponse =
    await _connection.queryProductDetails([_kConsumableId].toSet());
    if (productDetailResponse.error != null) {
      print("查询产品错误：" + productDetailResponse.error.message);
      setState(() {
        _queryProductError = productDetailResponse.error.message;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = [];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }
    productDetailResponse.productDetails.forEach((p){
      print("查询到产品：${p.id} ${p.title}");
    });


    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _queryProductError = null;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = [];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    final QueryPurchaseDetailsResponse purchaseResponse =
    await _connection.queryPastPurchases();
    if (purchaseResponse.error != null) {
      // handle query past purchase error..
    }
    final List<PurchaseDetails> verifiedPurchases = [];
    for (PurchaseDetails purchase in purchaseResponse.pastPurchases) {
      if (await _verifyPurchase(purchase)) {
        verifiedPurchases.add(purchase);
      }
    }
    List<String> consumables = await ConsumableStore.load();
    setState(() {
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _purchases = verifiedPurchases;
      _notFoundIds = productDetailResponse.notFoundIDs;
      _consumables = consumables;
      _purchasePending = false;
      _loading = false;
    });
//    fetchProducts([_kConsumableId]);
//    toPayment();
  }
//  //添加的获取产品方法
//  Future<void> fetchProducts(List<String> productIds) async{
//    final bool isAvailable = await _connection.isAvailable();
//    if (!isAvailable) {
//      setState(() {
//        _isAvailable = isAvailable;
//        _products = [];
//        _purchases = [];
//        _notFoundIds = [];
//        _consumables = [];
//        _purchasePending = false;
//        _loading = false;
//      });
//      return;
//    }
//
//    ProductDetailsResponse productDetailResponse =
//        await _connection.queryProductDetails(productIds.toSet());
//    if (productDetailResponse.error != null) {
//      setState(() {
//        _queryProductError = productDetailResponse.error.message;
//        _isAvailable = isAvailable;
//        _products = productDetailResponse.productDetails;
//        _purchases = [];
//        _notFoundIds = productDetailResponse.notFoundIDs;
//        _consumables = [];
//        _purchasePending = false;
//        _loading = false;
//      });
//      return;
//    }
//
//    if (productDetailResponse.productDetails.isEmpty) {
//      setState(() {
//        _queryProductError = null;
//        _isAvailable = isAvailable;
//        _products = productDetailResponse.productDetails;
//        _purchases = [];
//        _notFoundIds = productDetailResponse.notFoundIDs;
//        _consumables = [];
//        _purchasePending = false;
//        _loading = false;
//      });
//      return;
//    }
//  }
//
//  //添加的支付方法
//  Future<void> toPayment() async {
//
//
//    final QueryPurchaseDetailsResponse purchaseResponse =
//    await _connection.queryPastPurchases();
//    if (purchaseResponse.error != null) {
//      // handle query past purchase error..
//    }
//    final List<PurchaseDetails> verifiedPurchases = [];
//    for (PurchaseDetails purchase in purchaseResponse.pastPurchases) {
//      if (await _verifyPurchase(purchase)) {
//        verifiedPurchases.add(purchase);
//      }
//    }
//    List<String> consumables = await ConsumableStore.load();
//    setState(() {
////      _isAvailable = isAvailable;
////      _products = productDetailResponse.productDetails;
//      _purchases = verifiedPurchases;
////      _notFoundIds = productDetailResponse.notFoundIDs;
//      _consumables = consumables;
//      _purchasePending = false;
//      _loading = false;
//    });
//  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> stack = [];
    if (_queryProductError == null) {
      stack.add(
        ListView(
          children: [
            _buildConnectionCheckTile(),
            _buildProductList(),
            _buildConsumableBox(),
          ],
        ),
      );
    } else {
      stack.add(Center(
        child: Text(_queryProductError),
      ));
    }
    if (_purchasePending) {
      stack.add(
        Stack(
          children: [
            Opacity(
              opacity: 0.3,
              child: const ModalBarrier(dismissible: false, color: Colors.grey),
            ),
            Center(
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      );
    }

    return  Scaffold(
      appBar: AppBar(
        title: Text(widget.course.title),
        //centerTitle: true,
        elevation:
        (Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0),
      ),
      // Use a FutureBuilder to display a loading spinner while waiting for the
      // VideoPlayerController to finish initializing.
      body: SingleChildScrollView(
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
                          //                            color: Colors.grey,
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
              child: Text( _isAvailable && _products.length > 0 ?
                _products[0].price : "￥" + widget.course.platformPrice(),
//              softWrap: true,
                style: TextStyle(fontSize: 18,color: Colors.red),
              ),
            ),

            widget.course.content != null ? Html(data: widget.course.content) : Container(),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: RaisedButton(
                  onPressed: () {
                    if(_isAvailable && _products.length > 0){
                       print("可以支付");
                       PurchaseParam purchaseParam = PurchaseParam(
                           productDetails: _products[0],
                           applicationUserName: null,
                           sandboxTesting: true);
                       if (_products[0].id == _kConsumableId) {
                         _connection.buyConsumable(
                             purchaseParam: purchaseParam,
                             autoConsume: kAutoConsume || Platform.isIOS);
                       } else {
                         //没有非消耗。注释掉
//                         _connection.buyNonConsumable(
//                             purchaseParam: purchaseParam);
                       }
                    }else{
                      print("不可支付");
                    }
                  },
                  child: Text('购买',
                      style: TextStyle(
                          color: Colors.white)),
                  color: _isAvailable && _products.length > 0 ? Theme.of(context).buttonColor : Colors.grey
              ),
//              margin: new EdgeInsets.only(
//                  top: 20.0
//              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 400,
              child: Stack(
                children: stack,
              ),
            ),

          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );;
  }

  //内购其他
  Card _buildConnectionCheckTile() {
    if (_loading) {
      return Card(child: ListTile(title: const Text('Trying to connect...')));
    }
    final Widget storeHeader = ListTile(
      leading: Icon(_isAvailable ? Icons.check : Icons.block,
          color: _isAvailable ? Colors.green : ThemeData.light().errorColor),
      title: Text(
          'The store is ' + (_isAvailable ? 'available' : 'unavailable') + '.'),
    );
    final List<Widget> children = <Widget>[storeHeader];

    if (!_isAvailable) {
      children.addAll([
        Divider(),
        ListTile(
          title: Text('Not connected',
              style: TextStyle(color: ThemeData.light().errorColor)),
          subtitle: const Text(
              'Unable to connect to the payments processor. Has this app been configured correctly? See the example README for instructions.'),
        ),
      ]);
    }
    return Card(child: Column(children: children));
  }

  Card _buildProductList() {
    if (_loading) {
      return Card(
          child: (ListTile(
              leading: CircularProgressIndicator(),
              title: Text('Fetching products...'))));
    }
    if (!_isAvailable) {
      return Card();
    }
    final ListTile productHeader = ListTile(title: Text('Products for Sale'));
    List<ListTile> productList = <ListTile>[];
    if (_notFoundIds.isNotEmpty) {
      productList.add(ListTile(
          title: Text('[${_notFoundIds.join(", ")}] not found',
              style: TextStyle(color: ThemeData.light().errorColor)),
          subtitle: Text(
              'This app needs special configuration to run. Please see example/README.md for instructions.')));
    }

    // This loading previous purchases code is just a demo. Please do not use this as it is.
    // In your app you should always verify the purchase data using the `verificationData` inside the [PurchaseDetails] object before trusting it.
    // We recommend that you use your own server to verity the purchase data.
    Map<String, PurchaseDetails> purchases =
    Map.fromEntries(_purchases.map((PurchaseDetails purchase) {
      if (purchase.pendingCompletePurchase) {
        InAppPurchaseConnection.instance.completePurchase(purchase);
      }
      return MapEntry<String, PurchaseDetails>(purchase.productID, purchase);
    }));
    productList.addAll(_products.map(
          (ProductDetails productDetails) {
        PurchaseDetails previousPurchase = purchases[productDetails.id];
        return ListTile(
            title: Text(
              productDetails.title,
            ),
            subtitle: Text(
              productDetails.description,
            ),
            trailing: previousPurchase != null
                ? Icon(Icons.check)
                : FlatButton(
              child: Text(productDetails.price),
              color: Colors.green[800],
              textColor: Colors.white,
              onPressed: () {
                PurchaseParam purchaseParam = PurchaseParam(
                    productDetails: productDetails,
                    applicationUserName: null,
                    sandboxTesting: true);
                if (productDetails.id == _kConsumableId) {
                  _connection.buyConsumable(
                      purchaseParam: purchaseParam,
                      autoConsume: kAutoConsume || Platform.isIOS);
                } else {
                  _connection.buyNonConsumable(
                      purchaseParam: purchaseParam);
                }
              },
            ));
      },
    ));

    return Card(
        child:
        Column(children: <Widget>[productHeader, Divider()] + productList));
  }

  Card _buildConsumableBox() {
    if (_loading) {
      return Card(
          child: (ListTile(
              leading: CircularProgressIndicator(),
              title: Text('Fetching consumables...'))));
    }
    if (!_isAvailable || _notFoundIds.contains(_kConsumableId)) {
      return Card();
    }
    final ListTile consumableHeader =
    ListTile(title: Text('Purchased consumables'));
    final List<Widget> tokens = _consumables.map((String id) {
      return GridTile(
        child: IconButton(
          icon: Icon(
            Icons.stars,
            size: 42.0,
            color: Colors.orange,
          ),
          splashColor: Colors.yellowAccent,
          onPressed: () => consume(id),
        ),
      );
    }).toList();
    return Card(
        child: Column(children: <Widget>[
          consumableHeader,
          Divider(),
          GridView.count(
            crossAxisCount: 5,
            children: tokens,
            shrinkWrap: true,
            padding: EdgeInsets.all(16.0),
          )
        ]));
  }

  Future<void> consume(String id) async {
    await ConsumableStore.consume(id);
    final List<String> consumables = await ConsumableStore.load();
    setState(() {
      _consumables = consumables;
    });
  }

  void showPendingUI() {
    setState(() {
      _purchasePending = true;
    });
  }

  void deliverProduct(PurchaseDetails purchaseDetails) async {
    // IMPORTANT!! Always verify a purchase purchase details before delivering the product.
    if (purchaseDetails.productID == _kConsumableId) {
      await ConsumableStore.save(purchaseDetails.purchaseID);
      List<String> consumables = await ConsumableStore.load();
      setState(() {
        _purchasePending = false;
        _consumables = consumables;
      });
    } else {
      setState(() {
        _purchases.add(purchaseDetails);
        _purchasePending = false;
      });
    }
  }

  void handleError(IAPError error) {
    setState(() {
      _purchasePending = false;
    });
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    return Future<bool>.value(true);
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // handle invalid purchase here if  _verifyPurchase` failed.
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      print("支付监听：产品id:${purchaseDetails.productID},purchaseID:${purchaseDetails.purchaseID},状态：${purchaseDetails.status}，错误：${purchaseDetails.error}");
      if (purchaseDetails.status == PurchaseStatus.pending) {
//        print("支付监听_listenToPurchaseUpdated：产品id:${purchaseDetails.productID}");
        showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          handleError(purchaseDetails.error);
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            deliverProduct(purchaseDetails);
          } else {
            _handleInvalidPurchase(purchaseDetails);
            return;
          }
        }
        if (Platform.isAndroid) {
          if (!kAutoConsume && purchaseDetails.productID == _kConsumableId) {
            await InAppPurchaseConnection.instance
                .consumePurchase(purchaseDetails);
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await InAppPurchaseConnection.instance
              .completePurchase(purchaseDetails);
        }
      }
    });
  }
}