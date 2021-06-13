import 'date.dart';

class PersonInfo {
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

  PersonInfo(
      {this.surname,
      this.name,
      this.patronymic,
      this.birthDate,
      this.minBirthDate,
      this.maxBirthDate,
      this.deathDate,
      this.minDeathDate,
      this.maxDeathDate,
      this.otherNames});

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
    if ((name == null) && (surname == null) && (patronymic == null)) {
      return '??????';
    } else {
      return ((surname ?? '') + (surname != null ? ' ' : '') + (name ?? '') + (name != null ? ' ' : '') + (patronymic ?? ''));
    }
  }

  PersonInfo.Igor() : this(name: 'Игорь', patronymic: 'Рюрикович', birthDate: DateInfo(year: 912), deathDate: DateInfo(year: 945));
}
