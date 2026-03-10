import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/student_model.dart';
import 'add_student.dart';

class StudentListScreen extends StatelessWidget {
  const StudentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Box box = Hive.box('students');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student List'),
      ),
      body: ValueListenableBuilder<Box>(
        valueListenable: box.listenable(),
        builder: (context, box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Text('No students added yet'),
            );
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final raw = box.getAt(index) as Map<dynamic, dynamic>;
              final student = Student.fromMap(raw);

              return ListTile(
                title: Text(student.name),
                subtitle: Text(
                  'Enroll: ${student.enroll}\nCourse: ${student.course}',
                ),
                isThreeLine: true,
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => AddStudentScreen(
                          editIndex: index,
                          initialData: student,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
