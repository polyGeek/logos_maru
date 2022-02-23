import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:logos_maru/logos/model/db.dart';
import 'package:logos_maru/logos/model/eol.dart';
import 'package:logos_maru/logos/model/lang_controller.dart';
import 'package:logos_maru/logos/model/lang_vo.dart';
import 'package:logos_maru/logos/model/logos_service.dart';
import 'package:logos_maru/logos/model/logos_vo.dart';


class LogosController extends ChangeNotifier {
  static final LogosController _logosController = LogosController._internal();
  factory LogosController() => _logosController;
  LogosController._internal();


  static const ENVIRONMENT = "HT";

  List<LogosVO> _logosList = [];
  List<LogosVO> _editingLogosList = [];

  /// Is editable
  bool _isEditable = false;

  bool get isEditable => _isEditable;

  void setIsEditable( { required String username } ) {
    _isEditable = true;

    /// These are different because the user might see EN in the app,
    /// but want to edit ES, or some other language.
    _editingLogosList = _logosList;
  }

  /**********************
   *** Initialization ***
   ***********************/
  Future<bool> init() async {

    /// 0: Copy databases from assets folder
    /*bool doesExist = await DBHelpers.copyEmbeddedDatabase( filename: 'logos_pref.db' );
    if( doesExist == false ) {
      _log(msg: 'coping databases', shout: true );
      /// Load the rest of the language files
      DBHelpers.copyEmbeddedDatabase( filename: 'logos_AR.db' );
      DBHelpers.copyEmbeddedDatabase( filename: 'logos_CN.db' );
      DBHelpers.copyEmbeddedDatabase( filename: 'logos_EN.db' );
      DBHelpers.copyEmbeddedDatabase( filename: 'logos_ES.db' );
    }*/

    /// 1: get the selected langCode from the local DB.
    LanguageController().selectedLanguageCode = await LogosDB().getSavedLanguagePreference();
    _log(msg: '_selectedLangCode: ' + LanguageController().selectedLanguageCode.toString());

    /// 2: get all of the language options from the local DB.
    LanguageController().languageOptionsList = await LogosDB().getLanguageOptionsList();

    _log(msg: 'Language options: ' + LanguageController().languageOptionsList.toString());

    /// 3: get language data from local DB.
    _logosList = await LogosDB().getLogosDataFromLocalDB( langCode: LanguageController().selectedLanguageCode.toString() );

    /// Initially, set the editing list equal to the viewing list.
    //_editingChanList = _chanList; /// doing this when the user becomes editor.

    /// 4: get any changes approved by the remote DB.
    getRemoteChanges(langCode: LanguageController().editingLanguageCode);

    /// 5: Set the EditingLanguage Code to be the same as the viewing language code.
    LanguageController().editingLanguageCode = LanguageController().selectedLanguageCode;

    _log(msg: '_logosList.isNotEmpty :' + _logosList.isNotEmpty.toString());
    if (_logosList.isNotEmpty) {
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  Future<void> getRemoteChanges({ required String langCode }) async {
    /// What is the timestamp of the last added entry?
    String lastUpdate = await LogosDB().getLastUpdate(langCode: langCode);

    /// Get the last index in the langPref local DB,
    /// so we can check for additions in the remote DB.
    int lastLangKey = await LogosDB().getLastLangKey();

    /// Data to the server
    Map<String, dynamic> map = {
      'lastLangID': lastLangKey,
      'lastUpdate': lastUpdate,
      'langCode': langCode,
      'env': ENVIRONMENT
    };

    _log(msg: "Kickoff: Data to server -> \n " + map.toString());

    String result = await NetworkHelper.sendPostRequest(
        url: NetworkHelper.API_LOCATION + NetworkHelper.API_VERSION +
            '/kickoff.php',
        map: map
    );

    /// Language Options
    var newLanguageOptionsDecoded = jsonDecode(
        result)[ 'newLanguagesOptions' ] as List;
    if (newLanguageOptionsDecoded.isNotEmpty) {
      _log(msg: 'We have new language options', shout: true);
      _log(msg: newLanguageOptionsDecoded.toString());
      List<LangVO> newLangList = newLanguageOptionsDecoded.map((e) =>
          LangVO.fromJson(e)).toList();

      /// Update local DB with newLanguage list.
      LanguageController().languageOptionsList = await LogosDB().updateLanguageOptions(
          newLangList: newLangList
      );
    }

    /// Translation Changes
    var changesDecoded = jsonDecode(result)[ 'changes' ] as List;
    if (changesDecoded.isNotEmpty) {
      _log(msg: "New translation changes: " + langCode, shout: true);
      List<LogosVO> changesList = changesDecoded.map((e) => LogosVO.fromJson(e)).toList();

      /// Update database
      await LogosDB().updateLocalDatabase(
          changesList: changesList,
          langCode: langCode
      );

      /// Re-query the local DB to get fresh data.
      _logosList = await LogosDB().getLogosDataFromLocalDB(langCode: langCode);

      if( _isEditable == true ) {

        /// This may be a change to the editing language,
        /// so updating the _editingChanList now.
        _editingLogosList = _logosList;
      }
      notifyListeners();
    }
  }

  bool doesHaveLogos() {
    return _logosList.isNotEmpty;
  }

  /// todo: look at ways to optimize.
  String getLogos({
    required int logosID,
    Map? vars }) {
    for (int i = 0; i < _logosList.length; i++) {
      LogosVO logosVO = _logosList.elementAt(i);
      if (logosVO.logosID == logosID) {
        return (vars == null) ? logosVO.txt : insertVars(
            txt: logosVO.txt, vars: vars);
      }
    }

    return 'ERROR: ' + logosID.toString();
  }

  LogosVO getEditLogos({
    required int logosID,
    Map? vars }) {

    LogosVO logosVO;

    _log( msg: "editingLogosList.length : " + _editingLogosList.length.toString() );
    for (int i = 0; i < _editingLogosList.length; i++) {
      logosVO = _editingLogosList.elementAt(i);
      if ( logosVO.logosID == logosID ) {

        _log( msg: 'FOUND LogosVO: ' + logosVO.txt );
        if (vars != null) {
          logosVO.txt = insertVars(txt: logosVO.txt, vars: vars);
        }

        return logosVO;
      }
    }

    _log( msg: "ERROR logosID =  $logosID" );
    /// Error
    return logosVO = LogosVO(
      logosID: 0, description: '', lastUpdate: '', note: '', tags: '',
      langCode: LanguageController().editingLanguageCode,
      txt: 'ERROR: ' + logosID.toString(),
    );
  }

  void changeLanguage( { required String langCode } ) async {
    _log(msg: '_selectedLangCode: $langCode' );

    LanguageController().selectedLanguageCode = langCode;
    LogosDB().saveLanguagePreference( code: langCode );

    /// Switch the language
    _logosList = await LogosDB().getLogosDataFromLocalDB( langCode: langCode );

    /// Check for updates to this language.
    getRemoteChanges( langCode: langCode );

    notifyListeners();
  }

  Future<bool> changeEditingLanguage( {
    required String langCode,
  } ) async {

    _log(msg: 'Editing language: $langCode' );

    /// Change EditingLanguage Code
    LanguageController().editingLanguageCode = langCode;

    /// Switch the editing language
    _editingLogosList = await LogosDB().getLogosDataFromLocalDB( langCode: langCode, );

    /// Check for updates to this language.
    await getRemoteChanges( langCode: langCode );

    notifyListeners();
    /// Todo: add some error catching.
    return true;
  }

  void updateLogosDatabase( {
    required LogosVO logosVO,
    required String langCode
  } ) async {

    /// Data to the server
    Map<String, dynamic> map = {
      'env'         : ENVIRONMENT,
      'langCode'    : langCode,
      'logosID'     : logosVO.logosID,
      'txt'         : logosVO.txt,
      'description' : logosVO.description,
      'tags'        : logosVO.tags,
      'note'        : logosVO.note,
    };

    _log(msg: "Data to server: " + map.toString() );

    String result = await NetworkHelper.sendPostRequest(
        url: NetworkHelper.API_LOCATION + NetworkHelper.API_VERSION + '/update_logos.php', map: map
    );

    var chanDecoded = jsonDecode( result )[ 'changes' ] as List;
    List<LogosVO> changesList = chanDecoded.map( ( e ) => LogosVO.fromJson( e ) ).toList();

    /// Update local database.
    logosVO = await LogosDB().updateLocalDatabase(
      changesList: changesList,
      langCode: langCode,
    );

    /// Update the model.
    updateModel( logosVO: logosVO );

    notifyListeners();

  }

  void updateModel( { required LogosVO logosVO } ) {
    for ( int i = 0; i < _logosList.length; i++ ) {
      LogosVO _logosVO = _logosList.elementAt( i );
      if( logosVO.logosID == _logosVO.logosID ) {
        _logosList[i] = logosVO;
        break;
      }
    }
  }

  void update() {
    Future.delayed( const Duration( milliseconds: 100 ), () {
      notifyListeners();
    });
  }

  String insertVars( { required String txt, required Map vars } ) {
    p( msg: '_________________START_________________' );
    p( msg: 'insertVars: ' + txt );
    p( msg: 'map: ' + vars.toString() );
    while( txt.contains( '{' ) == true ) {

      /// Get the first {}
      int start = txt.indexOf( '{' ) + 1;
      int end = txt.indexOf( '}', start );
      p( msg: '     start: ' + start.toString() + ', end: ' + end.toString() );

      /// Get the variable name
      String v = txt.substring( start, end );
      p( msg: '     variable: ' + v );

      txt = txt.substring( 0, start - 1 ) + vars[v] + txt.substring( end + 1 );
      p( msg: '     txt: ' + txt );
      p( msg: '_________________END_________________' );
    }

    return txt;
  }

  void p( { required String msg } ) {
    //print( msg );
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
          color: EOL.comboGreen_White,
      );
  }
}

