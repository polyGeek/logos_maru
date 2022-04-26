import 'package:flutter/material.dart';
import 'package:logos_maru/logos/ancillary.dart';
import 'package:logos_maru/logos/logos_widget.dart';
import 'package:logos_maru/logos/model/logos_controller.dart';
import 'package:logos_maru/logos/model/txt_utilities.dart';

class AuthenticateEditor extends StatefulWidget {
  @override
  AuthenticateEditorState createState() => AuthenticateEditorState();
}

class AuthenticateEditorState extends State<AuthenticateEditor> {

  TextEditingController _tec    = TextEditingController();
  bool                  _isBusy = false;

  void _update() {
    setState(() {});
  }

  String passCode = '';
  void _btnPressed(
      String character,
      bool isDelete,
      int column,
      ) {

    if( isDelete == true ) {
      passCode = passCode.replaceAll( character , '' );
    } else {
      passCode += character;
    }

    print( passCode );
  }

  void _onSubmit() async {

    _isBusy = true;
    _update();

    bool success = await LogosController().signIn(
        userName: _tec.text,
        passCode: passCode
    );

    passCode = '';

    if( success == true ) {
      _isBusy = false;
      Navigator.of( context ).pop();
      _update();
    } else {

      Future.delayed( const Duration( milliseconds: 5000 ), () {
        _isBusy = false;
        _update();
      } );
    }


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
          child: CircularProgress()
      )
          : Container(
        width: MediaQuery.of( context ).size.width / 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                  onPressed: (){
                    Navigator.of( context ).pop();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.all( Radius.circular( 4 ))
                    ),
                      child: Icon( Icons.close, color: Colors.white, )
                  )
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric( horizontal: 8 ),
              child: TextField(
                minLines: 1, /// Normal textInputField will be displayed
                maxLines: 5, /// When user presses enter it will adapt to it
                autofocus: false,
                controller: _tec,
                autocorrect: false,
                decoration: InputDecoration(
                  errorStyle: TextStyle( fontSize: 18, color: Colors.redAccent ),
                  border: OutlineInputBorder(),
                  labelText: LogosController().getLogos( logosID: 7, comment: 'User name: hint on TextInput' ),
                  focusedBorder: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ),
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

            Padding(
              padding: const EdgeInsets.symmetric( horizontal: 8 ),
              child: ElevatedButton(
                  onPressed: _onSubmit,
                  child: LogosTxt(
                    comment: 'SUBMIT: btn label',
                    logosID: 6,
                    txtStyle: TxtStyles.btn,
                  ),
              ),
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
          height: MediaQuery.of( context ).size.width / 8,
          width: MediaQuery.of( context ).size.width / 8,

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