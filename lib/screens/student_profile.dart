import 'package:flutter/material.dart';

import '../services/database_service.dart';
import 'add_student.dart';
import 'attendance_screen.dart';

class StudentProfileScreen extends StatelessWidget {
  const StudentProfileScreen({super.key, required this.studentIndex});

  final int studentIndex;

  @override
  Widget build(BuildContext context) {
    final student = DatabaseService.instance.getStudents()[studentIndex];

    return Scaffold(
      appBar: AppBar(title: const Text('Student Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(student.name,
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            _infoTile('Enrollment', student.enroll),
            _infoTile('Department', student.department),
            _infoTile('Semester', '${student.semester}'),
            _infoTile('Email', student.email),
            _infoTile('Phone', student.phone),
            _infoTile('Gender', student.gender),
            _infoTile(
              'Attendance',
              '${student.attendancePercentage.toStringAsFixed(1)}%',
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => AddStudentScreen(
                          editIndex: studentIndex,
                          initialData: student,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit Student'),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => AttendanceScreen(
                          studentIndex: studentIndex,
                          student: student,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.fact_check),
                  label: const Text('Manage Attendance'),
                ),
                TextButton.icon(
                  onPressed: () async {
                    final shouldDelete = await showDialog<bool>(
                          context: context,
                          builder: (dialogContext) {
                            return AlertDialog(
                              title: const Text('Delete Student'),
                              content: const Text(
                                'Are you sure you want to delete this student?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(dialogContext, false);
                                  },
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(dialogContext, true);
                                  },
                                  child: const Text('Delete'),
                                ),
                              ],
                            );
                          },
                        ) ??
                        false;

                    if (!shouldDelete || !context.mounted) {
                      return;
                    }

                    DatabaseService.instance.deleteStudent(studentIndex);
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  label: const Text(
                    'Delete Student',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(String label, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(label),
        subtitle: Text(value.isEmpty ? '-' : value),
      ),
    );
  }
}
