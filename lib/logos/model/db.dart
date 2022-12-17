import 'package:logos_maru/logos/model/data_tags/data_vo.dart';
import 'package:logos_maru/logos/model/db_helpers.dart';
import 'package:logos_maru/logos/model/eol.dart';
import 'package:logos_maru/logos/model/eol_colors.dart';
import 'package:logos_maru/logos/model/lang_vo.dart';
import 'package:logos_maru/logos/model/logos_controller.dart';
import 'package:logos_maru/logos/model/logos_vo.dart';
import 'package:sqflite/sqflite.dart';

class LogosDB {
  static final LogosDB _logosDB = LogosDB._internal();
  factory LogosDB() => _logosDB;
  LogosDB._internal();

  Future<String> getLastUpdate( { required String langCode } ) async {

    Database db = await DBHelpers.openLogosDatabase( langCode: langCode );

    /// Query the table for the movie to be updated.
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM `logos_$langCode` ORDER BY lastUpdate DESC LIMIT 1"
    );

    List<LogosVO> list = List.generate( maps.length, ( i ) {

      _log( msg: 'Last update: ' + langCode + ' > ' + maps[i][ 'lastUpdate' ] );
      _log( msg: 'i = ' + i.toString() );

      return LogosVO(
          logosID       : maps[i][ 'logosID' ],
          description   : maps[i][ 'description' ],
          tags          : maps[i][ 'tags' ],
          langCode      : ( maps[i][ 'langCode' ] == null )? '' : maps[i][ 'langCode' ],
          txt           : ( maps[i][ 'txt' ] == null )? '' : maps[i][ 'txt' ],
          note          : ( maps[i][ 'note' ] == null )? '' : maps[i][ 'note' ],
          lastUpdate    : maps[i][ 'lastUpdate' ],
          style         : maps[i][ 'style' ],
          isRich        : maps[i][ 'isRich' ]
      );
    });

