class Student {
  String name;
  String enroll;
  String department;
  int semester;
  String email;
  String phone;
  String gender;
  Map<String, bool> attendanceBySubject;

  Student({
    required this.name,
    required this.enroll,
    required this.department,
    required this.semester,
    required this.email,
    required this.phone,
    required this.gender,
    Map<String, bool>? attendanceBySubject,
  }) : attendanceBySubject = attendanceBySubject ?? <String, bool>{};

  double get attendancePercentage {
    if (attendanceBySubject.isEmpty) {
      return 0;
    }

    final presentCount =
        attendanceBySubject.values.where((isPresent) => isPresent).length;
    return (presentCount / attendanceBySubject.length) * 100;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'enroll': enroll,
      'department': department,
      'semester': semester,
      'email': email,
      'phone': phone,
      'gender': gender,
      'attendanceBySubject': attendanceBySubject,
    };
  }

  factory Student.fromMap(Map<dynamic, dynamic> map) {
    final rawAttendance = map['attendanceBySubject'];
    final attendance = <String, bool>{};

    if (rawAttendance is Map) {
      for (final entry in rawAttendance.entries) {
        attendance[entry.key.toString()] = entry.value == true;
      }
    }

    final legacyDepartment = map['course']?.toString() ?? 'General';

    return Student(
      name: map['name']?.toString() ?? '',
      enroll: map['enroll']?.toString() ?? '',
      department: map['department']?.toString() ?? legacyDepartment,
      semester: int.tryParse(map['semester']?.toString() ?? '') ?? 1,
      email: map['email']?.toString() ?? '',
      phone: map['phone']?.toString() ?? '',
      gender: map['gender']?.toString() ?? 'Other',
      attendanceBySubject: attendance,
    );
  }
}
