import 'package:flutter/material.dart';
import 'package:logos_maru/logos/ancillary.dart';
import 'package:logos_maru/logos/model/eol.dart';
import 'package:logos_maru/logos/model/lang_controller.dart';
import 'package:logos_maru/logos/model/logos_controller.dart';
import 'package:logos_maru/logos/model/logos_vo.dart';


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

    _tecNote.text = _logosVO.note;

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

  @override
  Widget build( BuildContext context ) {
    return AlertDialog(
      scrollable: true,
      insetPadding: EdgeInsets.symmetric( horizontal: 5 ),
      contentPadding: EdgeInsets.symmetric( vertical: 5, horizontal: 10 ),

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

            TextField(
              minLines: 1, /// Normal textInputField will be displayed
              maxLines: 5, /// When user presses enter it will adapt to it
              autofocus: false,
              controller: _tecTxt,
              autocorrect: false,
              decoration: InputDecoration(
                errorStyle: TextStyle( fontSize: 18, color: Colors.redAccent ),
                border: OutlineInputBorder(),
                labelText: LanguageController().editingLanguageCode,
                focusedBorder: OutlineInputBorder(
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue,
                  ),
                ),
              ),
            ),

            SizedBox( height: 5,),

            SizedBox( height: 5,),

            Text( 'Description: ' + _logosVO.description ),

            SizedBox( height: 5,),

            Text( 'Tags: ' + _logosVO.tags ),

            Row(
              children: [
                Checkbox(
                    value: ( _logosVO.isRich == 1 )? true : false,
                    onChanged: ( bool? value ) {
                      LogosController().setEditingLogoVOisRich( logosID: widget.logosID, isRich: value! );
                    }
                ),
                Text( 'isRichTxt' ),

                Expanded(child: SizedBox() ),

                StyleChooser( logosID: widget.logosID, ),
              ],
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
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ]

      ),

      actions: [

        TextButton(
          onPressed: () {

            LogosController().update();
            Navigator.of( context ).pop();
          },
          child: Text( 'CANCEL' ),
        ),

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
          child: Text( 'SUBMIT' ),
        ),
      ],
    );
  }
}

