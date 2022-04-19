import 'dart:io';
import 'package:flutter/services.dart';
import 'package:logos_maru/logos/model/eol.dart';
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
            "name             VARCHAR(32)"
            " )";

        db.execute( sql );
      },
      version: 1,
    );
  }

  static Future<bool> copyEmbeddedDatabase( { required String filename } ) async {
    /// TESTING: This forces the code to recreate the database.
    ///return true;

    _log( msg: 'Get DB: ' + filename );

    String dbPath = join( await getDatabasesPath(), filename );
    bool doesDbExist = await File( dbPath ).exists();

    _log(msg: 'Does DB exist: ' + doesDbExist.toString() );

    if( doesDbExist == false ) {

      try {

        ByteData data = await rootBundle.load( join( 'assets/', filename ) );
        _log(msg: 'ByteData lengthInBytes: ' + data.lengthInBytes.toString() );
        List<int> bytes = data.buffer.asUint8List( data.offsetInBytes, data.lengthInBytes );
        await new File( dbPath ).writeAsBytes( bytes );

        return true;

      } catch ( e ) {
        return false;
      }

    } else {
      return false;
    }
  }

  static dynamic openUserSettingsDatabase() async {

    return openDatabase(

      join( await getDatabasesPath(), 'settings.db' ),

      onCreate: ( db, version ) {
        String sql = "CREATE TABLE settings ( "
            "uKey 								INTEGER PRIMARY KEY, "
            "fontScale						REAL DEFAULT 1 )";
        db.execute( sql );
      },
      version: 1,
    );
  }

  static dynamic updateDB( { required Database db, required String langCode } ) async {
    try {
      await db.rawQuery( "ALTER TABLE logos_$langCode ADD COLUMN isRich INTEGER DEFAULT 0;" );
      await db.rawQuery( "ALTER TABLE logos_$langCode ADD COLUMN style VARCHAR(32) DEFAULT 'body';" );
    } catch( e ) {
    }
  }

  static bool isDebug = true;
  static void _log( { required String msg, bool isJson=false, bool shout=false, bool fail=false } ) {
    if ( isDebug == true || EOL.isDEBUG == true )
      EOL.log(
        msg: msg,
        isJson: isJson,
        shout: shout,
        fail: fail,
        color: EOL.BG_LiteBlue,
      );
  }
}
