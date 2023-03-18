import 'package:flutter/material.dart';
import 'package:logos_maru/logos/model/data_tags/data_vo.dart';
import 'package:logos_maru/logos/model/data_tags/styles_controller.dart';
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

  String _dropdownValue = LogosLanguageController().editingLanguageCode;

  @override
  void initState() {
    LogosLanguageController().addListener(() { _update(); });
    super.initState();
  }

  @override
  void dispose() {
    LogosLanguageController().removeListener(() { _update(); });
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
        widget.callbackState( true );
        await LogosController().changeEditingLanguage( langCode: newValue );
        if( mounted )
          setState(() {});
        widget.callbackState( false );
      },

      items: LogosLanguageController().permittedLanguageOptionsList.map<DropdownMenuItem<String>>(( LangVO value ) {
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

  String _dropdownValue = 'body'; /// Default to body style

  @override
  void initState() {
    LogosVO logosVO = LogosController().getEditLogos( logosID: widget.logosID );
    _dropdownValue = logosVO.style;
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
    return DropdownButton<String>(
        isExpanded: true,
        itemHeight: 80,
        borderRadius: BorderRadius.circular( 10 ),
        icon: const Icon(Icons.arrow_downward),
        iconSize: 24,
        elevation: 16,
        underline: Container(
          height: 0,
          color: Colors.amber,
        ),
        value: _dropdownValue,
        onChanged: ( String? value ){
          _dropdownValue = value!;
          print( _dropdownValue.toString() );
          LogosController().setEditingLogoVOstyle(
              logosID: widget.logosID,
              style: _dropdownValue.toString(),
          );
          _update();
        },
        items: StylesController().dataList.map<DropdownMenuItem<String>>(( DataVO value ) {
          return DropdownMenuItem<String>(
            value: value.name,
            child: Padding(
              padding: const EdgeInsets.symmetric( vertical: 8.0, horizontal: 0.0 ),
              child: Container(
                decoration: BoxDecoration(
                  color: ( value.id % 2 == 0 )? Colors.white10 : Colors.white24,
                  borderRadius: BorderRadius.circular( 4 ),
                ),
                width: MediaQuery.of( context ).size.width * 0.95,

                child: Padding(
                  padding: const EdgeInsets.symmetric( vertical: 2, horizontal: 5 ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        value.name,
                        style: LogosAdminTxtStyles.bodySm,
                      ),
                      Text( value.description,
                        style: LogosVO.getStyle(styleName: value.name ),
                        maxLines: 1,
                        overflow:TextOverflow.clip,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
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
  final String description;

  RadioBtnLabel( {
    required this.callback,
    required this.boolean,
    required this.label,
    required this.description,
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
        Row(

          children: [

            Checkbox(
                value: _localBool,
                side: BorderSide(
                  strokeAlign: BorderSide.strokeAlignOutside,
                  color: Colors.white,
                  width: 2,
                ),
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
                child: Text( widget.label, style: LogosAdminTxtStyles.body, )
            ),

            SizedBox( width: 10, ),
          ],
        ),

        Text( widget.description, style: LogosAdminTxtStyles.bodySm, ),
      ],
    );
  }
}

