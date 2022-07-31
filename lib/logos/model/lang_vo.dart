
class LangVO {
  int langID;
  String langCode;
  String countryCode;
  String name;

  LangVO({
    required this.langID,
    required this.langCode,
    required this.countryCode,
    required this.name
  });

  @override
  String toString() {
    return this.langCode + " : " + this.name;
  }


  LangVO fromMap( { required Map map } ) {
    return LangVO(
      langID			: map[ 'langID' ],
      langCode  	: map[ 'langCode' ],
      countryCode	: map[ 'countryCode' ],
      name        : map[ 'name' ],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'langID'      : langID,
      'langCode'    : langCode,
      'countryCode' : countryCode,
      'name'        : name,
    };
  }

  factory LangVO.fromJson( Map<String, dynamic> json ) {
    return LangVO(
      langID      : int.parse(json[ 'langID' ]),
      langCode    : json[ 'langCode' ],
      countryCode : json[ 'countryCode' ],
      name        : json[ 'name' ],
    );
  }
}