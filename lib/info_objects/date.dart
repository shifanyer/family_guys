class DateInfo {
  int? day;
  int? month;
  int? year;

  DateInfo({this.day, this.month, this.year});

  DateInfo.Jesus()
      : day = 0,
        month = 0,
        year = 0;

  String displayDate() {
    var resDay = day;
    var resMonth = month;
    var resYear = year;
    if (day == 666999) {
      resDay = null;
    }
    if (month == 666999) {
      resMonth = null;
    }
    if (year == 666999) {
      resYear = null;
    }
    if ((resDay == null) && (resMonth == null) && (resYear == null)) {
      return '??????';
    } else {
      return ((resDay?.toString() ?? '') +
          (resDay != null ? '.' : '') +
          (resMonth?.toString() ?? '') +
          (resMonth != null ? '.' : '') +
          (resYear?.toString() ?? ''));
    }
  }
}
