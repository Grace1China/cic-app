
import 'package:church_platform/utils/RegExpUtils.dart';

class ValidateUtils{
  static String validatePWD(String value){
    if (value == null || value.isEmpty) {
      return '密码不能为空';
    }
    if (!RegExp(RegExpUtils.PWD).hasMatch(value)) {
      return '密码必须为8-20位数字和字母';
    }
    return null;
  }
}

//FormFieldValidator<String>

String ValidatePWD(String value){
  if (value == null || value.isEmpty) {
    return '密码不能为空';
  }
  if (!RegExp(RegExpUtils.PWD).hasMatch(value)) {
    return '密码必须为8-20位数字和字母';
  }
  return null;
}

String ValidateEmail(String value){
  if (value == null || value.isEmpty) {
    return '邮箱不能为空';
  }
  if (!RegExp(RegExpUtils.EMAIL).hasMatch(value)) {
    return '请输入正确邮箱';
  }
  return null;
}

String ValidateUsername(String value){
  if (value == null || value.isEmpty) {
    return '用户名不能为空';
  }
  return null;
}

String ValidateVerifyCode(String value){
  if (value == null || value.isEmpty) {
    return '验证码不能为空';
  }
  if (!RegExp(RegExpUtils.VERIFY_CODE).hasMatch(value)) {
    return '请输入6位数字验证码';
  }
  return null;
}