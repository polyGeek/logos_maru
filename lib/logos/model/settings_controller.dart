
import 'package:logos_maru/logos/model/settings_db.dart';

class SettingsController {

	static bool isDebug = false;

	static SettingsDB _settingsDB = SettingsDB();
	static late SettingsVO _settingsVO;
	static SettingsVO get settingsVO => _settingsVO;

	static void initSettings() async {

		_settingsVO = await _settingsDB.getUserSettings();
		_settingsDB.incrementAppStart();
	}


	static void setFontScale( { required double fontScale } ) async {
		_settingsDB.setFontScale( fontScale: fontScale );
	}
}


class SettingsVO {

	bool isDebug = false;

	double 					fontScale			= 1.0;
	String 					bits =
			'0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
			'0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000';


	SettingsVO( {
		required this.fontScale,
		required this.bits,
	} );

	Map<String, dynamic> toMap() {
		return {
			'fontScale'		: fontScale,
			'bits'				: bits,
		};
	}

}