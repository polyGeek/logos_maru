import 'package:flutter/material.dart';
import 'package:logos_maru/alert_dialogs.dart';
import 'package:logos_maru/logos/logos_widget.dart';
import 'package:logos_maru/logos/model/lang_controller.dart';
import 'package:logos_maru/logos/model/lang_vo.dart';
import 'package:logos_maru/logos/model/logos_controller.dart';
import 'package:logos_maru/logos/model/txt_utilities.dart';
import 'package:logos_maru/utils/data_controller.dart';
import 'package:logos_maru/utils/drawer.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _dropdownValue   = 'EN';


  @override
  void initState() {
    super.initState();
    _dropdownValue = LanguageController().selectedAppLanguageCode;
    LogosController().addListener(() { _update(); } );
  }

  void _update() {
    if( mounted )
      setState(() {});
  }

  void userNameAlert() {
    showDialog<void>(
        context: context,
        barrierDismissible: false,
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

              LogosTxt(
                comment: 'welcome msg',
                logosID: 4,
                vars: { 'fName': DataController().userName },
              ),
            ],
          )
      ),

      endDrawer: Drawer(
        child: DrawerMenu(),
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                const SizedBox( height: 20, ),



                const SizedBox( height: 20, ),


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
                    logosID: 3,
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

              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UserNameAlert extends StatefulWidget {
  @override
  State<UserNameAlert> createState() => _UserNameAlertState();
}

class _UserNameAlertState extends State<UserNameAlert> {

  String _myName          = 'My Name';
  late TextEditingController _tec;

  @override
  void initState() {
    super.initState();

    _tec = TextEditingController( text: _myName );
  }

  void _update() {
    if( mounted )
      setState(() {});
  }

  @override
  Widget build( BuildContext context ) {
    return AlertDialog(
      scrollable: true,
      insetPadding: EdgeInsets.all( 10 ),
      contentPadding: EdgeInsets.all( 10 ),
      title: Center(
        child: Text(
          'Title',
        ),
      ),

      content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
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
          ]

      ),

      actions: [

        ElevatedButton(
            onPressed: (){
              Navigator.of( context ).pop();
            },
            child: Text( 'CLOSE', style: TxtStyles.btn,)
        ),

      ],

    );
  }
}
