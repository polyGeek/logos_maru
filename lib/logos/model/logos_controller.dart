import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:logos_maru/logos/model/db.dart';
import 'package:logos_maru/logos/model/db_helpers.dart';
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

  /// Places a #hashtag# at the beginning and ending of all text
  /// so that developer can tell where Logos is applied and where
  /// there is raw text.
  bool? _useHashtag = false;
  bool get useHashtag => _useHashtag!;
  void setUseHashtag( { required bool useHashtag } ) {
    _useHashtag = useHashtag;
  }

  /// Repeat the text to test Text Wrapping
  bool? _makeDoubleSize = false;
  bool get makeDoubleSize => _makeDoubleSize!;
  void setMakeDoubleSize( { required bool makeDoubleSize } ) {
    _makeDoubleSize = makeDoubleSize;
  }

  /// userID and userName
  int? _userID;
  String? _userName;

  /**********************
   *** Initialization ***
   ***********************/
  Future<bool> init() async {

    /// 0: Copy databases from assets folder
    DBHelpers.copyEmbeddedDatabase( filename: 'logosmaru/logos_pref.db' );
    DBHelpers.copyEmbeddedDatabase( filename: 'logosmaru/logos_AR.db' );
    DBHelpers.copyEmbeddedDatabase( filename: 'logosmaru/logos_CN.db' );
    DBHelpers.copyEmbeddedDatabase( filename: 'logosmaru/logos_EN.db' );
    DBHelpers.copyEmbeddedDatabase( filename: 'logosmaru/logos_ES.db' );

    /// 1: get the selected langCode from the local DB.
    LanguageController().selectedAppLanguageCode = await LogosDB().getSavedLanguagePreference();
    _log(msg: '_selectedLangCode: ' + LanguageController().selectedAppLanguageCode.toString());

    /// 2: get all of the language options from the local DB.
    LanguageController().languageOptionsList = await LogosDB().getLanguageOptionsList();

    _log(msg: 'Language options: ' + LanguageController().languageOptionsList.toString());

    /// 3: get language data from local DB.
    _logosList = await LogosDB().getLogosDataFromLocalDB( langCode: LanguageController().selectedAppLanguageCode.toString() );

    /// 4: get any changes approved by the remote DB.
    getRemoteChanges( langCode: LanguageController().selectedAppLanguageCode );

    /// 5: Set the EditingLanguage Code to be the same as the viewing language code.
    LanguageController().editingLanguageCode = LanguageController().selectedAppLanguageCode;

    _log(msg: _logosList.isNotEmpty.toString(), isJson: true );
    if (_logosList.isNotEmpty) {
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> signIn( {
    required String userName,
    required String passCode
  } ) async {

    /// These are different because the user might see EN in the app,
    /// but want to edit ES, or some other language.
    _editingLogosList = _logosList;

    /// Data to the server
    Map<String, dynamic> map = {
      'userName': userName.toLowerCase(),
      'passCode': passCode.toLowerCase(),
      'env': ENVIRONMENT
    };

    _log(msg: "signIn: Data to server -> \n " + map.toString());

    String result = await NetworkHelper.sendPostRequest(
        url: NetworkHelper.API_LOCATION + NetworkHelper.API_VERSION + '/signin.php',
        map: map
    );

    /// Language Options
    var user = jsonDecode( result )[ 'user' ] as List;

    if( user.isNotEmpty ) {

      _log(msg: 'User signed in', shout: true);
      _log(msg: user.toString());

      _isEditable = true;
      _userID = int.parse( user[0][ 'userID' ] );
      _userName = user[0][ 'userName' ];
      _log(msg: 'userName: ' + _userName! );

      var permittedLangCodesDecoded = jsonDecode( result )[ 'permittedLangCodes' ] as List;

      if( permittedLangCodesDecoded.isNotEmpty ) {
        _log(msg: permittedLangCodesDecoded.toString());

        LanguageController().permittedLanguageOptionsList =
            permittedLangCodesDecoded.map((e) => LangVO.fromJson(e)).toList();
      }

      return true;
    } else {

      _log(msg: 'User signin error', shout: true );
      return false;
    }
  }

  Future<void> getRemoteChanges( { required String langCode } ) async {
    /// What is the timestamp of the last added entry?
    String lastUpdate = await LogosDB().getLastUpdate( langCode: langCode );

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
    _log(msg: map.toString() );

    String result = await NetworkHelper.sendPostRequest(
        url: NetworkHelper.API_LOCATION + NetworkHelper.API_VERSION +
            '/kickoff.php',
        map: map
    );
    print( ' ######################### map ###########################');
    map.forEach( (key, value) {
      print( 'key: ' + key + '        value: ' + value.toString() );
    });
    print( ' ######################### map ###########################');

    _log(msg: '', map: map, isJson: true );

    /// Language Options
    var newLanguageOptionsDecoded = jsonDecode( result )[ 'newLanguagesOptions' ] as List;

    if( newLanguageOptionsDecoded.isNotEmpty ) {
      _log(msg: 'We have new language options', shout: true );
      List<LangVO> newLangList = newLanguageOptionsDecoded.map((e) => LangVO.fromJson(e)).toList();

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
  String getLogos( {
    required int logosID,
    required String comment,
    Map? vars } ) {

    for (int i = 0; i < _logosList.length; i++) {
      LogosVO logosVO = _logosList.elementAt(i);

      if ( logosVO.logosID == logosID ) {

        /// Add vars if needed.
        String txt = ( vars == null )? logosVO.txt : insertVars( txt: logosVO.txt, vars: vars);

        if( _useHashtag == true ) {
          return '#' + txt + '#';
        } else if( _makeDoubleSize == true ) {
          return txt + ' | ' + txt.toUpperCase();
        } else {
          return txt;
        }
      }
    }

    return 'ERROR: #' + logosID.toString();
  }

  LogosVO getLogosVO( {
    required int logosID,
    Map? vars }) {

    for (int i = 0; i < _logosList.length; i++) {
      LogosVO logosVO = _logosList.elementAt(i);
      if ( logosVO.logosID == logosID ) {
        return logosVO;
      }
    }

    return LogosVO(
        txt: 'ERROR',
        logosID: 0, tags: '', note: '', description: '', langCode: 'EN', lastUpdate: '', style: '', isRich: 0 );
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
      logosID: 0, description: '', lastUpdate: '', note: '', tags: '', style: '', isRich: 0,
      langCode: LanguageController().editingLanguageCode,
      txt: 'ERROR: #' + logosID.toString(),
    );
  }

  void changeLanguage( { required String langCode } ) async {
    _log(msg: '_selectedLangCode: $langCode' );

    LanguageController().selectedAppLanguageCode = langCode;
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
      'userID'      : _userID.toString(),
      'userName'    : _userName,
      'txt'         : logosVO.txt,
      'description' : logosVO.description,
      'tags'        : logosVO.tags,
      'note'        : logosVO.note,
      'isRich'      : logosVO.isRich.toString(),
      'style'       : logosVO.style,
    };

    _log(msg: "Data to server: " + map.toString() );

    String result = await NetworkHelper.sendPostRequest(
        url: NetworkHelper.API_LOCATION + NetworkHelper.API_VERSION + '/add-new.php', map: map
    );

    if( result.contains( '#ABORT#' ) ) {
      return;
    }

    var logosDecoded = jsonDecode( result )[ 'changes' ] as List;
    List<LogosVO> changesList = logosDecoded.map( ( e ) => LogosVO.fromJson( e ) ).toList();

    /// Update local database.
    logosVO = await LogosDB().updateLocalDatabase(
      changesList: changesList,
      langCode: langCode,
    );

    /// Update the model.
    updateLogosList( logosVO: logosVO );

    notifyListeners();
  }

  void updateLogosList( { required LogosVO logosVO } ) {
    for ( int i = 0; i < _logosList.length; i++ ) {
      LogosVO _logosVO = _logosList.elementAt( i );
      if( logosVO.logosID == _logosVO.logosID ) {
        _logosList[i] = logosVO;
        break;
      }
    }
  }

  void updateEditLogosList( { required LogosVO logosVO } ) {
    for ( int i = 0; i < _editingLogosList.length; i++ ) {
      LogosVO _logosVO = _editingLogosList.elementAt( i );
      if( logosVO.logosID == _logosVO.logosID ) {
        _editingLogosList[i] = logosVO;
        break;
      }
    }
  }

  void update() {
    Future.delayed( const Duration( milliseconds: 100 ), () {
      notifyListeners();
    });
  }



  void setEditingLogoVOisRich( { required int logosID, required bool isRich } ) {
    LogosVO logosVO = getEditLogos( logosID: logosID );
    logosVO.isRich = ( isRich == true )? 1 : 0;
    updateEditLogosList( logosVO: logosVO );
    update();
  }

  void setEditingLogoVOstyle( { required int logosID, required String style } ) {
    LogosVO logosVO = getEditLogos( logosID: logosID );
    logosVO.style = style;
    updateEditLogosList( logosVO: logosVO );
  }

  String insertVars( { required String txt, required Map vars } ) {
    p(msg: '_________________START_________________');
    p(msg: 'insertVars: ' + txt);
    p(msg: 'map: ' + vars.toString());
    while (txt.contains('{') == true) {

      /// Get the first {}
      int start = txt.indexOf('{') + 1;
      int end = txt.indexOf('}', start);
      p(msg: '     start: ' + start.toString() + ', end: ' + end.toString());

      /// Get the variable name
      String v = txt.substring(start, end);
      p(msg: '     variable: ' + v);

      txt = txt.substring(0, start - 1) + vars[v] + txt.substring(end + 1);
      p(msg: '     txt: ' + txt);
      p(msg: '_________________END_________________');
    }

    return txt;
  }

  void p( { required String msg } ) {
    //print( msg );
  }

  static bool isDebug = true;
  static void _log( { required String msg, String title = '', Map<String, dynamic>? map, bool isJson=false, bool shout=false, bool fail=false } ) {
    if ( isDebug == true || EOL.isDEBUG == true )
      EOL.log(
        msg: msg,
        title: title,
        map: map,
        isJson: isJson,
        shout: shout,
        fail: fail,
        color: EOL.comboGreen_White,
      );
  }
}

