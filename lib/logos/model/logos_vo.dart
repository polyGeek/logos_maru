import 'package:flutter/cupertino.dart';
import 'package:logos_maru/logos/model/adjust_font.dart';
import 'package:logos_maru/logos/model/eol.dart';
import 'package:logos_maru/logos/model/eol_colors.dart';
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

  String txtOriginal;

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
  }): txtOriginal = txt {
    this.txt = LogosController().newLine( txt: txt );
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
    this.isRich = 0,
  } ): txtOriginal = '' {
    this.txt = txt;
    this.txtOriginal = txt;
  }

  /*LogosVO.clone( { required LogosVO logosVO } ) :
        this.logosID      = logosVO.logosID,
        this.tags         = logosVO.tags,
        this.note         = logosVO.note,
        this.description  = logosVO.description,
        this.langCode     = logosVO.langCode,
        this.txt          = logosVO.txt,
        this.lastUpdate   = logosVO.lastUpdate,
        this.style        = logosVO.style,
        this.isRich       = logosVO.isRich,
        this.txtOriginal = logosVO.txtOriginal;*/

  LogosVO fromMap( { required Map map } ) {
    return LogosVO(
      logosID			: map[ 'logosID' ],
      description	: map[ 'description' ],
      tags        : map[ 'tags' ],
      langCode    : map[ 'langCode' ],
      txt         : map[ 'txt' ],
      note        : map[ 'note' ],
      lastUpdate	: map[ 'lastUpdate' ],
      style       : map[ 'style' ],
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
      'txt'         : txt, //escapeTxt( s: txt ),
      'note'        : note,
      'lastUpdate'  : lastUpdate,
      'style'      : style,
    };
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
  static Map<String, dynamic> _txtStyles = LogosController().logosFontStyles!.toJson();
  static double _lastFontSize = LogosController().logosFontStyles!.body.fontSize! + LogosFontSizeController().fontSizeAdjustment;

  static TextStyle getStyle( { required String styleName } ) {

    /*if( _txtStyles.isEmpty ) {
      Map<String, dynamic> _txtStyles = LogosController().logosFontStyles!.toJson();
    }*/

    /// todo: Using the _lastFontSize won't work if the text begins with a different style.
    try {

      TextStyle ts = _txtStyles[ styleName ] as TextStyle;
      if( ts.fontSize == null ) {
        return ts.copyWith( fontSize: _lastFontSize );
      } else {
        _lastFontSize = ts.fontSize! + LogosFontSizeController().fontSizeAdjustment;
        return ts.copyWith( fontSize: ts.fontSize! + LogosFontSizeController().fontSizeAdjustment );
      }

    } catch (e) {
      _log( msg: 'ERROR GETTING STYLE : $styleName \n $e', fail: true );
      return LogosController().logosFontStyles!.body.copyWith(
          fontSize: LogosController().logosFontStyles!.body.fontSize! + LogosFontSizeController().fontSizeAdjustment
      );
    }
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

  static void _log( { required String msg, String title = '', bool shout=false, bool fail=false } ) {
    if( LogosController().showConsoleOutput == true )
      EOL.log(
        msg: msg,
        title: title,
        shout: shout,
        fail: fail,
        color: EOLcolors.vo_blue_Black,
      );
  }
}


/*
import 'package:flutter/cupertino.dart';
import 'package:logos_maru/logos/model/adjust_font.dart';
import 'package:logos_maru/logos/model/eol.dart';
import 'package:logos_maru/logos/model/eol_colors.dart';
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
    this.txt = unEscapeTxt(
        s: LogosController().newLine(
            txt: txt
        )
    );
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

  LogosVO.clone( { required LogosVO logosVO } ) :
    this.logosID      = logosVO.logosID,
    this.tags         = logosVO.tags,
    this.note         = logosVO.note,
    this.description  = logosVO.description,
    this.langCode     = logosVO.langCode,
    this.txt          = logosVO.txt,
    this.lastUpdate   = logosVO.lastUpdate,
    this.style        = logosVO.style,
    this.isRich       = logosVO.isRich;

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
  static Map<dynamic, dynamic> _txtStyles = LogosController().logosFontStyles!.toJson();
  static double _lastFontSize = LogosController().logosFontStyles!.body.fontSize! + LogosFontSizeController().fontSizeAdjustment;

  static TextStyle getStyle( { required String styleName } ) {

    if( _txtStyles.isEmpty ) {
      Map<dynamic, dynamic> _txtStyles = LogosController().logosFontStyles!.toJson();
    }

    /// todo: Using the _lastFontSize won't work if the text begins with a different style.
    try {

      TextStyle ts = _txtStyles[ styleName ] as TextStyle;
      if( ts.fontSize == null ) {
        return ts.copyWith( fontSize: _lastFontSize );
      } else {
        _lastFontSize = ts.fontSize! + LogosFontSizeController().fontSizeAdjustment;
        return ts.copyWith( fontSize: ts.fontSize! + LogosFontSizeController().fontSizeAdjustment );
      }

    } catch (e) {
      _log( msg: 'ERROR GETTING STYLE : $styleName \n $e', fail: true );
      return LogosController().logosFontStyles!.body.copyWith(
          fontSize: LogosController().logosFontStyles!.body.fontSize! + LogosFontSizeController().fontSizeAdjustment
      );
    }
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

  static void _log( { required String msg, String title = '', bool shout=false, bool fail=false } ) {
    if( LogosController().showConsoleOutput == true )
      EOL.log(
        msg: msg,
        title: title,
        shout: shout,
        fail: fail,
        color: EOLcolors.vo_blue_Black,
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
*/