    if( list.length == 0 ) {
      return '2021-01-01 00:00:00'; /// Table created date
    } else {
      return list.elementAt( 0 ).lastUpdate;
    }
  }

  Future<List<LogosVO>> getLogosDataFromLocalDB( { required String langCode } ) async {

    Database db = await DBHelpers.openLogosDatabase( langCode: langCode );
    List<Map<String, dynamic>> maps;

    maps = await db.rawQuery( "SELECT * FROM `logos_$langCode` ORDER BY `logosID` ASC" );

    if( maps.isEmpty == false ) {

      List<LogosVO> list = List.generate( maps.length, (i) {

        return LogosVO(
          logosID     : maps[i][ 'logosID' ],
          description : maps[i][ 'description' ],
          tags        : maps[i][ 'tags' ],
          langCode    : (maps[i][ 'langCode' ] == null )? '' : maps[i][ 'langCode' ],
          note        : (maps[i][ 'note' ] == null )? '' : maps[i][ 'note' ],
          txt         : (maps[i][ 'txt' ] == null )? '' : maps[i][ 'txt' ],
          lastUpdate  : maps[i][ 'lastUpdate' ],
          style       : ( maps[i][ 'style' ] == null )? '' : maps[i][ 'style' ],
          isRich      : ( maps[i][ 'isRich' ] == null )? 0 : maps[i][ 'isRich' ],
        );
      });

      _log( msg: '_logosLength: ' + maps.length.toString() );
      _log( msg: maps[0].toString(), );
      /// TEST

      return list;

    } else {

      return [];

    }
  }

  Future<List<LangVO>> updateLanguageOptions( {
    required List newLangList,
  } ) async {

    Database db = await DBHelpers.openLanguagePreference();

    List<Map<String, dynamic>> maps;

    for( int i = 0; i < newLangList.length; i++ ) {

      LangVO langVO = newLangList.elementAt( i );

      _log( msg: "updating changes: " + langVO.langID.toString() + " : " + langVO.langCode.toString() + " : " + langVO.name );

      maps = await db.rawQuery( "SELECT * FROM `pref` WHERE `langID` = ?", [ langVO.langID ] );

      if( maps.isEmpty ) {

        await db.rawInsert( "INSERT INTO `pref` ( "
            "langID, "
            "isSelected, "
            "langCode, "
            "countryCode,"
            "name "
            " ) VALUES ( "
            + langVO.langID.toString() + ', '
            + "0, ?, ?, ? )",
            [
              0, /// isSelected
              langVO.langCode,
              langVO.countryCode,
              langVO.name
            ]
        );

      } else {

        await db.rawUpdate( "UPDATE `pref` SET "
            + "langCode = ?, "
            + "countryCode = ?, "
            + "name = ? "
            + "WHERE langID = ?",
            [
              langVO.langCode,
              langVO.countryCode,
              langVO.name,
              langVO.langID
            ]
        );
      }
    }

    return getLanguageOptionsList();
  }

  Future<List<LangVO>> updateData( {
    required List newData,
    required DataManagerType dataManagerType
  } ) async {

    late Database db;
    String tableName = '';
    if( dataManagerType == DataManagerType.tags ) {
      db = await DBHelpers.openDataTable( table: 'tags' );
      tableName = 'tags';
    } else if( dataManagerType == DataManagerType.screens ) {
      db = await DBHelpers.openDataTable( table: 'screens' );
      tableName = 'screens';
    }


    late List<Map<String, dynamic>> maps;
    String sql = '';

    for( int i = 0; i < newData.length; i++ ) {

      DataVO dataVO = newData.elementAt( i );

      _log( msg: "updating changes: " + dataVO.id.toString() + " : " + dataVO.name );

      if( dataManagerType == DataManagerType.tags ) {
        maps = await db.rawQuery( "SELECT * FROM `$tableName` WHERE `id` = ?", [ dataVO.id ] );
      } else if( dataManagerType == DataManagerType.screens ) {
        maps = await db.rawQuery( "SELECT * FROM `$tableName` WHERE `id` = ?", [ dataVO.id ] );
      }

      if( maps.isEmpty ) {

        sql = "INSERT INTO `$tableName` ( "
            "id, "
            "name, "
            "description, "
            "lastUpdated "
            " ) VALUES ( ?, ?, ?, ? )";
        await db.rawInsert( sql, [ dataVO.id, dataVO.name, dataVO.description, dataVO.lastUpdated ] );

      } else {

        sql = "UPDATE `$tableName` SET "
            + "id = ?, "
            + "name = ?, "
            + "description = ?, "
            + "lastUpdated = ? "
            + "WHERE id = ?";
        await db.rawUpdate( sql, [ dataVO.id, dataVO.name, dataVO.description, dataVO.lastUpdated, dataVO.id ] );
      }
    }

    return getLanguageOptionsList();
  }

  Future<LogosVO> updateLocalDatabase( {
    required List changesList,
    required String langCode,
  } ) async {

    Database db = await DBHelpers.openLogosDatabase( langCode: langCode );

    List<Map<String, dynamic>> maps;
    String sql = '';

    _log( msg: 'changesList.length: ' + changesList.length.toString() );

    for( int i = 0; i < changesList.length; i++ ) {
      LogosVO logosVO = changesList.elementAt( i );

      _log( msg: "updating changes: " + logosVO.logosID.toString() + " : " + logosVO.logosID.toString() + " : " + logosVO.txt );

      maps = await db.rawQuery(
          "SELECT * FROM `logos_$langCode` WHERE logosID = " + logosVO.logosID.toString()
      );

      if( maps.isEmpty ) {

        await db.rawInsert( "INSERT INTO `logos_$langCode` ( "
            "logosID, "
            "description, "
            "tags, "
            "note, "
            "txt, "
            "style, "
            "isRich, "
            "lastUpdate "
            " ) VALUES ( ?, ?, ?, ?, ?, ?, ?, ? ) ",
            [
              logosVO.logosID,
              logosVO.description,
              logosVO.tags,
              logosVO.note,
              logosVO.txt,
              logosVO.style,
              logosVO.isRich,
              logosVO.lastUpdate
            ]

        );
        _log(msg: sql );
        /// Select the row that was just INSERTED.
        sql = "SELECT * FROM `logos_$langCode` ORDER BY `logosID` DESC LIMIT 1";

      } else {

        await db.rawUpdate( "UPDATE `logos_$langCode` SET "
            "description      = ?, "
            + "tags           = ?, "
            + "note           = ?, "
            + "txt            = ?, "
            + "style          = ?, "
            + "isRich         = ?, "
            + "lastUpdate     = ? "
            + "WHERE logosID  = ? ",
            [
              logosVO.description,
              logosVO.tags,
              logosVO.note,
              logosVO.txt,
              logosVO.style,
              logosVO.isRich,
              logosVO.lastUpdate,
              logosVO.logosID,
            ]
        );

        /// Select the row that was just UPDATED.
        sql = "SELECT * FROM `logos_$langCode` WHERE `logosID` = " + logosVO.logosID.toString();
      }
    }

    _log( msg: "SQL: " + sql );
    maps = await db.rawQuery( sql );


    return LogosVO(
        logosID     : maps[0][ 'logosID' ],
        description : maps[0][ 'description' ],
        tags        : maps[0][ 'tags' ],
        lastUpdate  : maps[0][ 'lastUpdate' ],
        langCode    : ( maps[0][ 'langCode' ] == null ) ? '' : maps[0][ 'langCode' ],
        note        : ( maps[0][ 'note' ] == null )     ? '' : maps[0][ 'note' ],
        txt         : ( maps[0][ 'txt' ] == null )      ? '' : maps[0][ 'txt' ],
        style       : maps[0][ 'style' ],
        isRich      : maps[0][ 'isRich' ]

    );
  }

  Future<String> saveLanguagePreference( { required String code } ) async {
    Database db = await DBHelpers.openLanguagePreference();

    /// Set all 'isSelected' = 0
    await db.rawUpdate( "UPDATE `pref` SET `isSelected` = 0", );

    /// Set selected language.
    String sql = "UPDATE `pref` SET `isSelected` = 1 WHERE `langCode` = ?";
    _log( msg: sql );
    await db.rawUpdate( sql, [ code ] );

    /// Select the newly selected language.
    List<Map<String, dynamic>> maps = await db.rawQuery(
      "SELECT `langCode` FROM `pref` WHERE `isSelected` = 1",
    );

    if( maps.isEmpty == true ) {
      /// No language is selected. Set 'EN' to selected as a default.
      return 'EN';
    } else {

      return maps[0][ 'langCode' ];
    }
  }

  Future<String> getSavedLanguagePreference() async {
    Database db = await DBHelpers.openLanguagePreference();

    List<Map<String, dynamic>> maps = await db.rawQuery( "SELECT `langCode` FROM `pref` WHERE `isSelected` = 1" );

    if( maps.isEmpty == true ) {

      _log( msg: 'EMPTY > Setting default language to EN', shout: true );
      return 'EN';
    } else {

      _log( msg: 'Returning saved language code: ' + maps[0][ 'langCode' ] );
      return maps[0][ 'langCode' ];
    }
  }

  /// todo: Change this to using lastUpdate instead of lastKey. Just in case there are changes to existing data.
  Future<int> getLastLangKey() async {
    Database db = await DBHelpers.openLanguagePreference();
    List<Map<String, dynamic>> maps = await db.rawQuery( "SELECT `langID` FROM `pref` ORDER BY `langID` DESC LIMIT 1" );

    _log( msg: 'last langID = ' + maps.toString() );

    if( maps.isEmpty == true ) {
      return 0;
    } else {

      return maps[0][ 'langID' ] as int;
    }
  }

  Future<String> getLastDataUpdate( { required String table } ) async {
    Database db = await DBHelpers.openDataTable( table: table );
    List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT `lastUpdated` FROM `$table` ORDER BY `lastUpdated` DESC LIMIT 1"
    );

    _log( msg: 'last $table update = ' + maps.toString() );

    if( maps.isEmpty == true ) {
      return '2000-01-01 00:00:00';
    } else {

      return maps[0][ 'lastUpdated' ];
    }
  }

  Future<List<LangVO>> getLanguageOptionsList() async {
    Database db = await DBHelpers.openLanguagePreference();
    List<Map<String, dynamic>> maps = await db.rawQuery( "SELECT * FROM `pref` ORDER BY `langCode` DESC" );
    if( maps.isEmpty ) {

      /// Default to EN.
      return [ LangVO( langID: 1, langCode: 'EN', countryCode: 'en', name: 'English' ) ];
    } else {

      List<LangVO> list = List.generate( maps.length, (i) {
        return LangVO(
          langID      : maps[i][ 'langID' ],
          langCode    : maps[i][ 'langCode' ],
          countryCode : maps[i][ 'countryCode' ],
          name        : maps[i][ 'name' ],
        );
      });

      return list;
    }
  }

  /// Return list of Tags or Screens.
  Future<List<DataVO>> getDataListFromLocalDB( { required DataManagerType dataManagerType } ) async {

    late String tableName;
    late Database db;

    if( dataManagerType == DataManagerType.tags ) {
      db = await DBHelpers.openDataTable( table: 'tags' );
      tableName = 'tags';
    } else if( dataManagerType == DataManagerType.screens ) {
      db = await DBHelpers.openDataTable( table: 'screens' );
      tableName = 'screens';
    }

    List<Map<String, dynamic>> maps = await db.rawQuery( "SELECT * FROM `$tableName`" );

    if( maps.isNotEmpty ) {
      List<DataVO> list = List.generate( maps.length, (i) {
        return DataVO(
          id            : maps[i][ 'id' ],
          name          : maps[i][ 'name' ],
          description   : maps[i][ 'description' ],
          lastUpdated   : maps[i][ 'lastUpdated' ],
        );
      });

      return list;
    } else {
      return [];
    }
  }

  static void _log( { required String msg, String title='', Map<String, dynamic>? map, String json='', bool shout=false, bool fail=false } ) {
    if( LogosController().showConsoleOutput == true )
      EOL.log( msg: msg, map: map, title: title, json: json, shout: shout, fail: fail,
          color: EOLcolors.database_blue_LightYellow
      );
  }
}
