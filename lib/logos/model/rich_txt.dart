import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logos_maru/logos/model/adjust_font.dart';
import 'package:logos_maru/logos/model/logos_controller.dart';
import 'package:logos_maru/logos/model/txt_utilities.dart';

class Styles {
  static final Styles _styles = Styles._internal();
  factory Styles() => _styles;
  Styles._internal();

  static TextStyle fixedGoogle = GoogleFonts.robotoMono(
      letterSpacing: 1.2
  );

  static const Color c_RPYellow           = Color(0xe6fca905);
  static const Color c_bone               = Color(0xff000000);
  static const Color c_primaryColor       = Color(0xff000000);
  static const Color c_greenAccent        = Color( 0xff05FC2E ); /// Colors.lightGreenAccent;
  static const Color c_redAccent          = Colors.redAccent;      /// Color( 0xffFC05D4 );

  static const double PADDING = 10;

  static double iconSize      = 10;

  TextStyle getTxtStyle( { required String tag } ) {
    switch( tag ) {
      case 'strong':
        return TxtStyles.strong;
      case 'b':
        return TxtStyles.strong;
      case 'em':
        return TxtStyles.emphasis;
      case 'u':
        return TxtStyles.body.underline;
      case 'title':
        return TxtStyles.header.gold;
      case 'link':
        return TxtStyles.body.blue.underline;
      default:
        return TxtStyles.body;
    }
  }


  List<TextSpan> makeRichTxt( {
    required String txt,
    TextAlign textAlign = TextAlign.left,
    TextStyle? txtStyle,
  }) {


    if( txtStyle == null )
      txtStyle = TxtStyles.body;

    List<TextSpan> spans  = [];
    String tag            = '';
    String styledTxt      = '';

    while( txt.length > 0 ) {
      int n = txt.indexOf( '<' );

      if( n == -1 ) {
        spans.add( TextSpan( text: txt, style: TxtStyles.body ) );
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

        spans.add( TextSpan( text: snip, style: TxtStyles.body ) );
        spans.add( TextSpan( text: styledTxt, style: getTxtStyle( tag: tag ) ) );
      } else {
        spans.add( TextSpan( text: txt, style: TxtStyles.body ) );
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
  final TextStyle style;

  RichTxt( {
    required this.txt,
    required this.style,
    this.textAlign = TextAlign.left,
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
          txtStyle: widget.style,
          textAlign: widget.textAlign
      );

      _txtSpan = TextSpan(
        children: _spans,
        style: widget.style,
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

