
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
  static String BG_purple = '\x1b[93m\x1b[41m';//'\x1b[97m\x1b[46m';
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
        String title = '',
        Map<String, dynamic>? map,
        String borderTop = '=',
        String borderSide = '|',
        String color = '',
        bool isJson = false,
        bool shout = false,
        bool underline = false,
        bool fail = false}) {

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
        //if (StackTrace != null && StackTrace.current != null) {
          String trace = StackTrace.current.toString();
          trace = trace.substring(trace.indexOf('#2') + 8);
          trace = trace.substring(0, trace.indexOf(')'));

          fnName = trace.substring(0, trace.indexOf(' '));
          fileName = trace.substring(trace.indexOf('(') + 1);
          currentClass = trace.substring(
              trace.lastIndexOf('/') + 1, trace.lastIndexOf('.dart'));
        //}

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

        /// Json data printed below
        if (isJson == false) {
          _print(s: 'MSG: ' + msg, color: color, borderSide: borderSide);
        }

        /// Called from FILE
        _print(
          s: fileName,
          color: color,
          borderSide: borderSide,
        );
        _logFile += '\n' + s;

        //if (EOL._previousNow == null) {
          _previousNow = DateTime.now();
        //}

        if (msg == '') {
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

          if (isJson == true) {
            if ( msg == '[]') {
              _print(
                  s: 'JSON EMPTY > ' + msg,
                  color: _comboBlackOverLightRed,
                  borderSide: borderSide);
              return;
            }

            /// Removing strange characters in the output
            /// that create unwanted line breaks.
            for (int k = 0; k < msg.length; k++) {
              if (msg.codeUnitAt(k) == 27) {
                msg = msg.substring(0, k - 2) + msg.substring(k + 2);
              }
            }
            msg = msg.replaceAll('09104m| ', '');
            msg = msg.replaceAll('09107m| ', '');
            msg = msg.replaceAll('03107m| ', '');
            msg = msg.replaceAll('\n', '');


/*
{"changes":[],"newLanguagesOptions":[{"langID":"2","langCode":"ES","name":"Spanish"},{"langID":"3","langCode":"CN","name":"Chinese"},{"langID":"4","langCode ":"AR","name":"Arabic"}]}


    [{langID: 2, langCode: ES, name: Spanish}, {langID: 3, langCode: CN, name: Chinese}, {langID: 4, langCode: AR, name: Arabic}]

*/

            print( '1 <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< ' );
            print( '2 <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< ' );

            if( map != null ) {
              print( '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
              map.forEach( (key, value) {
                print( 'key: ' + key + '        value: ' + value.toString() );
              });
            } else {
              print( ' ######################### null map ###########################');
            }

            print( msg );
            Map<String, dynamic> jsonMap = jsonDecode( msg );
            print( 'jsonMap.length: ' + jsonMap.length.toString() );

            jsonMap.forEach( ( String k, dynamic v ) {
              print( ">Key : $k, Value : $v" );

              /*if( v.runtimeType == Map ) {
                print( ' ----------------map ');
                v.forEach( ( String k2, dynamic v2 ) {
                  print(">>Key : $k2, Value : $v2" );

                } );

              }*/
            } );

            /*for (var i = 0; i < jsonMap.length; i++){
              print("array index: " + i.toString() );
              var obj = jsonMap[i];
              for (var key in obj){
                var value = obj[key];
                print(" " + key + ": " + value);
              }
            }*/


            print( '3 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ' );
            print( '4 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ' );

            /// Break the JSON array into multiple collections.
            List<String> jsonArray = msg.split('],');




    if (jsonArray.length == -1 ) { /// was > 0
              for (int i = 0; i < jsonArray.length - 1; i++) {
                /// This will output the name of this collection
                /// Example     {{{ COLLECTION_NAME }}}
                String s = jsonArray[i];
                int firstQuote = s.indexOf('"') + 1;
                int secondQuote = s.indexOf('"', firstQuote);
                String field = s.substring(firstQuote, secondQuote);
                _print(
                    s: _spaces.substring(
                            0, ((_lineWidth - field.length - 10) / 2).round()) +
                        '{{{ ' +
                        field.toUpperCase() +
                        ' }}}',
                    color: BG_gray,
                    borderSide: borderSide);
                _logFile += '\n' + s;

                /// Trim off the beginning ':[{' and closing '}' from this nameValuePair
                String nameValuePairs =
                    s.substring(s.indexOf(':[{') + 3, s.length - 1);

                /// Split the nameValuePairs from each other.
                List<String> pairs = nameValuePairs.split('","');

                if (pairs != -1) {
                  for (int j = 0; j < pairs.length - 1; ++j) {
                    String p = pairs[j];

                    /// Remove all the quotes.
                    p = p.replaceAll('"', '');
                    String name = p.substring(0, p.indexOf(':'));
                    String value = p.substring(p.indexOf(':') + 1);

                    /// Add empty spaces after the name.
                    name = name +
                        '                         '
                            .substring(0, 20 - name.length);

                    /// Check if value will fit on one line.
                    if (value.length + 20 > _lineWidth) {
                      /// Value doesn't fit so break it into multiple lines.

                      int start = 0;
                      int end = _lineWidth - 25;
                      String subValue;

                      for (int valueLines = 0;
                          valueLines <= value.length / (_lineWidth - 25);
                          valueLines++) {
                        start = valueLines * (_lineWidth - 25);
                        if (start + end > value.length) {
                          subValue = value.substring(start);
                        } else {
                          subValue = value.substring(start, start + end);
                        }

                        end = start + _lineWidth - 25;

                        _print(
                            s: name + ': ' + subValue,
                            color: color,
                            borderSide: borderSide);
                        name = '                    ';
                      }
                    } else {
                      _print(
                          s: name + ': ' + value,
                          color: color,
                          borderSide: borderSide);
                      _logFile += '\n' + s;
                    }
                  }
                } else {
                  _print(
                      s: '< < < NO PAIRS > > > ',
                      color: color,
                      borderSide: borderSide);
                }
              }
            } else {
              _print(
                  s: '< < < JSON EMPTY > > > ',
                  color: color,
                  borderSide: borderSide);
            }
          }
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

  static String addEmptySpaces({ required String msg, String borderSide = '|'}) {
    msg = borderSide + ' ' + msg;
    msg = msg.padRight(_lineWidth, ' ') + borderSide;
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
