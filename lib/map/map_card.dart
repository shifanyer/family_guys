import 'package:family_guys/info_objects/person_info.dart';
import 'package:family_guys/person_card/person_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zflutter/zflutter.dart';
import 'dart:math';

class MapCard extends StatefulWidget {
  @override
  _MapCardState createState() => _MapCardState();
}

class _MapCardState extends State<MapCard> {
  // ZDragController zDragController = ZDragController(ZVector.zero);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ZDragDetector(
        builder: (context, zDragController) {
          var x = -zDragController.value.y * 100;
          if ((x.abs() ?? 0.0) > MediaQuery.of(context).size.width / 2){
            x = (MediaQuery.of(context).size.width / 2) * (x.isNegative ? -1 : 1);
          }
          var y = -zDragController.value.x * 100;
          if ((y.abs() ?? 0.0) > MediaQuery.of(context).size.height / 2){
            y = (MediaQuery.of(context).size.height / 2) * (y.isNegative ? -1 : 1);
          }
          zDragController.value = ZVector(y / -100, x / -100 , zDragController.value.z);
          var translateVector = ZVector(x, -zDragController.value.x * 100, zDragController.value.z);
          print('controller.rotate: ${zDragController.value}');
          return ZIllustration(
            children: [
              ZPositioned(
                  translate: translateVector,
                  child: ZToBoxAdapter(
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    child: PersonCard(
                      personInformation: PersonInfo.Igor(),
                      shortInfo: true,
                      activeTaps: false,
                    ),
                  )),
              /*
              ZPositioned(
                  rotate: zDragController.rotate,
                  child: ZToBoxAdapter(
                    width: 80,
                    height: 80,
                    child: Container(
                      color: Colors.redAccent,
                    ),
                  )),

               */
            ],
          );
        },
      ),
    );
  }
}
