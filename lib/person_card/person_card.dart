import 'dart:ui';

import 'package:family_guys/card_page.dart';
import 'package:family_guys/db_methods/db_main_methods.dart';
import 'package:family_guys/info_objects/date.dart';
import 'package:family_guys/info_objects/person_info.dart';
import 'package:family_guys/my_icons.dart';
import 'full_person_card.dart';
import '../map/map.dart';
import 'select_list.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PersonCard extends StatefulWidget {
  final PersonInfo personInformation;
  final bool shortInfo;
  final bool activeTaps;

  const PersonCard({Key? key, required this.personInformation, required this.shortInfo, this.activeTaps = true}) : super(key: key);

  @override
  _PersonCardState createState() => _PersonCardState();
}

class _PersonCardState extends State<PersonCard> {
  var IgorChildren = <PersonInfo>[];
  PersonInfo personInformation = PersonInfo();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.only(top: 20.0, left: 10, right: 10),
      child: Stack(
        children: [
          GestureDetector(
            onLongPress: () {
              if (widget.activeTaps) {
                /*
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => MapOfPersons()));
                */
                /*
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => FullPersonCard(
                              personInfo: widget.personInformation,
                            )));

                 */
                // setState(() {
                //   showFullPersonCard = true;
                // });
                // Navigator.push(context, CupertinoPageRoute(builder: (context) => FullPersonCard()));
                /*
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return FutureBuilder<List<PersonInfo>>(
                        future: DbMainMethods.loadAllPersons(),
                        builder: (context, childrenSnapshot) {
                          if (childrenSnapshot.hasData) {
                            return SelectPerson(
                              persons: childrenSnapshot.data ?? [],
                              isLoading: !childrenSnapshot.hasData,
                              noItemsMessage: '?? ?????? ?????? ???????????? ??????????',
                              makeConnectionWithPerson: widget.personInformation,
                            );
                          } else {
                            return LinearProgressIndicator();
                          }
                        });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  isScrollControlled: false,
                  isDismissible: true,
                );
                */
              }
            },
            onTap: () async {
              if (widget.activeTaps) {
                if (widget.shortInfo) {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => CardPage(
                                personInfo: widget.personInformation,
                              )));
                } else {
                  var avatar = await DbMainMethods.getAvatar(context, widget.personInformation.id!);
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => FullPersonCard(
                            personInfo: widget.personInformation,
                            avatar: avatar,
                          )));
                }
              }
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular((widget.shortInfo) ? 20.0 : 0.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: Icon(CustomIcons.parents),
                    title: Text(widget.personInformation.nameDisplay()),
                    subtitle: Text((widget.personInformation.birthDate?.displayDate() ?? 'NONE') +
                        ' - ' +
                        (widget.personInformation.deathDate?.displayDate() ?? 'NONE')),
                  ),
                  if (!widget.shortInfo)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          child: const Text('??????????'),
                          onPressed: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => MapOfPersons(personInfo: widget.personInformation,)));
                          },
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          child: const Text('????????'),
                          onPressed: () {
                            // SelectField();
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return FutureBuilder<List<PersonInfo>>(
                                    future: DbMainMethods.loadChildren(widget.personInformation.id!),
                                    builder: (context, childrenSnapshot) {
                                      if (childrenSnapshot.hasData) {
                                        return SelectPerson(
                                          persons: childrenSnapshot.data ?? [],
                                          isLoading: !childrenSnapshot.hasData,
                                          noItemsMessage: '?? ?????????? ???????????????? ???? ?????????????? ??????????',
                                        );
                                      } else {
                                        return LinearProgressIndicator();
                                      }
                                    });
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              isScrollControlled: false,
                              isDismissible: true,
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          child: const Text('????????????????'),
                          onPressed: () {
                            // SelectField();
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return FutureBuilder<List<PersonInfo>>(
                                    future: DbMainMethods.loadParents(widget.personInformation.id!),
                                    builder: (context, childrenSnapshot) {
                                      if (childrenSnapshot.hasData) {
                                        return SelectPerson(
                                          persons: childrenSnapshot.data ?? [],
                                          isLoading: !childrenSnapshot.hasData,
                                          noItemsMessage: '?? ?????????? ???????????????? ???? ?????????????? ??????????????????',
                                        );
                                      } else {
                                        return LinearProgressIndicator();
                                      }
                                    });
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              isScrollControlled: false,
                              isDismissible: true,
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                      ],
                    )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
