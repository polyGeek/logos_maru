import 'package:flutter/material.dart';
import 'package:logos_maru/logos/model/eol.dart';
import 'package:logos_maru/logos/model/lang_controller.dart';
import 'package:logos_maru/logos/model/lang_vo.dart';
import 'package:logos_maru/logos/model/logos_controller.dart';
import 'package:logos_maru/logos/model/logos_vo.dart';

/* ===============================================
*  Language Chooser
*  ===============================================*/
class LanguageChooser extends StatefulWidget {

  final void Function( bool isBusy ) callbackState;

  LanguageChooser( { required this.callbackState } );

  @override
  State<LanguageChooser> createState() => _LanguageChooserState();
}

class _LanguageChooserState extends State<LanguageChooser> {

  String _dropdownValue = LanguageController().editingLanguageCode;

  @override
  void initState() {
    LanguageController().addListener(() { _update(); });
    super.initState();
  }

  @override
  void dispose() {
    LanguageController().removeListener(() { _update(); });
    super.dispose();
  }

  void _update() {
    if( mounted )
      setState(() {});
  }

  @override
  Widget build( BuildContext context ) {
    return DropdownButton<String>(
      value: _dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),

      onChanged: ( String? newValue ) async {
        _dropdownValue = newValue!;
        EOL.log(msg: 'Changing edit language start');
        widget.callbackState( true );
        await LogosController().changeEditingLanguage( langCode: newValue );
        if( mounted )
          setState(() {});
        widget.callbackState( false );
      },

      items: LanguageController().permittedLanguageOptionsList.map<DropdownMenuItem<String>>(( LangVO value ) {
        return DropdownMenuItem<String>(
          value: value.langCode,
          child: Text( value.langCode + ' - ' + value.name ),
        );
      }).toList(),
    );
  }
}

/* ===============================================
*  Style Chooser
*  ===============================================*/
class StyleChooser extends StatefulWidget {

  final int logosID;

  StyleChooser( { required this.logosID} );

  @override
  State<StyleChooser> createState() => _StyleChooserState();
}

class _StyleChooserState extends State<StyleChooser> {

  TxtStyleOptions _dropdownValue = TxtStyleOptions.body;

  @override
  void initState() {
    LogosVO logosVO = LogosController().getEditLogos( logosID: widget.logosID );
    _dropdownValue = LogosVO.getStyleName( style: logosVO.style );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _update() {
    if( mounted )
      setState(() {});
  }

  @override
  Widget build( BuildContext context ) {
    return DropdownButton<TxtStyleOptions>(
        icon: const Icon(Icons.arrow_downward),
        iconSize: 24,
        elevation: 16,
        style: const TextStyle(color: Colors.deepPurple),
        underline: Container(
          height: 2,
          color: Colors.deepPurpleAccent,
        ),
        value: _dropdownValue,
        onChanged: ( TxtStyleOptions? value ){
          _dropdownValue = value!;
          print( _dropdownValue.toString() );
          LogosController().setEditingLogoVOstyle(
              logosID: widget.logosID,
              style: _dropdownValue.toString().split( '.')[1]
          );
          _update();
        },
        items: TxtStyleOptions.values.map((TxtStyleOptions styles) {
          return DropdownMenuItem<TxtStyleOptions>(
              value: styles,
              child: Text( styles.toString().split( '.' )[1] ));
        }).toList() );
  }
}

class CircularProgress extends StatelessWidget {

  @override
  Widget build( BuildContext context ) {
    return Center(
      child: Container(
        constraints: BoxConstraints( maxHeight: 20, maxWidth:  20 ),
        child: Center(
          child: CircularProgressIndicator(
            color: Colors.deepPurpleAccent,
            strokeWidth: 1,
          ),
        ),
      ),
    );
  }
}