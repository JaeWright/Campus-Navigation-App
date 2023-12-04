import 'package:intl/intl.dart';


//converts long form days into short form if needed
String getWeekday(int index) {
  return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'][index];
}

//gets the short form weekday string from DateTime
String convertWeekday(DateTime fullDate){
    return DateFormat('EEE').format(fullDate);
}

DateTime setInitialDate(){
  if(DateTime.now().weekday==6){
    return DateTime.now().add(const Duration(days: 2));
  }else if(DateTime.now().weekday==7){
    return DateTime.now().add(const Duration(days: 1));
  }
  else{
    return DateTime.now();
  }
}