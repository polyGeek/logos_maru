import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LogosStyles {

  static TextStyle fixedGoogle = GoogleFonts.robotoMono(
      letterSpacing: 1.2,
      fontSize: 20,
  );

  static TextStyle title = TextStyle(
    fontFamily: 'RobotoMono',
    fontWeight: FontWeight.w500,
    fontSize: 20,
  );

  static const TextStyle titleLight = TextStyle(
    color: Colors.red,
    fontWeight: FontWeight.w100,
    fontSize: 20,
  );

  static const TextStyle header = TextStyle(
    color: Colors.yellowAccent,
    fontWeight: FontWeight.w500,
    fontSize: 18,
  );

  static const TextStyle body = TextStyle(
    color: Colors.yellowAccent,
    fontWeight: FontWeight.w300,
    fontSize: 16,
  );

  static const TextStyle bodySm = TextStyle(
    color: Colors.yellowAccent,
    fontWeight: FontWeight.w300,
    fontSize: 10,
  );

  static const TextStyle strong = TextStyle(
    color: Colors.yellowAccent,
    fontWeight: FontWeight.bold,
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title']         = LogosStyles.title;
    data['titleLight']    = LogosStyles.titleLight;
    data['header']        = LogosStyles.header;
    data['body']          = LogosStyles.body;
    data['bodySm']        = LogosStyles.bodySm;

    data['strong']        = LogosStyles.strong;
    return data;
  }
}