
//https://www.jianshu.com/p/33ccf516ed6a
class RegExpUtils{
  static const EMAIL = r'^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$';
  //中国手机号
  static const PHONE = r"^1([38][0-9]|4[579]|5[0-3,5-9]|6[6]|7[0135678]|9[89])\d{8}$";
  static const URL = r"^((https|http|ftp|rtsp|mms)?:\/\/)[^\s]+";
  //身份证
  static const IDENTITY_CODE = r"\d{17}[\d|x]|\d{15}";
  //中文
  static const CHINESE = r"[\u4e00-\u9fa5]";
  //密码：数字和字母,8-20位
  static const PWD = r"^[ZA-ZZa-z0-9_]{8,20}$";
  //数字和小写字母
  static const PWD2 = r"^[Za-z0-9_]+$";
  static const XXX = r"^[\u4E00-\u9FA5A-Za-z0-9_]+$";
  static const VERIFY_CODE = r"^[0-9]{6}$";
}