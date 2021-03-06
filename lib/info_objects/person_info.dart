import 'date.dart';

class PersonInfo {
  String? id;

  String? surname;
  String? name;
  String? patronymic;

  DateInfo? birthDate;
  DateInfo? minBirthDate;
  DateInfo? maxBirthDate;

  DateInfo? deathDate;
  DateInfo? minDeathDate;
  DateInfo? maxDeathDate;

  List? otherNames;

  List<String>? spouses;
  List<String>? children;
  List<String>? parents;
  List<String>? friends;

  PersonInfo(
      {this.id,
      this.surname,
      this.name,
      this.patronymic,
      this.birthDate,
      this.minBirthDate,
      this.maxBirthDate,
      this.deathDate,
      this.minDeathDate,
      this.maxDeathDate,
      this.otherNames,
      this.spouses,
      this.children,
      this.parents,
      this.friends});

  PersonInfo.clone(PersonInfo randomObject)
      : this(
            surname: randomObject.surname,
            name: randomObject.name,
            patronymic: randomObject.patronymic,
            birthDate: randomObject.birthDate,
            minBirthDate: randomObject.minBirthDate,
            maxBirthDate: randomObject.maxBirthDate,
            deathDate: randomObject.deathDate,
            minDeathDate: randomObject.minDeathDate,
            maxDeathDate: randomObject.maxDeathDate,
            otherNames: randomObject.otherNames);

  String nameDisplay() {
    if ((((name == null) || (name == '')) && ((surname == null) || (surname == '')) && ((patronymic == null) || (patronymic == '')))) {
      return '??????';
    } else {
      return ((surname ?? '') +
          (((surname != null) && (surname != '')) ? ' ' : '') +
          (name ?? '') +
          (((name != null) && (name != '')) ? ' ' : '') +
          (patronymic ?? ''));
    }
  }

  String datesDisplay() {
    return (birthDate?.displayDate() ?? '??????') + ' - ' + (deathDate?.displayDate() ?? '??????');
  }

  PersonInfo.Igor()
      : this(id: '-McAWaTcf7V9_Incz9ZG', name: 'Игорь', patronymic: 'Рюрикович', birthDate: DateInfo(year: 912), deathDate: DateInfo(year: 945));
}
