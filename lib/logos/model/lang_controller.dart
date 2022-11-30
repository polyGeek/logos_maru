import 'package:flutter/cupertino.dart';
import 'package:logos_maru/logos/model/eol.dart';
import 'package:logos_maru/logos/model/lang_vo.dart';

/// Editing LanguageCode: this is the selected CC in the popup editor.
class LanguageController extends ChangeNotifier {
  static final LanguageController _editingLanguageCodeController = LanguageController._internal();
  factory LanguageController() => _editingLanguageCodeController;
  LanguageController._internal();

  /** ===============================================
  *  Selected language in APP
  *  ===============================================*/
  String _selectedAppLanguageCode = 'EN';

  String get selectedAppLanguageCode => _selectedAppLanguageCode;

  set selectedAppLanguageCode( String langCode ) {
    _selectedAppLanguageCode = langCode;
    notifyListeners();
  }

  /** ===============================================
  *  Selected EDITING language
  *  ===============================================*/
  String _editingLanguageCode = 'EN';

  String get editingLanguageCode => _editingLanguageCode;

  set editingLanguageCode( String langCode ) {
    _editingLanguageCode = langCode;
    _log( msg: langCode );
    notifyListeners();
  }

  String getLanguageNameFromCode( { required String langCode } ) {

    int _len = permittedLanguageOptionsList.length;
    for( int i = 0; i < _len; i++ ) {
      LangVO langVO = permittedLanguageOptionsList.elementAt( i );
      if( langVO.langCode == langCode )
        return langVO.name;
    }
    return 'Language unknown';
}

  /** ===============================================
   *  List of language options for app
   *  ===============================================*/
  List<LangVO> _languageOptionsList = [ LangVO(
      langID: 1,
      langCode: 'EN',
      countryCode: 'en',
      name: 'English')
  ];

  List<LangVO> get languageOptionsList => _languageOptionsList;
  set languageOptionsList(  List<LangVO> languageOptionsList ) {
    _languageOptionsList = languageOptionsList;
  }

  /** ===============================================
   *  List of language options for EDITING
   *  ===============================================*/
  List<LangVO> _editingLanguageOptionsList = [ LangVO(
      langID: 1,
      langCode: 'EN',
      countryCode: 'en',
      name: 'English')
  ];

  List<LangVO> get permittedLanguageOptionsList => _editingLanguageOptionsList;
  set permittedLanguageOptionsList(  List<LangVO> editingLanguageOptionsList ) {
    _editingLanguageOptionsList = editingLanguageOptionsList;
  }

  static const bool isDebug = false;
  static void _log( { required String msg, String title='', Map<String, dynamic>? map, String json='', bool shout=false, bool fail=false } ) {
    if ( isDebug == true )
      EOL.log( msg: msg, map: map, title: title, json: json, shout: shout, fail: fail, color: EOL.comboLightGray_Olive );
  }
}