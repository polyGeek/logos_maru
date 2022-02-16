import 'package:logos_maru/logos/model/db_helpers.dart';
import 'package:logos_maru/logos/model/eol.dart';
import 'package:logos_maru/logos/model/settings_controller.dart';
import 'package:sqflite/sqflite.dart';


class SettingsDB {

	void updateBits( String bits ) async {
		Database db = await DBHelpers.openUserSettingsDatabase();
		String sql = "UPDATE settings set bits = '$bits' WHERE uKey = 1";
		await db.rawQuery( sql );
	}
	
	void setFontScale( { required double fontScale } ) async {
		Database db = await DBHelpers.openUserSettingsDatabase();
		String sql = "UPDATE settings set fontScale = $fontScale WHERE uKey = 1";
		_log( msg: 'DBuserSettings.setFontScale-> ' + sql );
		await db.rawQuery( sql );
		
		sql = "SELECT fontScale FROM settings WHERE uKey = 1";
		List<Map<String, dynamic>> maps = await db.rawQuery( sql );
		
		SettingsVO sVO = SettingsVO(
			bits					: maps[0][ 'bits' ],
			fontScale			: maps[0][ 'fontScale' ],
		);
		
		_log( msg: 'fontScale stored in DB: ' + sVO.fontScale.toString() );
	}
	
	Future<SettingsVO> getUserSettings() async {
		Database db = await DBHelpers.openUserSettingsDatabase();
		
		String sql = "SELECT * FROM settings WHERE uKey = 1";
		List<Map<String, dynamic>> maps = await db.rawQuery( sql );
		
		if( maps.length == 0 ) {
			
			/// Insert default values.
			await db.rawQuery( "INSERT INTO settings ( "
			"uKey, "
			"bits, "
			"fontScale, "
					" ) VALUES ( "
					"null, "				/// uKey
					"'0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
					"0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000' "				/// bits
					"1.0, "					/// fontScale
			);
			
			sql = "SELECT * FROM settings WHERE uKey = 1";
			maps = await db.rawQuery( sql );
		}
		
		return SettingsVO(
			bits    					: maps[0][ 'bits' ],
			fontScale					: maps[0][ 'fontScale' ],
		);
	}
	
	void incrementAppStart() async {
		Database db = await DBHelpers.openUserSettingsDatabase();
		String sql = "UPDATE settings SET `app_starts` = `app_starts` + 1 WHERE uKey = 1";
		db.rawQuery( sql );
	}

	static bool isDebug = false;
	static void _log( { required String msg, bool isJson=false, bool shout=false, bool fail=false } ) {
		if ( isDebug == true || EOL.isDEBUG == true )
			EOL.log( msg: msg, isJson: isJson, shout: shout, fail: fail );
	}
	
}