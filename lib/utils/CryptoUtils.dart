import 'dart:convert';

import 'package:crypto/crypto.dart';

class CryptoUtils{
  static String convertSha256(String source){
    var bytes1 = utf8.encode(source);         // data being hashed
    var digest1 = sha256.convert(bytes1);         // Hashing Process
//    print("Digest as bytes: ${digest1.bytes}");   // Print Bytes
//    print("Digest as hex string: $digest1");
    return digest1.toString();
  }
}