import 'package:family_guys/info_objects/person_info.dart';
import 'package:flutter/material.dart';

class MapPersonInformation {
  final PersonInfo personInfo;
  final Image avatar;
  final List<MapPersonInformation> children;
  final List<MapPersonInformation> friends;
  final List<MapPersonInformation> spouses;
  final List<MapPersonInformation> parents;

  MapPersonInformation(
      {required this.personInfo, required this.avatar, required this.children, required this.friends, required this.spouses, required this.parents});
}
