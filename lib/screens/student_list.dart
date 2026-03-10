import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/student_model.dart';
import '../widgets/student_card.dart';
import 'add_student.dart';
import 'student_profile.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  String _query = '';
  String _department = 'All';
  String _semester = 'All';

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
          final departments = {'All'};
          final semesters = {'All'};

          final studentsWithIndex = <MapEntry<int, Student>>[];
          for (var i = 0; i < box.length; i++) {
            final raw = box.getAt(i) as Map<dynamic, dynamic>;
            final student = Student.fromMap(raw);
            studentsWithIndex.add(MapEntry(i, student));
            departments.add(student.department);
            semesters.add(student.semester.toString());
          }

          final filtered = studentsWithIndex.where((entry) {
            final student = entry.value;
            final q = _query.toLowerCase();

            final queryMatch = q.isEmpty ||
                student.name.toLowerCase().contains(q) ||
                student.enroll.toLowerCase().contains(q);
            final departmentMatch =
                _department == 'All' || student.department == _department;
            final semesterMatch =
                _semester == 'All' || student.semester.toString() == _semester;

            return queryMatch && departmentMatch && semesterMatch;
          }).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        hintText: 'Search by name or enrollment',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _query = value.trim();
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: _department,
                            decoration:
                                const InputDecoration(labelText: 'Department'),
                            items: departments
                                .map(
                                  (department) => DropdownMenuItem(
                                    value: department,
                                    child: Text(department),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _department = value ?? 'All';
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: _semester,
                            decoration:
                                const InputDecoration(labelText: 'Semester'),
                            items: semesters
                                .map(
                                  (semester) => DropdownMenuItem(
                                    value: semester,
                                    child: Text(semester),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _semester = value ?? 'All';
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: filtered.isEmpty
                    ? const Center(child: Text('No students match the filter'))
                    : ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final entry = filtered[index];
                          final studentIndex = entry.key;
                          final student = entry.value;

                          return StudentCard(
                            student: student,
                            onView: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (_) => StudentProfileScreen(
                                    studentIndex: studentIndex,
                                  ),
                                ),
                              );
                            },
                            onEdit: () {
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
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (_) => const AddStudentScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
