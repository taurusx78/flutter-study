import 'dart:convert';

import 'package:flutter_delivery_app/common/const/data.dart';

class DataUtils {
  static String pathToUrl(String value) {
    return 'http://$ip$value';
  }

  static List<String> listPathToUrls(List values) {
    return values.map((e) => pathToUrl(e)).toList();
  }

  // 문자열을 Base 64로 인코딩하는 함수
  static String plainToBase64(String plain) {
    // 문자열을 Base64로 변환
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(plain);
    return encoded;
  }
}
