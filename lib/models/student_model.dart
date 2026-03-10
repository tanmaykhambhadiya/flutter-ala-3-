class Student {
  String name;
  String enroll;
  String course;

  Student({
    required this.name,
    required this.enroll,
    required this.course,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'enroll': enroll,
      'course': course,
    };
  }

  factory Student.fromMap(Map<dynamic, dynamic> map) {
    return Student(
      name: map['name']?.toString() ?? '',
      enroll: map['enroll']?.toString() ?? '',
      course: map['course']?.toString() ?? '',
    );
  }
}
