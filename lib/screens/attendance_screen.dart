import 'package:flutter/material.dart';

import '../models/student_model.dart';
import '../services/database_service.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({
    super.key,
    required this.studentIndex,
    required this.student,
  });

  final int studentIndex;
  final Student student;

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final _subjectController = TextEditingController();

  @override
  void dispose() {
    _subjectController.dispose();
    super.dispose();
  }

  void _addSubject() {
    final subject = _subjectController.text.trim();
    if (subject.isEmpty) {
      return;
    }

    DatabaseService.instance.setAttendance(
      index: widget.studentIndex,
      subject: subject,
      isPresent: true,
    );

    _subjectController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final latestStudent =
        DatabaseService.instance.getStudents()[widget.studentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance - ${latestStudent.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Attendance: ${latestStudent.attendancePercentage.toStringAsFixed(1)}%',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _subjectController,
                    decoration: const InputDecoration(
                      labelText: 'Add Subject',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addSubject,
                  child: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Expanded(
              child: latestStudent.attendanceBySubject.isEmpty
                  ? const Center(child: Text('No subjects added yet'))
                  : ListView(
                      children: latestStudent.attendanceBySubject.entries
                          .map(
                            (entry) => Card(
                              child: SwitchListTile(
                                title: Text(entry.key),
                                subtitle:
                                    Text(entry.value ? 'Present' : 'Absent'),
                                value: entry.value,
                                onChanged: (value) {
                                  DatabaseService.instance.setAttendance(
                                    index: widget.studentIndex,
                                    subject: entry.key,
                                    isPresent: value,
                                  );
                                  setState(() {});
                                },
                              ),
                            ),
                          )
                          .toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
