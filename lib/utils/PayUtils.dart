import 'package:church_platform/net/CourseResponse.dart';
import 'package:flutter/foundation.dart';

class PayUtils{
  pay(Course course){
    if(defaultTargetPlatform == TargetPlatform.iOS){
      if(course.iapCharge != null){

      }else{
        //错误；
      }
    }else{
      //android支付
    }
  }
}