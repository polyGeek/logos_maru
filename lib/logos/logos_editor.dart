
import 'package:flutter/material.dart';
import 'package:logos_maru/logos/ancillary.dart';
import 'package:logos_maru/logos/model/eol.dart';
import 'package:logos_maru/logos/model/lang_controller.dart';
import 'package:logos_maru/logos/model/logos_controller.dart';
import 'package:logos_maru/logos/model/logos_vo.dart';
import 'package:logos_maru/logos/model/rich_txt.dart';
import 'package:logos_maru/logos/model/txt_utilities.dart';


class LogosEditor extends StatefulWidget {
  final int logosID;
  LogosEditor( { required this.logosID } );

  @override
  State<LogosEditor> createState() => _LogosEditorState();
}

class _LogosEditorState extends State<LogosEditor> {

  final _tecTxt   = TextEditingController();
  final _tecNote  = TextEditingController();

  late LogosVO _logosVO;
  bool _isBusy = false;

  @override
  void initState() {
    super.initState();
    _logosVO = LogosController().getEditLogos( logosID: widget.logosID );
    _tecTxt.text = _logosVO.txt;

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
    EOL.log(msg: "EDITOR SET STATE");
    _logosVO = LogosController().getEditLogos( logosID: widget.logosID );
    _tecTxt.text = _logosVO.txt;
    _tecNote.text = _logosVO.note;

    if( mounted )
      setState(() {});
  }

  void changeBusyState( bool isBusy ) {
    _isBusy = isBusy;
    EOL.log(msg: "isBusy: " + isBusy.toString() );
  }

  void formatCallback( String formatChar ) {

    int selectionStart = _tecTxt.selection.start;
    int selectionEnd = _tecTxt.selection.extent.offset;

    String txt = _tecTxt.text;
    String t1 = '';
    String t2 = '';
    String newTxt = '';

    if( selectionStart == selectionEnd ) {
      /// Insert one character where the cursor is.
      t1 = txt.substring( 0, selectionStart );
      t2 = txt.substring( selectionStart, txt.length );
      newTxt = t1 + '<' + formatChar + '>' + t2;
      selectionEnd += formatChar.length + 2;

    } else {
      /// Insert formatChar around the text selection.
      String t1 = txt.substring( 0, selectionStart );
      String s  = txt.substring( selectionStart, selectionEnd );
      String t2 = txt.substring( selectionEnd, txt.length );
      newTxt = t1 + '<' + formatChar + '>' + s + '</' + formatChar + '>' + t2;
      selectionEnd += ( formatChar.length * 2 ) + 5;
    }

    _tecTxt.value = TextEditingValue(
      text: newTxt,
      selection: TextSelection.fromPosition(
        TextPosition( offset: selectionEnd ),
      ),
    );
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

                Text( 'logosID: ' + widget.logosID.toString(), ),

                Expanded(child: SizedBox() ),

                LanguageChooser( callbackState: changeBusyState,),
              ],
            ),

            Text( 'Description: ' + _logosVO.description ),

            SizedBox( height: 5,),

            Row(
              children: [

                Text( 'Tags: ' + _logosVO.tags ),

                Expanded(child: SizedBox() ),

                StyleChooser( logosID: widget.logosID, ),
              ],
            ),

            SizedBox( height: 10,),

            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [

                Checkbox(
                    value: ( _logosVO.isRich == 1 )? true : false,
                    onChanged: ( bool? value ) {
                      LogosController().setEditingLogoVOisRich( logosID: widget.logosID, isRich: value! );
                    }
                ),

                GestureDetector(
                    onTap: () {
                      bool newValue = ( _logosVO.isRich == 1 )? false : true;
                      LogosController().setEditingLogoVOisRich( logosID: widget.logosID, isRich: newValue );
                    },
                    child: Text( 'isRichTxt' )
                ),

                SizedBox( width: 8 ,),

                _FormattingBtn(
                  tag: 'em',
                  formattedCharacter: 'italic',
                  callback: formatCallback,
                ),

                _FormattingBtn(
                  tag: 'strong',
                  formattedCharacter: 'bold',
                  callback: formatCallback,
                ),

                _FormattingBtn(
                  tag: 'u',
                  formattedCharacter: 'u',
                  callback: formatCallback,
                ),

                _FormattingBtn(
                  tag: 'title',
                  formattedCharacter: 'title',
                  callback: formatCallback,
                ),

                _FormattingBtn(
                  tag: 'link',
                  formattedCharacter: 'link',
                  callback: formatCallback,
                ),

              ],
            ),

            SizedBox( height:  25,),

            TextField(
              minLines: 1, /// Normal textInputField will be displayed
              maxLines: 5, /// When user presses enter it will adapt to it
              autofocus: false,
              controller: _tecTxt,
              autocorrect: false,
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

                _logosVO.txt = _tecTxt.text;
                _logosVO.note = _tecNote.text;

                LogosController().updateLogosDatabase(
                  logosVO: _logosVO,
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

class _FormattingBtn extends StatelessWidget {

  final String formattedCharacter;
  final String tag;
  final void Function( String s ) callback;

  _FormattingBtn( {
    required this.formattedCharacter,
    required this.tag,
    required this.callback,
  });

  @override
  Widget build( BuildContext context ) {
    return Padding(
      padding: const EdgeInsets.only( right: 12.0 ),
      child: OutlinedButton(
        onPressed: () {
          callback( tag );
        },

        child: IntrinsicWidth(
          child: Row(
            children: [
              Text( '<', style: TextStyle( color: Colors.white ), ),

              RichTxt(
                txt: '<' + tag + '>' + formattedCharacter + '</' + tag + '>',
                style: TxtStyles.body,
              ),

              Text( '>', style: TextStyle( color: Colors.white ), ),
            ],
          ),
        ),
      ),
    );
  }
}
