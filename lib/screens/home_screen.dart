import 'package:flutter/material.dart';
import 'package:logos_maru/logos/language_dropdown/dropdown.dart';
import 'package:logos_maru/logos/logos_widget.dart';
import 'package:logos_maru/logos/model/adjust_font.dart';
import 'package:logos_maru/logos/model/lang_vo.dart';
import 'package:logos_maru/logos/model/logos_controller.dart';
import 'package:logos_maru/screens/drawer.dart';
import 'package:logos_maru/utils/data_controller.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String _dynamicText = 'update';

  @override
  void initState() {
    super.initState();
    AppController().addListener(() { _update(); } );
    LogosController().addListener(() { _update(); } );

    _dynamicText = LogosController().getLogosVO(
        logosID: 67,
        vars: {'count': 4}
    ).txt;
  }

  @override
  void dispose() {
    AppController().removeListener(() { _update(); } );
    LogosController().removeListener(() { _update(); } );
    super.dispose();
  }

  void _update() {
    if( mounted )
      setState(() {});
  }

  @override
  Widget build( BuildContext context ) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [



              /*
              Sign in
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
              }),*/

            ],
          ),

            actions: [
              Padding(
                padding: const EdgeInsets.only( right: 15.0),
                child: LogosMaruShowAdjustFontScale( iconSize: 30, package: '', ),
              ),
            ],
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
                comment: 'Sign in & <gold>get 2 FREE Peecoins</gold> | sign in message',
                logosID: 2,
                //textStyle: LogosTextStyles().bodySm,
              ),

              Text( _dynamicText ),

              SizedBox( height: 30, ),

              Text( LogosController().getLogosVO( logosID: 20 ).txt,),

              SizedBox( height: 30, ),

              LogosTxt(
                comment: "Title | Search movies by title.",
                logosID: 18,
              ),

              LogosTxt(
                comment: "RunPee: because movie theaters don't have pause buttons. | RunPee tagline",
                logosID: 1,
                textStyle: LogosController().logosFontStyles!.header,
              ),

              LogosTxt(
                comment: "The core feature of the RunPee app is to provide you the best times to <gold>run</gold> and <gold>pe... | 2nd screen, 1st paragraph",
                logosID: 23,
                textAlign: TextAlign.center,
              ),

              /*Text(
                "RunPee: because movie theaters don't have pause buttons. 20",
                style: LogosTextStyles().title.copyWith( fontSize: 20 ),
              ),

              Text(
                "RunPee: because movie theaters don't have pause buttons. 25",
                style: LogosTextStyles().title.copyWith( fontSize: 25 ),
              ),

              Text(
                "RunPee: because movie theaters don't have pause buttons. 30",
                style: LogosTextStyles().title.copyWith( fontSize: 30 ),
              ),

              Text(
                "RunPee: because movie theaters don't have pause buttons. 35",
                style: LogosTextStyles().title.copyWith( fontSize: 35 ),
              ),

              Text(
                "RunPee: because movie theaters don't have pause buttons. 40",
                style: LogosTextStyles().title.copyWith( fontSize: 40 ),
              ),

              Text(
                "RunPee: because movie theaters don't have pause buttons. 50",
                style: LogosTextStyles().title.copyWith( fontSize: 50 ),
              ),*/



              /*Builder(builder: (BuildContext context) {
                List<String> days = [ 'January', 'February', 'March', 'April', 'May' ];
                List<Widget> dayChildren = [];

                days.forEach( (element) {
                  dayChildren.add(

                    LogosTxt.dynamic(
                      tag: 'month',
                      txt: element,
                    ),
                  );
                });

                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: dayChildren,
                );
              }),*/


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
                    childOptions: DropDownChildOptions.worldIconCountryCodeLangCode,
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


