import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class SharedPreferencesUtils{
  static saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('CP_TOKEN', token);
  }

  static Future<String> getToken() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return  prefs.getString("CP_TOKEN");
  }

  static Future<bool> isLogin() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token =  prefs.getString("CP_TOKEN");
    return token != null && token.isNotEmpty;
  }

  static Future<bool> logout() async {
//    SharedPreferences.getInstance().then((prefs){
//      prefs.setString('CP_TOKEN', null);
//    }).whenComplete((){
//      return true;
//    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString('CP_TOKEN', null);
  }


}


