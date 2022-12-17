import 'dart:io';
import 'package:flutter/services.dart';
import 'package:logos_maru/logos/model/eol.dart';
import 'package:logos_maru/logos/model/eol_colors.dart';
import 'package:logos_maru/logos/model/logos_controller.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelpers {

  static dynamic openLogosDatabase( { required String langCode } ) async {

    return openDatabase(

      join( await getDatabasesPath(), 'logos_$langCode.db' ),

      onCreate: ( db, version ) {
        String sql = "CREATE TABLE logos_$langCode ( "
            "logosID 				  INTEGER PRIMARY KEY, "
            "description      TEXT, "
            "tags             VARCHAR(64), "
            "note             TEXT, "
            "txt              TEXT, "
            "isRich           INTEGER DEFAULT 0, "
            "style            VARCHAR(64) DEFAULT 'body', "
            "lastUpdate       VARCHAR(16)"
            " )";
        db.execute( sql );
      },
      version: 1,
    );
  }

  static dynamic openLanguagePreference() async {

    return openDatabase(

      join( await getDatabasesPath(), 'logos_pref.db' ),

      onCreate: ( db, version ) {
        String sql = "CREATE TABLE `pref` ( "
            "langID 				  INTEGER PRIMARY KEY, "
            "isSelected       INT, "
            "langCode         VARCHAR(4), "
            "countryCode      VARCHAR(8) DEFAULT '', "
            "name             VARCHAR(32)"
            " )";

        db.execute( sql );
      },
      version: 1,
    );
  }

  static dynamic openDataTable( { required String table } ) async {

    return openDatabase(

      join( await getDatabasesPath(), 'logos_$table.db' ),

      onCreate: ( db, version ) {
        String sql = "CREATE TABLE `$table` ( "
            "id 				  INTEGER PRIMARY KEY, "
            "name         VARCHAR(32), "
            "description  TEXT, "
            "lastUpdated   datetime"
            " )";

        db.execute( sql );
      },
      version: 1,
    );
  }

  static Future<bool> copyEmbeddedDatabase( { required String assetPath } ) async {
    /// TESTING: This forces the code to recreate the database.
    ///return true;

    _log( msg: 'Get DB: ' + assetPath );

    String fileName = assetPath.split( '/' ).last;
    String dbPath = join( await getDatabasesPath(), fileName );
    bool doesDbExist = await File( dbPath ).exists();

    _log(msg: 'Does DB exist: ' + doesDbExist.toString() );

    if( doesDbExist == false ) {

      try {

        ByteData data = await rootBundle.load( join( assetPath ) );
        _log(msg: 'ByteData lengthInBytes: ' + data.lengthInBytes.toString() );
        List<int> bytes = data.buffer.asUint8List( data.offsetInBytes, data.lengthInBytes );
        File file = await File( dbPath ).writeAsBytes( bytes );
        _log(msg: 'File path: ' + file.path );

        return true;

      } catch ( e ) {
        _log(msg: 'Error: ' + e.toString() );
        return false;
      }

    } else {
      return false;
    }
  }

  static dynamic openUserSettingsDatabase() async {

    return openDatabase(

      join( await getDatabasesPath(), 'logos_settings.db' ),

      onCreate: ( db, version ) {
        String sql = "CREATE TABLE `settings` ( "
            "uKey				          INTEGER PRIMARY KEY, "
            "bits                 VARCHAR(256), "
            "fontSizeAdjustment    INTEGER DEFAULT 0 "
            " )";

        db.execute( sql );
      },
      version: 1,
    );
  }

  static dynamic updateDB( { required Database db, required String langCode } ) async {
    try {
      await db.rawQuery( "ALTER TABLE logos_$langCode ADD COLUMN isRich INTEGER DEFAULT 0;" );
      await db.rawQuery( "ALTER TABLE logos_$langCode ADD COLUMN style VARCHAR(32) DEFAULT 'body';" );
      await db.rawQuery( "ALTER TABLE pref ADD COLUMN countryCode VARCHAR(8) DEFAULT '';" );
    } catch( e ) {}
  }

  static void _log( { required String msg, String title='', Map<String, dynamic>? map, String json='', bool shout=false, bool fail=false } ) {
    if ( LogosController().showConsoleOutput == true )
      EOL.log( msg: msg, map: map, title: title, json: json, shout: shout, fail: fail, color: EOLcolors.database_blue_LightYellow );
  }
}
