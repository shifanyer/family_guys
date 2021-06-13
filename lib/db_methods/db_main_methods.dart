import 'package:family_guys/info_objects/person_info.dart';
import 'package:firebase_database/firebase_database.dart';

class DbMainMethods{

  static uploadPerson(PersonInfo personInfo){
    DatabaseReference newPerson = FirebaseDatabase.instance.reference().push();
    uploadName(){
      newPerson.child('name').set(personInfo.name ?? '');
      newPerson.child('surname').set(personInfo.surname ?? '');
      newPerson.child('patronymic').set(personInfo.patronymic ?? '');
    }
    uploadBirthDate(){
      newPerson.child('birth').child('year').set(personInfo.birthDate?.year ?? 666999);
      newPerson.child('birth').child('month').set(personInfo.birthDate?.month ?? 666999);
      newPerson.child('birth').child('day').set(personInfo.birthDate?.day ?? 666999);
    }
    uploadDeathDate(){
      newPerson.child('death').child('year').set(  personInfo.deathDate?.year ?? 666999);
      newPerson.child('death').child('month').set( personInfo.deathDate?.month ?? 666999);
      newPerson.child('death').child('day').set(   personInfo.deathDate?.day ?? 666999);
    }
    uploadName();
    uploadBirthDate();
    uploadDeathDate();

  }

  static downloadPerson(String personID){
    DatabaseReference person = FirebaseDatabase.instance.reference().child(personID);
    person.once().then((value) => print(value.value));
  }
}