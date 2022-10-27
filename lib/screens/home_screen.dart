import 'package:flutter/material.dart';
import 'package:logos_maru/alert_dialogs.dart';
import 'package:logos_maru/logos/language_dropdown/dropdown.dart';
import 'package:logos_maru/logos/logos_widget.dart';
import 'package:logos_maru/logos/model/lang_vo.dart';
import 'package:logos_maru/logos/model/logos_controller.dart';
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
                  comment: 'RunPee tag line',
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

      drawer: Drawer(
        child: DrawerMenu(),
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              LogosTxt(
                comment: "RunPee: because movie theaters don't have pause buttons. | RunPee tagline",
                logosID: 1,
              ),


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


              Align(
                  alignment: Alignment.center,
                  child: ChangeLanguageDropdown(
                    childOptions: DropDownChildOptions.flagAndCountryCode,
                  )
              ),

              SizedBox( height: 20, ),

            ],
          ),
        ),
      ),
    );
  }

  Widget DropdownChild( LangVO value ) {
    return Row(
      children: [
        Text( value.name ),
        SizedBox( width: 10, ),
        Image.asset( 'assets/logosmaru/flags/' + value.countryCode + '.png', width: 30, ),
      ],
    );
  }

}


