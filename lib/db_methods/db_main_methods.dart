import 'dart:io';

import 'package:family_guys/info_objects/connection_types.dart';
import 'package:family_guys/info_objects/date.dart';
import 'package:family_guys/info_objects/person_info.dart';
import 'package:family_guys/map/map_person_info.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:family_guys/db_methods/fire_storages/fire_storage_service.dart';

class DbMainMethods {
  static Future<String> uploadPerson(PersonInfo personInfo, File avatar, List<File> photosList) async {
    uploadImageToFirebase(File image, String personId) async {
      var fileName = await DbMainMethods.addImageToPerson(personId);
      var firebaseStorageRef = FirebaseStorage.instance.ref().child(personId + '/' + fileName);
      await firebaseStorageRef.putFile(image);
    }

    uploadAvatar(File image, String personId) async {
      var firebaseStorageRef = FirebaseStorage.instance.ref().child(personId + '/avatar');
      await firebaseStorageRef.putFile(image);
    }

    DatabaseReference newPerson = FirebaseDatabase.instance.reference().push();
    uploadName() {
      newPerson.child('person_information').child('name').set(personInfo.name ?? '');
      newPerson.child('person_information').child('surname').set(personInfo.surname ?? '');
      newPerson.child('person_information').child('patronymic').set(personInfo.patronymic ?? '');
    }

    uploadBirthDate() {
      newPerson.child('person_information').child('birth').child('year').set(personInfo.birthDate?.year ?? 666999);
      newPerson.child('person_information').child('birth').child('month').set(personInfo.birthDate?.month ?? 666999);
      newPerson.child('person_information').child('birth').child('day').set(personInfo.birthDate?.day ?? 666999);
    }

    uploadDeathDate() {
      newPerson.child('person_information').child('death').child('year').set(personInfo.deathDate?.year ?? 666999);
      newPerson.child('person_information').child('death').child('month').set(personInfo.deathDate?.month ?? 666999);
      newPerson.child('person_information').child('death').child('day').set(personInfo.deathDate?.day ?? 666999);
    }

    uploadName();
    uploadBirthDate();
    uploadDeathDate();
    newPerson.child('person_information').child('id').set(newPerson.key);
    FirebaseDatabase.instance.reference().child('available_persons').child(newPerson.key).set(newPerson.key);
    var uploadList = [uploadAvatar(avatar, newPerson.key)];
    for (var img in photosList) {
      uploadList.add(uploadImageToFirebase(img, newPerson.key));
    }
    await Future.wait(uploadList);
    return newPerson.key;
  }

  static Future<Map> downloadPerson(String personID) async {
    DatabaseReference person = FirebaseDatabase.instance.reference().child(personID).child('person_information');
    var info = await person.once();
    return info.value;
  }

  static PersonInfo makePersonInfo(Map info) {
    var name = info['name'];
    var surname = info['surname'];
    var patronymic = info['patronymic'];

    var birthYear = info['birth']['year'];
    var birthMonth = info['birth']['month'];
    var birthDay = info['birth']['day'];

    var deathYear = info['death']['year'];
    var deathMonth = info['death']['month'];
    var deathDay = info['death']['day'];

    var id = info['id'];

    return PersonInfo(
        id: id,
        name: name,
        surname: surname,
        patronymic: patronymic,
        birthDate: DateInfo(day: birthDay, month: birthMonth, year: birthYear),
        deathDate: DateInfo(day: deathDay, month: deathMonth, year: deathYear));
  }

  static Future<PersonInfo> getPersonInfo(String personId) async {
    return makePersonInfo(await downloadPerson(personId));
  }

  static Future<List<PersonInfo>> loadConnectionsByType(String personID, String connectionType) async {
    List makeIdList(Map children) {
      return children.keys.toList();
    }

    DatabaseReference personsChildren = FirebaseDatabase.instance.reference().child(personID).child(connectionType);
    var childrenList = await personsChildren.once();
    if (childrenList.value == null) {
      return [];
    }

    var idList = makeIdList(childrenList.value);

    var personInfoList = <PersonInfo>[];
    for (var id in idList) {
      var childInfo = await downloadPerson(id);
      personInfoList.add(makePersonInfo(childInfo));
    }
    return personInfoList;
  }

  static Future<List<String>> loadConnectionsIdList(String personID, String connectionType) async {
    List<String> makeIdList(Map children) {
      return children.keys.map((e) => e.toString()).toList();
    }

    DatabaseReference personsChildren = FirebaseDatabase.instance.reference().child(personID).child(connectionType);
    var childrenList = await personsChildren.once();
    if (childrenList.value == null) {
      return [];
    }

    var idList = makeIdList(childrenList.value);

    return idList;
  }

  static Future<List<PersonInfo>> loadChildren(String personID) async {
    List makeIdList(Map children) {
      return children.keys.toList();
    }

    DatabaseReference personsChildren = FirebaseDatabase.instance.reference().child(personID).child('children');
    var childrenList = await personsChildren.once();
    if (childrenList.value == null) {
      return [];
    }

    var idList = makeIdList(childrenList.value);

    var personInfoList = <PersonInfo>[];
    for (var id in idList) {
      var childInfo = await downloadPerson(id);
      personInfoList.add(makePersonInfo(childInfo));
    }
    return personInfoList;
  }

