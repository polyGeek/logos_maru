import 'package:flutter/material.dart';
import 'package:logos_maru/logos/logos_widget.dart';
import 'package:logos_maru/logos/model/eol.dart';
import 'package:logos_maru/logos/model/settings_controller.dart';
import 'package:logos_maru/logos/model/txt_utilities.dart';
import 'package:logos_maru/logos_styles.dart';


class LogosMaruShowAdjustFontScale extends StatelessWidget {

    /// The icon is square, so the width and height are the same.
    final double iconSize;

    static const String fontsizeAdjustIcon = 'assets/logos_maru/fontsize-adjust-icon.png';

    LogosMaruShowAdjustFontScale( { required this.iconSize } );

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
                package: 'logos_maru',
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
                'Font Scale = ' + FontSizeController().userScale.toString(),
            ),
            content: SingleChildScrollView(
                child: ListBody(
                    children: <Widget>[


                        SizedBox(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height / 3,
                            child: LogosTxt(
                                comment: "This is sample text to show you the default font scale as you make adjustments.!!! | Text shown on the *Adjust Font Size* popup for readers to guage fontSize changes.",
                                logosID: 30,
                                txtStyle: LogosStyles.titleLight,
                            ),

                            /// todo: set maxLines and overflow.
                        ),

                        const SizedBox( height: 20 ,),

                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                            children: <Widget>[

                                GestureDetector(
                                    onTap: (){
                                        FontSizeController().adjustFontScale( scale: -0.1 );
                                    },
                                    child: Icon(
                                        Icons.remove_circle_outline,
                                        size: 60,
                                    )
                                ),

                                GestureDetector(
                                    onTap: (){
                                        FontSizeController().adjustFontScale( scale: 0.1 );
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
        _userScale = SettingsController.settingsVO.fontScale;
        if( _userScale > 1 ) {
            _titleScale = 1 + ( ( _userScale - 1 ) / 2 );
        }

        FontSizeController().adjustFontScale( scale: 0 );
    }

    double _userScale = 1.0;
    double get userScale => _userScale;
    set userScale( double value ) {
        _userScale = value;
        notifyListeners();
    }

    double _titleScale = 1.0;
    double get titleScale => _titleScale;

    /*void adjustUserScale( { required double scale } ) {

        double newScale = double.parse( ( _userScale + scale ).toStringAsFixed( 1 ) );

        if( newScale >= 0.5 && newScale <= 2.0 ) {
            _userScale = newScale;

            if( _userScale > 1 ) {
                _titleScale = 1 + ( ( _userScale - 1 ) / 2 );
            }
            EOL.log( msg: "SETTING FONT SCALE = " + _userScale.toString() + ' : titleScale = ' + _titleScale.toString() );
        } else if( _userScale > 2.0 ) {
            _userScale = 1;
            EOL.log( msg: "RESETTING FONT SCALE = 1 \nInstead of " + newScale.toString(), fail: true );
        }
    }*/

    /**original*/
    /*double get title       => 28 * _titleScale;
    double get heading     => 20 * _titleScale;
    double get subHeading  => 18 * _userScale;
    double get bodySize    => 16 * _userScale;
    double get bodySm      => 12 * _userScale;
    double get bodySubSm   => 10 * _userScale;*/

    void adjustFontScale( { required double scale } ) async {

        scale = double.parse( ( _userScale + scale ).toStringAsFixed( 1 ) );

        if( scale >= 0.5 && scale <= 2.0 ) {
            _userScale = scale;

            if( _userScale > 1 ) {
                _titleScale = 1 + ( ( _userScale - 1 ) / 2 );
            }
            EOL.log( msg: "SETTING FONT SCALE = " + _userScale.toString() + ' : titleScale = ' + _titleScale.toString() );
        }

        /// Keep the _userScale within the range of 0.5 to 2.0.
        if( _userScale > 2.0 ) {
            _userScale = 2.0;
        } else if( _userScale < 0.5 ) {
            _userScale = 0.5;
        }

        notifyListeners();

        /// Store the fontScale in the UserSettings.
        SettingsController().setFontScale( fontScale: FontSizeController().userScale );
    }
}
