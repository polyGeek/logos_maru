import 'package:flutter/material.dart';
import 'package:logos_maru/logos/ancillary.dart';
import 'package:logos_maru/logos/logos_editor.dart';
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

  final int         logosID;
  final String      comment;
  final Map?        vars;
  final TextStyle?  txtStyle;

  LogosTxt( {
    required this.logosID,
    required this.comment,
    this.vars,
    this.txtStyle,
  } );

  @override
  _LogosTxtState createState() => _LogosTxtState();
}

class _LogosTxtState extends State<LogosTxt> {

  late Widget _body;
  late LogosVO _logosVO;

  @override
  void initState() {
    super.initState();

    _logosVO = LogosController().getLogosVO( logosID: widget.logosID );

    TextStyle textStyle = LogosVO.getStyle( style: _logosVO.style );

    if( _logosVO.logosID == 0 ) {
      print( '\n\n#############################################');
    }

    print( '_LogosTxtState > init >\n'
        + 'ID:           ' + _logosVO.logosID.toString() + "\n"
        + 'txt:          ' + _logosVO.txt + "\n"
        + 'logosStyle:   ' + _logosVO.style + "\n"
        + 'textStyle:    ' + textStyle.toString() + '\n'
        + 'widget.style: ' + widget.txtStyle.toString( )
        + "\n**************************\n" );

    if( _logosVO.logosID == 0 ) {
      print( '#############################################\n\n');
    }

    _body = _LogosUpdateTxt(
      logosVO:    _logosVO,
      callback:   _waitingForUpdate,
      vars:       widget.vars,
      txtStyle:   LogosVO.chooseStyle(
          fromWidget: widget.txtStyle,
          fromLogos: textStyle
      ),
      /*txtStyle:   ( widget.txtStyle == null )
          ? textStyle
          : widget.txtStyle,*/
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
      logosVO:    _logosVO,
      callback:   _waitingForUpdate,
      vars:       widget.vars,
      txtStyle:   LogosVO.chooseStyle(
          fromWidget: widget.txtStyle,
          fromLogos: textStyle
      ),
      /*txtStyle:   ( widget.txtStyle == null )
      ? textStyle
      : widget.txtStyle,*/
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
  final LogosVO     logosVO;
  final Function    callback;
  final Map?        vars;
  final TextStyle   txtStyle;

  late final LogosVO _logosVO;

  _LogosUpdateTxt( {
    required this.logosVO,
    required this.callback,
    required this.txtStyle,
    this.vars,
  } ) {
    _logosVO = LogosController().getLogosVO( logosID: logosVO.logosID );
  }

  @override
  Widget build( BuildContext context ) {
    return GestureDetector(
      onLongPress: (){
        if( LogosController().isEditable == true ) {
          callback();
          showDialog<void> (
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return LogosEditor( logosID: logosVO.logosID, );
              }
          );
        }
      },

      child: ( _logosVO.isRich == 0 )
          ? Text(
        LogosController().getLogos( logosID: logosVO.logosID, vars: vars ),
        style: txtStyle,
      )
          : RichTxt(
        txt: LogosController().getLogos( logosID: logosVO.logosID, vars: vars ),
        style: txtStyle,
      ),
    );
  }
}
