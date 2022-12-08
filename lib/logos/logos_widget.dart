import 'package:flutter/material.dart';
import 'package:logos_maru/logos/ancillary.dart';
import 'package:logos_maru/logos/logos_editor.dart';
import 'package:logos_maru/logos/model/adjust_font.dart';
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

  /// Allows dynamic creation of a translation based on the EN txt and a tag.
  ///
  /// For instance, if you have the days of the week generated dynamically
  /// you can create translations for each day of the week and tag them with 'weekdays'.
  /// Then, as an example, if you pass 'Monday', 'weekdays' then LogosMaru will find
  /// all of the tags for 'weekdays' and return the translation for 'Monday'.
  ///
  /// Note: all of the translations with this tag will be retained in a list so that
  /// the next request for 'Tuesday' will not have to find all of the translations with
  /// the tag 'weekdays' again.
  LogosTxt.dynamic({
    required String txt,
    required String tag,
    this.textStyle,
    this.vars,
    this.child,
    this.textAlign = TextAlign.start,
  })  : this.logosID = LogosController().getDynamicLogos( txt: txt, tag: tag ).logosID,
        this.comment = tag;

  @override
  _LogosTxtState createState() => _LogosTxtState();
}

class _LogosTxtState extends State<LogosTxt> {
  late Widget _body;
  //late LogosVO _logosVO;

  /// Set to the default. (body)
  //late TextStyle textStyle;

  @override
  void initState() {
    super.initState();

    //_logosVO = LogosController().getLogosVO( logosID: widget.logosID );

   //_getStyle();

    //print('.\n..\n#############################################');

    /*if( LogosController().showConsoleOutput == true ) {
      EOL.log(
          msg: '_LogosTxtState > init >\n' +
              'ID:                  ' + _logosVO.logosID.toString() +
              "\n" + 'txt:          ' + _logosVO.txt +
              "\n" + 'logosStyle:   ' + _logosVO.style +
              "\n" + 'ts:           ' + textStyle.toString() +
              "\n**************************\n",
          color: EOLcolors.logosWidget_lightRed_White
      );
    }*/

    _body = _LogosUpdateTxt(
      //logosVO: _logosVO,
      logosID: widget.logosID,
      callback: _waitingForUpdate,
      vars: widget.vars,
      textStyle: widget.textStyle,
      textAlign: widget.textAlign,
      child: widget.child,
    );

    LogosController().addListener(() { _textUpdated(); });
    LanguageController().addListener(() { _selectedLanguageChanged(); });
    FontSizeController().addListener(() { _textUpdated(); });
  }

  /*void _getStyle() {

    if( widget.textStyle == null ) {

      /// The Logos style will default to body if it is not set.
      textStyle = LogosVO.getStyle( styleName: _logosVO.style );

    } else {
      /// If the Logos widget has a txtStyle then use it.
      textStyle = widget.textStyle!.copyWith( fontSize: widget.textStyle!.fontSize! + FontSizeController().fontSizeAdjustment );
    }
  }*/

  @override
  void dispose() {
    LogosController().removeListener(() { _textUpdated; });
    LanguageController().removeListener(() { _selectedLanguageChanged(); });
    FontSizeController().removeListener(() { _textUpdated(); });
    super.dispose();
  }

  void _update() {
    if (mounted) setState(() {});
  }

  void _selectedLanguageChanged() {
    _body = CircularProgress();
    _update();
  }

  void _textUpdated() {
    //_getStyle();

    _body = _LogosUpdateTxt(
      //logosVO: _logosVO,
      logosID: widget.logosID,
      callback: _waitingForUpdate,
      vars: widget.vars,
      textStyle: widget.textStyle,
      child: widget.child,
    );

    _update();
  }

  void _waitingForUpdate() {
    _body = CircularProgress();
    _update();
  }

  @override
  Widget build(BuildContext context) {
    return _body;
  }
}

class _LogosUpdateTxt extends StatelessWidget {
  //final LogosVO logosVO;
  final int logosID;
  final Function callback;
  final Map? vars;
  TextStyle? textStyle;
  final Widget? child;
  final TextAlign textAlign;
  late final LogosVO _logosVO;

  _LogosUpdateTxt({
    //required this.logosVO,
    required this.logosID,
    required this.callback,
    this.textStyle,
    this.child,
    this.vars,
    this.textAlign = TextAlign.start,
  }) {
    //_logosVO = LogosController().getLogosVO( logosID: logosVO.logosID );
    _logosVO = LogosController().getLogosVO( logosID: logosID );
    _getStyle();
  }

  void _getStyle() {

    if( textStyle == null ) {

      /// The Logos style will default to body if it is not set.
      textStyle = LogosVO.getStyle( styleName: _logosVO.style );

    } else {
      /// If the Logos widget has a txtStyle then use it.
      textStyle = textStyle!.copyWith( fontSize: textStyle!.fontSize! + FontSizeController().fontSizeAdjustment );
    }
  }

  void openEditor({required BuildContext context}) {
    if (LogosController().isEditable == true) {
      callback();

      LogosController().setEditingLogosVO( logosVO: _logosVO );

      showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return LogosEditor();
          });
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
      child: Builder(builder: (BuildContext context) {
        if (child == null) {
          return (_logosVO.isRich == 0)
              ? Text(
                  LogosController().getLogos(logosID: _logosVO.logosID, vars: vars, comment: ''),
                  style: textStyle,
                  textAlign: textAlign,
                )
              : RichTxt(
                  txt: LogosController().getLogos(logosID: _logosVO.logosID, vars: vars, comment: ''),
                  txtStyle: textStyle!,
                  textAlign: textAlign,
                );
        } else {
          return child!;
        }
      }),
    );
  }
}
