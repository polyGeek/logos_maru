import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class LogosTextStyles {

  /// Note: Body MUST have a declared font size.
  TextStyle body = GoogleFonts.robotoSerif(
    color: Colors.greenAccent,//Styles.c_bone,
    fontWeight: FontWeight.w100,
    height: 1.3,
    fontSize: 16,
  );

  TextStyle content = GoogleFonts.robotoSerif(
    color: Colors.white,
    fontWeight: FontWeight.w100,
    height: 1.3,
    fontSize: 16,
  );

  TextStyle bodySm = GoogleFonts.robotoSerif(
    color: Colors.purpleAccent,// Styles.c_bone,
    fontWeight: FontWeight.w300,
    fontSize: 10,
  );

  TextStyle title = GoogleFonts.robotoSerif(
    color: Colors.white70,
    fontWeight: FontWeight.w500,
    fontSize: 20,
  );

  TextStyle header = GoogleFonts.robotoSerif(
    color: Colors.white70,
    fontWeight: FontWeight.w500,
    fontSize: 28,
  );

  TextStyle subHeader = GoogleFonts.robotoSerif(
    color: Colors.white70,
    fontWeight: FontWeight.w500,
    fontSize: 16,
  );

  TextStyle strong = GoogleFonts.robotoSerif(
    //color: Styles.c_bone,
    fontWeight: FontWeight.bold,
    //fontSize: 16,
  );

  TextStyle emphasis = GoogleFonts.robotoSerif(
    color: Colors.white70,
    fontStyle: FontStyle.italic,
  );

  TextStyle gold = GoogleFonts.robotoSerif(
    color: Colors.orangeAccent,
  );

  TextStyle underline = GoogleFonts.robotoSerif(
    color: Colors.white70,
    decoration: TextDecoration.underline,
  );

  TextStyle error = GoogleFonts.robotoSerif(
    color: Colors.redAccent,
  );

  TextStyle btn = GoogleFonts.roboto(
    color: Colors.black,
    fontWeight: FontWeight.w400,
    letterSpacing: 1.5,
    fontSize: 14,
  );

  /*TextStyle titleLight = GoogleFonts.robotoSerif(
    color: Styles.c_bone,
    fontWeight: FontWeight.w100,
    fontSize: 20,
  );*/

  TextStyle fixed = GoogleFonts.jetBrainsMono(
    color: Colors.white70,
    letterSpacing: 1.8,
    fontSize: 30,
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['body']          = body;
    data['title']         = title;
    data['header']        = header;
    data['subHeader']     = subHeader;
    data['strong']        = strong;
    data['emphasis']      = emphasis;
    data['gold']          = gold;
    data['underline']     = underline;
    data['error']         = error;
    data['btn']        = btn;
    data['bodySm']        = bodySm;
    //data['titleLight']    = titleLight;
    data['fixed']         = fixed;
    return data;
  }
}


/*
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
}*/
