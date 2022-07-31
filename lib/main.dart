import 'package:flutter/material.dart';
import 'package:logos_maru/logos/model/logos_controller.dart';
import 'package:logos_maru/logos/model/txt_utilities.dart';
import 'package:logos_maru/screens/home_screen.dart';
import 'package:logos_maru/utils/data_controller.dart';
import 'package:package_info_plus/package_info_plus.dart';

/**
 * todo:
 * When someone authenticates as editor download all the language updates.
 * Store "My Name" in DBch and test that retrieved data updates widget.
 *
 * On the server:
 * Move to AWS
 * LastUpdate sends "lastLangID": "1" for a new DB. Make sure the remote DB sends everything >= that ID.
 *
 * Add a 'lastUpdate' field to the prefs table and get updates based on last update instead
 * of last key in case there are changes to existing data.
 */

void main() {
  runApp( _MyApp() );
}

class _MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        /* light theme settings */
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme(
          background: Colors.black,
          brightness: Brightness.dark,
          error: Colors.redAccent,
          onBackground: Colors.white,
          onError: Colors.white,
          onPrimary: Colors.black,
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
                  (_) => const BorderSide(
                  width: 1,
                  color: Colors.black54,
                  style: BorderStyle.solid
              )
          ),
          fillColor: MaterialStateProperty.all( Colors.lightGreenAccent ),
          checkColor: MaterialStateProperty.all( Colors.black ),
          shape: CircleBorder(),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            side: BorderSide(
                width: 1.0,
                color: Colors.white70
            ),
          ),
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

    if( await LogosController().init(
      apiPath: 'https://runpee.net/logos_api/',
      apiVersion: '0.0',
    ) == true ) {
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

