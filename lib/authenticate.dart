import 'package:flutter/material.dart';
import 'package:logos_maru/logos/model/logos_controller.dart';

class AuthenticateEditor extends StatefulWidget {
  @override
  AuthenticateEditorState createState() => AuthenticateEditorState();
}

class AuthenticateEditorState extends State<AuthenticateEditor> {

  String    _code         = 'CY2';

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

    onInputChanged( code: code );
  }

  bool validateCode( { required String code } ) {

    if( code == _code ) {
      return true;
    } else {
      return false;
    }
  }

  void onInputChanged( { required String code } ) async {

    if( code.length >= 3 ) {

      if( code == _code ) {

        LogosController().setIsEditable();
        Navigator.of( context ).pop();

      } else {
        //incorrect code
      }

    }
    _update();
  }

  @override
  Widget build( BuildContext context ) {
    return Container(
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

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

        ],
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