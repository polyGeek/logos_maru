import 'package:flutter/material.dart';

class MyStyles {
  static const TextStyle title = TextStyle(
    color: Colors.blue,
    fontWeight: FontWeight.w500,
    fontSize: 30,
  );

  static const TextStyle titleLight = TextStyle(
    color: Colors.red,
    fontWeight: FontWeight.w100,
    fontSize: 20,
  );

  static const TextStyle header = TextStyle(
    color: Colors.yellowAccent,
    fontWeight: FontWeight.w500,
    fontSize: 18,
  );

  static const TextStyle body = TextStyle(
    color: Colors.yellowAccent,
    fontWeight: FontWeight.w300,
    fontSize: 16,
  );

  static const TextStyle bodySm = TextStyle(
    color: Colors.yellowAccent,
    fontWeight: FontWeight.w300,
    fontSize: 10,
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title']         = MyStyles.title;
    data['titleLight']    = MyStyles.titleLight;
    data['header']        = MyStyles.header;
    data['body']          = MyStyles.body;
    data['bodySm']        = MyStyles.bodySm;
    return data;
  }
}