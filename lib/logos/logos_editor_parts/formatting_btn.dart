import 'package:flutter/material.dart';
import 'package:logos_maru/logos/model/logos_controller.dart';
import 'package:logos_maru/logos/model/logos_vo.dart';
import 'package:logos_maru/logos/model/rich_txt.dart';
import 'package:logos_maru/logos/model/txt_utilities.dart';

/** ===============================================
 *  Formatting Row for the Translation Editor
 *  ===============================================*/

class FormattingRow extends StatefulWidget {

  final LogosVO logosVO;
  final String txt;
  final void Function( String s ) callback;

  FormattingRow( {
    required this.logosVO,
    required this.txt,
    required this.callback } );

  @override
  _FormattingRowState createState() => _FormattingRowState();
}

class _FormattingRowState extends State<FormattingRow> {

  void removeFormattingAlert( { required bool isRich } ) {
    print( 'widget.txt: ' + widget.txt );
    print( 'isRich: ' + isRich.toString() );
    print( ' widget.txt.contains "</" = ' + widget.txt.contains( '</' ).toString() );
    if( isRich == false && widget.txt.contains( '</' ) ) {
      showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return FormattingAlert( callback: widget.callback );
          });
    }
  }

  @override
  Widget build( BuildContext context ) {
    return Row(
      children: [

        /** ===============================================
         *  RichTxt toggle
         *  ===============================================*/
        Container(
          decoration: BoxDecoration(
            border: Border.all(
                width: 1.0,
                color: Colors.white70
            ),
            borderRadius: BorderRadius.all( Radius.circular( 4 ) ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Checkbox(
                    value: ( widget.logosVO.isRich == 1 )? true : false,
                    onChanged: ( bool? value ) {
                      LogosController().setEditingLogoVOisRich( isRich: value! );
                      FormattingBtnController().update();
                      removeFormattingAlert( isRich: value );
                    }
                ),

                GestureDetector(
                    onTap: () {
                      bool newValue = ( LogosController().editingLogosVO!.isRich == 1 )? false : true;

                      LogosController().setEditingLogoVOisRich( isRich: newValue );
                      FormattingBtnController().update();
                      removeFormattingAlert( isRich: newValue );
                    },
                    child: Text( 'isRichTxt' )
                ),
              ],
            ),
          ),
        ),/// End RichTxt toggle

        SizedBox( width: 8 ,),

        Expanded(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              FormattingBtn(
                tag: 'em',
                formattedCharacter: 'italic',
                logosVO: widget.logosVO,
                callback: widget.callback,
              ),

              FormattingBtn(
                tag: 'strong',
                formattedCharacter: 'bold',
                logosVO: widget.logosVO,
                callback: widget.callback,
              ),

              FormattingBtn(
                tag: 'u',
                formattedCharacter: 'u',
                logosVO: widget.logosVO,
                callback: widget.callback,
              ),

              FormattingBtn(
                tag: 'title',
                formattedCharacter: 'title',
                logosVO: widget.logosVO,
                callback: widget.callback,
              ),

              FormattingBtn(
                tag: 'link',
                formattedCharacter: 'link',
                logosVO: widget.logosVO,
                callback: widget.callback,
              ),

            ],
          ),
        ),

      ],
    );
  }
}

/** ===============================================
*  RichTxt styling button
*  ===============================================*/
class FormattingBtn extends StatefulWidget {

  final String formattedCharacter;
  final String tag;
  final LogosVO logosVO;
  final void Function( String s ) callback;

  FormattingBtn( {
    required this.formattedCharacter,
    required this.tag,
    required this.logosVO,
    required this.callback,
  });

  @override
  State<FormattingBtn> createState() => _FormattingBtnState();
}

class _FormattingBtnState extends State<FormattingBtn> {

  @override
  void initState() {
    super.initState();

    FormattingBtnController().addListener(() { _update(); });
  }

  @override
  void dispose() {
    FormattingBtnController().removeListener(() { _update(); });
    super.dispose();
  }

  void _update() {
    if( mounted )
      setState(() {});
  }

  @override
  Widget build( BuildContext context ) {
    return Padding(
      padding: const EdgeInsets.only( right: 12.0 ),
      child: OutlinedButton(
        onPressed: ( widget.logosVO.isRich == 1 )
            ? () { widget.callback( widget.tag ); }
            : null,

        /// If the isRichTxt is turned off then this button is disabled.
        /// The background color will change to reflect that it is disabled.
        style: ButtonStyle(

          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.disabled)) {
              return Colors.white60;
            }
            return Colors.white10;
          }),

        ),

        child: IntrinsicWidth(
          child: Row(
            children: [
              Text( '<', style: TextStyle( color: Colors.white ), ),

              RichTxt(
                txt: '<' + widget.tag + '>' + widget.formattedCharacter + '</' + widget.tag + '>',
                txtStyle: TxtStyles.body,
              ),

              Text( '>', style: TextStyle( color: Colors.white ), ),
            ],
          ),
        ),
      ),
    );
  }
}

/** ===============================================
 *  Formatting Alert
 *  ===============================================*/
class FormattingAlert extends StatelessWidget {

  final Function callback;

  FormattingAlert( { required this.callback } );

    @override
    Widget build( BuildContext context ) {
        return AlertDialog(
          scrollable: true,
          insetPadding: EdgeInsets.all( 10 ),
          contentPadding: EdgeInsets.all( 10 ),
          title: Center(
            child: Text(
              'Remove Formatting?',
            ),
          ),

          content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text( 'The text includes <formatting>, but isRichTxt is turned off.',
                  style: TxtStyles.body,
                )
              ]

          ),

          actions: [

            TextButton(
                onPressed: (){
                  Navigator.of( context ).pop();
                },
                child: Text( 'CLOSE', style: TxtStyles.btn,)
            ),

            ElevatedButton(
                onPressed: () {
                  callback( '<>' );
                  Navigator.of( context ).pop();
                },
                child: Text( 'REMOVE FORMATTING', style: TxtStyles.btn,)
            ),
          ],
        );
    }
}



/** ===============================================
 *  Formatting Controller
 *  ===============================================*/
class FormattingBtnController extends ChangeNotifier {
  static final FormattingBtnController _formattingBtnController = FormattingBtnController._internal();
  factory FormattingBtnController() => _formattingBtnController;
  FormattingBtnController._internal();

  void update() {
    notifyListeners();
  }
}

