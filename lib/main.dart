import 'package:church_platform/views/account/LoginWidget.dart';
import 'package:church_platform/views/courses/store/CourseStoreWidget.dart';
import 'package:church_platform/views/donate/DonateWidget.dart';
import 'package:church_platform/views/lordday/LorddayInfoMainWidget.dart';
import 'package:church_platform/views/spiritual/SpiritualMainWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

import 'utils/CPTheme.dart';
import 'utils/SharedPreferencesUtils.dart';
import 'views/church/ChurchWidget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  static final myTabbedPageKey = new GlobalKey<_HomeTabBarWidgetState>();

  @override
  Widget build(BuildContext context) {

//    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(  没反应
//        statusBarColor: Colors.white
//    ));

//    FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    return OKToast(
      child:  MaterialApp(
        title: '教会平台',
        themeMode: ThemeMode.light,
        theme: defaultTargetPlatform == TargetPlatform.iOS         //new
            ? kIOSTheme                                              //new
            : kAndroidTheme,
        home: HomeTabBarWidget(key:myTabbedPageKey,title: '主页'),
      ),
    );
  }
}

class HomeTabBarWidget extends StatefulWidget {
  HomeTabBarWidget({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeTabBarWidgetState createState() => _HomeTabBarWidgetState();
}

class _HomeTabBarWidgetState extends State<HomeTabBarWidget> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static  List<Widget> _widgetOptions = <Widget>[
    ChurchWidget(),
    DonateWidget(),
//    SpiritualMainWidget(),
    LorddayInfoMainWidget(key:LorddayInfoMainWidget.myLorddayInfoWidgetKey),
//    CourseStoreWidget(),
  ];

  void changeIndex(int index){
    _onItemTapped(index);
  }
  void _onItemTapped(int index) async {
    bool b = await SharedPreferencesUtils.isLogin();
//    if(!b && [0,1,2].contains(index)){
////      Navigator.of(context).push(route)
//      Navigator.push(context, CupertinoPageRoute(
//          fullscreenDialog: true,
//          builder: (context) => LoginWidget()
//      ));
//      return;
//    }
    
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
