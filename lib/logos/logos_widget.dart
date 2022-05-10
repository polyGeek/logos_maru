import 'package:flutter/material.dart';
import 'package:logos_maru/logos/ancillary.dart';
import 'package:logos_maru/logos/logos_editor.dart';
import 'package:logos_maru/logos/model/eol.dart';
import 'package:logos_maru/logos/model/lang_controller.dart';
import 'package:logos_maru/logos/model/logos_controller.dart';
import 'package:logos_maru/logos/model/logos_vo.dart';
import 'package:logos_maru/logos/model/rich_txt.dart';

/* ===============================================
*  This root class has two states:
*     1-Text state
*     2-Circular progress view
*  ===============================================*/
class LogosTxt extends StatefulWidget {

  final int           logosID;
  final String        comment;
  final Map?          vars;
  final TextStyle?    txtStyle;
  final Widget?       child;

  LogosTxt( {
    required this.logosID,
    required this.comment,
    this.child,
    this.vars,
    this.txtStyle,
  } );

  @override
  _LogosTxtState createState() => _LogosTxtState();
}

class _LogosTxtState extends State<LogosTxt> {

  late Widget   _body;
  late LogosVO _logosVO;

  @override
  void initState() {
    super.initState();

    _logosVO = LogosController().getLogosVO( logosID: widget.logosID );

    TextStyle textStyle = LogosVO.getStyle( style: _logosVO.style );

    if( _logosVO.logosID == 0 ) {
      print( '.\n..\n#############################################');

      EOL.log( msg: '_LogosTxtState > init >\n'
          + 'ID:           ' + _logosVO.logosID.toString() + "\n"
          + 'txt:          ' + _logosVO.txt + "\n"
          + 'logosStyle:   ' + _logosVO.style + "\n"
          + 'textStyle:    ' + textStyle.toString() + '\n'
          + 'widget.style: ' + widget.txtStyle.toString( ) + '\n'
          + "\n**************************\n",
          color: EOL.comboLightRed_White
      );

      print( '#############################################\n.\n..');
    }

    _body = _LogosUpdateTxt(
      logosVO     : _logosVO,
      callback    : _waitingForUpdate,
      vars        : widget.vars,
      child       : widget.child,
      txtStyle    : LogosVO.chooseStyle(
          fromWidget: widget.txtStyle,
          fromLogos: textStyle
      ),
    );

    LogosController().addListener(() { _textUpdated(); });
    LanguageController().addListener(() { _selectedLanguageChanged(); });
  }

  @override
  void dispose() {
    LogosController().removeListener(() { _textUpdated; });
    LanguageController().removeListener(() { _selectedLanguageChanged(); });
    super.dispose();
  }

  void _update() {
    if( mounted )
      setState(() {});
  }

  void _selectedLanguageChanged() {
    _body = CircularProgress();
    _update();
  }

  void _textUpdated() {

    TextStyle textStyle = LogosVO.getStyle( style: _logosVO.style );

    _body = _LogosUpdateTxt(
      logosVO         : _logosVO,
      callback        : _waitingForUpdate,
      vars            : widget.vars,
      child           : widget.child,
      txtStyle        : LogosVO.chooseStyle(
          fromWidget  : widget.txtStyle,
          fromLogos   : textStyle
      ),
    );
    _update();
  }

  void _waitingForUpdate() {
    _body = CircularProgress();
    _update();
  }

  @override
  Widget build( BuildContext context ) {
    return _body;
  }
}


class _LogosUpdateTxt extends StatelessWidget {
  final LogosVO       logosVO;
  final Function      callback;
  final Map?          vars;
  final TextStyle     txtStyle;
  final Widget?       child;
  late final LogosVO _logosVO;

  _LogosUpdateTxt( {
    required this.logosVO,
    required this.callback,
    required this.txtStyle,
    this.child,
    this.vars,
  } ) {
    _logosVO = LogosController().getLogosVO( logosID: logosVO.logosID );
  }

  void openEditor( { required BuildContext context } ) {
    if( LogosController().isEditable == true ) {
      callback();
      LogosController().setEditingLogosVO(logosVO: logosVO );
      showDialog<void> (
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return LogosEditor();// logosID: logosVO.logosID, );
          }
      );
    }
  }

  @override
  Widget build( BuildContext context ) {
    return GestureDetector(
      onDoubleTap:(){
          openEditor( context: context );
      },
      onLongPress: (){
        openEditor( context: context );
      },

      child: Builder(builder: (BuildContext context) {
        if ( child == null ) {

          return ( _logosVO.isRich == 0 )
              ? Text(
            LogosController().getLogos( logosID: logosVO.logosID, vars: vars, comment: '' ),
            style: txtStyle,
          )
              : RichTxt(
            txt: LogosController().getLogos( logosID: logosVO.logosID, vars: vars, comment: '' ),
            style: txtStyle,
          );

        } else {
          return child!;
        }
      }),
    );
  }
}
