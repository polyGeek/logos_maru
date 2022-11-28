import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logos_maru/logos/model/adjust_font.dart';

class LogosStyles {

  /// Note: Body MUST have a declared font size.
  static TextStyle body = GoogleFonts.cabin(
    color: Colors.white,
    fontWeight: FontWeight.w100,
    fontSize: 20 * FontSizeController().userScale,
  );

  static TextStyle title = GoogleFonts.cabin(
    color: Colors.greenAccent,
    fontWeight: FontWeight.w500,
    fontSize: 20 * FontSizeController().userScale,
  );

  static TextStyle header = GoogleFonts.cabin(
    color: Colors.purple,
    fontWeight: FontWeight.w500,
    fontSize: 18 * FontSizeController().userScale,
  );

  static TextStyle subHeader = GoogleFonts.cabin(
    color: Colors.purple,
    fontWeight: FontWeight.w500,
    fontSize: 16 * FontSizeController().userScale,
  );

  static TextStyle strong = GoogleFonts.cabin(
    color: Colors.yellowAccent,
    fontWeight: FontWeight.bold,
    fontSize: 20 * FontSizeController().userScale,
  );

  static TextStyle emphasis = GoogleFonts.cabin(
    color: Colors.redAccent,
    fontStyle: FontStyle.italic,
  );

  static TextStyle gold = GoogleFonts.cabin(
    color: Colors.orangeAccent,
  );

  static TextStyle underline = GoogleFonts.cabin(
    color: Colors.pink,
    decoration: TextDecoration.underline,
  );

  static TextStyle error = GoogleFonts.cabin(
    color: Colors.redAccent,
  );

  ///____________________

  static TextStyle bodySm = GoogleFonts.cabin(
    color: Colors.yellowAccent,
    fontWeight: FontWeight.w300,
    fontSize: 10 * FontSizeController().userScale,
  );

  static TextStyle fixedGoogle = GoogleFonts.jetBrainsMono(
    color: Colors.blue,
    letterSpacing: 1.8,
    fontSize: 30 * FontSizeController().userScale,
  );

  static TextStyle titleLight = GoogleFonts.cabin(
    color: Colors.red,
    fontWeight: FontWeight.w100,
    fontSize: 20 * FontSizeController().userScale,
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['body']          = LogosStyles.body;
    data['title']         = LogosStyles.title;
    data['header']        = LogosStyles.header;
    data['subHeader']     = LogosStyles.subHeader;
    data['strong']        = LogosStyles.strong;
    data['emphasis']      = LogosStyles.emphasis;
    data['gold']          = LogosStyles.gold;
    data['underline']     = LogosStyles.underline;
    data['error']         = LogosStyles.error;

    data['bodySm']        = LogosStyles.bodySm;
    data['titleLight']    = LogosStyles.titleLight;
    return data;
  }
}