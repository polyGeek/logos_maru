import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:logos_maru/logos/model/data_tags/data_vo.dart';
import 'package:logos_maru/logos/model/data_tags/screens_controller.dart';
import 'package:logos_maru/logos/model/data_tags/styles_controller.dart';
import 'package:logos_maru/logos/model/data_tags/tag_controller.dart';
import 'package:logos_maru/logos/model/db.dart';
import 'package:logos_maru/logos/model/db_helpers.dart';
import 'package:logos_maru/logos/model/eol.dart';
import 'package:logos_maru/logos/model/eol_colors.dart';
import 'package:logos_maru/logos/model/lang_controller.dart';
import 'package:logos_maru/logos/model/lang_vo.dart';
import 'package:logos_maru/logos/model/logos_service.dart';
import 'package:logos_maru/logos/model/logos_vo.dart';
import 'package:logos_maru/logos/model/settings_controller.dart';


class LogosController extends ChangeNotifier {
  static final LogosController _logosController = LogosController._internal();
  factory LogosController() => _logosController;
  LogosController._internal();

  String _environment = '';

  List<LogosVO> _logosList = [];
  List<LogosVO> _logosList_EN = [];
  List<LogosVO> _editingLogosList = [];
  List<DataVO>  _tagList = [];

  /// Is editable
  bool _isEditable = false;
  bool get isEditable => _isEditable;

  /// Selected LogosVO for editing.
  LogosVO? _editingLogosVO;
  LogosVO? get editingLogosVO => _editingLogosVO;
  void setEditingLogosVO( { required LogosVO logosVO } ) {
    _editingLogosVO = logosVO;
  }

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

  /// API path and version
  String _apiPath = '';
  String get api => _apiPath;
  String _apiVersion = '';
  String get apiVersion => _apiVersion;

  /// Reference to the LogosFontStyles class
  dynamic _logosTextStyles;
  dynamic get logosFontStyles => _logosTextStyles;

  bool _showConsoleOutput = false;
  bool get showConsoleOutput => _showConsoleOutput;

  /**********************
   *** Initialization ***
   ***********************/
  Future<bool> init( {
    required String apiPath,
    required String apiVersion,
    required String environment,
    required dynamic logosTextStyles,
    required List<String> embeddedDatabases,
    bool showConsoleOutput = false,
  } ) async {

    _apiPath          = apiPath;
    _apiVersion       = apiVersion;
    _environment      = environment;
    _logosTextStyles  = logosTextStyles;
    _showConsoleOutput = showConsoleOutput;

    // todo: the translation files should be passed as a list in the init() call.
    /// 0: Copy databases from assets folder
    embeddedDatabases.forEach( (embeddedDatabase) async {
      await DBHelpers.copyEmbeddedDatabase( assetPath: embeddedDatabase );
      print( 'LogosController.init() - Copied embedded database: $embeddedDatabase' );
    } );
    /*DBHelpers.copyEmbeddedDatabase( filename: 'logos_maru/logos_pref.db' );
    DBHelpers.copyEmbeddedDatabase( filename: 'logos_maru/logos_EN.db' );
    DBHelpers.copyEmbeddedDatabase( filename: 'logos_maru/logos_ES.db' );*/

    /// 0.1: Init the SettingsController where the fontScale is set.
    await SettingsController().initSettings();

    /// 1: get the selected langCode from the local DB.
    LanguageController().selectedAppLanguageCode = await LogosDB().getSavedLanguagePreference();
    _log(msg: '_selectedLangCode: ' + LanguageController().selectedAppLanguageCode.toString());

    /// 2: get all of the language options from the local DB.
    LanguageController().languageOptionsList = await LogosDB().getLanguageOptionsList();

    _log( msg: 'Language options: ' + LanguageController().languageOptionsList.toString() );

    /// 3: get language data from local DB.
    _logosList = await LogosDB().getLogosDataFromLocalDB( langCode: LanguageController().selectedAppLanguageCode.toString() );
    _logosList_EN = await LogosDB().getLogosDataFromLocalDB( langCode: 'EN' );

    /// 4: get any changes approved by the remote DB.
    getRemoteChanges( langCode: LanguageController().selectedAppLanguageCode );

    /// 5: Set the EditingLanguage Code to be the same as the viewing language code.
    LanguageController().editingLanguageCode = LanguageController().selectedAppLanguageCode;

    /// 6: get the tag list from the local DB.
    _tagList = await LogosDB().getDataListFromLocalDB( dataManagerType: DataManagerType.tags );

    /// 7: get the screen list from the local DB.
    //_screenList = await LogosDB().getDataListFromLocalDB( dataManagerType: DataManagerType.screens );

    //FontSizeController().adjustFontScale( scale: 0 );
    //_logosTextStyles.updateStyles();

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
      'env': _environment,
    };

    _log(msg: "signIn: Data to server -> \n " + map.toString() );

