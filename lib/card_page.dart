import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'info_objects/person_info.dart';
import 'lines/lines.dart';
import 'person_card/person_card.dart';

class CardPage extends StatefulWidget{
  final PersonInfo personInfo;

  const CardPage({Key? key, required this.personInfo}) : super(key: key);

  @override
  _CardPageState createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            PersonCard(personInformation: widget.personInfo, shortInfo: false),
            CustomPaint(
              painter: LinePainter(false),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){

        },
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}