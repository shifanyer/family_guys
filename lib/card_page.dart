import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'db_methods/db_main_methods.dart';
import 'info_objects/person_info.dart';
import 'lines/lines.dart';
import 'fill_info/create_person.dart';
import 'person_card/person_card.dart';

class CardPage extends StatefulWidget {
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
        onPressed: () async {
          // DbMainMethods.uploadPerson(widget.personInfo);
          // var downloadedMapInfo = await DbMainMethods.downloadPerson('-Mc61goe-2Chxq_-Uwmi');
          // var downloadedPersonInfo = DbMainMethods.makePersonInfo(downloadedMapInfo);
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => SelectPage(
                        title: 'new person',
                      )));
        },
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