    String result = await NetworkHelper.sendPostRequest(
        url: _apiPath + _apiVersion + '/signin.php',
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

      /// Style Options
      var stylesDecoded = jsonDecode( result )[ 'styles' ] as List;
      if( stylesDecoded.isNotEmpty ) {
        _log(msg: 'Styles\n' + stylesDecoded.toString() );
        StylesController().setDataList( dataList: stylesDecoded.map( (e) => DataVO.fromJson(e) ).toList() );
      }

      /// Screen Options
      var screensDecoded = jsonDecode( result )[ 'screens' ] as List;
      if( stylesDecoded.isNotEmpty ) {
        _log(msg: 'screens\n' + screensDecoded.toString() );
        ScreensController().setDataList( dataList: screensDecoded.map( (e) => DataVO.fromJson( e ) ).toList() );
      }

      /// Tag Options
      var tagsDecoded = jsonDecode( result )[ 'tags' ] as List;
      if( tagsDecoded.isNotEmpty ) {
        _log(msg: 'Tags\n' + tagsDecoded.toString() );
        TagController().setDataList( dataList: tagsDecoded.map( (e) => DataVO.fromJson(e) ).toList() );
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

    /// Get the last update timestamp from the tagsDB.
    String lastTagUpdate = await LogosDB().getLastTagUpdate();

    /// Get the last update timestamp from the screensDB.
    String lastScreenUpdate = await LogosDB().getLastScreensUpdate();

    /// Data to the server
    Map<String, dynamic> map = {
      'lastLangID'        : lastLangKey,
      'lastUpdate'        : lastUpdate,
      'langCode'          : langCode,
      'lastTagUpdate'     : lastTagUpdate,
      'lastScreenUpdate'  : lastScreenUpdate,
      'env'               : _environment
    };

    _log( msg: 'Data To Server', map: map );

    String result = await NetworkHelper.sendPostRequest(
        url: _apiPath + _apiVersion + '/kickoff.php',
        map: map
    );

    /// Language Options
    var newLanguageOptionsDecoded = jsonDecode( result )[ 'newLanguagesOptions' ] as List;

    if( newLanguageOptionsDecoded.isNotEmpty ) {
      _log(msg: 'newLanguageOptions', json: result );

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

    /// Update tagsDB
    var tagsDecoded = jsonDecode(result)[ 'tags' ] as List;
    if( tagsDecoded.isNotEmpty ) {
      _log( msg: "New tags", shout: true );
      List<DataVO> tagsList = tagsDecoded.map((e) => DataVO.fromJson(e)).toList();

      /// Update database
      await LogosDB().updateData(
          dataManagerType: DataManagerType.tags,
          newData: tagsList
      );
    }

    /// Update screensDB
    var screensDecoded = jsonDecode(result)[ 'screens' ] as List;
    if( screensDecoded.isNotEmpty ) {
      _log( msg: "New screens", shout: true );
      List<DataVO> screensList = screensDecoded.map((e) => DataVO.fromJson(e)).toList();

      /// Update database
      await LogosDB().updateData(
          dataManagerType: DataManagerType.screens,
          newData: screensList
      );
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
        String txt = ( vars == null )? logosVO.txt : _insertVars( txt: logosVO.txt, vars: vars);

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

  String _debugWithDoubleSizeORhashtag( { required String txt } ) {
    if( _useHashtag == true ) {
      return txt = '#' + txt + '#';
    } else if( _makeDoubleSize == true ) {
      return txt + ' | ' + txt.toUpperCase();
    } else {
      return txt;
    }
  }

  List<LogosVO> _lastTagList = [];
  LogosVO getDynamicLogos( {
    required String txt,
    required String tag,
    Map? vars,
  } ) {

    if( _lastTagList.isEmpty || _lastTagList[0].tags != tag ) {
      _lastTagList = _logosList_EN.where((element) => element.tags == tag).toList();
    }

    int tagID = 0;
    /// Go through the _tagList and find the matching name.
    for( int i = 0; i < _tagList.length; i++ ) {
      if( _tagList[i].name == tag ) {
        tagID = _tagList[i].id;
        break;
      }
    }

    for (int i = 0; i < _logosList_EN.length; i++) {
      LogosVO logosVO = _logosList_EN.elementAt(i);

      if( logosVO.tags.contains( tagID.toString() ) ) {
        if( logosVO.txt == txt ) {
          logosVO.txt = ( vars == null )? logosVO.txt :  _insertVars( txt: logosVO.txt, vars: vars );
          logosVO.txt = _debugWithDoubleSizeORhashtag( txt: logosVO.txt );
          return logosVO;
        }
      }
    }

    return LogosVO.error( txt: '###ERROR\n'
        'no match found for:\n' + txt + '\nwith tag: ' + tag );
  }

  LogosVO getLogosVO( {
    required int logosID,
    Map? vars }) {

    for (int i = 0; i < _logosList.length; i++) {
      LogosVO logosVO = _logosList.elementAt(i);
      if ( logosVO.logosID == logosID ) {
        logosVO.txt = ( vars == null )? logosVO.txt : _insertVars( txt: logosVO.txt, vars: vars );

        logosVO.txt = _debugWithDoubleSizeORhashtag( txt: logosVO.txt );
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
          logosVO.txt = _insertVars( txt: logosVO.txt, vars: vars );
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
      'env'         : _environment,
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
        url: _apiPath + _apiVersion + '/add-new.php',
        map: map
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

  void setEditingLogoVOisRich( { required bool isRich } ) {
    _editingLogosVO!.isRich = ( isRich == true )? 1 : 0;
    update();
  }

  void setEditingLogoVOstyle( { required int logosID, required String style } ) {
    LogosVO logosVO = getEditLogos( logosID: logosID );
    logosVO.style = style;
    updateEditLogosList( logosVO: logosVO );
  }

  String _insertVars( { required String txt, required Map vars } ) {

    while (txt.contains('{') == true) {

      /// Get the first {}
      int start = txt.indexOf('{') + 1;
      int end = txt.indexOf('}', start);

      /// Get the variable name
      String v = txt.substring(start, end);

      txt = txt.substring(0, start - 1) + vars[v].toString() + txt.substring(end + 1);
    }

    return txt;
  }

  static void _log( { required String msg, String title='', Map<String, dynamic>? map, String json='', bool shout=false, bool fail=false } ) {
    if( LogosController().showConsoleOutput == true )
      EOL.log( msg: msg, map: map, title: title, json: json, shout: shout, fail: fail, color:
      EOLcolors.logosController_green_White
      );
  }
}

