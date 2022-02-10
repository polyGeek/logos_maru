import 'package:flutter/material.dart';
import 'package:logos_maru/alert_dialogs.dart';
import 'package:logos_maru/drawer.dart';
import 'package:logos_maru/logos/logos_widget.dart';
import 'package:logos_maru/logos/model/lang_controller.dart';
import 'package:logos_maru/logos/model/lang_vo.dart';
import 'package:logos_maru/logos/model/logos_controller.dart';
import 'package:logos_maru/test.dart';
import 'package:package_info_plus/package_info_plus.dart';

/**
 * 1a
 * On desktop set: Editor > Code Style > Dart: Line Length = 200
 * So that there's no more wrapping.
 *
 *
 * todo:
 * When someone becomes an editor download all the language updates.
 * Store "My Name" in DB and test that retrieved data updates widget.
 *
 *
 * On the server:
 * Move to AWS
 * Sanitize the text.
 * LastUpdate sends "lastLangID": "1" for a new DB. Make sure the remote DB sends everything >= that ID.
*/

void main() {
  runApp( MyApp() );
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData( primarySwatch: Colors.blue, ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),

    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Widget _body = Center( child: CircularProgressIndicator() );

  @override
  void initState() {
    super.initState();

    Future.delayed( const Duration( milliseconds: 100 ), () {
      init(); /// Need to wait for initState to complete.
    } );

  }


  void init() async {

    LogosController().addListener(() {_update();});

    if( await LogosController().init() == true ) {
      _body = HomeScreen();
    } else {
      _body = Center( child: Text( 'ERROR' ),);
    }

    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    Init.appName      = packageInfo.appName;
    Init.packageName  = packageInfo.packageName;
    Init.version      = packageInfo.version;
    Init.buildNumber  = packageInfo.buildNumber;

    _update();
  }

  void _update() {

    if( LogosController().doesHaveLogos() ) {
      _body = HomeScreen();
    }

    if( mounted )
      setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text( 'LogosMaru'),// Text( 'ChánChán' ),
      ),
      endDrawer: Drawer(
        child: DrawerMenu(),
      ),
      body: _body,

    );
  }
}


class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _dropdownValue = 'EN';
  String _myName = 'My Name';
  late TextEditingController _tec;

  @override
  void initState() {
    super.initState();

    _tec = TextEditingController( text: _myName );
    _dropdownValue = LanguageController().selectedLanguageCode;
    LogosController().addListener(() { _update(); } );
  }

  void _update() {
    if( mounted )
      setState(() {});
  }

  @override
  Widget build( BuildContext context ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              const SizedBox( height: 20, ),

              TextField(
                onChanged: ( txt ) {
                  _myName = txt;
                  _update();
                  LogosController().update();
                },
                minLines: 1, /// Normal textInputField will be displayed
                maxLines: 5, /// When user presses enter it will adapt to it
                autofocus: false,
                controller: _tec,
                autocorrect: false,
                decoration: InputDecoration(
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

              const SizedBox( height: 20, ),

              LogosTxt(
                comment: 'welcome msg',
                logoID: 4,
                vars: { 'fName': _myName },
                txtStyle: TextStyle( fontSize: 28 ),
              ),

              const SizedBox( height: 20, ),

              LogosTxt(
                comment: 'intro txt',
                logoID: 2,
                txtStyle: TextStyle( fontSize: 16 ),
              ),

              const SizedBox( height: 20, ),

              LogosTxt(
                comment: 'desc txt',
                logoID: 5,
                txtStyle: TextStyle( fontSize: 16 ),
              ),

              const SizedBox( height: 20, ),

              ElevatedButton(
                onPressed: (){

                  showDialog<void>(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return SubmitBtnPressed();
                      }
                  );
                },
                child: LogosTxt(
                  comment: 'submit btn',
                  logoID: 3,
                ),
              ),

              const SizedBox( height: 20, ),

              DropdownButton<String>(
                value: _dropdownValue,
                icon: const Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
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
              ),

              SizedBox( height: 20, ),

              CallbackWidget(
                onPressed: () {
                  print( 'pressed');
                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}

class Init {
  static String appName        = appName = '';
  static String packageName    = packageName = '';
  static String version        = version = '';
  static String buildNumber    = buildNumber = '';
}