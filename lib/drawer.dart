import 'package:flutter/material.dart';
import 'package:logos_maru/alert_dialogs.dart';
import 'package:logos_maru/authenticate.dart';
import 'package:logos_maru/logos/logos_widget.dart';
import 'package:logos_maru/logos/model/lang_controller.dart';
import 'package:logos_maru/logos/model/logos_controller.dart';
import 'package:logos_maru/main.dart';

class DrawerMenu extends StatelessWidget {

  @override
  Widget build( BuildContext context ) {

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          SizedBox( height: 50 ,),

          LogosTxt(
            comment: 'version',
            logosID: 9,
            vars: { 'version': Init.version },
          ),

          LogosTxt(
              comment: 'build',
              logosID: 10,
              vars: { 'build': Init.buildNumber }
          ),

          SizedBox( height: 20 ,),

          TextButton(
            onPressed: (){
              Navigator.of( context ).pop();
              LogosController().getRemoteChanges( langCode: LanguageController().editingLanguageCode );
            },
            child: LogosTxt(
              comment: 'getRemoteChanges',
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
                    return AuthenticateEditor();
                  });
            },
            child: LogosTxt(
              comment: 'authenticateAsEditor',
              logosID: 12,
            ),
          ),

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
              comment: 'viewLogs_btn',
              logosID: 13,
            ),
          ),
        ],
      ),
    );
  }
}
