import 'package:church_platform/sunday/SundayWidget.dart';
import 'package:flutter/material.dart';
import 'home/HomeWidget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static  List<Widget> _widgetOptions = <Widget>[
    HomeWidget(),
    Text(
      'Index 1: 奉献',
      style: optionStyle,
    ),
    Text(
      'Index 2: 灵修打卡',
      style: optionStyle,
    ),
    SundayWidget(),
    Text(
      'Index 4: 课程资料',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
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
