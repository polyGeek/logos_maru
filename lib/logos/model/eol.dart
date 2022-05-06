
// ignore_for_file: dead_code

import 'dart:convert';
import 'dart:io';


class EOL {
  static const bool isDEBUG = false;
  static int _lineWidth = 80;
  static DateTime _previousNow = DateTime.now();
  static int _count = 1;
  static const String _reset = '\x1B[0m';
  static const String _backspace =
      '\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b';

  static String _logFile = '';
  static String getLogFile() => _logFile;
  static const String _spaces =
      '                                                                                                                                                      ';

  static const String _divider = '========================================================================================================================';
  static String _makeDivider() {
    return _divider.substring(0, _lineWidth);
  }

  static void setLineWidth({int characterLineWidth = 70}) {
    assert(
    characterLineWidth > 40 && characterLineWidth <= 120,
    EOL.comboYellow_Gray +
        "LineWidth must be between 40 and 120: requested = $characterLineWidth");
    _lineWidth = characterLineWidth;
  }

  static String lineBreak({String msg = '', String borderTop = '—'}) {
    String s = msg;
    for (int i = 0; i < _lineWidth - msg.length - 2; i++) {
      s += borderTop;
    }
    return s;
  }

  static String printLabelValue({ required String msg, required int longestLabel}) {
    if ( msg.contains(':') == true ) {
      String label = msg.split(':')[0];
      String value = msg.split(':')[1];
      for (int i = label.length; i < longestLabel; i++) {
        label += ' ';
      }
      return label + ': ' + value;
    } else {
      return msg;
    }
  }

  ///https://github.com/shiena/ansicolor/blob/master/README.md
  static String BG_purple = '\x1b[93m\x1b[41m';
  static String BG_gray = '\x1b[97m\x1b[47m';
  static String BG_green = '\x1b[97m\x1b[42m';
  static String BG_LiteBlue = '\x1b[97m\x1b[104m';
  static String BG_LightGreen = '\x1b[97m\x1b[102m';
  static String BG_Magenta = '\x1b[97m\x1b[45m';
  static String BG_Black = '\x1b[97m\x1b[40m';
  static String BG_Olive = '\x1b[97m\x1b[43m';


  static String comboBlue_White = '\x1b[34m\x1b[107m';
  static String comboBlue_LightYellow = '\x1b[34m\x1b[103m';
  static String comboBlue_Black = '\x1b[34m\x1b[40m';
  static String comboGreen_White = '\x1b[32m\x1b[107m';
  static String comboLightBlue_White = '\x1b[94m\x1b[107m';
  static String comboLightCyan_DarkGray = '\x1b[96m\x1b[100m';
  static String comboLightGreen_White = '\x1b[92m\x1b[107m';
  static String comboMagenta_Gray = '\x1b[95m\x1b[100m';
  static String comboMagenta_White = '\x1b[95m\x1b[107m';
  static String comboLightRed_White = '\x1b[91m\x1b[107m';
  static String comboYellow_Gray = '\x1b[93m\x1b[47m';
  static String comboPurple_White = '\x1b[35m\x1b[107m';
  static String comboPurple_Black = '\x1b[35m\x1b[40m';
  static String comboLightGray_Yellow = '\x1b[90m\x1b[103m';
  static String comboLightGray_Olive = '\x1b[90m\x1b[43m';
  static String comboLightGray_Black = '\x1b[90m\x1b[40m';

  /// Used exclusively for FAIL
  static const String _comboBlackOverLightRed =
      '\x1b[93m\x1b[41m'; //'\x1b[97m\x1b[101m';
  /// Used exclusively for SHOUT.
  static const String _comboBlackOverLightYellow =
      '\x1b[97m\x1b[105m'; //'\x1b[97m\x1b[103m';

