import 'package:flutter/cupertino.dart';

class DataController extends ChangeNotifier {
  static final DataController _dataController = DataController._internal();
  factory DataController() => _dataController;
  DataController._internal();

  static String appName        = appName      = '';
  static String packageName    = packageName  = '';
  static String version        = version      = '';
  static String buildNumber    = buildNumber  = '';

  String? _userName = '';
  String get userName => _userName!;
  void setUserName( { required String userName } ) {
    _userName = userName;
    notifyListeners();
  }
}