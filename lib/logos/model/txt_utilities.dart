import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logos_maru/logos/model/adjust_font.dart';

class LogosAdminTxtStyles {

  static TextStyle body = GoogleFonts.robotoMono(
    letterSpacing: 1.2,
    fontSize: (20 + FontSizeController().fontSizeAdjustment).toDouble(),
    //fontWeight: FontWeight.w300,
    height: 1.3,
  ).white;

  static TextStyle get btn =>
      body.copyWith( fontSize: FontSizeController().fontSizeAdjustment + 16 ).black.bold;

  static TextStyle get btnSub =>
      body.copyWith( fontSize: FontSizeController().fontSizeAdjustment + 14 ).white;

  static TextStyle get title =>
      body.copyWith( fontSize: FontSizeController().fontSizeAdjustment + 22 ).bold;




}


extension LogosAdminTextStyleHelpers on TextStyle {
  TextStyle get bold          => copyWith( fontWeight: FontWeight.bold );
  TextStyle get gold          => copyWith( color: Colors.orangeAccent );
  TextStyle get black         => copyWith( color: Colors.black87 );
  TextStyle get white         => copyWith( color: Colors.white );
  TextStyle get offWhite      => copyWith( color: Colors.white70 );
  TextStyle get small         => copyWith( fontSize: FontSizeController().fontSizeAdjustment + 14 );
  TextStyle get italic        => copyWith( fontStyle: FontStyle.italic );
  TextStyle letterSpace( double v ) => copyWith( letterSpacing: v );
}

class LogosAdminWidgetStyles {

  static final LogosAdminWidgetStyles _logosAdminWidgetStyles = LogosAdminWidgetStyles._internal();
  factory LogosAdminWidgetStyles() => _logosAdminWidgetStyles;
  LogosAdminWidgetStyles._internal();

  ButtonStyle elevatedBtnStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.green,
    textStyle: LogosAdminTxtStyles.body.black,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular( 8 ),
    ),
  );

  ButtonStyle outlineBtnStyle = ElevatedButton.styleFrom(
    textStyle: LogosAdminTxtStyles.body.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular( 8 ),
      side: BorderSide( color: Colors.white, width: 2 ),
    ),
  );
}