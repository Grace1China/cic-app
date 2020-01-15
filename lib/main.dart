import 'package:church_platform/views/account/LoginWidget.dart';
import 'package:church_platform/views/course/CourseWidget.dart';
import 'package:church_platform/views/donate/DonateWidget.dart';
import 'package:church_platform/views/lordday/LorddayInfoWidget.dart';
import 'package:church_platform/views/sermon/SermonMain2Widget.dart';
import 'package:church_platform/views/sermon/SermonMainWidget.dart';
import 'package:church_platform/views/spiritual/SpiritualMainWidget.dart';
import 'package:church_platform/views/sunday/SundayWidget.dart';
import 'package:church_platform/views/sunday/details/SermonDetailsWidget.dart';
import 'package:church_platform/views/sunday/details/SermonListOnceWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'views/home/HomeWidget.dart';
import 'utils/SharedPreferencesUtils.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter/foundation.dart';
import 'utils/CPTheme.dart';
//import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  static final myTabbedPageKey = new GlobalKey<_MyHomePageState>();

  @override
  Widget build(BuildContext context) {
//    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(  没反应
//        statusBarColor: Colors.white
//    ));

//    FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    return OKToast(
      child:  MaterialApp(
        title: 'Flutter Demo',
        themeMode: ThemeMode.light,
        theme: defaultTargetPlatform == TargetPlatform.iOS         //new
            ? kIOSTheme                                              //new
            : kAndroidTheme,
        home: MyHomePage(key:myTabbedPageKey,title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 4;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static  List<Widget> _widgetOptions = <Widget>[
    HomeWidget(),
    DonateWidget(),
    SpiritualMainWidget(),
    LorddayInfoWidget(key:LorddayInfoWidget.myLorddayInfoWidgetKey),
    CourseWidget(),
  ];

  void changeIndex(int index){
    _onItemTapped(index);
  }
  void _onItemTapped(int index) async {
    bool b = await SharedPreferencesUtils.isLogin();
    if(!b && [0,1,2].contains(index)){
//      Navigator.of(context).push(route)
      Navigator.push(context, CupertinoPageRoute(
          fullscreenDialog: true,
          builder: (context) => LoginWidget()
      ));
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
