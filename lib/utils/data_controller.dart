import 'package:flutter/cupertino.dart';

class AppController extends ChangeNotifier {
  static final AppController _dataController = AppController._internal();
  factory AppController() => _dataController;
  AppController._internal();

  static String appName        = appName      = '';
  static String packageName    = packageName  = '';
  static String version        = version      = '';
  static String buildNumber    = buildNumber  = '';

  String? _userName = 'Dan';
  String get userName => _userName!;
  void setUserName( { required String userName } ) {
    _userName = userName;
    notifyListeners();
  }
}