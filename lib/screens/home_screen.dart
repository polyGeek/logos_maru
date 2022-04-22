import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:logos_maru/alert_dialogs.dart';
import 'package:logos_maru/logos/logos_widget.dart';
import 'package:logos_maru/logos/model/lang_controller.dart';
import 'package:logos_maru/logos/model/lang_vo.dart';
import 'package:logos_maru/logos/model/logos_controller.dart';
import 'package:logos_maru/utils/data_controller.dart';
import 'package:logos_maru/utils/drawer.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _dropdownValue   = 'EN';

  @override
  void initState() {
    super.initState();
    _dropdownValue = LanguageController().selectedAppLanguageCode;
    DataController().addListener(() { _update(); } );
    LogosController().addListener(() { _update(); } );
  }

  @override
  void dispose() {
    DataController().removeListener(() { _update(); } );
    LogosController().removeListener(() { _update(); } );
    super.dispose();
  }

  void _update() {
    if( mounted )
      setState(() {});
  }

  void _onSigninTap() {
    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return UserNameAlert();
        });
  }

  @override
  Widget build( BuildContext context ) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              LogosTxt(
                  comment: 'LogosMaru',
                  logosID: 1
              ),

              Builder(builder: (BuildContext context) {

                if ( DataController().userName == '' ) {

                  return LogosTxt(
                    comment: 'Link for user to sign in',
                    logosID: 2,
                    onTap: _onSigninTap,
                  );

                } else {

                  return Container(
                    padding: EdgeInsets.zero,
                    child: LogosTxt(
                      comment: 'Welcome UserName and link to user settings',
                      logosID: 3,
                      vars: { 'userName': DataController().userName },
                      onTap: ()=>print( 'Welcome, ' + DataController().userName ),
                    ),
                  );
                }
              }),

            ],
          )
      ),

      endDrawer: Drawer(
        child: DrawerMenu(),
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                const SizedBox( height: 20, ),

                const SizedBox( height: 20, ),

                DropdownButton<String>(
                  value: _dropdownValue,
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: ( String? newValue ) {
                    _dropdownValue = newValue!;
                    print( newValue );
                    LogosController().changeLanguage( langCode: newValue );
                    if( mounted )
                      setState(() {});
                  },
                  items: LanguageController().languageOptionsList.map<DropdownMenuItem<String>>(( LangVO value ) {
                    return DropdownMenuItem<String>(
                      value: value.langCode,
                      child: Text( value.langCode + ' - ' + value.name ),
                    );
                  }).toList(),
                ),

                SizedBox( height: 20, ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
