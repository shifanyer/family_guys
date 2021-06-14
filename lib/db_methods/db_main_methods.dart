import 'package:family_guys/info_objects/date.dart';
import 'package:family_guys/info_objects/person_info.dart';
import 'package:firebase_database/firebase_database.dart';

class DbMainMethods {
  static uploadPerson(PersonInfo personInfo) {
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
  }

  static downloadPerson(String personID) async {
    DatabaseReference person = FirebaseDatabase.instance.reference().child(personID).child('person_information');
    var info = await person.once();
    return info.value;
  }

  static makePersonInfo(Map info) {
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

  static Future<List<PersonInfo>> loadChildren(String personID) async {
    List makeIdList(Map children) {
      return children.keys.toList();
    }

    DatabaseReference personsChildren = FirebaseDatabase.instance.reference().child(personID).child('children');
    var childrenList = await personsChildren.once();
    if (childrenList.value == null){
      return [];
    }

    var idList = makeIdList(childrenList.value);

    var personInfoList = <PersonInfo>[];
    for (var id in idList){
      var childInfo = await downloadPerson(id);
      personInfoList.add(makePersonInfo(childInfo));
    }
    return personInfoList;
  }
}
