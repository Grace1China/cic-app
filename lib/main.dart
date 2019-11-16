import 'package:church_platform/account/LoginWidget.dart';
import 'package:church_platform/course/CourseWidget.dart';
import 'package:church_platform/donate/DonateWidget.dart';
import 'package:church_platform/sunday/SundayWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home/HomeWidget.dart';
import 'utils/SharedPreferencesUtils.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  static final myTabbedPageKey = new GlobalKey<_MyHomePageState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(key:myTabbedPageKey,title: 'Flutter Demo Home Page'),
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
    Text(
      'Index 2: 灵修打卡',
      style: optionStyle,
    ),
    SundayWidget(),
    CourseWidget(),
  ];

  void changeIndex(int index){
    _onItemTapped(index);
  }
  void _onItemTapped(int index) async {
    bool b = await SharedPreferencesUtils.isLogin();
    if(!b && index != 4){
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
            title: Text('IMS教会'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            title: Text('奉献'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.markunread_mailbox),
            title: Text('灵修打卡'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.live_tv),
            title: Text('主日信息'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            title: Text('课程资料'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
