//import 'package:logger/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


//Logger Log;
//
//InitLogger(){
//  Logger.level = Level.debug;
////  Log = Logger(
////    printer: PrettyPrinter(
////        methodCount: 2, // number of method calls to be displayed
////        errorMethodCount: 8, // number of method calls if stacktrace is provided
////        lineLength: 120, // width of the output
////        colors: true, // Colorful log messages
////        printEmojis: true, // Print an emoji for each log message
////        printTime: false // Should each log print contain a timestamp
////    ),
////  );
//
//  Log = Logger(
//    printer: PrettyPrinter(methodCount: 0,printTime: true),
//  );
//
//}
class Log{
  static i(String message){
//    final log = Logger('MyClassName');
//    log.info(message);
//    developer.log(message);
    debugPrint(message);
//    print(message);
  }
  static d(String message){
//    final log = Logger('MyClassName');
//    log.info(message);
//    developer.log(message);
    debugPrint(message);
//    print(message);
  }
  static v(String message){
    debugPrint(message);
//    print(message);
  }
}
