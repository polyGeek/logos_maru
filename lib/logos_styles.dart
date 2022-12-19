import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Styles {

  static TextStyle fixedGoogle = GoogleFonts.robotoMono(
      letterSpacing: 1.2
  );

  static const Color c_gold = Color(0xe6fca905);
  static const Color c_bone = Color(0xffFCFCFC);
  static const Color c_primaryGray = Color(0xff484848);
  static const Color c_appBGcolor = Color(0xff212121);
  static const Color c_primaryColor = Color(0xff212121);
  static const Color c_greenAccent = Color( 0xff05FC2E );
  static const Color c_redAccent = Colors.redAccent;

}

class LogosTextStyles {

  static const Color c_RPYellow       = Color(0xe6fca905);
  static const Color c_bone           = Color(0xffFCFCFC); /// For 'white' text.
  static const Color c_primaryGray    = Color(0xff484848);
  static const Color c_appBGcolor     = Color(0xff212121);
  static const Color c_primaryColor   = Color(0xff212121);
  static const Color c_greenAccent    = Color( 0xff05FC2E );
  static const Color c_redAccent      = Colors.redAccent;

  /// Note: Body MUST have a declared font size.
  TextStyle body = GoogleFonts.robotoSerif(
    color: c_bone,
    fontWeight: FontWeight.w100,
    height: 1.3,
    fontSize: 16,
  );

  /// Used for Peetimes/synopsis.
  /// Not included in Logos options for styles.
  TextStyle content = GoogleFonts.robotoSerif(
    color: c_bone,
    fontWeight: FontWeight.w100,
    height: 1.3,
    fontSize: 16,
  );

  TextStyle title = GoogleFonts.robotoSerif(
    color: c_bone,
    fontWeight: FontWeight.w500,
    fontSize: 20,
  );

  TextStyle header = GoogleFonts.robotoSerif(
    color: Styles.c_bone,
    fontWeight: FontWeight.w500,
    fontSize: 22,
  );

  TextStyle subTitle = GoogleFonts.robotoSerif(
    color: Styles.c_bone,
    fontWeight: FontWeight.w500,
    fontSize: 16,
  );

  TextStyle strong = GoogleFonts.robotoSerif(
    fontWeight: FontWeight.bold,
  );

  TextStyle boldGold = GoogleFonts.robotoSerif(
    fontWeight: FontWeight.bold,
    color: c_RPYellow,
  );

  TextStyle emphasis = GoogleFonts.robotoSerif(
    color: Styles.c_bone,
    fontStyle: FontStyle.italic,
  );

  TextStyle emGold = GoogleFonts.robotoSerif(
    color: Styles.c_gold,
    fontStyle: FontStyle.italic,
  );

  TextStyle gold = GoogleFonts.robotoSerif(
    color: Styles.c_gold,
  );

  TextStyle underline = GoogleFonts.robotoSerif(
    color: Styles.c_bone,
    decoration: TextDecoration.underline,
  );

  TextStyle error = GoogleFonts.robotoSerif(
    color: Colors.redAccent,
  );

  TextStyle btn = GoogleFonts.robotoSerif(
    color: Colors.black,
    fontWeight: FontWeight.w400,
    letterSpacing: 1.5,
    fontSize: 14,
  );

  TextStyle bodySm = GoogleFonts.robotoSerif(
    color: Styles.c_bone,
    fontWeight: FontWeight.w300,
    fontSize: 14,
  );

  TextStyle bodySub = GoogleFonts.robotoSerif(
    color: Styles.c_bone,
    fontWeight: FontWeight.w300,
    fontSize: 12,
  );

  TextStyle fixed = GoogleFonts.jetBrainsMono(
    color: Styles.c_bone,
    letterSpacing: 1.8,
    fontSize: 20,
  );

  TextStyle fixedGold = GoogleFonts.jetBrainsMono(
    color: Styles.c_gold,
    letterSpacing: 1.8,
    fontSize: 20,
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['body']          = body;
    data['title']         = title;
    data['header']        = header;
    data['subTitle']      = subTitle;
    data['strong']        = strong;
    data['emphasis']      = emphasis;
    data['emGold']        = emGold;
    data['boldGold']      = boldGold;
    data['gold']          = gold;
    data['underline']     = underline;
    data['error']         = error;
    data['btn']           = btn;
    data['bodySm']        = bodySm;
    data['fixed']         = fixed;
    data['fixedGold']     = fixedGold;
    return data;
  }
}
