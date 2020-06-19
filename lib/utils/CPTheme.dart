import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'HexColor.dart';

bool isDarkMode(BuildContext context){
  return Theme.of(context).brightness == Brightness.dark;
}

//NAME       SIZE   WEIGHT   SPACING  2018 NAME
//display4   112.0  thin     0.0      headline1
//display3   56.0   normal   0.0      headline2
//display2   45.0   normal   0.0      headline3
//display1   34.0   normal   0.0      headline4
//headline   24.0   normal   0.0      headline5
//title      20.0   medium   0.0      headline6
//subhead    16.0   normal   0.0      subtitle1
//body2      14.0   medium   0.0      body1
//body1      14.0   normal   0.0      body2
//caption    12.0   normal   0.0      caption
//button     14.0   medium   0.0      button
//subtitle   14.0   medium   0.0      subtitle2
//overline   10.0   normal   0.0      overline

final ThemeData kFlutterDefaultTheme = ThemeData(
  // Define the default brightness and colors.
  brightness: Brightness.dark,
  primaryColor: Colors.lightBlue[800],
  accentColor: Colors.cyan[600],

  // Define the default font family.
  fontFamily: 'Montserrat',

  // Define the default TextTheme. Use this to specify the default
  // text styling for headlines, titles, bodies of text, and more.
  textTheme: TextTheme(
    headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
    title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
    body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
  ),
);

//自定义大小
final kFontSizeTitle = 20;
final kFontSizeSubTitle = 16;
final kFontSizeBody = 14;
final kFontSizeCaption = 12;


final kCPColorGreen1Hex = "2AA77B";
final kCPColorGreen2Hex = "279C74";
final kCPColorGreen3Hex = "24926D";

final kCPColorGreen1 = HexColor.Hex(kCPColorGreen1Hex); //浅
final kCPColorGreen2 = HexColor.Hex(kCPColorGreen2Hex); //中 39,156,116
final kCPColorGreen3 = HexColor.Hex(kCPColorGreen3Hex); //深
//浅橘色 Colors.amber[800]

final ThemeButtonColor = kCPColorGreen1;

Map<int, Color> kCPMaterialColorGreen2 =
{
  50:Color.fromRGBO(39,156,116, .1),
  100:Color.fromRGBO(39,156,116, .2),
  200:Color.fromRGBO(39,156,116, .3),
  300:Color.fromRGBO(39,156,116, .4),
  400:Color.fromRGBO(39,156,116, .5),
  500:Color.fromRGBO(39,156,116, .6),
  600:Color.fromRGBO(39,156,116, .7),
  700:Color.fromRGBO(39,156,116, .8),
  800:Color.fromRGBO(39,156,116, .9),
  900:Color.fromRGBO(39,156,116, 1),
};

final ThemeData kIOSTheme = ThemeData(

  primaryColor: kCPColorGreen2,// Colors.grey[100], //navgationbar颜色
  primaryColorBrightness: Brightness.light,
  primaryTextTheme: TextTheme(  //title颜色。android默认白色
      title: TextStyle(
          color: Colors.white
      )
  ),
  primaryIconTheme: IconThemeData(color: Colors.white),//navgation item icon 颜色。android默认白色，若在appBar的iconTheme写上，反而变成黑色。

  accentColor: kCPColorGreen2,

  fontFamily: 'Montserrat',


//  textTheme: TextTheme(
//    headline: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
//    title: TextStyle(fontSize: 24.0, fontStyle: FontStyle.italic),
//    body1: TextStyle(fontSize: 12.0, fontFamily: 'Hind'),
//  ),

  buttonColor: kCPColorGreen1,
  primarySwatch: Colors.blue,
  brightness: Brightness.light,
);

final ThemeData kAndroidTheme = ThemeData(
  brightness: Brightness.light,
//  primaryColor: Colors.grey[100],
  accentColor: kCPColorGreen2, //  2AA77B浅绿，279C74中绿，24926D深绿，浅橘色 Colors.amber[800]
//
//  fontFamily: 'Montserrat',
//
////  textTheme: TextTheme(
////    headline: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
////    title: TextStyle(fontSize: 24.0, fontStyle: FontStyle.italic),
////    body1: TextStyle(fontSize: 12.0, fontFamily: 'Hind'),
////  ),
//
  buttonColor: kCPColorGreen1,
  //其他
  primarySwatch: MaterialColor(0xFF279C74, kCPMaterialColorGreen2), //0xFF880E4F紫红
//  primaryColorBrightness: Brightness.light,

);

//demo
//final ThemeData kIOSTheme = new ThemeData(
//  primarySwatch: Colors.orange,
//  primaryColor: Colors.grey[100],
//  primaryColorBrightness: Brightness.light,
//);
//
//final ThemeData kDefaultTheme = new ThemeData(
//  primarySwatch: Colors.purple,
//  accentColor: Colors.orangeAccent[400],
//);

//ios和android用同一个黑暗主题。
final ThemeData kiOSDarkTheme = ThemeData.dark().copyWith(
  primaryColor: kCPColorGreen2,// Colors.grey[100], //navgationbar颜色
  primaryColorBrightness: Brightness.dark,
  primaryTextTheme: TextTheme(  //title颜色。android默认白色
      title: TextStyle(
          color: Colors.white
      )
  ),
  primaryIconTheme: IconThemeData(color: Colors.white),//navgation item icon 颜色。android默认白色，若在appBar的iconTheme写上，反而变成黑色。

  accentColor: kCPColorGreen2,

//  textTheme: TextTheme(
//    headline: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
//    title: TextStyle(fontSize: 24.0, fontStyle: FontStyle.italic),
//    body1: TextStyle(fontSize: 12.0, fontFamily: 'Hind'),
//  ),
  buttonTheme: ButtonThemeData(buttonColor: kCPColorGreen1),
  buttonColor: kCPColorGreen1,
  brightness: Brightness.dark,
);

//final ThemeData kAndroidDarkTheme = ThemeData.dark().copyWith(
//  brightness: Brightness.dark,
////  primaryColor: Colors.grey[100],
//  accentColor: kCPColorGreen2, //  2AA77B浅绿，279C74中绿，24926D深绿，浅橘色 Colors.amber[800]
//  buttonColor: kCPColorGreen1,
////  primaryColorBrightness: Brightness.light,
//
//);