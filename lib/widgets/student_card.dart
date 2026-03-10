import 'package:flutter/material.dart';

import '../models/student_model.dart';

class StudentCard extends StatelessWidget {
  const StudentCard({
    super.key,
    required this.student,
    required this.onView,
    required this.onEdit,
  });

  final Student student;
  final VoidCallback onView;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              student.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text('Enroll: ${student.enroll}'),
            Text('Dept: ${student.department} | Sem: ${student.semester}'),
            Text(
                'Attendance: ${student.attendancePercentage.toStringAsFixed(1)}%'),
            const SizedBox(height: 10),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: onView,
                  icon: const Icon(Icons.visibility_outlined),
                  label: const Text('View'),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('Edit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
