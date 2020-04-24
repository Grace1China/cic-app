import 'package:logger/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//var logger = Logger(
//  printer: PrettyPrinter(),
//);

var logger = Logger(
  printer: PrettyPrinter(
      methodCount: 2, // number of method calls to be displayed
      errorMethodCount: 8, // number of method calls if stacktrace is provided
      lineLength: 120, // width of the output
      colors: true, // Colorful log messages
      printEmojis: true, // Print an emoji for each log message
      printTime: false // Should each log print contain a timestamp
  ),
);


var loggerNoStack = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

void main() {

  runApp(MaterialApp(home: LoggerDemoWidget(),));
}

void demo() {
  print("Run with either `dart example/lib/main.dart` or `dart --enable-asserts example/lib/main.dart`.");

  logger.d("Log message with 2 methods");

  loggerNoStack.i("Info message");

  loggerNoStack.w("Just a warning!");

  logger.e("Error! Something bad happened", "Test Error");

  loggerNoStack.v({"key": 5, "value": "something"});

//  Logger(printer: SimplePrinter().useColor = true).v("boom");
  Logger(printer: SimplePrinter()).v("boom");
}


class LoggerDemoWidget extends StatefulWidget {
  @override
  _LoggerDemoWidgetState createState() => _LoggerDemoWidgetState();
}


class _LoggerDemoWidgetState extends State<LoggerDemoWidget> {

  @override
  void initState() {
    super.initState();
//    post = fetchPost();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Login Demo'),
        //centerTitle: true,
        elevation:
        (Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0),
      ),
      body: Center(
//        width: MediaQuery.of(context).size.width,
        child: RaisedButton(
            onPressed: () {
              demo();
//              Navigator.push(
//                context,
//                new MaterialPageRoute(
//                  builder: (context) => new SpiritualDetailsWidget(),
//                ),
//              );
            },
            child: Text('Logger 测试',
                style: new TextStyle(
                    color: Colors.white)),
            color: Theme.of(context).accentColor
        ),

      ),

    );
  }
}
