import 'package:flutter/material.dart';
import 'package:logos_maru/logos/ancillary.dart';
import 'package:logos_maru/logos/model/logos_controller.dart';

class AuthenticateEditor extends StatefulWidget {
  @override
  AuthenticateEditorState createState() => AuthenticateEditorState();
}

class AuthenticateEditorState extends State<AuthenticateEditor> {

  String    _code         = 'CY2';
  TextEditingController _tec    = TextEditingController();
  bool                  _isBusy = false;

  void _update() {
    setState(() {});
  }

  String code = '';
  void _btnPressed(
      String character,
      bool isDelete,
      int column,
      ) {

    if( isDelete == true ) {
      code = code.replaceAll( character , '' );
    } else {
      /// First character
      if( column == 0 ) {

        code = character + code;

        /// Second character
      } else if( column == 1 ) {

        if( code.length == 0 ) {
          code += character;
        } else if( code.length == 1 ){

          if( code == '1' || code == '2' || code == '3' ) {
            code = character + code;
          } else {
            code = code[0] + character;
          }

        } else {
          code = code[0] + character + code[1];
        }

      } else {
        /// Third column

        if( code.length == 0 ){
          code += character;
        } else if( code.length == 1 ) {
          code = code[0] + character;
        } else {
          code += character;
        }
      }
    }

    //onInputChanged( code: code );
  }

  bool validateCode( { required String code } ) {

    if( code == _code ) {
      return true;
    } else {
      return false;
    }
  }

  void onInputChanged( { required String code } ) async {

    if( code.length == 3 ) {

      LogosController().setIsEditable(
          username: _tec.text,
          pass: code
      );

      /*if( code == _code ) {

        LogosController().setIsEditable(
            username: _tec.text,
            pass: code
        );
        Navigator.of( context ).pop();

      } else {
        //incorrect code
      }*/

    }
    _update();
  }


  @override
  Widget build( BuildContext context ) {
    return AlertDialog(
      scrollable: true,
      insetPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.symmetric( vertical: 5, horizontal: 10 ),

      content: ( _isBusy == true )
          ? Container(
          width: MediaQuery.of( context ).size.width / 2,
          height: MediaQuery.of( context ).size.width / 2,
          child: CircularProgress()
      )
          : Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            TextField(
              minLines: 1, /// Normal textInputField will be displayed
              maxLines: 5, /// When user presses enter it will adapt to it
              autofocus: false,
              controller: _tec,
              autocorrect: false,
              decoration: InputDecoration(
                errorStyle: TextStyle( fontSize: 18, color: Colors.redAccent ),
                border: OutlineInputBorder(),
                labelText: 'User name:',
                focusedBorder: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue,
                  ),
                ),
              ),
            ),

            Table(
                children: <TableRow> [
                  TableRow(
                      children: <Widget>[
                        CodeInputBtn( character: 'A', column: 0, btnPressed: _btnPressed, ),
                        CodeInputBtn( character: 'X', column: 1, btnPressed: _btnPressed, ),
                        CodeInputBtn( character: '1', column: 2, btnPressed: _btnPressed, ),
                      ]
                  ),

                  TableRow(
                      children: <Widget>[
                        CodeInputBtn( character: 'B', column: 0, btnPressed: _btnPressed, ),
                        CodeInputBtn( character: 'Y', column: 1, btnPressed: _btnPressed, ),
                        CodeInputBtn( character: '2', column: 2, btnPressed: _btnPressed, ),
                      ]
                  ),

                  TableRow(
                      children: <Widget>[
                        CodeInputBtn( character: 'C', column: 0, btnPressed: _btnPressed, ),
                        CodeInputBtn( character: 'Z', column: 1, btnPressed: _btnPressed, ),
                        CodeInputBtn( character: '3', column: 2, btnPressed: _btnPressed, ),
                      ]
                  )
                ]
            ),

            SizedBox( height: 20 ,),

            ElevatedButton(
                onPressed: (){
                  LogosController().setIsEditable(
                      username: _tec.text,
                      pass: code
                  );
                  _isBusy = true;
                  _update();
                },
                child: Text( 'SUBMIT' )
            )

          ],
        ),
      ),
    );
  }
}

class CodeInputBtn extends StatefulWidget {

  final String character;
  final int column;
  final void Function( String char, bool isDelete, int column ) btnPressed;

  CodeInputBtn( {
    required this.character,
    required this.column,
    required this.btnPressed,
  } );

  @override
  State<CodeInputBtn> createState() => _CodeInputBtnState();
}

class _CodeInputBtnState extends State<CodeInputBtn> {

  Color btnColor = Colors.amber;

  void _update() {
    setState(() {});
  }

  @override
  Widget build( BuildContext context ) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>( btnColor ),
        ),
        child: Container(
          height: MediaQuery.of( context ).size.width / 6,
          width: MediaQuery.of( context ).size.width / 6,

          child: Center(
              child: Text(
                widget.character,
                style: TextStyle( fontSize: 24 ),
              )
          ),
        ),
        onPressed: () {
          bool isDelete = ( btnColor == Colors.amber )? false : true;
          widget.btnPressed( widget.character, isDelete, widget.column );
          btnColor = ( btnColor == Colors.amber )
              ? Colors.green
              : Colors.amber;
          _update();
        },
      ),
    );
  }
}