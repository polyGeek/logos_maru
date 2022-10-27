
import 'package:flutter/material.dart';
import 'package:logos_maru/logos/model/lang_controller.dart';
import 'package:logos_maru/logos/model/lang_vo.dart';
import 'package:logos_maru/logos/model/logos_controller.dart';

/** ===============================================
 *  Change Language Dropdown
 *  ===============================================*/

enum DropDownChildOptions {
  flagOnly,
  flagAndFullName,
  flagAndCountryCode,
  countryFullNameOnly,
  countryFullNameAndCountryCode,
}

Widget DropDownChild_FlagOnly( LangVO value, double width ) {
  return Row(
    children: [
      Image.asset(
        'assets/logosmaru/flags/' + value.countryCode + '.png',
        width: width,
      ),
    ],
  );
}

class ChangeLanguageDropdown extends StatefulWidget {

  final DropDownChildOptions childOptions;

  ChangeLanguageDropdown( { required this.childOptions } );

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
            child: LayoutBuilder( builder: ( BuildContext context, BoxConstraints constraints ) {

              if( widget.childOptions == DropDownChildOptions.flagOnly )
                return DropDownChild_FlagOnly( value, 30 );
              else if( widget.childOptions == DropDownChildOptions.flagAndFullName )
                return Row(
                  children: [
                    DropDownChild_FlagOnly( value, 30 ),
                    SizedBox( width: 10 ),
                    Text( value.name ),
                  ],
                );
              else if( widget.childOptions == DropDownChildOptions.flagAndCountryCode )
                return Row(
                  children: [
                    DropDownChild_FlagOnly( value, 24 ),
                    SizedBox( width: 10 ),
                    Text( value.countryCode.toUpperCase() ),
                  ],
                );
              else if( widget.childOptions == DropDownChildOptions.countryFullNameOnly )
                return Text( value.name );
              else if( widget.childOptions == DropDownChildOptions.countryFullNameAndCountryCode )
                return Row(
                  children: [
                    Text( value.name ),
                    SizedBox( width: 10 ),
                    Text( value.countryCode ),
                  ],
                );
              else {
                return Text( value.countryCode );
              }
            }
            )

        );
      }).toList(),
    );
  }
}
