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
                textAlign: TextAlign.center,
                textStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.blue,
                ),
              ),

              Text( _dynamicText ),

              SizedBox( height: 30, ),

              Text( LogosController().getLogosVO( logosID: 20 ).txt,),

              SizedBox( height: 30, ),

              LogosTxt(
                comment: "Title | Search movies by title.",
                logosID: 18,
                child: Container( width: 300, height: 50, color: Colors.black,),
              ),

              LogosTxt(
                comment: "RunPee: because movie theaters don't have pause buttons. | RunPee tagline",
                logosID: 1,
                textStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.blue,
                ),
                textAlign: TextAlign.center,
              ),

              LogosTxt(
                comment: "The core feature of the RunPee app is to provide you the best times to <gold>run</gold> and <gold>pe... | 2nd screen, 1st paragraph",
                logosID: 23,
                textAlign: TextAlign.center,
              ),

              LogosTxt.static( txt: 'This is <gold>static</gold> text', isRich: true,),
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


              //LogosTxt.static( txt: 'HELLO \nWORLD...', textStyle: TextStyle( fontSize: 44, color: Colors.yellowAccent),),



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


