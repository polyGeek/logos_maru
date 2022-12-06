import 'package:flutter/material.dart';
import 'package:logos_maru/logos/ancillary.dart';
import 'package:logos_maru/logos/logos_editor_parts/formatting_btn.dart';
import 'package:logos_maru/logos/model/lang_controller.dart';
import 'package:logos_maru/logos/model/logos_controller.dart';
import 'package:logos_maru/logos/model/txt_utilities.dart';

class LogosEditor extends StatefulWidget {
  @override
  State<LogosEditor> createState() => _LogosEditorState();
}

class _LogosEditorState extends State<LogosEditor> {
  final _tecTxt = TextEditingController();
  final _tecNote = TextEditingController();

  bool _isBusy = false;

  @override
  void initState() {
    super.initState();

    _tecTxt.text = LogosController().editingLogosVO!.txt;

    LogosController().addListener(() {
      _update();
    });
    LanguageController().addListener(() {
      _update();
    });
  }

  @override
  void dispose() {
    LogosController().removeListener(() {
      _update();
    });
    LanguageController().removeListener(() {
      _update();
    });

    super.dispose();
  }

  void _update() {
    /// todo: this update is called multiple times when editing language changes.
    if (mounted) setState(() {});
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
  void onChange(String txt) {
    if (txt.contains('</') == true) _update();
  }

  void callbackHashtag(bool value) {
    LogosController().setUseHashtag(useHashtag: value);
  }

  void callbackDoubleSized(bool value) {
    LogosController().setMakeDoubleSize(makeDoubleSize: value);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      insetPadding: EdgeInsets.symmetric(horizontal: 20),
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
              SizedBox(
                width: MediaQuery.of(context).size.width - 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('LogosMaru Editor [ID:' + LogosController().editingLogosVO!.logosID.toString() + ']', style: LogosAdminTxtStyles.title),
                  Expanded(child: SizedBox()),
                  LanguageChooser(
                    callbackState: changeBusyState,
                  ),
                ],
              ),
              Divider(
                color: Colors.white38,
                thickness: 1,
                height: 2,
              ),
              SizedBox(
                height: 20,
              ),
              Table(
                columnWidths: {
                  0: FlexColumnWidth(3),
                  1: FlexColumnWidth(7),
                },
                children: [
                  /// Description
                  TableRow(
                    children: [
                      TableCell(
                        child: Text(
                          'Description:',
                          style: LogosAdminTxtStyles.body,
                        ),
                      ),
                      TableCell(
                        child: Text(
                          LogosController().editingLogosVO!.description,
                          style: LogosAdminTxtStyles.body.italic,
                        ),
                      ),
                    ],
                  ),

                  /// Tags
                  TableRow(
                    children: [
                      TableCell(
                        child: Text(
                          'Tags:',
                          style: LogosAdminTxtStyles.body,
                        ),
                      ),
                      TableCell(
                        child: Text(
                          LogosController().editingLogosVO!.tags,
                          style: LogosAdminTxtStyles.body.italic,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Primary Style:',
                style: LogosAdminTxtStyles.body.small,
              ),
              StyleChooser(
                logosID: LogosController().editingLogosVO!.logosID,
              ),
              SizedBox(
                height: 10,
              ),
              FormattingRow(logosVO: LogosController().editingLogosVO!, txt: _tecTxt.text, callback: formatCallback),
              SizedBox(
                height: 35,
              ),
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
                  labelText: LanguageController().getLanguageNameFromCode(
                    langCode: LanguageController().editingLanguageCode,
                  ),
                  labelStyle: LogosAdminTxtStyles.body.small.offWhite,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.amber,
                      width: 3,
                      strokeAlign: StrokeAlign.outside,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white70,
                      width: 2,
                      strokeAlign: StrokeAlign.outside,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
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
                  labelStyle: LogosAdminTxtStyles.body.small.offWhite,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.amber,
                      width: 3,
                      strokeAlign: StrokeAlign.outside,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white70,
                      width: 2,
                      strokeAlign: StrokeAlign.outside,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              RadioBtnLabel(
                boolean: LogosController().useHashtag,
                callback: callbackHashtag,
                label: 'Add Hashtag',
              ),
              SizedBox(
                width: 20,
              ),
              RadioBtnLabel(
                boolean: LogosController().makeDoubleSize,
                callback: callbackDoubleSized,
                label: 'DoubleSize',
              ),
            ]),
      actions: [
        Row(
          children: [
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
                  langCode: LanguageController().editingLanguageCode,
                );

                Navigator.of(context).pop();
              },
              style: LogosAdminWidgetStyles().elevatedBtnStyle,
              child: Text(
                'SUBMIT',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
