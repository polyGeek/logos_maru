import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logos_maru/logos/model/adjust_font.dart';
import 'package:logos_maru/logos/model/logos_controller.dart';
import 'package:logos_maru/logos/model/txt_utilities.dart';

class Styles {


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

  static TextStyle getTxtStyle( { required String tag } ) {
    switch( tag ) {
      case 'strong':
        return TxtStyles.strong;
      case 'b':
        return TxtStyles.strong;
      case 'em':
        return TxtStyles.emphasis;
      default:
        return TxtStyles.body;
    }
  }


  static List<TextSpan> makeRichTxt( {
    required String txt,
    TextAlign textAlign = TextAlign.left,
    TextStyle? txtStyle,
  }) {

    /**
     * 	*Italics*
     * 	^Bold^
     * 	_underline_
     * 	>Big>
     *  <small<
     * 	§Big-Italic§

     * 	more to use: þ Ø × ¿ « » ± œ ƒ
     */

    String c          = '';
    String subString  = '';
    bool isItalic     = false;
    bool isBold       = false;
    bool isGold       = false;
    bool isBig        = false;
    bool isBigItalic  = false;
    bool isSmall      = false;
    bool isUnderline  = false;
    bool isBigBoldGold= false;
    bool isGoldItalic = false;
    bool isFixed      = false;
    TextSpan ts;

    if( txtStyle == null )
      txtStyle = TxtStyles.body;

    List<TextSpan> spans = [];

    //<[^>]+>\s+(?=<)|<[^>]+>
    //<(\S*?)[^>]>.?</\1>|<.*?/>

    // This is <b>bold</b> text.
    /*for ( int i = 0; i < txt.length; i++ ) {

    }*/

    int loopCount = 4;
    String tag = '';
    int tagLen = 0;
    String styledTxt = '';

    while( txt.length > 0 ) {
      loopCount--;
      int n = txt.indexOf( '<' );
      print( '10-n: ' + n.toString() );

      if( n == -1 ) {
        spans.add( TextSpan( text: txt, style: TxtStyles.body ) );
        return spans;
      }

      String snip = txt.substring( 0, n );
      print( '20-snip: ' + snip );

      txt = txt.substring( n );
      print( '30-txt: ' + txt );

      ///txt: 'This is <strong>some bold text</strong> text. This is <em>italics</em> text. This is <tag>something</tag>',
      if( n > 0 ) {
        tag = txt.substring( 1, txt.indexOf( '>' ) );
        print( '40-tag: ' + tag );
        txt = txt.substring( tag.length + 2 ); /// Adding 2 for the opening and closing <>.
        print( '50-txt: ' + txt );
        styledTxt = txt.substring( 0, txt.indexOf( '</' + tag + '>' ) ); /// text up to the closing tag.
        print( '60-styledTxt: ' + styledTxt );
        txt = txt.substring( styledTxt.length + tag.length + 3 );
        print( '70-remaining: ' + txt );

        spans.add( TextSpan( text: snip, style: TxtStyles.body ) );
        spans.add( TextSpan( text: styledTxt, style: getTxtStyle( tag: tag ) ) );
      } else {
        spans.add( TextSpan( text: txt, style: TxtStyles.body ) );
        return spans;
      }

      print( '============================');
      if( loopCount == 0 )
        break;
    }

    print( 'ooooooooooooooooooooooooooooooooooooooooo');
    print( spans.toString() );


    return spans;

    for ( int i = 0; i < txt.length; i++ ) {



      /// KEEP
      if( txt[ i ] == '~' ) {
        print( 'skipping: ' + i.toString() + ' : ' + txt.codeUnitAt(i).toString());
        subString += txt[ i+1 ];
        i+=2; /// skip over if escaped.
        if( i == txt.length ) {
          spans.add( TextSpan( text: subString, style: txtStyle ) );
          return spans;
        }
      }

      c = txt[ i ];

      if ( c == '*' ) {
        ts = ( isItalic == true )
            ? TextSpan( text: subString, style: txtStyle.italic )
            : TextSpan( text: subString, style: txtStyle );
        spans.add( ts );
        subString = '';
        isItalic = !isItalic;
      } else if ( c == '†' ) {
        ts = ( isBold == true )
            ? TextSpan( text: subString, style: txtStyle.boldMild.gold )
            : TextSpan( text: subString, style: txtStyle );
        spans.add( ts );
        subString = '';
        isBold = !isBold;
      } else if ( c == '^' ) {
        ts = ( isGold == true )
            ? TextSpan( text: subString, style: txtStyle.boldHeavy )
            : TextSpan( text: subString, style: txtStyle );
        spans.add( ts );
        subString = '';
        isGold = !isGold;
      } else if ( c == '>' ) {
        ts = ( isBig == true )
            ? TextSpan( text: subString, style: txtStyle.big )
            : TextSpan( text: subString, style: txtStyle );
        spans.add( ts );
        subString = '';
        isBig = !isBig;
      } else if ( c == '§' ) {
        ts = ( isBigItalic == true )
            ? TextSpan( text: subString, style: txtStyle.big.gold.italic )
            : TextSpan( text: subString, style: txtStyle );
        spans.add( ts );
        subString = '';
        isBigItalic = !isBigItalic;
      } else if ( c == '<' ) {
        ts = ( isSmall == true )
            ? TextSpan( text: subString, style: txtStyle.subSmall )
            : TextSpan( text: subString, style: txtStyle );
        spans.add( ts );
        subString = '';
        isSmall = !isSmall;
      } else if ( c == '_' ) {
        ts = ( isUnderline == true )
            ? TextSpan( text: subString, style: txtStyle.underline.blue )
            : TextSpan( text: subString, style: txtStyle );
        spans.add( ts );
        subString = '';
        isUnderline = !isUnderline;
      } else if ( c == '‡' ) {
        ts = ( isGoldItalic == true )
            ? TextSpan( text: subString, style: txtStyle.gold.italic )
            : TextSpan( text: subString, style: txtStyle );
        spans.add( ts );
        subString = '';
        isGoldItalic = !isGoldItalic;
      } else if ( c == '|' ) {
        ts = ( isBigBoldGold == true )
            ? TextSpan( text: subString, style: txtStyle.big.gold.bold )
            : TextSpan( text: subString, style: txtStyle );
        spans.add( ts );
        subString = '';
        isBigBoldGold = !isBigBoldGold;
      } else if ( c == '~' ) {
        ts = ( isFixed == true )
            ? TextSpan( text: subString, style: Styles.fixedGoogle )
            : TextSpan( text: subString, style: txtStyle );
        spans.add( ts );
        subString = '';
        isFixed = !isFixed;
      } else {
        subString += c;
      }
    }

    ts = TextSpan( text: subString, style: txtStyle );
    spans.add(ts);

    return spans;
  }
}

class RichTxt extends StatefulWidget {
  final String txt;
  final TextAlign textAlign;
  final int maxLines;
  final TextStyle style;

  /** ƒ ‰ › «
   * 	*Italics*
   *    ‡Gold Italic‡
   * 	†Bold†
   * 	^RP Gold^
   * 	>Big>
   *    <small<
   * 	§Big-Italic§
   * 	_underline/gold_
   *    |Big Bold Gold|
   *    ~Fixed~
   */

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

  //bool _isRefresh   = false;

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
      _spans = Styles.makeRichTxt(
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
    //_isRefresh = true;
    //_update();

    Future.delayed( const Duration( milliseconds: 50 ), () {
      //_isRefresh = false;
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

