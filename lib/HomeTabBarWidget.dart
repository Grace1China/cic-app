import 'package:church_platform/main.dart';
import 'package:church_platform/utils/SharedPreferencesUtils.dart';
import 'package:church_platform/views/church/TabWebViewMainWidget.dart';
import 'package:church_platform/views/church/WeeklyWidget.dart';
import 'package:church_platform/views/courses/store/CourseStoreWidget.dart';
import 'package:church_platform/views/donate/DonateWidget.dart';
import 'package:church_platform/views/lordday/list/LorddayInfoListWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeTabBarWidget extends StatefulWidget {
  // This widget is the root of your application.
  static final myTabbedPageKey = new GlobalKey<_HomeTabBarWidgetState>();

  HomeTabBarWidget({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeTabBarWidgetState createState() => _HomeTabBarWidgetState();
}

class _HomeTabBarWidgetState extends State<HomeTabBarWidget> with AutomaticKeepAliveClientMixin<HomeTabBarWidget> {
  @protected
  bool get wantKeepAlive=>true;

  int _selectedIndex = 0;
//  static const TextStyle optionStyle =
//      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
//    WeeklyWidget(key: WeeklyWidget.WeeklyWidgetKey),
    TabWebViewMainWidget(key: TabWebViewMainWidget.ChurchMainWidgetKey,tabType: TabType.CHURCH,),
    DonateWidget(key:DonateWidget.DonateWidgetKey),

//    SpiritualMainWidget(),
//    LorddayInfoListWidget(key: LorddayInfoListWidget.myLorddayInfoListWidgetKey),
    TabWebViewMainWidget(key: TabWebViewMainWidget.LordDayMainWidgetKey,tabType: TabType.LORDINFO,),
    CourseStoreWidget(key:CourseStoreWidget.myCourseStoreWidgetKey),
  ];

//  void reloadWidgets(){
//    _widgetOptions = <Widget>[
//      WeeklyWidget(key: WeeklyWidget.WeeklyWidgetKey),
//      DonateWidget(key:DonateWidget.DonateWidgetKey),
////    SpiritualMainWidget(),
//      LorddayInfoListWidget(key: LorddayInfoListWidget.myLorddayInfoListWidgetKey),
//      CourseStoreWidget(key:CourseStoreWidget.myCourseStoreWidgetKey),
//    ];
//  }

  void tryShowAccount() async{
    bool isLogin = await SharedPreferencesUtils.isLogin();
    if(isLogin){
      Navigator.of(context).pushNamed(RouteNames.ACCOUNT);
    }else{
      Navigator.of(context).pushNamed(RouteNames.LOGIN);
    }
  }

  void loginSuccess(){
    Navigator.of(context).pop(); //先pop。后refresh。refresh可能会出错
    refresh();
  }
  void logoutSuccess(){
    Navigator.of(context).pop();
    logout();
  }

//  bool isShow401 = false;
//  void showLogout() {
//    if(isShow401){
//      return;
//    }
//
//    isShow401 = true;
//    AlertDialogUtils.show(context, title: "提示", content: "登录过期。",
//        okHandler: () async {
//      isShow401 = false;
//      _logout();
//    });
//
//  }

  void logout() async {
    bool success = await SharedPreferencesUtils.logout();
    if(success){
      //          if(Navigator.of(context).canPop()){
//            Navigator.of(context).pop(); //先pop。
//          }
      //pop
      Navigator.of(context).popUntil(ModalRoute.withName("/"));
      //show login
//    Navigator.of(context)
//        .pushNamedAndRemoveUntil('/login', ModalRoute.withName('/'));

//      Future.delayed(Duration(milliseconds: 100),(){
        //改变tabÒ
        changeIndex(0);
//        先pop，  后refresh
        refresh();
//      });
    }
  }

 //无论初始化，还是刷新。都是非首次效果，即没有圈圈。
  void refresh(){

//    setState(() {
//      reloadWidgets(); //解决WeeklyWidget的webview从空刷新成有数据失败的问题。 就不需要刷新了。
//    });

//    if (WeeklyWidget.WeeklyWidgetKey.currentState != null) {
//      WeeklyWidget.WeeklyWidgetKey.currentState.refresh();
//    }
    if (TabWebViewMainWidget.ChurchMainWidgetKey.currentState != null) {
      TabWebViewMainWidget.ChurchMainWidgetKey.currentState.refresh(isFirst: true);
    }

    if (DonateWidget.DonateWidgetKey.currentState != null) {
      DonateWidget.DonateWidgetKey.currentState.refresh();
    }
//    if (LorddayInfoListWidget.myLorddayInfoListWidgetKey.currentState != null) {
//      LorddayInfoListWidget.myLorddayInfoListWidgetKey.currentState.refresh(isFirst: true);
//    }
    if (TabWebViewMainWidget.LordDayMainWidgetKey.currentState != null) {
      TabWebViewMainWidget.LordDayMainWidgetKey.currentState.refresh(isFirst: true);
    }
    if (CourseStoreWidget.myCourseStoreWidgetKey.currentState != null) {
      CourseStoreWidget.myCourseStoreWidgetKey.currentState.refresh(isFirst: true);
    }
  }

  void changeIndex(int index) {
    _onItemTapped(index);
  }

  void _onItemTapped(int index){
    //不论任何一个tab，都可以不登录进入。
//    bool b = await SharedPreferencesUtils.isLogin();
//    if (!b && [1].contains(index)) {
//      Navigator.pushNamed(context, '/login');
//      return;
//    }

    if(_selectedIndex != index){
      setState(() {
        _selectedIndex = index;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
//        child: _widgetOptions.elementAt(_selectedIndex),
//        child:TabBarView(children: _widgetOptions,),
        child:IndexedStack(
          index: _selectedIndex,
          children: _widgetOptions,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance),
            title: Text('教会'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            title: Text('奉献'),
          ),
//          BottomNavigationBarItem(
//            icon: Icon(Icons.markunread_mailbox),
//            title: Text('L3'),
//          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.live_tv),
            title: Text('主日'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            title: Text('课程'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).accentColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
