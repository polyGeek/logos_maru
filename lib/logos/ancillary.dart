import 'package:flutter/material.dart';
import 'package:logos_maru/logos/model/eol.dart';
import 'package:logos_maru/logos/model/lang_controller.dart';
import 'package:logos_maru/logos/model/lang_vo.dart';
import 'package:logos_maru/logos/model/logos_controller.dart';
import 'package:logos_maru/logos/model/logos_vo.dart';
import 'package:logos_maru/logos/model/txt_utilities.dart';

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
      underline: Container(
        height: 2,
        color: Colors.amber,
      ),

      onChanged: ( String? newValue ) async {
        _dropdownValue = newValue!;
        EOL.log( msg: 'Changing edit language start');
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
        underline: Container(
          height: 2,
          color: Colors.amber,
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
        constraints: BoxConstraints(
            minHeight: 200, minWidth: 200,
            maxHeight: 200, maxWidth:  200
        ),
        child: Center(
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 1,
          ),
        ),
      ),
    );
  }
}

/** ===============================================
 *  Radio Button and Label
 *  ===============================================*/
class RadioBtnLabel extends StatefulWidget {

  final void Function( bool value )  callback;
  final bool boolean;
  final String label;

  RadioBtnLabel( {
    required this.callback,
    required this.boolean,
    required this.label,
  } );

  @override
  _RadioBtnLabelState createState() => _RadioBtnLabelState();
}

class _RadioBtnLabelState extends State<RadioBtnLabel> {

  late bool _localBool;

  @override
  void initState() {
    super.initState();

    _localBool = widget.boolean;
  }

  void _update() {
    if( mounted )
      setState(() {});
  }

  @override
  Widget build( BuildContext context ) {
    return Column(

      children: [

        Checkbox(
            value: _localBool,
            onChanged: ( bool? value ) {
              _localBool = value!;
              widget.callback( value );
              _update();
            }
        ),

        GestureDetector(
            onTap: () {
              _localBool = !_localBool;
              widget.callback( _localBool );
              _update();
            },
            child: Text( widget.label, style: TxtStyles.body, )
        ),

      ],
    );
  }
}
