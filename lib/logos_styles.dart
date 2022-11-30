import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logos_maru/logos/model/logos_controller.dart';

class LogosTextStyles {

  /// Note: Body MUST have a declared font size.
  TextStyle body = GoogleFonts.cabin(
    color: Colors.white,
    fontWeight: FontWeight.w100,
    fontSize: 20,
  );

  TextStyle title = GoogleFonts.cabin(
    color: Colors.greenAccent,
    fontWeight: FontWeight.w500,
    fontSize: 30,
  );

  TextStyle header = GoogleFonts.cabin(
    color: Colors.purple,
    fontWeight: FontWeight.w500,
    fontSize: 30,
  );

  TextStyle subHeader = GoogleFonts.cabin(
    color: Colors.purple,
    fontWeight: FontWeight.w500,
    fontSize: 26,
  );

  TextStyle strong = GoogleFonts.cabin(
    color: Colors.yellowAccent,
    fontWeight: FontWeight.bold,
  );

  TextStyle emphasis = GoogleFonts.cabin(
    color: Colors.redAccent,
    fontStyle: FontStyle.italic,
  );

  TextStyle gold = GoogleFonts.cabin(
    color: Colors.orangeAccent,
  );

  TextStyle underline = GoogleFonts.cabin(
    color: Colors.pink,
    decoration: TextDecoration.underline,
  );

  TextStyle error = GoogleFonts.cabin(
    color: Colors.redAccent,
  );

  ///____________________

  TextStyle bodySm = GoogleFonts.cabin(
    color: Colors.yellowAccent,
    fontWeight: FontWeight.w300,
    fontSize: 16,
  );

  TextStyle fixedGoogle = GoogleFonts.jetBrainsMono(
    color: Colors.blue,
    letterSpacing: 1.8,
    fontSize: 22,
  );

  TextStyle titleLight = GoogleFonts.cabin(
    fontWeight: FontWeight.w100,
    fontSize: 26,
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['body']          = LogosController().logosFontStyles!.body;
    data['title']         = LogosController().logosFontStyles!.title;
    data['header']        = LogosController().logosFontStyles!.header;
    data['subHeader']     = LogosController().logosFontStyles!.subHeader;
    data['strong']        = LogosController().logosFontStyles!.strong;
    data['emphasis']      = LogosController().logosFontStyles!.emphasis;
    data['gold']          = LogosController().logosFontStyles!.gold;
    data['underline']     = LogosController().logosFontStyles!.underline;
    data['error']         = LogosController().logosFontStyles!.error;

    data['bodySm']        = LogosController().logosFontStyles!.bodySm;
    data['titleLight']    = LogosController().logosFontStyles!.titleLight;
    return data;
  }
}