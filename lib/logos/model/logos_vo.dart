import 'package:flutter/cupertino.dart';
import 'package:logos_maru/logos/model/eol.dart';
import 'package:logos_maru/logos/model/txt_utilities.dart';

enum TxtStyleOptions {
  body,
  title,
  header,
  subHeader,
  strong,
  em
}

/*extension on Styles {
  String get name => describeEnum(this);
}*/

/*String describeEnum(Object enumEntry) {
  final String description = enumEntry.toString();
  final int indexOfDot = description.indexOf('.');
  assert(indexOfDot != -1 && indexOfDot < description.length - 1);
  return description.substring(indexOfDot + 1);
}*/

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

  static TxtStyleOptions getStyleName( { required String style } ) {
    switch( style ) {
      case 'title':
        return TxtStyleOptions.title;
      case 'header':
        return TxtStyleOptions.header;
      case 'subHeader':
        return TxtStyleOptions.subHeader;
      case 'strong':
        return TxtStyleOptions.strong;
      case 'em':
        return TxtStyleOptions.em;
      default:
        return TxtStyleOptions.body;
    }
  }

  static TextStyle getStyle( { required String style } ) {
    switch( style ) {
      case 'title':
        return TxtStyles.title;
      case 'header':
        return TxtStyles.header;
      case 'subHeader':
        return TxtStyles.subHeader;
      case 'strong':
        return TxtStyles.strong;
      case 'emphasis':
        return TxtStyles.emphasis;
      default:
        return TxtStyles.body;
    }
  }

  static TextStyle chooseStyle( {
    required TextStyle? fromWidget,
    required TextStyle fromLogos } ) {

    if( fromLogos == TxtStyles.body
        && fromWidget != null
        && fromWidget != TxtStyles.body) {
      return fromWidget;
    } else {
      return fromLogos;
    }
  }

  static bool isDebug = true;
  static void _log( { required String msg, String title = '', bool isJson=false, bool shout=false, bool fail=false } ) {
    if ( isDebug == true || EOL.isDEBUG == true )
      EOL.log(
        msg: msg,
        title: title,
        isJson: isJson,
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