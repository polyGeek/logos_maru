import 'package:logos_maru/logos/model/adjust_font.dart';
import 'package:logos_maru/logos/model/settings_db.dart';

class SettingsController {
	static final SettingsController _settingsController = SettingsController._internal();
	factory SettingsController() => _settingsController;
	SettingsController._internal();

	static bool isDebug = false;

	static SettingsDB _settingsDB = SettingsDB();
	static late SettingsVO _settingsVO;
	static SettingsVO get settingsVO => _settingsVO;

	Future<void> initSettings() async {
		_settingsVO = await _settingsDB.getUserSettings();

		//FontSizeController().fontSizeAdjustment = _settingsVO.fontSizeAdjustment;
		FontSizeController().changeFontSizeAdjustment( fontSizeAdjustment: _settingsVO.fontSizeAdjustment );
	}


	void setFontSizeAdjustment( { required int fontSizeAdjustment } ) async {
		_settingsDB.setFontScale( fontSizeAdjustment: fontSizeAdjustment );
	}
}


class SettingsVO {

	bool isDebug = false;

	int 					fontSizeAdjustment			= 0;
	String 				bits = '';
			/*'0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
			'0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000';*/


	SettingsVO( {
		required this.fontSizeAdjustment,
		required this.bits,
	} );

	Map<String, dynamic> toMap() {
		return {
			'fontSizeAdjustment'		: fontSizeAdjustment,
			'bits'									: bits,
		};
	}

}