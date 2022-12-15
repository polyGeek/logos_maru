
import 'package:flutter/material.dart';
import 'package:logos_maru/logos/model/lang_controller.dart';
import 'package:logos_maru/logos/model/lang_vo.dart';
import 'package:logos_maru/logos/model/logos_controller.dart';

/** ===============================================
 *  Change Language Dropdown
 *  ===============================================*/

enum LogosDropDownOptions {
  flagOnly,
  flagAndFullName,
  flagAndCountryCode,
  countryFullNameOnly,
  countryFullNameAndCountryCode,
  worldIconCountryCodeLangCode,
  worldIconLangName,
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

class LogosChangeLanguageDropdown extends StatefulWidget {

  final LogosDropDownOptions childOptions;
  final Function? onLanguageChanged;

  LogosChangeLanguageDropdown( {
    required this.childOptions,
    this.onLanguageChanged = null,
  } );

  @override
  _LogosChangeLanguageDropdownState createState() => _LogosChangeLanguageDropdownState();
}

class _LogosChangeLanguageDropdownState extends State<LogosChangeLanguageDropdown> {
  String _dropdownValue   = 'EN';

  @override
  void initState() {
    super.initState();
    _dropdownValue = LogosLanguageController().userSelectedLanguageCode;
  }

  @override
  Widget build( BuildContext context ) {
    return DropdownButton<String>(
      value: _dropdownValue,
      iconSize: 24,
      elevation: 16,
      underline: Container(
        height: 2,
        color: Colors.amber,
      ),
      onChanged: ( String? newValue ) {
        _dropdownValue = newValue!;
        if( widget.onLanguageChanged != null )
          widget.onLanguageChanged!( newValue );
        LogosController().changeLanguage( langCode: newValue );
        if( mounted )
          setState(() {});
      },
      items: LogosLanguageController().languageOptionsList.map<DropdownMenuItem<String>>(( LangVO value ) {
        return DropdownMenuItem<String>(
            value: value.langCode,
            child: LayoutBuilder( builder: ( BuildContext context, BoxConstraints constraints ) {

              if( widget.childOptions == LogosDropDownOptions.flagOnly )
                return DropDownChild_FlagOnly( value, 30 );
              else if( widget.childOptions == LogosDropDownOptions.flagAndFullName )
                return Row(
                  children: [
                    DropDownChild_FlagOnly( value, 30 ),
                    SizedBox( width: 10 ),
                    Text( value.name ),
                  ],
                );
              else if( widget.childOptions == LogosDropDownOptions.flagAndCountryCode )
                return Row(
                  children: [
                    DropDownChild_FlagOnly( value, 24 ),
                    SizedBox( width: 10 ),
                    Text( value.countryCode.toUpperCase() ),
                  ],
                );
              else if( widget.childOptions == LogosDropDownOptions.countryFullNameOnly )
                return Text( value.name );
              else if( widget.childOptions == LogosDropDownOptions.countryFullNameAndCountryCode )
                return Row(
                  children: [
                    Text( value.name ),
                    SizedBox( width: 10 ),
                    Text( value.countryCode ),
                  ],
                );
              else if( widget.childOptions == LogosDropDownOptions.worldIconCountryCodeLangCode )
                return Row(
                  children: [
                    Icon( Icons.language ),
                    SizedBox( width: 10 ),
                    Text( value.countryCode.toUpperCase() + ' [' + value.langCode + ']'),
                  ],
                );
              else if( widget.childOptions == LogosDropDownOptions.worldIconLangName )
                return Row(
                  children: [
                    Icon( Icons.language ),
                    SizedBox( width: 10 ),
                    Text( value.langCode ),
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
