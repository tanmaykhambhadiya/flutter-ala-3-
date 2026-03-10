import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/student_model.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key, this.editIndex, this.initialData});

  final int? editIndex;
  final Student? initialData;

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _enrollController = TextEditingController();
  final _courseController = TextEditingController();
  final Box _box = Hive.box('students');

  bool get _isEdit => widget.editIndex != null;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialData;
    if (initial != null) {
      _nameController.text = initial.name;
      _enrollController.text = initial.enroll;
      _courseController.text = initial.course;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _enrollController.dispose();
    _courseController.dispose();
    super.dispose();
  }

  void _saveStudent() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final student = Student(
      name: _nameController.text.trim(),
      enroll: _enrollController.text.trim(),
      course: _courseController.text.trim(),
    );

    if (_isEdit) {
      _box.putAt(widget.editIndex!, student.toMap());
    } else {
      _box.add(student.toMap());
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isEdit ? 'Student updated' : 'Student added'),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Update Student' : 'Add Student'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Student Name'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter student name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _enrollController,
                decoration:
                    const InputDecoration(labelText: 'Enrollment Number'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter enrollment number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _courseController,
                decoration: const InputDecoration(labelText: 'Course'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter course';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveStudent,
                child: Text(_isEdit ? 'Update' : 'Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
