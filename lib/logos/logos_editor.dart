import 'package:flutter/material.dart';
import 'package:logos_maru/logos/ancillary.dart';
import 'package:logos_maru/logos/logos_editor_parts/formatting_btn.dart';
import 'package:logos_maru/logos/model/lang_controller.dart';
import 'package:logos_maru/logos/model/logos_controller.dart';
import 'package:logos_maru/logos/model/logos_vo.dart';
import 'package:logos_maru/logos/model/txt_utilities.dart';

class LogosEditor extends StatefulWidget {
  @override
  State<LogosEditor> createState() => _LogosEditorState();
}

class _LogosEditorState extends State<LogosEditor> {
  final _tecTxt  = TextEditingController();
  final _tecNote = TextEditingController();

  bool _isBusy              = false;
  bool _showSettings        = false;
  Widget _settingsContainer = Container();

  /** ===============================================
   *  This VO is used internally to track changes.
   *  And only when the user clicks the save button
   *  will the changes be saved to the LogosController.
   *  ===============================================*/
  late LogosVO _logosVO;

  @override
  void initState() {
    super.initState();

    _logosVO = LogosController().editingLogosVO!;

    _tecTxt.text = _logosVO.txtOriginal;

    LogosController().addListener(() { _update(); });

    LogosLanguageController().addListener(() { _update(); });
  }

  @override
  void dispose() {
    LogosController().removeListener(() { _update(); });
    LogosLanguageController().removeListener(() { _update(); });

    super.dispose();
  }

  void _update() {
    /// todo: this update is called multiple times when editing language changes.
    if (mounted) setState(() {});
  }

  void _toggleSettings() {
    _showSettings = !_showSettings;

    _settingsContainer = ( _showSettings == true )
        ? _settingsView()
        : SizedBox.shrink();

    _update();
  }

  void changeBusyState(bool isBusy) {
    _isBusy = isBusy;
  }

  void formatCallback(String formatChar) {
    String newTxt = '';
    int selectionEnd = 0;

    int selectionStart = _tecTxt.selection.start;
    selectionEnd = _tecTxt.selection.extent.offset;

    String txt = _tecTxt.text;
    String t1 = '';
    String t2 = '';

    /// Check to see if the selection is already inside of other formatting characters.
    /// First, selection can't be at the beginning or end of the text.
    if( selectionStart > 0
        && selectionEnd < _tecTxt.text.length - 3
        && _tecTxt.text.substring( selectionStart - 1, selectionStart ) == '>'
        && _tecTxt.text.substring( selectionEnd, selectionEnd + 2 ) == '</' ) {

      int i = selectionStart - 1;
      for( i; i > 0; i-- ) {
        if( _tecTxt.text.substring( i, i + 1 ) == '<' ) {
          t1 = _tecTxt.text.substring( i, selectionStart );
          break;
        }
      }

      int j = selectionEnd + 2;
      for( j; j < _tecTxt.text.length - 3; j++ ) {
        if( _tecTxt.text.substring( j, j + 1 ) == '>' ) {
          t2 = _tecTxt.text.substring( selectionEnd + 2, j + 1 );
          break;
        }
      }

      print( 'i = ' + i.toString() );
      print( 'j = ' + j.toString() );
      newTxt = _tecTxt.text.substring( 0, i ) + _tecTxt.text.substring( selectionStart, selectionEnd ) + _tecTxt.text.substring( j + 1, _tecTxt.text.length );

    } else {


      if (selectionStart == selectionEnd) {
        /// Insert one character where the cursor is.
        t1 = txt.substring( 0, selectionStart );
        t2 = txt.substring( selectionStart, txt.length );
        newTxt = t1 + '<' + formatChar + '>' + t2;
        selectionEnd += formatChar.length + 2;
      } else {
        /// Insert formatChar around the text selection.
        String t1 = txt.substring(0, selectionStart);
        String s = txt.substring(selectionStart, selectionEnd);
        String t2 = txt.substring(selectionEnd, txt.length);
        newTxt = t1 + '<' + formatChar + '>' + s + '</' + formatChar + '>' + t2;
        selectionEnd += (formatChar.length * 2) + 5;
      }
    }


    _tecTxt.value = TextEditingValue(
      text: newTxt,
      selection: TextSelection.fromPosition(
        TextPosition(offset: selectionEnd),
      ),
    );

    _update();
  }

  /// If the txt contains a closing HTML tag then make sure update is called
  /// so that if the user toggles isRichTxt off the app will display an Alert
  /// asking if they want to remove the HTML tags in their text.
  void onChange(String txt) {
    if (txt.contains('</') == true) _update();
  }

  void callbackHashtag(bool value) {
    LogosController().setUseHashtag(useHashtag: value);
    Navigator.of( context ).pop();
  }

