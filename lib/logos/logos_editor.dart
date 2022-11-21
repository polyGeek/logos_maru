import 'package:flutter/material.dart';
import 'package:logos_maru/logos/ancillary.dart';
import 'package:logos_maru/logos/logos_editor_parts/formatting_btn.dart';
import 'package:logos_maru/logos/model/eol.dart';
import 'package:logos_maru/logos/model/lang_controller.dart';
import 'package:logos_maru/logos/model/logos_controller.dart';
import 'package:logos_maru/logos/model/txt_utilities.dart';


class LogosEditor extends StatefulWidget {

  @override
  State<LogosEditor> createState() => _LogosEditorState();
}

class _LogosEditorState extends State<LogosEditor> {

  final _tecTxt   = TextEditingController();
  final _tecNote  = TextEditingController();

  bool _isBusy = false;

  @override
  void initState() {
    super.initState();

    _tecTxt.text = LogosController().editingLogosVO!.txt;

    LogosController().addListener(() { _update(); });
    LanguageController().addListener(() { _update(); });
  }

  @override
  void dispose() {
    LogosController().removeListener(() { _update(); });
    LanguageController().removeListener(() { _update(); });

    super.dispose();
  }

  void _update() {
    _tecTxt.text = LogosController().editingLogosVO!.txt;
    _tecNote.text = LogosController().editingLogosVO!.note;

    /// todo: this update is called multiple times when editing language changes.
    if( mounted )
      setState(() {});
  }

  void changeBusyState( bool isBusy ) {
    _isBusy = isBusy;
    EOL.log(msg: "isBusy: " + isBusy.toString() );
  }

  void formatCallback( String formatChar ) {
    String newTxt = '';
    int selectionEnd = 0;

    if (formatChar == '<>') {
      newTxt = _tecTxt.text;
      RegExp exp = RegExp(
          r"<[^>]*>",
          multiLine: true,
          caseSensitive: true
      );

      newTxt = newTxt.replaceAll(exp, '');
      selectionEnd = newTxt.length;
    } else {
      int selectionStart = _tecTxt.selection.start;
      selectionEnd = _tecTxt.selection.extent.offset;

      String txt = _tecTxt.text;
      String t1 = '';
      String t2 = '';

      if (selectionStart == selectionEnd) {
        /// Insert one character where the cursor is.
        t1 = txt.substring(0, selectionStart);
        t2 = txt.substring(selectionStart, txt.length);
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
  void onChange( String txt ) {
    if( txt.contains( '</' ) == true )
      _update();
  }

  void callbackHashtag( bool value ) {
    LogosController().setUseHashtag( useHashtag: value );
  }

  void callbackDoubleSized( bool value ) {
    LogosController().setMakeDoubleSize( makeDoubleSize: value );
  }

  @override
  Widget build( BuildContext context ) {
    return AlertDialog(
      scrollable: true,
      insetPadding: EdgeInsets.symmetric( horizontal: 10 ),
      contentPadding: EdgeInsets.symmetric( vertical: 5, horizontal: 10 ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all( Radius.circular( 8 ) ),
          side: BorderSide(color: Colors.white38 )
      ),

      content: ( _isBusy == true )
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CircularProgress(),
        ],
      )
          : Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            SizedBox( width: MediaQuery.of( context ).size.width - 30,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                Text( 'logosID: ' + LogosController().editingLogosVO!.logosID.toString() ),

                Expanded(child: SizedBox() ),

                LanguageChooser( callbackState: changeBusyState,),
              ],
            ),

            Text( 'Description: ' + LogosController().editingLogosVO!.description, ),

            SizedBox( height: 5,),

            Row(
              children: [

                Text( 'Tags: ' + LogosController().editingLogosVO!.tags ),

                Expanded(child: SizedBox() ),

                StyleChooser( logosID: LogosController().editingLogosVO!.logosID, ),
              ],
            ),

            SizedBox( height: 10,),

            FormattingRow(
                logosVO: LogosController().editingLogosVO!,
                txt: _tecTxt.text,
                callback: formatCallback
            ),

            SizedBox( height:  35,),

            TextField(
              minLines: 1, /// Normal textInputField will be displayed
              maxLines: 5, /// When user presses enter it will adapt to it
              autofocus: false,
              controller: _tecTxt,
              autocorrect: false,
              onChanged: onChange,
              decoration: InputDecoration(
                errorStyle: TextStyle( fontSize: 18, color: Colors.redAccent ),
                border: OutlineInputBorder(),
                labelText: LanguageController().getLanguageNameFromCode(
                    langCode: LanguageController().editingLanguageCode
                ),
                focusedBorder: OutlineInputBorder(
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white70,
                  ),
                ),
              ),
            ),

            SizedBox( height: 15,),

            TextField(
              minLines: 1, /// Normal textInputField will be displayed
              maxLines: 7, /// When user presses enter it will adapt to it
              autofocus: false,
              controller: _tecNote,
              autocorrect: false,
              decoration: InputDecoration(
                errorStyle: TextStyle( fontSize: 18, color: Colors.redAccent ),
                border: OutlineInputBorder(),
                labelText: 'Note',
                focusedBorder: OutlineInputBorder(
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white70,
                  ),
                ),
              ),
            ),
          ]

      ),

      actions: [

        Row(
          children: [
            RadioBtnLabel(
              boolean: LogosController().useHashtag,
              callback: callbackHashtag,
              label: 'Add Hashtag',
            ),

            SizedBox( width: 20,),

            RadioBtnLabel(
              boolean: LogosController().makeDoubleSize,
              callback: callbackDoubleSized,
              label: 'DoubleSize',
            ),

            Expanded(child: SizedBox()),

            TextButton(
              onPressed: () {

                LogosController().update();
                Navigator.of( context ).pop();
              },
              child: Text( 'CANCEL', style: TxtStyles.btnFlat ),
            ),

            SizedBox( width: 25 ,),

            ElevatedButton(
              onPressed: () {

                LogosController().editingLogosVO!.txt = _tecTxt.text;
                LogosController().editingLogosVO!.note = _tecNote.text;

                LogosController().updateLogosDatabase(
                  logosVO: LogosController().editingLogosVO!,
                  langCode: LanguageController().editingLanguageCode,
                );

                Navigator.of( context ).pop();
              },
              child: Text( 'SUBMIT', style: TxtStyles.btn ),
            ),
          ],
        ),
      ],
    );
  }
}

