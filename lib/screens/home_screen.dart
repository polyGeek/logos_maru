import 'package:flutter/material.dart';
import 'package:logos_maru/alert_dialogs.dart';
import 'package:logos_maru/logos/logos_widget.dart';
import 'package:logos_maru/logos/model/logos_controller.dart';
import 'package:logos_maru/logos/model/rich_txt.dart';
import 'package:logos_maru/logos/model/txt_utilities.dart';
import 'package:logos_maru/screens/drawer.dart';
import 'package:logos_maru/utils/data_controller.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
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
        barrierDismissible: true,
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

                  return TextButton(
                    onPressed: _onSigninTap,
                    child: LogosTxt(
                      comment: 'Link for user to sign in',
                      logosID: 2,
                    ),
                  );

                } else {

                  return Container(
                    padding: EdgeInsets.zero,
                    child: LogosTxt(
                      comment: 'Welcome UserName and link to user settings',
                      logosID: 3,
                      vars: { 'userName': DataController().userName },
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

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

             /* RichTxt(
                txt: "This is <strong>some bold text</strong> text. This is <em>italics</em> text. This is <tag>something</tag>!",
                style: TxtStyles.header,
              ),

              RichTxt(
                txt: "<u>Here</u> is a <b>tag</b> that starts <em>but does not end.",
                style: TxtStyles.header,
              ),

              RichTxt( txt: "<u>Underlined text</u> is the first tag in this string, followed by <strong>some bold text</strong>, and then something using "
                  "<b>the b-tag</b> for bold text, and at the end we go with an <em>emphasis</em>. And here is a <tag> that just doesn't have a closing-tag</tag>. "
                  "Finally, let's add a custom tag: <title>Title Text</title> an extra line...",
                  style: TxtStyles.body ),*/

              SizedBox( height: 20,),

              LogosTxt(
                comment: 'Welcome to LogosMaru. | Intro to app',
                logosID: 14,
              ),

              LogosTxt(
                comment: 'This is a demo app to show you how easy it is to create a multi-language application using our service. | Description of the LogosMaru Demo app',
                logosID: 15,
              ),

              SizedBox( height: 20,),

              LogosTxt(
                comment: 'Key benefits: | Header',
                logosID: 16,
              ),
              SizedBox( height: 10,),

              LogosTxt(
                comment: '• Authorized users can edit any text, in any language, from within your client side app. This way translators have access the context and display where their translation will go. ',
                logosID: 17,
              ),
              SizedBox( height: 10,),

              LogosTxt(
                comment: '• Update the text/translations in your application without updating the app. Once a change has been approved by the administrator, using the LogosMaru Admin app, the next user who starts your app will see the latest text changes instead of waiting to submit and get approval from the app stores. | ',
                logosID: 18,
              ),
              SizedBox( height: 10,),

              LogosTxt(
                comment: '• Update the text/translations in your application without updating the app. Once a change has been approved by the administrator, using the LogosMaru Admin app, the next user who starts your app will see the latest text changes instead of waiting to submit and get approval from the app stores. | ',
                logosID: 18,
              ),
              SizedBox( height: 10,),

              LogosTxt(
                comment: '• Add a new language to your application without updating the app in the app stores. | ',
                logosID: 20,
              ),
              SizedBox( height: 10,),

              LogosTxt(
                comment: '• Get access to hundreds of pre-translated common words and phrases used in most apps, like: Submit, Send, Cancel, Close... | Feature description: access to pre-translated common words.',
                logosID: 21,
              ),
              SizedBox( height: 10,),

              LogosTxt(
                comment: '• Let trusted users help you with translations in their native language. | Feature',
                logosID: 22,
              ),
              SizedBox( height: 10,),

              LogosTxt(
                comment: '• Include multiple variables in the text, like names and dates that may be dynamic in your applicati... | Logos variables',
                logosID: 23,
              ),
              SizedBox( height: 10,),

              LogosTxt(
                comment: '• Include and change text styles with the translations. | Add text styles dynamically.',
                logosID: 24,
              ),
              SizedBox( height: 10,),

              Text( "• Add special formatting to your text.\n" ),
              SizedBox( height: 10,),

              const SizedBox( height: 20, ),

              Align(
                  alignment: Alignment.center,
                  child: ChangeLanguageDropdown()
              ),

              SizedBox( height: 20, ),

            ],
          ),
        ),
      ),
    );
  }
}


