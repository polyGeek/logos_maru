import 'package:flutter/material.dart';
import 'package:logos_maru/alert_dialogs.dart';
import 'package:logos_maru/authenticate.dart';
import 'package:logos_maru/logos/language_dropdown/dropdown.dart';
import 'package:logos_maru/logos/logos_widget.dart';
import 'package:logos_maru/logos/model/lang_controller.dart';
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

          ChangeLanguageDropdown(
            childOptions: DropDownChildOptions.countryFullNameAndCountryCode,
          ),

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
            child: Text( 'Authenticate as Editor',
            style: LogosController().logosFontStyles!.fixedGoogle.gold,)
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
            vars: { 'version': AppController.version },
          ),

          LogosTxt(
              comment: 'application build number',
              logosID: 9,
              vars: { 'build': AppController.buildNumber }
          ),

        ],
      ),
    );
  }
}

