
import 'package:flutter/material.dart';
import 'package:logos_maru/logos/model/lang_controller.dart';
import 'package:logos_maru/logos/model/lang_vo.dart';
import 'package:logos_maru/logos/model/logos_controller.dart';

/** ===============================================
 *  Change Language Dropdown
 *  ===============================================*/

class ChangeLanguageDropdown extends StatefulWidget {
  @override
  _ChangeLanguageDropdownState createState() => _ChangeLanguageDropdownState();
}

class _ChangeLanguageDropdownState extends State<ChangeLanguageDropdown> {
  String _dropdownValue   = 'EN';

  @override
  void initState() {
    super.initState();
    _dropdownValue = LanguageController().selectedAppLanguageCode;
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
      onChanged: ( String? newValue ) {
        _dropdownValue = newValue!;
        print( newValue );
        LogosController().changeLanguage( langCode: newValue );
        if( mounted )
          setState(() {});
      },
      items: LanguageController().languageOptionsList.map<DropdownMenuItem<String>>(( LangVO value ) {
        return DropdownMenuItem<String>(
          value: value.langCode,
          child: ( value.countryCode == '' )
              ? Text( value.langCode + ' - ' + value.countryCode )
              : Image.asset( 'assets/flags/' + value.countryCode + '.png' ),
        );
      }).toList(),
    );
  }
}
