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
  String _selectedLangCode = 'EN';

  String get selectedLanguageCode => _selectedLangCode;

  set selectedLanguageCode( String langCode ) {
    _selectedLangCode = langCode;
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

  /** ===============================================
  *  List of language options
  *  ===============================================*/
  List<LangVO> _languageOptionsList = [ LangVO(langID: 1, langCode: 'EN', name: 'English') ];
  List<LangVO> get languageOptionsList => _languageOptionsList;
  set languageOptionsList(  List<LangVO> languageOptionsList ) {
    _languageOptionsList = languageOptionsList;
  }

  static bool isDebug = true;
  static void _log( { required String msg, String title = '', bool isJson=false, bool shout=false, bool fail=false } ) {
    if ( isDebug == true || EOL.isDEBUG == true )
      EOL.log(
        msg: msg,
        title: title,
        isJson: isJson,
        shout: shout,
        fail: fail,
        color: EOL.comboLightGray_Olive,
      );
  }
}