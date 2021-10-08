import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

class CodecUtil {

  static String getMd5(String data) {
    var bytes = utf8.encode(data);
    var digest = md5.convert(bytes).toString();
    return digest;
  }
}