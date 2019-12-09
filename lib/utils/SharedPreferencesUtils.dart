import 'package:shared_preferences/shared_preferences.dart';

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

  static logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('CP_TOKEN', null);
  }


}


