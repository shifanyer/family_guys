class DateInfo {
  int? day;
  int? month;
  int? year;

  DateInfo({this.day, this.month, this.year});

  DateInfo.Jesus()
      : day = 0,
        month = 0,
        year = 0;

  String displayDate(){
    if ((day == null) && (month == null) && (year == null)) {
      return '??????';
    } else {
      return ((day?.toString() ?? '') + (day != null ? '.' : '') + (month?.toString() ?? '') + (month != null ? '.' : '') + (year?.toString() ?? ''));
    }
  }
}
