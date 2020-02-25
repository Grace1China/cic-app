
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';


class IAPUnCompletePurchaseStore {

  //com.churchplatform.iap.map {
  //  com.churchplatform.iap.aaaaa,
  //  com.churchplatform.iap.bbbbb,
  //  com.churchplatform.iap.ccccc,
  //}
  static const String PREFIX_MAP = 'com.churchplatform.iap.map';

  //com.churchplatform.iap.aaaaa,courseid
  //com.churchplatform.iap.aaaaa,coursename
  //com.churchplatform.iap.aaaaa,courseprice
  static String PREFIX = "com.churchplatform.iap.";
  static Future<void> save(String purchaseID,String courseID,String courseName,String coursePrice) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(PREFIX + purchaseID + ".courseid", courseID);
    await prefs.setString(PREFIX + purchaseID + ".coursename", courseName);
    await prefs.setString(PREFIX + purchaseID + ".courseprice", coursePrice);
    await _saveList(PREFIX + purchaseID);
  }

  static Future<void> remove(String purchaseID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(PREFIX + purchaseID + ".courseid");
    await prefs.remove(PREFIX + purchaseID + ".coursename");
    await prefs.remove(PREFIX + purchaseID + ".courseprice");
    await _removeList(PREFIX + purchaseID);
  }

  static Future<bool> has(String purchaseID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> list = prefs.getStringList(PREFIX_MAP) ?? [];
    return list.contains(PREFIX + purchaseID);
  }

  static Future<void> _saveList(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cached = prefs.getStringList(PREFIX_MAP) ?? [];
    if(!cached.contains(key)){
      cached.add(key);
    }
    await prefs.setStringList(PREFIX_MAP, cached);
  }

  static Future<void> _removeList(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cached = prefs.getStringList(PREFIX_MAP) ?? [];
    if(cached.contains(key)){
      cached.remove(key);
    }
    await prefs.setStringList(PREFIX_MAP, cached);
  }
  //  {
  //    aaaaa {
  //       courseid:   xxx,
  //       coursename: xxxx,
  //       courseprice:xxxx, //iap rmb price
  //    }
  //    bbbbb{...}
  //    ccccc{...}
  //  }
  static Future<Map<String,Map<String,String>>> loadMap() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cached = prefs.getStringList(PREFIX_MAP) ?? [];

    Map<String,Map<String,String>> resultMap = Map<String,Map<String,String>>();

    cached.forEach((String key){
      Map<String,String> oneCourseMap = Map<String,String>();
      oneCourseMap["courseid"] = prefs.getString(key + ".courseid");
      oneCourseMap["coursename"] = prefs.getString(key + ".coursename");
      oneCourseMap["courseprice"] = prefs.getString(key + ".courseprice");
      resultMap[key.replaceAll(PREFIX, "")] = oneCourseMap;
    });
    return resultMap;
  }
}
