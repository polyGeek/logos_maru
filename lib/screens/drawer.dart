import 'package:flutter/material.dart';
import 'package:logos_maru/alert_dialogs.dart';
import 'package:logos_maru/authenticate.dart';
import 'package:logos_maru/logos/logos_widget.dart';
import 'package:logos_maru/logos/model/lang_controller.dart';
import 'package:logos_maru/logos/model/lang_vo.dart';
import 'package:logos_maru/logos/model/logos_controller.dart';
import 'package:logos_maru/utils/data_controller.dart';

class DrawerMenu extends StatelessWidget {

  @override
  Widget build( BuildContext context ) {

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          SizedBox( height: 50 ,),

          ChangeLanguageDropdown(),

          SizedBox( height: 20 ,),

          TextButton(
            onPressed: (){
              Navigator.of( context ).pop();
              LogosController().getRemoteChanges( langCode: LanguageController().editingLanguageCode );
            },
            child: LogosTxt(
              comment: 'Button text to update LogosMaru data from the remote database',
              logosID: 10,
            ),

          ),

          SizedBox( height: 20 ,),

          TextButton(
            onPressed: (){
              Navigator.of( context ).pop();
              showDialog<void>(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return AuthenticateEditor();
                  });
            },
            child:LogosTxt(
              comment: 'Authenticate as Editor',
              logosID: 11,
            ),
          ),

          SizedBox( height: 20 ,),

          TextButton(
            onPressed: (){
              Navigator.of( context ).pop();
              showDialog<void>(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return ViewLogsDialog();
                  });
            },
            child: LogosTxt(
              comment: 'View Logs: view the logs',
              logosID: 12,
            ),
          ),

          SizedBox( height: 20,),

          LogosTxt(
            comment: 'App version label',
            logosID: 8,
            vars: { 'version': DataController.version },
          ),

          LogosTxt(
              comment: 'application build number',
              logosID: 9,
              vars: { 'build': DataController.buildNumber }
          ),

        ],
      ),
    );
  }
}


/** ===============================================
 *  Change Language Dropdown
 *  ===============================================*/

class ChangeLanguageDropdown extends StatefulWidget {
    @override
    _ChangeLanguageDropdownState createState() => _ChangeLanguageDropdownState();
}

class _ChangeLanguageDropdownState extends State<ChangeLanguageDropdown> {
  String _dropdownValue   = 'EN';

  @override
  void initState() {
    super.initState();
    _dropdownValue = LanguageController().selectedAppLanguageCode;
  }

    @override
    Widget build( BuildContext context ) {
        return DropdownButton<String>(
          value: _dropdownValue,
          icon: const Icon(Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          underline: Container(
            height: 2,
            color: Colors.amber,
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
        );
    }
}