import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../services/database_service.dart';
import '../widgets/summary_card.dart';
import 'add_student.dart';
import 'student_list.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('students');

    return Scaffold(
      appBar: AppBar(title: const Text('Student Management')),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, _, __) {
          final stats = DatabaseService.instance.getStats();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SummaryCard(
                  title: 'Total Students',
                  value: '${stats.total}',
                  icon: Icons.groups,
                  color: Colors.indigo,
                ),
                SummaryCard(
                  title: 'Male Students',
                  value: '${stats.male}',
                  icon: Icons.male,
                  color: Colors.blue,
                ),
                SummaryCard(
                  title: 'Female Students',
                  value: '${stats.female}',
                  icon: Icons.female,
                  color: Colors.pink,
                ),
                SummaryCard(
                  title: 'Avg Attendance',
                  value: '${stats.averageAttendance.toStringAsFixed(1)}%',
                  icon: Icons.percent,
                  color: Colors.green,
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (_) => const AddStudentScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.person_add_alt_1),
                        label: const Text('Add Student'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (_) => const StudentListScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.list_alt),
                        label: const Text('Student List'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Students Per Department',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 220,
                  child: _DepartmentChart(data: stats.byDepartment),
                ),
                const SizedBox(height: 16),
                Text(
                  'Students Per Semester',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 220,
                  child: _SemesterChart(data: stats.bySemester),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (_) => const AddStudentScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Student'),
      ),
    );
  }
}

class _DepartmentChart extends StatelessWidget {
  const _DepartmentChart({required this.data});

  final Map<String, int> data;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text('No department data yet'));
    }

    final entries = data.entries.toList();
    final colors = [
      Colors.indigo,
      Colors.teal,
      Colors.orange,
      Colors.pink,
      Colors.deepPurple,
    ];

    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 34,
        sections: List.generate(entries.length, (index) {
          final entry = entries[index];
          return PieChartSectionData(
            value: entry.value.toDouble(),
            title: '${entry.key}\n${entry.value}',
            color: colors[index % colors.length],
            radius: 64,
            titleStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          );
        }),
      ),
    );
  }
}

class _SemesterChart extends StatelessWidget {
  const _SemesterChart({required this.data});

  final Map<int, int> data;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text('No semester data yet'));
    }

    final entries = data.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    final maxY = entries
            .map((entry) => entry.value)
            .reduce((current, next) => current > next ? current : next)
            .toDouble() +
        1;

    return BarChart(
      BarChartData(
        maxY: maxY,
        barGroups: entries
            .map(
              (entry) => BarChartGroupData(
                x: entry.key,
                barRods: [
                  BarChartRodData(
                    toY: entry.value.toDouble(),
                    width: 18,
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.blue,
                  ),
                ],
              ),
            )
            .toList(),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 28),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text('Sem ${value.toInt()}');
              },
            ),
          ),
        ),
      ),
    );
  }
}
