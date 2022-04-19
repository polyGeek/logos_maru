import 'package:flutter/material.dart';
import 'package:logos_maru/logos/model/adjust_font.dart';
import 'package:logos_maru/logos/model/rich_txt.dart';


class MyFontTypes {
  static String get body => "Lato";
  static String get title => "Roboto";
}

class TxtStyles {
  static TextStyle get bodyFont => TextStyle( fontFamily: MyFontTypes.body );

  static TextStyle get inputTxtFont => TextStyle( fontFamily: 'RobotoMono' );

  static TextStyle get body => bodyFont.copyWith(
    fontSize: FontSizeController().bodySize,
    fontWeight: FontWeight.w300,
    height: 1.3,
    color: Colors.white,
  );

  static TextStyle get bodySm =>
      body.copyWith( fontSize: FontSizeController().bodySize ).small;

  static TextStyle get btn =>
      body.copyWith( fontSize: FontSizeController().bodySize ).small.black.boldMild;

  static TextStyle get bodySubSmall =>
      body.copyWith( fontSize: FontSizeController().bodySubSm );

  static TextStyle get subHeader =>
      body.copyWith( fontSize: FontSizeController().subHeading );

  static TextStyle get titleFont =>
      TextStyle( fontFamily: MyFontTypes.title );

  static TextStyle get title =>
      titleFont.copyWith( fontSize: FontSizeController().title );

  static TextStyle get titleLight =>
      title.copyWith( fontWeight: FontWeight.w100 );

  static TextStyle get header =>
      title.copyWith( fontSize: FontSizeController().heading, fontWeight: FontWeight.w500 );


  static TextStyle get strong =>
      title.copyWith( fontSize: FontSizeController().bodySize, fontWeight: FontWeight.bold, color: Colors.white );

  static TextStyle get emphasis =>
      title.copyWith( fontSize: FontSizeController().bodySize, fontStyle: FontStyle.italic );
}


extension TextStyleHelpers on TextStyle {
  TextStyle get bold          => copyWith( fontWeight: FontWeight.bold );
  TextStyle get boldHeavy     => copyWith( fontWeight: FontWeight.w900 );
  TextStyle get boldMild      => copyWith( fontWeight: FontWeight.w500 );
  TextStyle get boldLight     => copyWith( fontWeight: FontWeight.w100 );
  TextStyle get gold          => copyWith( color: Styles.c_RPYellow );
  TextStyle get green         => copyWith( color: Styles.c_greenAccent);
  TextStyle get black         => copyWith( color: Colors.black87 );
  TextStyle get red           => copyWith( color: Styles.c_redAccent );
  TextStyle get blue           => copyWith( color: Colors.blue );
  TextStyle get bone          => copyWith( color: Styles.c_bone );
  TextStyle get error         => copyWith( color: Colors.redAccent );
  TextStyle get heading       => copyWith( fontSize: FontSizeController().heading );
  TextStyle get big           => copyWith( fontSize: FontSizeController().bodySize + 4 );
  TextStyle get body          => copyWith( fontSize: FontSizeController().bodySize );
  TextStyle get small         => copyWith( fontSize: FontSizeController().bodySize - 2 );
  TextStyle get subSmall      => copyWith( fontSize: FontSizeController().bodySize - 4 );
  TextStyle get italic        => copyWith( fontStyle: FontStyle.italic );
  TextStyle get underline     => copyWith( decoration: TextDecoration.underline );
  TextStyle get secsLineHeight=> copyWith( height: 1.4 );
  TextStyle get spacedOut     => copyWith( letterSpacing: 1.5 );
  TextStyle get enabled       => copyWith( color: Colors.lightGreenAccent );
  TextStyle get disabled      => copyWith( color: Colors.redAccent );
  TextStyle get light         => copyWith( fontWeight: FontWeight.w100 );


  TextStyle letterSpace( double v ) => copyWith( letterSpacing: v );
}
