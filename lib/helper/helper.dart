import 'dart:convert';

import 'package:crypto/crypto.dart';

class Helper {
  static String publicKey = "";
  static String privateKey = "";
}

String gerarHash() {
  var inputToHash = "${timestamp}${Helper.privateKey}${Helper.publicKey}";
  var hasConverted = md5.convert(utf8.encode(inputToHash)).toString();

  return hasConverted;
}

var timestamp = DateTime.now().millisecondsSinceEpoch.toString();

String urlFinal = "http://gateway.marvel.com/v1/public/characters?ts=${timestamp}&apikey=${Helper.publicKey}&hash=${gerarHash()}";