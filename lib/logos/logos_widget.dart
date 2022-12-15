import 'package:flutter/material.dart';
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
  final int? maxLines;
  final bool? isRich;

  /// Used for LogosTxt.static
  final String txt;

  LogosTxt({
    required this.logosID,
    required this.comment,
    this.child,
    this.vars,
    this.textStyle,
    this.textAlign = TextAlign.start,
    this.txt = '',
    this.maxLines = 9999,
    this.isRich,
  });

  /// This will search through all of the matching tags to find
  /// the correct txt and return the translation for the selected language.
  LogosTxt.dynamic({
    required String txt,
    required String tag,
    this.isRich,
    this.textStyle,
    this.vars,
    this.child,
    this.maxLines,
    this.textAlign = TextAlign.start,
  })  : this.logosID = LogosController().getDynamicLogos( txt: txt, tag: tag ).logosID,
        this.txt = '', /// Used for LogosTxt.static
        this.comment = tag;


  /// Allows static text to be passed through LogosTxt so that it will be adjusted for font size.
  LogosTxt.static({
    required String txt,
    this.isRich,
    this.textStyle,
    this.comment = '',
    this.vars,
    this.child,
    this.maxLines,
    this.textAlign = TextAlign.start,
  })  : this.logosID = 0, /// This is what makes it static.
        this.txt = txt;

  @override
  State<LogosTxt> createState() => _LogosTxtState();
}

class _LogosTxtState extends State<LogosTxt> {
  Widget _body = Container();

  @override
  void initState() {
    super.initState();

    _body = _LogosUpdateTxt(
      logosID     : widget.logosID,
      comment     : widget.comment,
      vars        : widget.vars,
      textStyle   : widget.textStyle,
      textAlign   : widget.textAlign,
      txt         : widget.txt,
      maxLines    : widget.maxLines,
      isRich      : widget.isRich,
      child       : widget.child,
    );

    LogosController().addListener(() { _update(); });
    LogosLanguageController().addListener(() { _update(); });
    LogosFontSizeController().addListener(() { _update(); });
  }

  @override
  void dispose() {
    LogosController().removeListener(() { _update(); });
    LogosLanguageController().removeListener(() { _update(); });
    LogosFontSizeController().removeListener(() { _update(); });
    super.dispose();
  }

  void _update() async {
    if( mounted ) {

      _body = _Wait();

      setState(() {});

      await Future.delayed( const Duration( milliseconds: 100 ), () {
        _body = _LogosUpdateTxt(
          logosID     : widget.logosID,
          comment     : widget.comment,
          vars        : widget.vars,
          textStyle   : widget.textStyle,
          textAlign   : widget.textAlign,
          txt         : widget.txt,
          maxLines    : widget.maxLines,
          isRich      : widget.isRich,
          child       : widget.child,
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
  final String comment;
  final Map? vars;
  final TextStyle? textStyle;
  final Widget? child;
  final TextAlign textAlign;
  String? txt;
  final int? maxLines;
  final bool? isRich;

  _LogosUpdateTxt( {
    required this.logosID,
    required this.comment,
    this.textStyle,
    this.child,
    this.vars,
    this.textAlign = TextAlign.start,
    this.txt,
    this.maxLines,
    this.isRich,
  });

  @override
  State<_LogosUpdateTxt> createState() => _LogosUpdateTxtState();
}

class _LogosUpdateTxtState extends State<_LogosUpdateTxt> {
  Widget _body = SizedBox.shrink();
  late LogosVO _logosVO;
  late TextStyle _style;

  @override
  void initState() {
    super.initState();

    if( widget.logosID == 0 ) {
      /// This is STATIC text.
      if( LogosController().useHashtag == true ) {
        widget.txt = '#${widget.txt}#';
      }
      _logosVO = LogosVO(
        logosID       : 0,
        txt           : widget.txt!,
        style         : 'body', /// This would have been chosen as the default text no matter.
        description   : '',
        tags          : '',
        isRich        : ( widget.isRich == null ) ? 0 : ( widget.isRich == true )? 1 : 0,
        langCode      : '',
        lastUpdate    : '',
        note          : '',
      );
    } else {
      _logosVO = LogosController().getLogosVO(
        logosID       : widget.logosID,
        comment       : widget.comment,
        vars          : widget.vars,
      );
    }

    _getStyle();

    _textUpdated();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _getStyle() {

    if( widget.textStyle == null ) {

      /// The Logos style will default to body if it is not set.
      _style = LogosVO.getStyle( styleName: _logosVO.style );

    } else {
      /// If the Logos widget has a txtStyle then use it.
      _style = widget.textStyle!.copyWith( fontSize: widget.textStyle!.fontSize! + LogosFontSizeController().fontSizeAdjustment );
    }
  }

  void openEditor({required BuildContext context}) {
    if (LogosController().isEditable == true) {
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

        _body = LogosRichTxt(
          txt         : _logosVO.txt,
          txtStyle    : _style,
          textAlign   : widget.textAlign,
          maxLines    : widget.maxLines,
        );

      } else {

        _body = Text(
          _logosVO.txt,
          style       : _style,
          textAlign   : widget.textAlign,
          maxLines    : widget.maxLines
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
