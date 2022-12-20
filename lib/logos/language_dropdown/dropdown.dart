
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
  worldIconLangNameFull,
  worldIconLangNameCode,
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

class LogosLanguageOptionsDropdown extends StatefulWidget {

  final LogosDropDownOptions    childOptions;
  final Function?               onLanguageChanged;
  final Color                   dropDownUnderlineColor;
  final double                  dropDownUnderlineThickness;
  final TextStyle               dropDownTextStyle;
  final IconData                dropDownIcon;
  final double                  dropDownIconSize;
  final Color                   dropDownIconColor;
  final double                  gapBetweenIconAndText;

  LogosLanguageOptionsDropdown( {
    required this.childOptions,
    this.dropDownUnderlineColor       = Colors.white54,
    this.dropDownUnderlineThickness   = 1.0,
    this.dropDownTextStyle            = const TextStyle( color: Colors.white, fontSize: 12 ),
    this.dropDownIcon                 = Icons.language,
    this.dropDownIconSize             = 20,
    this.dropDownIconColor            = Colors.white,
    this.gapBetweenIconAndText        = 10,
    this.onLanguageChanged            = null,
  } );

  @override
  _LogosLanguageOptionsDropdownState createState() => _LogosLanguageOptionsDropdownState();
}

class _LogosLanguageOptionsDropdownState extends State<LogosLanguageOptionsDropdown> {
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
        height: widget.dropDownUnderlineThickness,
        color: widget.dropDownUnderlineColor,
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
                    SizedBox( width: widget.gapBetweenIconAndText ),
                    Text(
                      value.name,
                      style: widget.dropDownTextStyle,
                    ),
                  ],
                );
              else if( widget.childOptions == LogosDropDownOptions.flagAndCountryCode )
                return Row(
                  children: [
                    DropDownChild_FlagOnly( value, 24 ),
                    SizedBox( width: widget.gapBetweenIconAndText ),
                    Text(
                      value.countryCode.toUpperCase(),
                      style: widget.dropDownTextStyle,
                    ),
                  ],
                );
              else if( widget.childOptions == LogosDropDownOptions.countryFullNameOnly )
                return Text(
                  value.name,
                  style: widget.dropDownTextStyle,
                );
              else if( widget.childOptions == LogosDropDownOptions.countryFullNameAndCountryCode )
                return Row(
                  children: [
                    Text(
                      value.name,
                      style: widget.dropDownTextStyle,
                    ),
                    SizedBox( width: widget.gapBetweenIconAndText ),
                    Text(
                      value.countryCode,
                      style: widget.dropDownTextStyle,
                    ),
                  ],
                );
              else if( widget.childOptions == LogosDropDownOptions.worldIconCountryCodeLangCode )
                return Row(
                  children: [
                    Icon(
                        widget.dropDownIcon,
                        size: widget.dropDownIconSize,
                        color: widget.dropDownIconColor,
                    ),
                    SizedBox( width: widget.gapBetweenIconAndText ),
                    Text(
                      value.countryCode.toUpperCase() + ' [' + value.langCode + ']',
                      style: widget.dropDownTextStyle,
                    ),

                  ],
                );
              else if( widget.childOptions == LogosDropDownOptions.worldIconLangNameFull )
                return Row(
                  children: [
                    Icon(
                      widget.dropDownIcon,
                      size: widget.dropDownIconSize,
                      color: widget.dropDownIconColor,
                    ),
                    SizedBox( width: widget.gapBetweenIconAndText ),
                    Text(
                      value.name,
                      style: widget.dropDownTextStyle,),
                  ],
                );
              else if( widget.childOptions == LogosDropDownOptions.worldIconLangNameCode )
                return Row(
                  children: [
                    Icon(
                      widget.dropDownIcon,
                      size: widget.dropDownIconSize,
                      color: widget.dropDownIconColor,
                    ),
                    SizedBox( width: widget.gapBetweenIconAndText ),
                    Text(
                      value.langCode,
                      style: widget.dropDownTextStyle,),
                  ],
                );
              else {
                return Text(
                  value.countryCode,
                  style: widget.dropDownTextStyle,
                );
              }
            }
            )

        );
      }).toList(),
    );
  }
}
