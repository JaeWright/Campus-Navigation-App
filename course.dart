// course.dart

class Course {
  int? id;
  String? weekday;
  String? courseName;
  String? profName;
  String? roomNum;
  String? startTime;
  String? endTime;

  Course({
    this.id,
    required this.weekday,
    required this.courseName,
    required this.profName,
    required this.roomNum,
    required this.startTime,
    required this.endTime,
  });
}
