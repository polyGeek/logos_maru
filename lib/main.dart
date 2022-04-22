import 'package:flutter/material.dart';
import 'package:logos_maru/logos/model/logos_controller.dart';
import 'package:logos_maru/logos/model/txt_utilities.dart';
import 'package:logos_maru/screens/home_screen.dart';
import 'package:logos_maru/utils/data_controller.dart';
import 'package:package_info_plus/package_info_plus.dart';

/**
 *
 * Add edit by user
 * --add a textfield for username. On the server, if the user name isn't recognized then nothing happens.
 *
 *
 * On desktop set: Editor > Code Style > Dart: Line Length = 200
 * So that there's no more wrapping.
 *
 *
 * todo:
 * When someone becomes an editor download all the language updates.
 * Store "My Name" in DBch and test that retrieved data updates widget.
 *
 * Feature: Double the text to test for text overflows.
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
      //theme: ThemeData( primarySwatch: Colors.blue, ),
      theme: ThemeData(
        brightness: Brightness.light,
        /* light theme settings */
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme(
          primaryVariant: Colors.blueGrey.shade800,
          secondaryVariant: Colors.amber.shade800,
          background: Colors.black,
          brightness: Brightness.dark,
          error: Colors.redAccent,
          onBackground: Colors.white,
          onError: Colors.white,
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          onSurface: Colors.white70,
          primary: Colors.blueGrey,
          secondary: Colors.amber,
          surface: Colors.black45,
        ),
        buttonTheme: ButtonThemeData(
          splashColor: Colors.white70,
          textTheme: ButtonTextTheme.primary, ///  <-- this auto selects the right color
        ),
        textTheme: TextTheme( bodyText1: TxtStyles.body, bodyText2: TxtStyles.body ),
        checkboxTheme: CheckboxThemeData(
          side: MaterialStateBorderSide.resolveWith(
                  (_) => const BorderSide( width: 0, color: Colors.black54, style: BorderStyle.none )
          ),
          fillColor: MaterialStateProperty.all( Colors.lightGreenAccent ),
          checkColor: MaterialStateProperty.all( Colors.black ),
          shape: CircleBorder(),
        ),
      ),
      themeMode: ThemeMode.dark,
      /* ThemeMode.system to follow system theme,
         ThemeMode.light for light theme,
         ThemeMode.dark for dark theme
      */
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

    LogosController().addListener(() { _update(); } );

    if( await LogosController().init() == true ) {
      _body = HomeScreen();
    } else {
      _body = Scaffold( body: Center( child: Column(
        children: [
          Text( 'Loading' ),
          CircularProgressIndicator(),
        ],
      ),));
    }

    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    DataController.appName      = packageInfo.appName;
    DataController.packageName  = packageInfo.packageName;
    DataController.version      = packageInfo.version;
    DataController.buildNumber  = packageInfo.buildNumber;

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
    return _body;
  }
}

