import 'package:flutter/material.dart';
import 'package:logos_maru/logos/logos_widget.dart';
import 'package:logos_maru/logos/model/eol.dart';

class SubmitBtnPressed extends StatelessWidget {

  @override
  Widget build( BuildContext context ) {
    return AlertDialog(
      scrollable: true,

      title: Center(
        child: LogosTxt( comment: 'alertTitle', logoID: 6, ),
      ),

      content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            LogosTxt( comment: 'alertContent', logoID: 7, ),
          ]

      ),

      actions: [

        ElevatedButton(
          onPressed: (){
            Navigator.of( context ).pop();
          },
          child: LogosTxt( comment: 'closeBtn', logoID: 8, ),
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
