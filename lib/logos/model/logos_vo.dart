import 'package:flutter/cupertino.dart';
import 'package:logos_maru/logos/model/adjust_font.dart';
import 'package:logos_maru/logos/model/eol.dart';
import 'package:logos_maru/logos/model/logos_controller.dart';
import 'package:logos_maru/logos/model/txt_utilities.dart';

class LogosVO {
  int logosID;
  String description;
  String tags;
  String note;
  String langCode;
  String txt;
  String lastUpdate;
  String style;
  int isRich;

  LogosVO( {
    required this.logosID,
    required this.tags,
    required this.note,
    required this.description,
    required this.langCode,
    required this.txt,
    required this.lastUpdate,
    required this.style,
    required this.isRich
  }) {
    this.txt = unEscapeTxt( s: txt );
    this.note = unEscapeTxt( s: note );
  }

  LogosVO.error( {
    required this.txt,
    this.logosID = 0,
    this.tags = '',
    this.note = '',
    this.description = '',
    this.langCode = '',
    this.lastUpdate = '',
    this.style = '',
    this.isRich = 0
  } ) {
    this.txt = txt;
  }

  LogosVO fromMap( { required Map map } ) {
    return LogosVO(
        logosID			: map[ 'logosID' ],
        description	: map[ 'description' ],
        tags        : map[ 'tags' ],
        langCode    : map[ 'langCode' ],
        txt         : map[ 'txt' ],
        note        : map[ 'note' ],
        lastUpdate	: map[ 'lastUpdate' ],
        style      : map[ 'style' ],
        isRich      : map[ 'isRich' ],
    );
  }

  @override
  String toString() {
    return '\n' + langCode + ' : ' + description + ' : ' + txt;
  }

  Map<String, dynamic> toMap() {
    return {
      'logosID'    	: logosID,
      'description'	: description,
      'tags'        : tags,
      'langCode'    : langCode,
      'txt'         : escapeTxt( s: txt ),
      'note'        : note,
      'lastUpdate'  : lastUpdate,
      'style'      : style,
    };
  }

  String escapeTxt( { required String s } ) {
    s = s.replaceAll( "'", "\'" );
    s = s.replaceAll( '"', '\"' );
    return s;
  }

  String unEscapeTxt( { required String s } ) {
    s = s.replaceAll( '&#39;', "'" );
    s = s.replaceAll( '&quot;', '"' );
    return s;
  }

  factory LogosVO.fromJson( Map<String, dynamic> json ) {
    _log(msg: json.toString() );

    LogosVO logosVO = LogosVO(
      logosID       : int.parse(json[ 'logosID' ]),
      description   : json[ 'description' ],
      tags          : json[ 'tags' ],
      note          : ( json[ 'note' ] == null )? '' : json[ 'note' ],
      langCode      : ( json[ 'langCode' ] == null )? '' : json[ 'langCode' ],
      txt           : json[ 'txt' ],
      lastUpdate    : json[ 'lastUpdate' ],
      style         : json[ 'style' ],
      isRich        : int.parse( json[ 'isRich' ] ),
    );
    return logosVO;
  }

  /// Returns the TextStyle for the given style name
  /// If the style name is not found, returns the default style (body).
  static TextStyle getStyle( { required String styleName } ) {
    Map<dynamic, dynamic> myStyles = LogosController().logosFontStyles!.toJson();

    TextStyle ts = LogosController().logosFontStyles!.body;
    print( ' ts.fontSize: ' + ts.fontSize.toString() );
    try {
      ts = myStyles[ styleName ] as TextStyle;
      double fontSize = ( ts.fontSize == null )? LogosController().logosFontStyles!.body.fontSize! : ts.fontSize!;
      ts = ts.copyWith( fontSize: fontSize * FontSizeController().userScale );
      _log( msg: 'Got Style: $styleName ---' + ts.toString() );
    } catch (e) {
      _log( msg: 'ERROR GETTING STYLE : $styleName \n $e', fail: true );
    }

    return ts;
  }

  static TextStyle chooseStyle( {
    required TextStyle? fromWidget,
    required TextStyle fromLogos } ) {

    if( fromLogos == LogosAdminTxtStyles.body
        && fromWidget != null
        && fromWidget != LogosAdminTxtStyles.body ) {
      return fromWidget;
    } else {
      return fromLogos;
    }
  }

  static bool isDebug = true;
  static void _log( { required String msg, String title = '', bool shout=false, bool fail=false } ) {
    if ( isDebug == true || EOL.isDEBUG == true )
      EOL.log(
        msg: msg,
        title: title,
        shout: shout,
        fail: fail,
        color: EOL.comboBlue_Black,
      );
  }
}

extension ExtendedString on String {

  String escapeTxt() {
    String s = this;
    s = s.replaceAll( "'", "&#39;" );
    s = s.replaceAll( '"', '&quot;' );
    return s;
  }

  String unEscapeTxt() {
    String s = this;
    s = s.replaceAll( '&#39;', "'" );
    s = s.replaceAll( '&quot;', '"' );
    return s;
  }
}