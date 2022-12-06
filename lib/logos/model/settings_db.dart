import 'package:logos_maru/logos/model/db_helpers.dart';
import 'package:logos_maru/logos/model/eol.dart';
import 'package:logos_maru/logos/model/logos_controller.dart';
import 'package:logos_maru/logos/model/settings_controller.dart';
import 'package:sqflite/sqflite.dart';


class SettingsDB {

	void setFontScale( { required int fontSizeAdjustment } ) async {
		Database db = await DBHelpers.openUserSettingsDatabase();
		String sql = "UPDATE `settings` set fontSizeAdjustment = $fontSizeAdjustment WHERE uKey = 1";
		_log( msg: 'UPDATE : DBuserSettings.fontSizeAdjustment-> ' + sql );
		await db.rawQuery( sql );
		
		sql = "SELECT bits, fontSizeAdjustment FROM `settings` WHERE uKey = 1";
		List<Map<String, dynamic>> maps = await db.rawQuery( sql );

		if( maps.isNotEmpty ) {
			SettingsVO sVO = SettingsVO(
				bits										: maps[0][ 'bits' ],
				fontSizeAdjustment			: maps[0][ 'fontSizeAdjustment' ],
			);

			_log( msg: 'fontSizeAdjustment stored in DB: ' + sVO.fontSizeAdjustment.toString() );
		}
	}
	
	Future<SettingsVO> getUserSettings() async {
		Database db = await DBHelpers.openUserSettingsDatabase();
		

		List<Map<String, dynamic>> maps = await db.rawQuery( "SELECT * FROM settings WHERE uKey = 1" );
		
		if( maps.isEmpty ) {
			
			/// Insert default values.
			await db.rawQuery( "INSERT INTO settings ( "
					"uKey, bits, fontSizeAdjustment "
					") VALUES ( "
					"null, "
					"'0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000', "
					"0 )"
			);

			maps = await db.rawQuery( "SELECT * FROM settings WHERE uKey = 1" );
		}

		SettingsVO sVO = SettingsVO(
			bits								: maps[0][ 'bits' ],
			fontSizeAdjustment	: maps[0][ 'fontSizeAdjustment' ],
		);

		_log( msg: 'fontSizeAdjustment stored in DB: ' + sVO.fontSizeAdjustment.toString() );
		return sVO;
	}

	static void _log( { required String msg, String title='', Map<String, dynamic>? map, String json='', bool shout=false, bool fail=false } ) {
		if( LogosController().showConsoleOutput == true )
			EOL.log( msg: msg, map: map, title: title, json: json, shout: shout, fail: fail, color: EOL.comboLightGreen_White );
	}
}