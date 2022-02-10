
class LangVO {
  int langID;
  String langCode;
  String name;

  LangVO({
    required this.langID,
    required this.langCode,
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
      name        : map[ 'name' ],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'langID'    : langID,
      'langCode'  : langCode,
      'name'      : name,
    };
  }

  factory LangVO.fromJson( Map<String, dynamic> json ) {
    return LangVO(
      langID      : int.parse(json[ 'langID' ]),
      langCode    : json[ 'langCode' ],
      name        : json[ 'name' ],
    );
  }
}