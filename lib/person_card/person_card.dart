import 'package:family_guys/card_page.dart';
import 'package:family_guys/db_methods/db_main_methods.dart';
import 'package:family_guys/info_objects/date.dart';
import 'package:family_guys/info_objects/person_info.dart';
import 'package:family_guys/my_icons.dart';
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
    PersonInfo tmpPerson = PersonInfo(name: 'Игорь', patronymic: 'Рюрикович', birthDate: DateInfo(year: 912), deathDate: DateInfo(year: 945));
    personInformation = PersonInfo(name: 'Игорь', patronymic: 'Рюрикович', birthDate: DateInfo(year: 912), deathDate: DateInfo(year: 945));
    var svyatChild = PersonInfo(name: 'Святослав', patronymic: 'Игоревич', birthDate: DateInfo(year: 920), deathDate: DateInfo(year: 972));
    var ulebChild = PersonInfo(name: 'Улеб', patronymic: 'Игоревич', deathDate: DateInfo(year: 971));
    IgorChildren.addAll([
      ulebChild,
      svyatChild,
      ulebChild,
      svyatChild,
      ulebChild,
      svyatChild,
      ulebChild,
      svyatChild,
      ulebChild,
      svyatChild,
      svyatChild,
      svyatChild,
      svyatChild
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.0, left: 10, right: 10),
      child: GestureDetector(
        onLongPress: () {
          if (widget.activeTaps) {
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
                          noItemsMessage: 'У Вас нет других людей',
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
          }
        },
        onTap: () {
          if (widget.activeTaps) {
            if (widget.shortInfo) {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => CardPage(
                            personInfo: widget.personInformation,
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
                      child: const Text('дети'),
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
                                      noItemsMessage: 'У этого человека не найлено детей',
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
                      child: const Text('родители'),
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
                                      noItemsMessage: 'У этого человека не найлено родителей',
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
    );
  }
}
