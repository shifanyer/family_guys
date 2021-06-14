import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'buttons/menu_button.dart';
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

class _CardPageState extends State<CardPage> with SingleTickerProviderStateMixin {
  late AnimationController buttonsMove;
  late Animation degAnimationMove;

  double degToRad(double deg) {
    return deg * (pi / 180.0);
  }

  @override
  void initState() {
    buttonsMove = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    degAnimationMove = Tween(begin: 0.0, end: 1.0).animate(buttonsMove);
    super.initState();
    buttonsMove.addListener(() {
      setState(() {});
    });
  }

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
      // floatingActionButton: Stack(
      //   children: [
      //     Transform.translate(
      //       offset: Offset.fromDirection(degToRad(180), degAnimationMove.value * 100),
      //       child: CircleButton(
      //         width: 50,
      //         height: 50,
      //         color: Colors.yellow,
      //         icon: Icons.person,
      //         onClick: () {
      //           print('HERE1');
      //         },
      //       ),
      //     ),
      //     Transform.translate(
      //       offset: Offset.fromDirection(degToRad(225), degAnimationMove.value * 100),
      //       child: CircleButton(
      //         width: 50,
      //         height: 50,
      //         color: Colors.lightGreen,
      //         icon: Icons.cake,
      //         onClick: () {
      //
      //           print('HERE2');
      //         },
      //       ),
      //     ),
      //     Transform.translate(
      //       offset: Offset.fromDirection(degToRad(270), degAnimationMove.value * 100),
      //       child: CircleButton(
      //         width: 50,
      //         height: 50,
      //         color: Colors.redAccent,
      //         icon: Icons.baby_changing_station_outlined,
      //         onClick: () {
      //           print('HERE3');
      //           Navigator.push(
      //               context,
      //               CupertinoPageRoute(
      //                   builder: (context) => SelectPage(
      //                         title: 'new person',
      //                       )));
      //         },
      //       ),
      //     ),
      //     FloatingActionButton(
      //       onPressed: () async {
      //         if (buttonsMove.isCompleted) {
      //           buttonsMove.reverse();
      //         } else {
      //           buttonsMove.forward();
      //         }
      //         // DbMainMethods.uploadPerson(widget.personInfo);
      //         // var downloadedMapInfo = await DbMainMethods.downloadPerson('-Mc61goe-2Chxq_-Uwmi');
      //         // var downloadedPersonInfo = DbMainMethods.makePersonInfo(downloadedMapInfo);
      //
      //         /*
      //     Navigator.push(
      //         context,
      //         CupertinoPageRoute(
      //             builder: (context) => SelectPage(
      //               title: 'new person',
      //             )));
      //     */
      //       },
      //       child: Icon(Icons.add),
      //     )
      //   ],
      // ), // This trailing comma makes auto-formatting nicer for build methods.
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
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