  void callbackDoubleSized(bool value) {
    LogosController().setMakeDoubleSize(makeDoubleSize: value);
    Navigator.of( context ).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('LogosMaru [ID:' + _logosVO.logosID.toString() + ']', style: LogosAdminTxtStyles.title),
      scrollable: true,
      insetPadding: EdgeInsets.symmetric(horizontal: 2),
      contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        side: BorderSide(color: Colors.white38, width: 3),
      ),
      content: (_isBusy == true)
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CircularProgress(),
        ],
      )
          : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        Align(
          alignment: Alignment.centerRight,
          child: LanguageChooser(
            callbackState: changeBusyState,
          ),
        ),

        Divider(
          color: Colors.white38,
          thickness: 1,
          height: 2,
        ),

        SizedBox(
          height: 20,
        ),

        Text(
          'Description:',
          style: LogosAdminTxtStyles.label,
        ),

        Text(
          _logosVO.description,
          style: LogosAdminTxtStyles.body.logos_italic,
        ),

        SizedBox( height: 20, ),

        Text(
          'Tags:',
          style: LogosAdminTxtStyles.label,
        ),

        Text(
          _logosVO.tags,
          style: LogosAdminTxtStyles.body.logos_italic,
        ),

        SizedBox( height: 20, ),

        Text(
          'Primary Style:',
          style: LogosAdminTxtStyles.label,
        ),

        StyleChooser(
          logosID: _logosVO.logosID,
        ),

        SizedBox( height: 10, ),

        TextField(
          minLines: 1,

          /// Normal textInputField will be displayed
          maxLines: 10,

          /// When user presses enter it will adapt to it
          autofocus: false,
          controller: _tecTxt,
          style: LogosAdminTxtStyles.body,
          autocorrect: false,
          onChanged: onChange,
          decoration: InputDecoration(
            errorStyle: TextStyle(fontSize: 18, color: Colors.redAccent),
            border: OutlineInputBorder(),
            labelText: LogosLanguageController().getLanguageNameFromCode(
              langCode: LogosLanguageController().editingLanguageCode,
            ),
            labelStyle: LogosAdminTxtStyles.bodySm.logos_offWhite,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.amber,
                width: 3,
                strokeAlign: BorderSide.strokeAlignOutside,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white70,
                width: 2,
                strokeAlign: BorderSide.strokeAlignOutside,
              ),
            ),
          ),
        ),

        SizedBox( height: 15, ),

        FormattingRow(
            logosVO: _logosVO,
            txt: _tecTxt.text,
            callback: formatCallback
        ),

        SizedBox( height: 15, ),

        TextField(
          minLines: 1,

          /// Normal textInputField will be displayed
          maxLines: 7,

          /// When user presses enter it will adapt to it
          autofocus: false,
          controller: _tecNote,
          style: LogosAdminTxtStyles.body,
          autocorrect: false,
          decoration: InputDecoration(
            errorStyle: TextStyle(fontSize: 18, color: Colors.redAccent),
            border: OutlineInputBorder(),
            labelText: 'Note',
            labelStyle: LogosAdminTxtStyles.bodySm.logos_offWhite,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.amber,
                width: 3,
                strokeAlign: BorderSide.strokeAlignOutside,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white70,
                width: 2,
                strokeAlign: BorderSide.strokeAlignOutside,
              ),
            ),
          ),
        ),

        SizedBox( height: 15, ),

        AnimatedSwitcher(
            duration: Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition( scale: animation, child: child,);
            },
            child: _settingsContainer
        ),

      ]),
      actions: [
        Container(
          color: Colors.white10,
          child: Row(
            children: [

              IconButton(
                onPressed: (){
                  _toggleSettings();
                },
                icon: Icon( Icons.settings, ),
              ),

              Expanded(child: SizedBox()),

              OutlinedButton(
                onPressed: () {
                  LogosController().update();
                  Navigator.of(context).pop();
                },
                style: LogosAdminWidgetStyles().outlineBtnStyle,
                child: Text(
                  'CANCEL',
                  style: LogosAdminTxtStyles.btnSub,
                ),
              ),
              SizedBox(
                width: 25,
              ),
              ElevatedButton(
                onPressed: () {
                  LogosController().editingLogosVO!.txt = _tecTxt.text;
                  LogosController().editingLogosVO!.note = _tecNote.text;

                  LogosController().updateLogosDatabase(
                    logosVO: LogosController().editingLogosVO!,
                    langCode: LogosLanguageController().editingLanguageCode,
                  );

                  Navigator.of(context).pop();
                },
                style: LogosAdminWidgetStyles().elevatedBtnStyle,
                child: Text(
                  'SUBMIT',
                ),
              ),

              SizedBox( width: 10, ),
            ],
          ),
        ),
      ],
    );
  }


  Widget _settingsView() {
    return Column(
      children: [

        RadioBtnLabel(
          boolean: LogosController().useHashtag,
          callback: callbackHashtag,
          label: 'Add Hashtag',
          description: "Adds a #hashtag# to the beginning/end of the text so that you can easily spot what text is translated and what isn't.",
        ),

        SizedBox( height: 20, ),

        RadioBtnLabel(
          boolean: LogosController().makeDoubleSize,
          callback: callbackDoubleSized,
          label: 'DoubleSize',
          description: "Repeats each translation twice so that you can spot places where translations might overflow.",
        ),

      ],
    );
  }
}
