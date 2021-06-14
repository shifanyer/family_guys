import 'package:family_guys/info_objects/person_info.dart';
import 'package:family_guys/person_card/person_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectField extends StatelessWidget {
  final List<PersonInfo> children;
  final bool isLoading;

  const SelectField({Key? key, required this.children, required this.isLoading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.7,
      builder: (BuildContext context, ScrollController scrollController) {
        if (children.length == 0){
          return Center(child: Text('У этого человека не найдено детей'));
        }
        return ListView.builder(
          controller: scrollController,
          itemCount: children.length,
          itemBuilder: (BuildContext context, int index) {
            return PersonCard(
              personInformation: children[index],
              shortInfo: true,
            );
          },
        );
      },
    );
  }
}
