import 'package:flutter/material.dart';
import 'package:logos_maru/logos/ancillary.dart';
import 'package:logos_maru/logos/logos_editor.dart';
import 'package:logos_maru/logos/model/adjust_font.dart';
import 'package:logos_maru/logos/model/lang_controller.dart';
import 'package:logos_maru/logos/model/logos_controller.dart';
import 'package:logos_maru/logos/model/logos_vo.dart';
import 'package:logos_maru/logos/model/rich_txt.dart';


class LogosTxt extends StatefulWidget {

  final int logosID;
  final String comment;
  final Map? vars;
  final TextStyle? textStyle;
  final Widget? child;
  final TextAlign textAlign;

  LogosTxt({
    required this.logosID,
    required this.comment,
    this.child,
    this.vars,
    this.textStyle,
    this.textAlign = TextAlign.start,
  });

  @override
  State<LogosTxt> createState() => _LogosTxtState();
}

class _LogosTxtState extends State<LogosTxt> {
  Widget _body = Container();

  /*void _waitingForUpdate() {
    //_body = CircularProgress();
    //_update();
  }*/


  @override
  void initState() {
    super.initState();

    _body = _LogosUpdateTxt(
      logosID: widget.logosID,
      //updateCallback: _waitingForUpdate,
      vars: widget.vars,
      textStyle: widget.textStyle,
      textAlign: widget.textAlign,
      child: widget.child,
    );

    LogosController().addListener(() { _update(); });
    LanguageController().addListener(() { _update(); });
    FontSizeController().addListener(() { _update(); });
  }

  @override
  void dispose() {
    LogosController().removeListener(() { _update(); });
    LanguageController().removeListener(() { _update(); });
    FontSizeController().removeListener(() { _update(); });
    super.dispose();
  }

  void _update() async {
    if( mounted ) {

      _body = _Wait();

      setState(() {});

      await Future.delayed( const Duration( milliseconds: 100 ), () {
        _body = _LogosUpdateTxt(
          logosID: widget.logosID,
          //updateCallback: _waitingForUpdate,
          vars: widget.vars,
          textStyle: widget.textStyle,
          textAlign: widget.textAlign,
          child: widget.child,
        );
      } );

      setState(() {});
    }

  }
  @override
  Widget build( BuildContext context ) {
    return _body;
  }
}



/* ===============================================
*  This root class has two states:
*     1-Text state
*     2-Circular progress view
*  ===============================================*/
class _LogosUpdateTxt extends StatefulWidget {
  final int logosID;
  //final Function updateCallback;
  final Map? vars;
  final TextStyle? textStyle;
  final Widget? child;
  final TextAlign textAlign;

  _LogosUpdateTxt( {
    required this.logosID,
    //required this.updateCallback,
    this.textStyle,
    this.child,
    this.vars,
    this.textAlign = TextAlign.start,
  });

  @override
  State<_LogosUpdateTxt> createState() => _LogosUpdateTxtState();
}

class _LogosUpdateTxtState extends State<_LogosUpdateTxt> {
  Widget _body = Container( width: 20, height: 20, color: Colors.red,);
  late LogosVO _logosVO;
  late TextStyle _style;

  @override
  void initState() {
    super.initState();

    _logosVO = LogosController().getLogosVO(
      logosID: widget.logosID,
      vars: widget.vars,
    );

    _getStyle();

    _textUpdated();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /*void _update() {
    if( mounted )
      setState(() {});
  }*/

  void _getStyle() {

    if( widget.textStyle == null ) {

      /// The Logos style will default to body if it is not set.
      _style = LogosVO.getStyle( styleName: _logosVO.style );

    } else {
      /// If the Logos widget has a txtStyle then use it.
      _style = widget.textStyle!.copyWith( fontSize: widget.textStyle!.fontSize! + FontSizeController().fontSizeAdjustment );
    }
  }

  void openEditor({required BuildContext context}) {
    if (LogosController().isEditable == true) {
      //widget.updateCallback();

      LogosController().setEditingLogosVO( logosVO: _logosVO );

      showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return LogosEditor();
          });
    }
  }

  void _textUpdated() async {

    if( widget.child != null ) {
      _body = widget.child!;
    } else {

      if( _logosVO.isRich == 1 ) {

        _body = RichTxt(
          txt: _logosVO.txt,
          txtStyle: _style,
          textAlign: widget.textAlign,
        );

      } else {

        _body = Text(
          _logosVO.txt,
          style: _style,
          textAlign: widget.textAlign,
        );

      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        openEditor(context: context);
      },
      onLongPress: () {
        openEditor(context: context);
      },
      child: _body,
    );
  }
}

Widget _Wait() {
  return Container(
    width: 20,
    height: 20,
    child: CircularProgressIndicator(
      color: Colors.white30,
      strokeWidth: 1,
    ),
  );
}
