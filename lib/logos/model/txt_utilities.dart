import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logos_maru/logos/model/adjust_font.dart';

class LogosAdminTxtStyles {

  static TextStyle body = GoogleFonts.robotoMono(
    letterSpacing: 1.2,
    fontSize: (20 + LogosFontSizeController().fontSizeAdjustment).toDouble(),
    height: 1.3,
  ).logos_white;

  static TextStyle bodySm = GoogleFonts.robotoMono(
    letterSpacing: 1.2,
    fontSize: (18 + LogosFontSizeController().fontSizeAdjustment).toDouble(),
    height: 1.3,
  ).logos_white;

  static TextStyle label = GoogleFonts.robotoMono(
    letterSpacing: 1.2,
    fontSize: ( 12 + LogosFontSizeController().fontSizeAdjustment).toDouble(),
    height: 1.2,
  ).logos_white;

  static TextStyle get btn =>
      body.copyWith( fontSize: LogosFontSizeController().fontSizeAdjustment + 16 ).logos_black.logos_bold;

  static TextStyle get btnSub =>
      body.copyWith( fontSize: LogosFontSizeController().fontSizeAdjustment + 14 ).logos_white;

  static TextStyle get title =>
      body.copyWith( fontSize: LogosFontSizeController().fontSizeAdjustment + 22 ).logos_bold;




}


extension LogosTextStyleEx on TextStyle {
  /// Weight/Style/Decoration
  TextStyle get logos_bold          => copyWith( fontWeight: FontWeight.bold );
  TextStyle get logos_boldHeavy     => copyWith( fontWeight: FontWeight.w900 );
  TextStyle get logos_boldMild      => copyWith( fontWeight: FontWeight.w500 );
  TextStyle get logos_boldLight     => copyWith( fontWeight: FontWeight.w100 );
  TextStyle get logos_italic        => copyWith( fontStyle: FontStyle.italic );
  TextStyle get logos_underline     => copyWith( decoration: TextDecoration.underline );

  /// Color
  TextStyle get logos_gold          => copyWith( color: Color( 0xe6fca905 ) );
  TextStyle get logos_black         => copyWith( color: Colors.black );
  TextStyle get logos_white         => copyWith( color: Colors.white );
  TextStyle get logos_offWhite      => copyWith( color: Colors.white70 );

  TextStyle get logos_enabled       => copyWith( color: Colors.lightGreenAccent );
  TextStyle get logos_disabled      => copyWith( color: Colors.redAccent );

  /// Spacing
  TextStyle letterSpace( double v ) => copyWith( letterSpacing: v );
}

class LogosAdminWidgetStyles {

  static final LogosAdminWidgetStyles _logosAdminWidgetStyles = LogosAdminWidgetStyles._internal();
  factory LogosAdminWidgetStyles() => _logosAdminWidgetStyles;
  LogosAdminWidgetStyles._internal();

  ButtonStyle elevatedBtnStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.green,
    textStyle: LogosAdminTxtStyles.body.logos_black,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular( 8 ),
    ),
  );

  ButtonStyle outlineBtnStyle = ElevatedButton.styleFrom(
    textStyle: LogosAdminTxtStyles.body.logos_white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular( 8 ),
      side: BorderSide( color: Colors.white, width: 2 ),
    ),
  );
}