import 'package:family_guys/card_page.dart';
import 'package:family_guys/info_objects/date.dart';
import 'package:family_guys/info_objects/person_info.dart';
import 'package:family_guys/my_icons.dart';
import 'package:family_guys/person_card/select_list.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PersonCard extends StatefulWidget {
  final PersonInfo personInformation;
  final bool shortInfo;

  const PersonCard({Key? key, required this.personInformation, required this.shortInfo}) : super(key: key);

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
    IgorChildren.addAll([ulebChild, svyatChild, ulebChild, svyatChild, ulebChild, svyatChild, ulebChild, svyatChild, ulebChild, svyatChild, svyatChild, svyatChild, svyatChild]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.0, left: 10, right: 10),
      child: InkWell(
        onTap: () {
          if (widget.shortInfo) {
            Navigator.pop(context);
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => CardPage(
                          personInfo: widget.personInformation,
                        )));
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
                            return SelectField(
                              children: IgorChildren,
                            );
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          isScrollControlled: false,
                          isDismissible: true,
                        );
                        // setState(() {
                        //   SelectField();
                        // });
                      },
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      child: const Text('родители'),
                      onPressed: () {
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
