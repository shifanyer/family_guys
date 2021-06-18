import 'package:family_guys/db_methods/db_main_methods.dart';
import 'package:family_guys/info_objects/connection_types.dart';
import 'package:family_guys/info_objects/person_info.dart';
import 'package:family_guys/person_card/person_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SelectPerson extends StatelessWidget {
  final List<PersonInfo> persons;
  final bool isLoading;
  final String noItemsMessage;
  final PersonInfo? makeConnectionWithPerson;
  final ConnectionType? connectionType;

  const SelectPerson({Key? key, required this.persons, required this.isLoading, required this.noItemsMessage, this.makeConnectionWithPerson, this.connectionType})
      : super(key: key);

  static const Map<ConnectionType, String> typeMessage = {
    ConnectionType.friends_friends : 'Друг добавлен',
    ConnectionType.spouses_spouses : 'Супруг добавлен',
    ConnectionType.parents_children : 'Ребёнок добавлен',
    ConnectionType.children_parents : 'Родитель добавлен',
  };

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.7,
      builder: (BuildContext context, ScrollController scrollController) {

        if (persons.length == 0) {
          return Center(child: Text(noItemsMessage));
        }
        return ListView.builder(
          controller: scrollController,
          itemCount: persons.length,
          itemBuilder: (BuildContext context, int index) {
            if (makeConnectionWithPerson != null) {
              return GestureDetector(
                onDoubleTap: () async {
                  Navigator.pop(context);
                  await DbMainMethods.makeConnection(makeConnectionWithPerson?.id ?? '', persons[index].id ?? '', connectionType!);
                  Fluttertoast.showToast(
                      msg: typeMessage[connectionType] ?? 'Связь добавлена',
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 3,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                  // Navigator.pop(context);

                },
                child: PersonCard(
                  personInformation: persons[index],
                  shortInfo: true,
                  activeTaps: false,
                ),
              );
            }
            return PersonCard(
              personInformation: persons[index],
              shortInfo: true,
            );
          },
        );
      },
    );
  }
}
