
class LogosVO {
  int logosID;
  String description;
  String tags;
  String note;
  String langCode;
  String txt;
  String lastUpdate;

  LogosVO( {
    required this.logosID,
    required this.tags,
    required this.note,
    required this.description,
    required this.langCode,
    required this.txt,
    required this.lastUpdate
  }) {
    this.txt = unEscapeTxt( s: txt );
    this.note = unEscapeTxt( s: note );
  }

  LogosVO fromMap( { required Map map } ) {
    return LogosVO(
        logosID			: map[ 'logosID' ],
        description	: map[ 'description' ],
        tags        : map[ 'tags' ],
        langCode    : map[ 'langCode' ],
        txt         : map[ 'txt' ],
        note        : map[ 'note' ],
        lastUpdate	: map[ 'lastUpdate' ],
    );
  }

  @override
  String toString() {
    return '\n' + langCode + ' : ' + description + ' : ' + txt;
  }

  Map<String, dynamic> toMap() {
    return {
      'logosID'    	: logosID,
      'description'	: description,
      'tags'        : tags,
      'langCode'    : langCode,
      'txt'         : escapeTxt( s: txt ),
      'note'        : note,
      'lastUpdate'  : lastUpdate,
    };
  }

  String escapeTxt( { required String s } ) {
    s = s.replaceAll( "'", "\'" );
    s = s.replaceAll( '"', '\"' );
    return s;
  }

  String unEscapeTxt( { required String s } ) {
    s = s.replaceAll( '&#39;', "'" );
    s = s.replaceAll( '&quot;', '"' );
    return s;
  }

  factory LogosVO.fromJson( Map<String, dynamic> json ) {
    LogosVO logosVO = LogosVO(
      logosID        : int.parse(json[ 'logosID' ]),
      description   : json[ 'description' ],
      tags          : json[ 'tags' ],
      note          : json[ 'note' ],
      langCode      : ( json[ 'langCode' ] == null )? '' : json[ 'langCode' ],
      txt           : json[ 'txt' ],
      lastUpdate    : json[ 'lastUpdate' ],
    );
    return logosVO;
  }
}

extension ExtendedString on String {

  String escapeTxt() {
    String s = this;
    s = s.replaceAll( "'", "&#39;" );
    s = s.replaceAll( '"', '&quot;' );
    return s;
  }

  String unEscapeTxt() {
    String s = this;
    s = s.replaceAll( '&#39;', "'" );
    s = s.replaceAll( '&quot;', '"' );
    return s;
  }
}