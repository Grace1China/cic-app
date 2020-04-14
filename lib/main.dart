import 'package:church_platform/HomeTabBarWidget.dart';
import 'package:church_platform/utils/SharedPreferencesUtils.dart';
import 'package:church_platform/views/account/AccountWidget.dart';
import 'package:church_platform/views/account/LoginWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

import 'utils/CPTheme.dart';

//routers 博客：https://zhuanlan.zhihu.com/p/56289929
//项目地址 /Users/kevin/FlutterProjects/mytestapps/flutter_app_routers

//TODO: 课程调适。暂时不做。

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(  没反应
//        statusBarColor: Colors.white
//    ));

//    FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    return OKToast(
      child: MaterialApp(
        title: '教会平台',
        themeMode: ThemeMode.light,
        theme: defaultTargetPlatform == TargetPlatform.iOS
            ? kIOSTheme
            : kAndroidTheme,
//      home: HomeTabBarWidget(key:myTabbedPageKey,title: '主页'),
        initialRoute: '/',
        routes: {
          '/': (context) => HomeTabBarWidget(
              key: HomeTabBarWidget.myTabbedPageKey, title: '主页'),
//          '/second': (context) => SecondScreen(), //当push多个同名字的时候，Navigator.of(context).popUntil(ModalRoute.withName("/second"));失效。
        },
        onGenerateRoute: (settings) {
          switch(settings.name){
            case RouteNames.LOGIN:
              {
                //            final ScreenArguments args = settings.arguments;

                return MaterialPageRoute(
                    fullscreenDialog: true, builder: (context) => LoginWidget());
              }
              break;
            case RouteNames.ACCOUNT:
              {

               return MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => AccountWidget());
              }
              break;
          }

          assert(false, 'Need to implement ${settings.name}');
          return null;
        },
      ),
    );
  }
}

class RouteNames {
  static const LOGIN = '/login';
  static const ACCOUNT = '/account';
}
