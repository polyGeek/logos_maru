import 'package:flutter/material.dart';
import 'package:logos_maru/logos/ancillary.dart';
import 'package:logos_maru/logos/logos_editor.dart';
import 'package:logos_maru/logos/model/lang_controller.dart';
import 'package:logos_maru/logos/model/logos_controller.dart';

/* ===============================================
*  This root class has two states:
*     1-Text state
*     2-Circular progress view
*  ===============================================*/
class LogosTxt extends StatefulWidget {

  final int         logoID;
  final String      comment;
  final Map?        vars;
  final TextStyle?  txtStyle;

  LogosTxt( {
    required this.logoID,
    required this.comment,
    this.vars,
    this.txtStyle,
  } );

  @override
  _LogosTxtState createState() => _LogosTxtState();
}

class _LogosTxtState extends State<LogosTxt> {

  late Widget _body;

  @override
  void initState() {
    super.initState();

    _body = _LogosUpdateTxt(
      logosID:    widget.logoID,
      callback:   _waitingForUpdate,
      vars:       widget.vars,
      txtStyle:   widget.txtStyle,
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

    _body = _LogosUpdateTxt(
      //id:         widget.comment,
      logosID:     widget.logoID,
      callback:   _waitingForUpdate,
      vars:       widget.vars,
      txtStyle:   widget.txtStyle,
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
  //final String      id;
  final int         logosID;
  final Function    callback;
  final Map?        vars;
  final TextStyle?  txtStyle;

  _LogosUpdateTxt( {
    //required this.id,
    required this.logosID,
    required this.callback,
    this.vars,
    this.txtStyle
  } );

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
                return LogosEditor( logosID: logosID, );
              }
          );
        }
      },

      child: Text(
        LogosController().getLogos(
            logosID: logosID,
            vars: vars
        ),
        style: ( txtStyle == null )? null : txtStyle,
      ),
    );
  }
}



