import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logos_maru/logos/model/adjust_font.dart';
import 'package:logos_maru/logos/model/rich_txt.dart';

class LogosAdminTxtStyles {

  static TextStyle body = GoogleFonts.robotoMono(
    letterSpacing: 1.2,
    fontSize: 20 * FontSizeController().userScale,
    //fontWeight: FontWeight.w300,
    height: 1.3,
  ).white;

  static TextStyle get btn =>
      body.copyWith( fontSize: FontSizeController().userScale * 16 ).black.bold;

  static TextStyle get btnSub =>
      body.copyWith( fontSize: FontSizeController().userScale * 14 ).white;

  static TextStyle get title =>
      body.copyWith( fontSize: FontSizeController().userScale * 22 ).bold;




}


extension LogosAdminTextStyleHelpers on TextStyle {
  TextStyle get bold          => copyWith( fontWeight: FontWeight.bold );
  //TextStyle get boldHeavy     => copyWith( fontWeight: FontWeight.w900 );
  //TextStyle get boldMild      => copyWith( fontWeight: FontWeight.w500 );
  //TextStyle get boldLight     => copyWith( fontWeight: FontWeight.w100 );
  TextStyle get gold          => copyWith( color: Styles.c_RPYellow );
  TextStyle get black         => copyWith( color: Colors.black87 );
  TextStyle get white         => copyWith( color: Colors.white );
  TextStyle get offWhite      => copyWith( color: Colors.white70 );

  //TextStyle get heading       => copyWith( fontSize: 28 * FontSizeController().userScale );
  //TextStyle get big           => copyWith( fontSize: FontSizeController().userScale * 20 );
  //TextStyle get body          => copyWith( fontSize: FontSizeController().userScale * 16);
  TextStyle get small         => copyWith( fontSize: FontSizeController().userScale * 14 );
  //TextStyle get subSmall      => copyWith( fontSize: FontSizeController().userScale * 12 );
  TextStyle get italic        => copyWith( fontStyle: FontStyle.italic );
  //TextStyle get underline     => copyWith( decoration: TextDecoration.underline );
  //TextStyle get spacedOut     => copyWith( letterSpacing: 1.5 );
  //TextStyle get enabled       => copyWith( color: Colors.lightGreenAccent );
  //TextStyle get disabled      => copyWith( color: Colors.redAccent );
  //TextStyle get light         => copyWith( fontWeight: FontWeight.w100 );

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