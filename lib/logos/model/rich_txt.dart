import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logos_maru/logos/model/adjust_font.dart';
import 'package:logos_maru/logos/model/logos_controller.dart';
import 'package:logos_maru/logos/model/logos_vo.dart';
import 'package:logos_maru/logos/model/txt_utilities.dart';

class Styles {
  static final Styles _styles = Styles._internal();
  factory Styles() => _styles;
  Styles._internal();

  static const Color c_RPYellow           = Color(0xe6fca905);
  static const Color c_bone               = Color(0xff000000);
  static const Color c_greenAccent        = Color( 0xff05FC2E ); /// Colors.lightGreenAccent;
  static const Color c_redAccent          = Colors.redAccent;    /// Color( 0xffFC05D4 );

  static double iconSize      = 10;

  List<TextSpan> makeRichTxt( {
    required String txt,
    required TextStyle txtStyle,
    TextAlign textAlign = TextAlign.left,
  }) {

    List<TextSpan> spans  = [];
    String tag            = '';
    String styledTxt      = '';

    while( txt.length > 0 ) {
      int n = txt.indexOf( '<' );

      if( n == -1 ) {
        spans.add( TextSpan( text: txt, style: txtStyle ) );
        return spans;
      }

      String snip = txt.substring( 0, n );

      txt = txt.substring( n );

      if( n > -1 ) {
        tag = txt.substring( 1, txt.indexOf( '>' ) );
        txt = txt.substring( tag.length + 2 ); /// Adding 2 for the opening and closing <>.

        int endTag = txt.indexOf( '</' + tag + '>' );

        if( endTag > 0 ) {
          styledTxt = txt.substring( 0, endTag ); /// text up to the closing tag.
        } else {
          styledTxt = txt.substring( 0, txt.length ); /// text up to the closing tag.
        }

        int positionOfEndTag = styledTxt.length + tag.length + 3;
        if( positionOfEndTag <= txt.length ) {
          txt = txt.substring( positionOfEndTag );
        } else {
          txt = '';
        }

        spans.add( TextSpan( text: snip, style: txtStyle ) );
        spans.add( TextSpan( text: styledTxt, style: LogosVO.getStyle( style: tag ).merge( txtStyle )  ) );
      } else {
        spans.add( TextSpan( text: txt, style: txtStyle ) );
        return spans;
      }

    }

    return spans;
  }
}

class RichTxt extends StatefulWidget {
  final String txt;
  final TextAlign textAlign;
  final int maxLines;
  final TextStyle txtStyle;

  RichTxt( {
    required this.txt,
    required this.txtStyle,
    this.textAlign = TextAlign.start,
    this.maxLines = 10000 } );

  @override
  _RichTxtState createState() => _RichTxtState();
}

class _RichTxtState extends State<RichTxt> {

  List<TextSpan>  _spans = [];

  TextSpan _txtSpan = TextSpan(
    children: null,
    style: null,
  );

  @override
  void initState() {
    super.initState();

    _txtSpan = TextSpan(
      children: null,
      style: widget.txtStyle,
    );

    print( 'RichTxt TextStyle:  ' + widget.txtStyle.toString() );

    FontSizeController().addListener( _update );
    LogosController().addListener( refresh );
    _update();
  }

  @override
  void dispose() {
    FontSizeController().removeListener( _update );
    LogosController().removeListener( refresh );
    super.dispose();
  }

  void _update() {
    if( mounted ) {
      _spans = Styles().makeRichTxt(
          txt: widget.txt,
          txtStyle: widget.txtStyle,
          textAlign: widget.textAlign,
      );

      _txtSpan = TextSpan(
        children: _spans,
        style: widget.txtStyle,
      );
      setState(() {});

    }
  }

  void refresh() {

    Future.delayed( const Duration( milliseconds: 50 ), () {
      _update();
    } );

  }

  @override
  Widget build( BuildContext context ) {
    return RichText(
      maxLines: widget.maxLines,
      overflow: TextOverflow.ellipsis,
      text: _txtSpan,
      textAlign: widget.textAlign,
    );
  }
}

