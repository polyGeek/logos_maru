import 'package:flutter/material.dart';
import 'package:logos_maru/logos/logos_widget.dart';
import 'package:logos_maru/logos/model/eol.dart';
import 'package:logos_maru/logos/model/logos_controller.dart';
import 'package:logos_maru/logos/model/settings_controller.dart';
import 'package:logos_maru/logos/model/txt_utilities.dart';


class LogosMaruShowAdjustFontScale extends StatelessWidget {

    /// The icon is square, so the width and height are the same.
    final double iconSize;
    final String package;

    static const String fontsizeAdjustIcon = 'assets/logos_maru/fontsize-adjust-icon.png';

    LogosMaruShowAdjustFontScale( {
        required this.iconSize,
        this.package = 'logos_maru',
    } );

    @override
    Widget build(BuildContext context) {
        return GestureDetector(
            onTap: () {
                showDialog<void>(
                    context: context,
                    barrierDismissible: true,
                    builder: ( BuildContext context ) {
                        return AdjustFontScale();
                    }
                );
            },
            child: Image.asset( fontsizeAdjustIcon,
                width: iconSize,
                height: iconSize,
                package: ( package == '' )? null : package,
            )
        );
    }
}

class AdjustFontScale extends StatefulWidget {

    @override
    _AdjustFontScaleState createState() => _AdjustFontScaleState();
}

class _AdjustFontScaleState extends State<AdjustFontScale> {

    @override
    void initState() {
        super.initState();
        FontSizeController().addListener(() { _update(); } );
    }

    @override
    void dispose() {

        FontSizeController().removeListener(() { _update(); } );
        super.dispose();
    }

    void _update() {
        if( mounted )
            setState(() {});
    }

    @override
    Widget build( BuildContext context ) {
        return AlertDialog(
            insetPadding: EdgeInsets.all( 30 ),
            contentPadding: EdgeInsets.all( 10 ),

            title: Text(
                'Text Size Adjustment = ' + FontSizeController().fontSizeAdjustment.toString(),
            ),
            content: SingleChildScrollView(
                child: ListBody(
                    children: <Widget>[


                        SizedBox(
                            //width: double.infinity,
                            width: MediaQuery.of( context ).size.width * 0.8,
                            height: MediaQuery.of(context).size.height / 3,
                            child: LogosTxt(
                                comment: "This is sample text to show you the default font scale as you make adjustments. | Text shown on the *Adjust Font Size* popup for readers to guage fontSize changes.",
                                logosID: 30,
                            ),

                            /// todo: set maxLines and overflow.
                        ),

                        const SizedBox( height: 20 ,),

                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                            children: <Widget>[

                                GestureDetector(
                                    onTap: (){
                                        FontSizeController().changeFontSizeAdjustment( fontSizeAdjustment: -1 );
                                    },
                                    child: Icon(
                                        Icons.remove_circle_outline,
                                        size: 60,
                                    )
                                ),

                                GestureDetector(
                                    onTap: (){
                                        FontSizeController().changeFontSizeAdjustment( fontSizeAdjustment: 1 );
                                    },
                                    child: Icon(
                                        Icons.add_circle_outline,
                                        size: 60,
                                    )
                                ),

                            ],
                        )
                    ],
                ),
            ),
            actions: <Widget>[

                ElevatedButton(
                    onPressed: () {
                        Navigator.of(context).pop();
                    },
                    child: Text( 'CLOSE', style: LogosAdminTxtStyles.btn ),
                ),
            ],
        );
    }
}


class FontSizeController extends ChangeNotifier {
    static final FontSizeController _fontSizeController = FontSizeController._internal();
    factory FontSizeController() => _fontSizeController;
    FontSizeController._internal();

    void init() {
        _fontSizeAdjustment = SettingsController.settingsVO.fontSizeAdjustment;
        FontSizeController().changeFontSizeAdjustment( fontSizeAdjustment: 0 );
    }

    int _fontSizeAdjustment = 0;
    int get fontSizeAdjustment => _fontSizeAdjustment;

    void changeFontSizeAdjustment( { required int fontSizeAdjustment } ) async {
        print( 'pre adjustment = ' + _fontSizeAdjustment.toString() );
        _fontSizeAdjustment += fontSizeAdjustment;
        print( 'post adjustment = ' + _fontSizeAdjustment.toString() );

        /// Keep the _fontSizeAdjustment within the range of -10 to 20.
        if( _fontSizeAdjustment > 20 ) {
            _fontSizeAdjustment = 20;
        } else if( _fontSizeAdjustment < -10 ) {
            _fontSizeAdjustment = -10;
        }

        /// Store the fontSizeAdjustment in the Settings.
        SettingsController().setFontSizeAdjustment( fontSizeAdjustment: _fontSizeAdjustment );

        _log(msg: 'userScale: ' + _fontSizeAdjustment.toString() );
        notifyListeners();
    }

    /** ===============================================
     *  EOL
     *  ===============================================*/
    static const bool isDebug = true;

    static void _log({required String msg, String title = '', Map<String, dynamic>? map, String json = '', bool shout = false, bool fail = false}) {
        if (isDebug == true || EOL.isDEBUG == true)
            EOL.log(msg: msg, borderSide: 'H', borderTop: 'H', map: map, title: title, json: json, shout: shout, fail: fail, color: EOL.comboLightGreen_White );
    }
}
