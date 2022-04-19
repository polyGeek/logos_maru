

class DataController {
  static final DataController _dataController = DataController._internal();
  factory DataController() => _dataController;
  DataController._internal();

  static String appName        = appName      = '';
  static String packageName    = packageName  = '';
  static String version        = version      = '';
  static String buildNumber    = buildNumber  = '';

  String? _userName = 'My name';
  String get userName => _userName!;
  void setUserName( String userName ) {
    _userName = userName;
  }
}