  static void printAllCombos() {
    List<Map> combos = [
      {'color': EOL.comboLightGray_Yellow,'name': 'comboLightGrayOverYellow'},
      {'color': EOL.comboLightGray_Olive, 'name': 'comboLightGrayOverOlive'},
      {'color': EOL.comboBlue_White, 'name': 'comboBlueOverWhite '},
      {'color': EOL.comboBlue_LightYellow,'name': 'comboBlueOverLightYellow'},
      {'color': EOL.comboBlue_Black, 'name': 'comboBlueOverBlack'},
      {'color': EOL.comboGreen_White, 'name': 'comboGreenOverWhite'},
      {'color': EOL.comboLightBlue_White, 'name': 'comboLightBlueOverWhite'},
      {'color': EOL.comboLightCyan_DarkGray,'name': 'comboLightCyanOverDarkGray'},
      {'color': EOL.comboLightGray_Black, 'name': 'comboLightGrayOverBlack'},
      {'color': EOL.comboLightGreen_White,'name': 'comboLightGreenOverWhite'},
      {'color': EOL.comboMagenta_Gray,'name': 'comboMagentaOverGray'},
      {'color': EOL.comboMagenta_White,'name': 'comboMagentaOverWhite' },
      {'color': EOL.comboLightRed_White, 'name': 'comboLightRedOverWhite'},
      {'color': EOL._comboBlackOverLightRed, 'name': '_comboBlackOverLightRed'},
      {'color': EOL._comboBlackOverLightYellow, 'name': '_comboBlackOverLightYellow' },
      {'color': EOL.comboYellow_Gray, 'name': 'comboYellowOverGray'},
      {'color': EOL.comboPurple_White, 'name': 'comboPurpleOverWhite'},
      {'color': EOL.comboPurple_Black, 'name': 'comboPurpleOverBlack'},
      {'color': EOL.BG_Magenta, 'name': 'Magenta_BG'},
      {'color': EOL.BG_Black, 'name': 'Black_BG'},
      {'color': EOL.BG_purple, 'name': 'BG_purple'},
      {'color': EOL.BG_gray, 'name': 'Gray_BG'},
      {'color': EOL.BG_green, 'name': 'Green_BG'},
      {'color': EOL.BG_LiteBlue, 'name': 'liteBlue_BG'},
      {'color': EOL.BG_LightGreen, 'name': 'LightGreen_BG' },
      {'color': EOL.BG_Olive, 'name': 'Olive_BG'},
    ];

    combos.forEach((combo) {
      log(msg: 'color: ' + combo['name'], color: combo['color']);
    });
  }

  static String buffer = '';

  static void log(
      { required String msg,
        String title      = '',
        String json       ='',
        String borderTop  = '=',
        String borderSide = '|',
        String color      = '',
        bool shout        = false,
        bool fail         = false,
        Map<String, dynamic>? map,
      }) {

    //return;
    buffer += msg + '\n\n';

    if (Platform.isIOS) {
      print(msg);
      return;
    } else {
      if ( _divider.length == 120 ) _makeDivider();

      String s = '';
      if (fail == true) {
        color = _comboBlackOverLightRed;
      }

      if (shout == true) {
        color = _comboBlackOverLightYellow;
      }

      if (msg.contains('://') == false) {
        msg = msg.replaceAllMapped(RegExp(r".{79}"),
                (match) => "${match.group(0)} $borderSide$_reset\n$color| ");
      }

      try {
      String fnName = '';
      String fileName = '';
      String currentClass = '';

      /// Parse the stacktrace data.

      String trace = StackTrace.current.toString();
      trace = trace.substring(trace.indexOf('#2') + 8);
      trace = trace.substring(0, trace.indexOf(')'));

      fnName = trace.substring(0, trace.indexOf(' '));
      fileName = trace.substring(trace.indexOf('(') + 1);
      currentClass = trace.substring(
          trace.lastIndexOf('/') + 1, trace.lastIndexOf('.dart'));

      EOL._logFile += '\n ';

      /// Print divider with [ CLASS ] information.
      _print(
          s: lineBreak(
              msg: borderTop +
                  borderTop +
                  borderTop +
                  borderTop +
                  borderTop +
                  '[ ' +
                  currentClass.toUpperCase() +( ( title == '' )? '' : ' > ' ) + title +
                  ' ]',
              borderTop: borderTop),
          color: color,
          borderSide: borderSide);

      /// Called from FUNCTION
      _print(s: 'Fn: ' + fnName + '()', color: color, borderSide: borderSide);
      _logFile += '\n' + s;

      _print(
        s: fileName,
        color: color,
        borderSide: borderSide,
      );
      _logFile += '\n' + s;

      _previousNow = DateTime.now();

      if( json != '' ) {
        _printJson(
          msg: msg,
          color: color,
          borderSide: borderSide,
          json: jsonDecode( json ),
        );
      }

      if( map != null ) {

        //_print(s: map.toString(), color: color, borderSide: borderSide);
        _printMap(
          msg: msg,
          color: color,
          borderSide: borderSide,
          map: map,
        );
      }


      if( msg == '' ) {
        /// If printing a blank line.
        s = '';
        _print(
          s: s,
          color: color,
          borderSide: borderSide,
        );
        _logFile += '\n' + s;

        _print(s: '', color: color, borderSide: borderSide);
        _logFile += '\n';
      } else {
        /// Display the time duration from last call.
        DateTime now = DateTime.now();
        s = '  #' +
            _count.toString() +
            ' [' + (now.millisecondsSinceEpoch - _previousNow.millisecondsSinceEpoch).toString() + 'ms]';
        _print(
          s: s,
          color: color,
          borderSide: borderSide,
        );
        s = '';
        _logFile += '\n' + s;
        _count++;
      }

      /// Reset the previousNow so we can keep track of time between steps. Not time from app startup.
      _previousNow = DateTime.now();
      } catch (error) {
        _print(
            s: "\n<<<<<<<<<<\nLOG TRY/CATCH: " +
                error.toString() +
                '\n     ' +
                msg +
                '\n>>>>>>>>>>\n',
            color: color,
            borderSide: borderSide);
        _logFile += '\nOUTPUT ERROR';
      }
    }
  }

