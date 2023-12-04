import 'package:intl/intl.dart';

String getWeekday(int index) {
  return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'][index];
}

DateTime getDate(DateTime fullDate){
  return DateTime(fullDate.year,fullDate.month,fullDate.day);
}

String convertWeekday(DateTime fullDate){
    return DateFormat('EEE').format(fullDate);
}