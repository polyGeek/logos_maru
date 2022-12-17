import 'package:logos_maru/logos/model/eol.dart';
import 'package:logos_maru/logos/model/eol_colors.dart';
import 'package:logos_maru/logos/model/logos_controller.dart';

enum DataManagerType {
  tags,
  styles,
  screens,
}

class DataVO {
  int     id;
  String  name;
  String  description;
  String  lastUpdated;
  bool    isSelected;


  DataVO( {
    required this.id,
    required this.name,
    required this.description,
    required this.lastUpdated,
    this.isSelected = false,
  });

  DataVO.empty() :
    id = 0,
    name = '',
    description = '',
    lastUpdated = '',
    isSelected = false;

  DataVO fromMap( { required Map map } ) {
    return DataVO(
      id			      : map[ 'id' ],
      name	        : map[ 'name' ],
      description	  : map[ 'description' ],
      lastUpdated	  : map[ 'lastUpdated' ],
      isSelected    : false,
    );
  }

  @override
  String toString() {
    return '\n' + id.toString() + ' : ' + name;
  }

  Map<String, dynamic> toMap() {
    return {
      'id'          : id,
      'name'   	    : name,
      'description' : description,
      'lastUpdated'	: lastUpdated,
      'isSelected'  : 0,
    };
  }

  /*String escapeTxt( { required String s } ) {
    s = s.replaceAll( "'", "\'" );
    s = s.replaceAll( '"', '\"' );
    return s;
  }*/

  /*String unEscapeTxt( { required String s } ) {
    s = s.replaceAll( '&#39;', "'" );
    s = s.replaceAll( '&quot;', '"' );
    return s;
  }*/

  factory DataVO.fromJson( Map<String, dynamic> json ) {
    _log(msg: json.toString() );

    DataVO dataVO = DataVO(
      id            : int.parse(json[ 'id' ]),
      name          : json[ 'name' ],
      description   : json[ 'description' ],
      lastUpdated   : json[ 'lastUpdated' ],
      isSelected    : false,
    );
    return dataVO;
  }

  /** ===============================================
   *  EOL
   *  ===============================================*/
  static void _log( { required String msg, String title='', Map<String, dynamic>? map, String json='', bool shout=false, bool fail=false } ) {
    if( LogosController().showConsoleOutput == true )
      EOL.log( msg: msg, map: map, title: title, json: json, shout: shout, fail: fail,
          color: EOLcolors.vo_blue_Black
      );
  }
}