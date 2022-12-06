import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logos_maru/logos/model/eol.dart';
import 'package:logos_maru/logos/model/logos_controller.dart';

class NetworkHelper {
  /** ===============================================
   *  API LOCATION
   *  ===============================================*/
  static const String API_LOCATION = 'https://runpee.net/logos_api/';
  static const String API_VERSION  = '0.0';


  /** ===============================================
	*  Network Responses
	*  ===============================================*/
  static const String SUCCESS 					= 'SUCCESS';
  static const String ERROR_UNKNOWN 		= 'ERROR_UNKNOWN';
  static const String NO_DATA						= 'NO_DATA';
  static const String NETWORK_ERROR 		= 'NETWORK_ERROR';
  static const String SERVER_ERROR_500	= '500_SERVER_ERROR';
  static const String NETWORK_TIMEOUT		= 'NETWORK_TIMEOUT';
  static const String NETWORK_TRY_CATCH	= 'NETWORK_TRY_CATCH';

  static final dynamic 	encoding = Encoding.getByName( 'utf-8' );
  static const dynamic	headers = {'Content-Type': 'application/json'};


  static Future<String> sendPostRequest( {
    required String 		url,
    required Map 		    map } ) async {


    _log( msg: '<<<<<<<<<<<<<<<<<<<<[ DATA SENT TO SERVER ]>>>>>>>>>>>>>>>>>>>>\n' + url );
    _log( msg: '', );


    String jsonBody = json.encode( map );
    late http.Response response;

    try {

      var nowA = DateTime.now();
      response = await http.post(
        Uri.parse( url ),
        headers: headers,
        body: jsonBody,
        encoding: encoding,
      ).timeout( const Duration( seconds: 15 ) );

      _log( msg: '<<<<<<<<<<<<<<<<<<<<[ DATA FROM SERVER ]>>>>>>>>>>>>>>>>>>>>\n' +
          "[load time: " + ( DateTime.now().millisecondsSinceEpoch - nowA.millisecondsSinceEpoch ).toString() + "ms]" );

    } on TimeoutException catch (_) {

      _log( msg: 'NETWORK_TIMEOUT >>> \n' + url + '\n\n' );
      return NETWORK_TIMEOUT;

    } catch( e ) {

      _log( msg: 'ERROR CODE: NETWORK_TRY_CATCH >>> \n' + e.toString() + '\n' + url + '\n\n' );
      return NETWORK_TRY_CATCH;
    }

    if( response.statusCode == 500 ) {

      _log( msg: 'ERROR CODE: SERVER_ERROR_500 >>> \n' + url + '\n\n' );
      return SERVER_ERROR_500;

    } else if( response.statusCode == 200 ) {

      String body = response.body.toString();

      if( body.length == 0 || body.indexOf( 'NO_DATA' ) > -1 ) {

        _log( msg: 'ERROR CODE: NO_DATA >>> \n' + url + '\n\n');
        return NO_DATA;

      } else {

        _log( msg: url, title: 'NETWORK CALL SUCCESS', json: body );
        /// TEST
        return body;
      }

    } else {

      _log( msg: 'ERROR CODE: ERROR_UNKNOWN >>> ' );
      return ERROR_UNKNOWN;

    }
  }

  static void _log( { required String msg, String title='', Map<String, dynamic>? map, String json='', bool shout=false, bool fail=false } ) {
    if( LogosController().showConsoleOutput == true )
      EOL.log( msg: msg, map: map, title: title, json: json, shout: shout, fail: fail, color: EOL.comboMagenta_Gray );
  }
}

