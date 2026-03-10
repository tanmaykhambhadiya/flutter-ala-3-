import 'package:hive/hive.dart';

import '../models/student_model.dart';

class StudentStats {
  final int total;
  final int male;
  final int female;
  final double averageAttendance;
  final Map<String, int> byDepartment;
  final Map<int, int> bySemester;

  const StudentStats({
    required this.total,
    required this.male,
    required this.female,
    required this.averageAttendance,
    required this.byDepartment,
    required this.bySemester,
  });
}

class DatabaseService {
  DatabaseService._();

  static final DatabaseService instance = DatabaseService._();

  Box get _box => Hive.box('students');

  List<Student> getStudents() {
    return _box.values
        .map((raw) => Student.fromMap(raw as Map<dynamic, dynamic>))
        .toList();
  }

  void addStudent(Student student) {
    _box.add(student.toMap());
  }

  void updateStudent(int index, Student student) {
    _box.putAt(index, student.toMap());
  }

  void deleteStudent(int index) {
    _box.deleteAt(index);
  }

  void setAttendance({
    required int index,
    required String subject,
    required bool isPresent,
  }) {
    final raw = _box.getAt(index) as Map<dynamic, dynamic>;
    final student = Student.fromMap(raw);
    student.attendanceBySubject[subject] = isPresent;
    _box.putAt(index, student.toMap());
  }

  StudentStats getStats() {
    final students = getStudents();
    final byDepartment = <String, int>{};
    final bySemester = <int, int>{};

    var male = 0;
    var female = 0;
    var totalAttendance = 0.0;

    for (final student in students) {
      byDepartment[student.department] =
          (byDepartment[student.department] ?? 0) + 1;
      bySemester[student.semester] = (bySemester[student.semester] ?? 0) + 1;

      final gender = student.gender.toLowerCase();
      if (gender == 'male') {
        male += 1;
      } else if (gender == 'female') {
        female += 1;
      }

      totalAttendance += student.attendancePercentage;
    }

    final averageAttendance =
        students.isEmpty ? 0.0 : totalAttendance / students.length;

    return StudentStats(
      total: students.length,
      male: male,
      female: female,
      averageAttendance: averageAttendance,
      byDepartment: byDepartment,
      bySemester: bySemester,
    );
  }
}
