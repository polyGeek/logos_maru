import 'package:logos_maru/logos/model/db_helpers.dart';
import 'package:logos_maru/logos/model/eol.dart';
import 'package:logos_maru/logos/model/settings_controller.dart';
import 'package:sqflite/sqflite.dart';


class SettingsDB {

	/*void updateBits( String bits ) async {
		Database db = await DBHelpers.openUserSettingsDatabase();
		String sql = "UPDATE settings set bits = '$bits' WHERE uKey = 1";
		await db.rawQuery( sql );
	}*/
	
	void setFontScale( { required double fontScale } ) async {
		Database db = await DBHelpers.openUserSettingsDatabase();
		String sql = "UPDATE `settings` set fontScale = $fontScale WHERE uKey = 1";
		//_log( msg: 'DBuserSettings.setFontScale-> ' + sql );
		await db.rawQuery( sql );
		
		sql = "SELECT bits, fontScale FROM `settings` WHERE uKey = 1";
		List<Map<String, dynamic>> maps = await db.rawQuery( sql );

		if( maps.isNotEmpty ) {
			SettingsVO sVO = SettingsVO(
				bits					: maps[0][ 'bits' ],
				fontScale			: maps[0][ 'fontScale' ],
			);

			_log( msg: 'fontScale stored in DB: ' + sVO.fontScale.toString() );
		} /*else {
			/// Set defaults.
			getUserSettings();
			sql = "INSERT INTO `settings` ( uKey, bits, fontScale ) VALUES ( 1, '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000', 1 )";
			print( sql );
			await db.rawQuery( sql );
		}*/
	}
	
	Future<SettingsVO> getUserSettings() async {
		Database db = await DBHelpers.openUserSettingsDatabase();
		
		String sql = "SELECT * FROM settings WHERE uKey = 1";
		List<Map<String, dynamic>> maps = await db.rawQuery( sql );
		
		if( maps.isEmpty ) {
			
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

	static const bool isDebug = false;
	static void _log( { required String msg, String title='', Map<String, dynamic>? map, String json='', bool shout=false, bool fail=false } ) {
		if ( isDebug == true || EOL.isDEBUG == true )
			EOL.log( msg: msg, map: map, title: title, json: json, shout: shout, fail: fail, color: EOL.comboLightGreen_White );
	}
}