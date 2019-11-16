import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtils{
  static saveIsLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('CP_ISLOGIN', true);
  }

  static Future<bool> isLogin() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool b =  await prefs.getBool("CP_ISLOGIN");
    return b ?? false;
  }

  static logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('CP_ISLOGIN', false);
  }

}


