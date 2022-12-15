import 'package:flutter/material.dart';
import 'package:logos_maru/alert_dialogs.dart';
import 'package:logos_maru/authenticate.dart';
import 'package:logos_maru/logos/language_dropdown/dropdown.dart';
import 'package:logos_maru/logos/logos_widget.dart';
import 'package:logos_maru/logos/model/lang_controller.dart';
import 'package:logos_maru/logos/model/logos_controller.dart';
import 'package:logos_maru/logos/model/txt_utilities.dart';
import 'package:logos_maru/logos_styles.dart';
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

          LogosChangeLanguageDropdown(
            childOptions: LogosDropDownOptions.countryFullNameAndCountryCode,
          ),

          SizedBox( height: 20 ,),

          TextButton(
            onPressed: (){
              Navigator.of( context ).pop();
              LogosController().getRemoteChanges( langCode: LogosLanguageController().editingLanguageCode );
            },
            child: Text(
              'update from the remote database',
              style: LogosTextStyles().btn.logos_white,
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
                    return AuthenticateLogosEditor();
                  });
            },
            child: Text(
              'Authenticate as Editor',
              style: LogosTextStyles().btn.logos_white,
            )
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
            child: Text(
              'View Logs',
              style: LogosTextStyles().btn.logos_white,
            ),
          ),

          SizedBox( height: 20,),

          LogosTxt.static(
            txt: 'App version: {version}',
            vars: { 'version': AppController.version },
            textStyle: LogosTextStyles().btn.logos_white,
          ),

          SizedBox( height: 20,),

          LogosTxt.static(
              txt: 'application build number {build}',
              vars: { 'build': AppController.buildNumber },
            textStyle: LogosTextStyles().btn.logos_white,

          ),

          SizedBox( height: 20,),

          TextButton(
            onPressed: (){
              showDialog<void>(
              	context: context,
              	barrierDismissible: false,
              	builder: (BuildContext context) {
              		return UserNameAlert();
              	});
            },
            child: LogosTxt.static(
              txt: 'User Sign In',
              textStyle: LogosTextStyles().btn.logos_white,
            ),
          )
        ],
      ),
    );
  }
}

