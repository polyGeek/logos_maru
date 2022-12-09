import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logos_maru/logos/model/adjust_font.dart';

class LogosAdminTxtStyles {

  static TextStyle body = GoogleFonts.robotoMono(
    letterSpacing: 1.2,
    fontSize: (20 + FontSizeController().fontSizeAdjustment).toDouble(),
    height: 1.3,
  ).white;

  static TextStyle bodySm = GoogleFonts.robotoMono(
    letterSpacing: 1.2,
    fontSize: (18 + FontSizeController().fontSizeAdjustment).toDouble(),
    height: 1.3,
  ).white;

  static TextStyle get btn =>
      body.copyWith( fontSize: FontSizeController().fontSizeAdjustment + 16 ).black.bold;

  static TextStyle get btnSub =>
      body.copyWith( fontSize: FontSizeController().fontSizeAdjustment + 14 ).white;

  static TextStyle get title =>
      body.copyWith( fontSize: FontSizeController().fontSizeAdjustment + 22 ).bold;




}


extension LogosTextStyleEx on TextStyle {
  /// Weight/Style/Decoration
  TextStyle get bold          => copyWith( fontWeight: FontWeight.bold );
  TextStyle get boldHeavy     => copyWith( fontWeight: FontWeight.w900 );
  TextStyle get boldMild      => copyWith( fontWeight: FontWeight.w500 );
  TextStyle get boldLight     => copyWith( fontWeight: FontWeight.w100 );
  TextStyle get italic        => copyWith( fontStyle: FontStyle.italic );
  TextStyle get underline     => copyWith( decoration: TextDecoration.underline );

  /// Color
  TextStyle get gold          => copyWith( color: Color( 0xe6fca905 ) );
  TextStyle get black         => copyWith( color: Colors.black );
  TextStyle get white         => copyWith( color: Colors.white );
  TextStyle get offWhite      => copyWith( color: Colors.white70 );

  TextStyle get enabled       => copyWith( color: Colors.lightGreenAccent );
  TextStyle get disabled      => copyWith( color: Colors.redAccent );

  /// Spacing
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