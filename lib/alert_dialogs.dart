import 'package:flutter/material.dart';
import 'package:logos_maru/logos/logos_widget.dart';
import 'package:logos_maru/logos/model/eol.dart';
import 'package:logos_maru/logos/model/logos_controller.dart';
import 'package:logos_maru/logos/model/txt_utilities.dart';
import 'package:logos_maru/utils/data_controller.dart';


class UserNameAlert extends StatefulWidget {
  @override
  State<UserNameAlert> createState() => _UserNameAlertState();
}

class _UserNameAlertState extends State<UserNameAlert> {

  String _myName          = '';
  late TextEditingController _tec;

  @override
  void initState() {
    super.initState();

    _tec = TextEditingController( text: _myName );
  }

  @override
  Widget build( BuildContext context ) {
    return AlertDialog(
      scrollable: true,
      insetPadding: EdgeInsets.all( 10 ),
      contentPadding: EdgeInsets.all( 10 ),
      title: Center(
        child: LogosTxt(
          comment: 'Title on Alert for signin',
          logosID: 4,
        ),
      ),

      content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            LogosTxt(
              comment: 'TEST',
              logosID: 7,

              child: TextField(
                minLines: 1, /// Normal textInputField will be displayed
                maxLines: 1, /// When user presses enter it will adapt to it
                autofocus: false,
                controller: _tec,
                autocorrect: false,
                decoration: InputDecoration(
                  /**
                   * The InputDecoration > labelText can only except raw text, not a widget.
                   * So we have to access the Logos data through the API. This text won't be
                   * editable in the client app. Only via the admin.
                   */
                  labelText: LogosController().getLogos( logosID: 7 ), /// 'User name',
                  errorStyle: TextStyle( fontSize: 18, color: Colors.redAccent ),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ),
          ]

      ),

      actions: [

        TextButton(
          onPressed: () => Navigator.of( context ).pop(),
          child: LogosTxt(
            comment: 'CANCEL btn',
            logosID: 5,
            onTap: () => Navigator.of( context ).pop(),
          ),
        ),

        SizedBox( width: 20, ),

        ElevatedButton(
          onPressed: () {
            DataController().setUserName( userName: _tec.text );
            LogosController().update();
            Navigator.of( context ).pop();
          },
          child: LogosTxt(
            comment: 'SUBMIT btn label',
            txtStyle: TxtStyles.btn,
            logosID: 6,
          ),
        ),

      ],

    );
  }
}




class SubmitBtnPressed extends StatelessWidget {

  @override
  Widget build( BuildContext context ) {
    return AlertDialog(
      scrollable: true,

      title: Center(
        child: LogosTxt( comment: 'alertTitle', logosID: 6, ),
      ),

      content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            LogosTxt( comment: 'alertContent', logosID: 7, ),
          ]

      ),

      actions: [

        ElevatedButton(
          onPressed: (){
            Navigator.of( context ).pop();
          },
          child: LogosTxt( comment: 'closeBtn', logosID: 8, ),
        ),

      ],

    );
  }
}


class ViewLogsDialog extends StatelessWidget {

  @override
  Widget build( BuildContext context ) {
    return AlertDialog(
      scrollable: true,

      title: Center(
        child: Text(
          'Logs',
        ),
      ),

      content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Text( EOL.buffer ),

          ]

      ),

      actions: [

        ElevatedButton(
          onPressed: (){
            Navigator.of( context ).pop();
          },
          child: Text( 'Close'),
        ),

      ],

    );
  }
}