  static dynamic _printMap( {
    required String msg,
    required String color,
    required String borderSide,
    required Map<String, dynamic> map } ) {

    _print(
        s: _spaces.substring( 0, ((_lineWidth - msg.length - 12) / 2).round())
            + '{ { { ' + msg.toUpperCase() + ' } } }',
        color: color,
        borderSide: borderSide);

    String type = map.runtimeType.toString();
    print( 'TYPE TYPE TYPE TYPE : ' + type );

    if( type == '_InternalLinkedHashMap<String, dynamic>' ) {

      /// Get the string length of the longest key for formatting.
      int longestKey = 0;
      map.forEach( ( key, value ) {
        if( key.length > longestKey )
          longestKey = key.length;
      });

      map.forEach( ( key, value ) {
        String type = value.runtimeType.toString();
        if( type.contains( 'List' ) ) {

          int _len = value.length;
          for( int i = 0; i < _len; i++ ) {
            _printJsonLine( key: ( i == 0)? key : '', value: '\b\b- ' + value[i], color: color, borderSide: borderSide, longestKey: longestKey );
          }

        } else {
          _printJsonLine( key: key, value: value, color: color, borderSide: borderSide, longestKey: longestKey );
        }
      });

    } else if( type.contains( 'List' ) == true ) {

      int _len = map.length;
      for( int i = 0; i < _len; i++ ) {
        _printMap(
            msg: msg,
            color: color,
            borderSide: borderSide,
            map: map[i]
        );
      }

    } else {
      _print(s: 'UNKNOWN TYPE: ' + type, color: color, borderSide: borderSide );
    }

    return json;
  }

  static dynamic _printJson( {
    required String msg,
    required String color,
    required String borderSide,
    required dynamic json } ) {

    _print(
        s: _spaces.substring( 0, ((_lineWidth - msg.length - 12) / 2).round())
            + '{ { { ' + msg.toUpperCase() + ' } } }',
        color: color,
        borderSide: borderSide);

    String type = json.runtimeType.toString();
    if( type == '_InternalLinkedHashMap<String, dynamic>' ) {

      json = json as Map<String, dynamic>;

      /// Get the string length of the longest key for formatting.
      int longestKey = 0;
      json.forEach( ( key, value ) {
        if( key.length > longestKey )
          longestKey = key.length;
      });

      json.forEach( ( key, value ) {

        if( value.runtimeType.toString().contains( 'List' ) == true ) {
          _printJson(msg: key, color: color, borderSide: borderSide, json: value );
        } else {

          _printJsonLine(
              key: key,
              value: value,
              color: color,
              borderSide: borderSide,
              longestKey: longestKey
          );
        }
      });
    } else if( type.contains( 'List' ) == true ) {

      int _len = json.length;
      for( int i = 0; i < _len; i++ ) {
        _printJson(
            msg: msg,
            color: color,
            borderSide: borderSide,
            json: json[i]
        );
      }

    } else {
      _print(s: 'UNKNOWN TYPE: ' + type, color: color, borderSide: borderSide );
    }

    return json;
  }

  static void _printJsonLine({
    required String key,
    required dynamic value,
    required String color,
    required String borderSide,
    required int longestKey,
  }) {

    String keyValueLine = key + _spaces.substring( 0, longestKey - key.length + 1 ) + ': ' + value.toString();

    /// Check to see if this line is longer than _lineWidth.
    if( keyValueLine.length > _lineWidth ) {

      List<String> words = value.split( ' ' );

      String currentLine = '';
      int _len = words.length;
      for( int i = 0; i < _len; i++ ) {

        if( i == 0 ) {
          /// First word with key     :
          currentLine = key + _spaces.substring( 0, longestKey - key.length + 1 ) + ': ' + words[0] + ' ';
        } else {

          int nextWord = ( i < _len - 1 )? i + 1 : i;
          if( ( currentLine + words[i] ).length + words[ nextWord ].length > _lineWidth ) {

            _print(
              s: currentLine,
              color: color,
              borderSide: borderSide,
            );
            currentLine = _spaces.substring( 0, longestKey + 3 ) + words[i] + ' ';
          } else {
            currentLine += words[i] + ' ';
          }
        }
      }

    } else {
      _print(
        s: keyValueLine,
        color: color,
        borderSide: borderSide,
      );
    }
  }

  static String addEmptySpaces({ required String msg, String borderSide = '|'}) {
    msg = borderSide + ' ' + msg;
    msg = msg.padRight( _lineWidth, ' ' ) + borderSide;
    return msg;
  }

  static void _print(
      { required String s,
        required String color,
        required String borderSide}) {
    List<String> lines = s.split('\n');
    lines.forEach((line) {
      if (line.contains('://') == true) {
        print(_backspace + line);
      } else {
        line = addEmptySpaces(msg: line, borderSide: borderSide);
        print(_backspace + color + line + _reset);
      }
    });
  }
}