  static Future<List<PersonInfo>> loadParents(String personID) async {
    List makeIdList(Map children) {
      return children.keys.toList();
    }

    DatabaseReference personsChildren = FirebaseDatabase.instance.reference().child(personID).child('parents');
    var childrenList = await personsChildren.once();
    if (childrenList.value == null) {
      return [];
    }

    var idList = makeIdList(childrenList.value);

    var personInfoList = <PersonInfo>[];
    for (var id in idList) {
      var childInfo = await downloadPerson(id);
      personInfoList.add(makePersonInfo(childInfo));
    }
    return personInfoList;
  }

  static List<String> makeIdList(Map children) {
    return (children.keys.map((e) => e.toString()).toList());
  }

  static List<String> makeValuesList(Map children) {
    print('children: ${children} ${children.values.toList()}');
    return (children.values.map((e) => e.toString()).toList());
  }

  static Future<List<PersonInfo>> loadAllPersons() async {
    DatabaseReference personsChildren = FirebaseDatabase.instance.reference().child('available_persons');
    var childrenList = await personsChildren.once();
    if (childrenList.value == null) {
      return [];
    }

    var idList = makeIdList(childrenList.value);

    var personInfoList = <PersonInfo>[];
    for (var id in idList) {
      var childInfo = await downloadPerson(id);
      personInfoList.add(makePersonInfo(childInfo));
    }
    return personInfoList;
  }

  static makeConnection(String firstPersonId, String secondPersonId, ConnectionType connectionType) async {
    var firstPersonField = connectionType.toString().split('.').last.split('_').last;
    var secondPersonField = connectionType.toString().split('.').last.split('_').first;
    print('${firstPersonField} ${secondPersonField}');
    await FirebaseDatabase.instance.reference().child(firstPersonId).child(firstPersonField).child(secondPersonId).set(secondPersonId);
    await FirebaseDatabase.instance.reference().child(secondPersonId).child(secondPersonField).child(firstPersonId).set(firstPersonId);
  }

  static Future<List<String>> downloadPersonImagesIdList(String personId) async {
    print('AAAAAAAAAA');
    var imagesIdList = await FirebaseDatabase.instance.reference().child(personId).child('images').once();
    if (imagesIdList.value == null) {
      return [];
    }

    print(imagesIdList.value);
    var idList = makeValuesList(imagesIdList.value);
    print('idList: ${idList}');
    return idList;
  }

  static Future<String> addImageToPerson(String personId) async {
    var newFile = FirebaseDatabase.instance.reference().child(personId).child('images').push();
    await newFile.set(newFile.key);
    return newFile.key;
  }

  static Future<MapPersonInformation> loadMapPersonInfo({required BuildContext context, required PersonInfo personInfo, bool isFinal = true}) async {
    Future<Image> getImage(BuildContext context, List<String> imagePath) async {
      late Image m;
      await FireStorageService.loadFromStorage(context, imagePath).then((downloadUrl) {
        m = Image.network(
          downloadUrl.toString(),
          fit: BoxFit.scaleDown,
        );
      });
      return m;
    }

    var avatarPath = [personInfo.id ?? '', 'avatar'];
    var avatar = await getImage(context, avatarPath);

    var children = <MapPersonInformation>[];
    if (!isFinal) {
      var childrenIdList = await loadConnectionsIdList(personInfo.id!, 'children');
      for (var personId in (childrenIdList)) {
        var connectedPersonInfo = await getPersonInfo(personId);
        children.add(await loadMapPersonInfo(context: context, personInfo: connectedPersonInfo));
      }
    }

    var parents = <MapPersonInformation>[];
    if (!isFinal) {
      var parentsIdList = await loadConnectionsIdList(personInfo.id!, 'parents');
      for (var personId in (parentsIdList)) {
        var connectedPersonInfo = await getPersonInfo(personId);
        parents.add(await loadMapPersonInfo(context: context, personInfo: connectedPersonInfo));
      }
    }

    var spouses = <MapPersonInformation>[];
    if (!isFinal) {
      var spousesIdList = await loadConnectionsIdList(personInfo.id!, 'spouses');
      for (var personId in (spousesIdList)) {
        var connectedPersonInfo = await getPersonInfo(personId);
        children.add(await loadMapPersonInfo(context: context, personInfo: connectedPersonInfo));
      }
    }

    var friends = <MapPersonInformation>[];
    if (!isFinal) {
      var friendsIdList = await loadConnectionsIdList(personInfo.id!, 'friends');
      for (var personId in (friendsIdList)) {
        var connectedPersonInfo = await getPersonInfo(personId);
        parents.add(await loadMapPersonInfo(context: context, personInfo: connectedPersonInfo));
      }
    }

    MapPersonInformation result =
        MapPersonInformation(personInfo: personInfo, avatar: avatar, children: children, parents: parents, friends: friends, spouses: spouses);

    return result;
  }

// static Future<String> addAvatarToPerson(String personId) async {
//   var newFile = FirebaseDatabase.instance.reference().child(personId).child('avatar').push();
//   await newFile.set(newFile.key);
//   return newFile.key;
// }
}
