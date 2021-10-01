class Courses {
  int courseID;
  String courseName;
  String Time;

  Courses(this.courseID, this.courseName, this.Time);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'CourseID': courseID,
      'CourseName': courseName,
      'Time': Time
    };
    return map;
  }

  Courses.fromMap(Map<String, dynamic> map) {
    courseID = map['CourseID'];
    courseName = map['CourseName'];
    Time = map['Time'];
  }
}
