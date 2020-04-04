
import 'package:church_platform/utils/AlertDialogUrils.dart';
import 'package:church_platform/utils/SharedPreferencesUtils.dart';
import 'package:church_platform/views/church/ChurchWidget.dart';
import 'package:church_platform/views/courses/store/CourseStoreWidget.dart';
import 'package:church_platform/views/donate/DonateWidget.dart';
import 'package:church_platform/views/lordday/LorddayInfoMainWidget.dart';
import 'package:church_platform/views/spiritual/SpiritualMainWidget.dart';
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
  int _selectedIndex = 4;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static  List<Widget> _widgetOptions = <Widget>[
    ChurchWidget(),
    DonateWidget(),
    SpiritualMainWidget(),
    LorddayInfoMainWidget(key:LorddayInfoMainWidget.myLorddayInfoWidgetKey),
    CourseStoreWidget(),
  ];

  void showLogout(){
    AlertDialogUtils.show(context,
        title: "提示",
        content:"登录过期，请重新登陆。",
        okHandler: () async {
          SharedPreferencesUtils.logout();

//          if(Navigator.of(context).canPop()){
//            Navigator.of(context).pop(); //先pop。
//          }
          //pop
//          Navigator.of(context).popUntil(ModalRoute.withName("/"));
          Navigator.of(context).pushNamedAndRemoveUntil('/login',ModalRoute.withName('/'));
          //login
//          Navigator.push(context, CupertinoPageRoute(
//              fullscreenDialog: true,
//              builder: (context) => LoginWidget()
//          ));

          //改变tab
          changeIndex(4);
//        先pop，  后refresh
          if (LorddayInfoMainWidget.myLorddayInfoWidgetKey.currentState != null) {
            LorddayInfoMainWidget.myLorddayInfoWidgetKey.currentState.refreshRemoteData();
          }
        });
  }
  void changeIndex(int index){
    _onItemTapped(index);
  }
  void _onItemTapped(int index) async {
    bool b = await SharedPreferencesUtils.isLogin();
    if(!b && [0,1,2].contains(index)){
      Navigator.pushNamed(context, '/login');
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
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
          BottomNavigationBarItem(
            icon: Icon(Icons.markunread_mailbox),
            title: Text('L3'),
          ),
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
