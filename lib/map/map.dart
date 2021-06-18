import 'package:family_guys/db_methods/db_main_methods.dart';
import 'package:family_guys/info_objects/person_info.dart';
import 'package:family_guys/lines/lines.dart';
import 'package:family_guys/person_card/person_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zflutter/zflutter.dart';
import 'dart:math';

import 'map_card.dart';
import 'map_person_info.dart';

class MapOfPersons extends StatefulWidget {
  final PersonInfo personInfo;

  const MapOfPersons({Key? key, required this.personInfo}) : super(key: key);

  @override
  _MapOfPersonsState createState() => _MapOfPersonsState();
}

class _MapOfPersonsState extends State<MapOfPersons> {
  // ZDragController zDragController = ZDragController(ZVector.zero);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var zoomValue = 0.5;
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<MapPersonInformation>(
          future: DbMainMethods.loadMapPersonInfo(context: context, personInfo: widget.personInfo, isFinal: false),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              MapPersonInformation mapInfo = snapshot.data!;
              var childrenList = mapInfo.children;
              var parentsList = mapInfo.parents;
              var childrenNumber = childrenList.length;
              var parentsNumber = parentsList.length;
              return ZDragDetector(
                builder: (context, zDragController) {
                  var x = -zDragController.value.y * 100;
                  /*
              if ((x.abs()) > (MediaQuery.of(context).size.width / 2) / zoomValue) {
                x = ((MediaQuery.of(context).size.width / 2) / zoomValue) * (x.isNegative ? -1 : 1);
              }
              */
                  var y = -zDragController.value.x * 100;
                  /*
              if ((y.abs()) > (MediaQuery.of(context).size.height / 2) / zoomValue) {
                y = ((MediaQuery.of(context).size.height / 2) / zoomValue) * (y.isNegative ? -1 : 1);
              }
              */
                  zDragController.value = ZVector(y / (-100), x / -100, zDragController.value.z);
                  var translateVector = ZVector(x, -zDragController.value.x * 100, zDragController.value.z);
                  // print('controller.rotate: ${zDragController.value}');

                  var cardWidth = MediaQuery.of(context).size.width / 2;
                  var cardHeight = MediaQuery.of(context).size.height / 3;

                  return ZIllustration(
                    zoom: zoomValue,
                    children: [
                      ZPositioned(
                          translate: translateVector,
                          child: ZGroup(
                            children: [
                              ZPositioned(
                                translate: ZVector(0, 0, 0),
                                child: ZToBoxAdapter(
                                  height: cardHeight,
                                  width: cardWidth,
                                  child: MapCard(
                                    cardHeight: cardHeight,
                                    cardWidth: cardWidth,
                                    avatar: mapInfo.avatar,
                                    personInfo: mapInfo.personInfo,
                                  ),
                                  /*
                              child: PersonCard(
                                personInformation: PersonInfo.Igor(),
                                shortInfo: true,
                                activeTaps: false,
                              ),

                               */
                                ),
                              ),

                              // children
                              ZGroup(
                                children: [
                                  for (var i = -(childrenNumber - 1); i <= (childrenNumber - 1); i += 2)
                                    ZGroup(
                                      children: [
                                        ZPositioned(
                                          translate: ZVector(i * cardWidth, cardHeight * 2, 0),
                                          child: ZToBoxAdapter(
                                            height: cardHeight,
                                            width: cardWidth,
                                            child: MapCard(
                                              cardHeight: cardHeight,
                                              cardWidth: cardWidth,
                                              avatar: childrenList[((childrenNumber - 1) - i) ~/ 2].avatar,
                                              personInfo: childrenList[((childrenNumber - 1) - i) ~/ 2].personInfo,
                                            ),
                                          ),
                                        ),
                                        ZPositioned(
                                          translate: ZVector(cardWidth / 2, cardHeight - 10, 0),
                                          // rotate: ZVector.only(y: tau / 4),
                                          child: ZToBoxAdapter(
                                            width: cardWidth,
                                            height: cardHeight,
                                            child: CustomPaint(
                                              painter: LinePainter(false, i * cardWidth, cardHeight + 20),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                ],
                              ),
                              // parents
                              ZGroup(
                                children: [
                                  for (var i = -(parentsNumber - 1); i <= (parentsNumber - 1); i += 2)
                                    ZGroup(
                                      children: [
                                        ZPositioned(
                                          translate: ZVector(i * cardWidth, -cardHeight * 2, 0),
                                          child: ZToBoxAdapter(
                                            height: cardHeight,
                                            width: cardWidth,
                                            child: MapCard(
                                              cardHeight: cardHeight,
                                              cardWidth: cardWidth,
                                              avatar: parentsList[((parentsNumber - 1) - i) ~/ 2].avatar,
                                              personInfo: parentsList[((parentsNumber - 1) - i) ~/ 2].personInfo,
                                            ),
                                          ),
                                        ),
                                        ZPositioned(
                                          translate: ZVector(cardWidth / 2, 10, 0),
                                          // rotate: ZVector.only(y: tau / 4),
                                          child: ZToBoxAdapter(
                                            width: cardWidth,
                                            height: cardHeight,
                                            child: CustomPaint(
                                              painter: LinePainter(false, i * cardWidth, -cardHeight - 20),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                ],
                              ),
                            ],
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
              );
            } else {
              return Center(
                child: SizedBox(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          }),
    );
  }
}
