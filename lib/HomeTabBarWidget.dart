import 'package:church_platform/main.dart';
import 'package:church_platform/utils/AlertDialogUrils.dart';
import 'package:church_platform/utils/SharedPreferencesUtils.dart';
import 'package:church_platform/views/church/ChurchWidget.dart';
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

class _HomeTabBarWidgetState extends State<HomeTabBarWidget> {
  int _selectedIndex = 0;
//  static const TextStyle optionStyle =
//      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    ChurchWidget(key: ChurchWidget.ChurchWidgetKey),
    DonateWidget(),
//    SpiritualMainWidget(),
    LorddayInfoListWidget(key: LorddayInfoListWidget.myLorddayInfoListWidgetKey),
//    CourseStoreWidget(),
  ];

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


  void refresh(){
    if (ChurchWidget.ChurchWidgetKey.currentState != null) {
      ChurchWidget.ChurchWidgetKey.currentState.refresh();
    }
    if (DonateWidget.DonateWidgetKey.currentState != null) {
      DonateWidget.DonateWidgetKey.currentState.refresh();
    }
    if (LorddayInfoListWidget.myLorddayInfoListWidgetKey.currentState != null) {
      LorddayInfoListWidget.myLorddayInfoListWidgetKey.currentState.refresh(isFirst: true);
    }
    //课程 TODO:
  }

  void changeIndex(int index) {
    _onItemTapped(index);
  }

  void _onItemTapped(int index) async {
    bool b = await SharedPreferencesUtils.isLogin();
    if (!b && [1].contains(index)) {
      Navigator.pushNamed(context, '/login');
      return;
    }

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
        child: _widgetOptions.elementAt(_selectedIndex),
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
//          BottomNavigationBarItem(
//            icon: Icon(Icons.library_books),
//            title: Text('课程'),
//          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).accentColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
