import 'package:family_guys/card_page.dart';
import 'package:family_guys/lines/lines.dart';
import 'package:family_guys/person_card/person_card.dart';
import 'package:flutter/material.dart';

import 'info_objects/person_info.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Family guys'),
      // home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return CardPage(personInfo: PersonInfo.Igor(),);
  }



}
