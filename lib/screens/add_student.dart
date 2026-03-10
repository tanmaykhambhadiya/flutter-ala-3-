import 'package:flutter/material.dart';

import '../models/student_model.dart';
import '../services/database_service.dart';

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
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final _departments = ['IT', 'CSE', 'CE', 'ME', 'EE', 'General'];
  final _genders = ['Male', 'Female', 'Other'];

  String _selectedDepartment = 'IT';
  String _selectedGender = 'Male';
  int _selectedSemester = 1;

  bool get _isEdit => widget.editIndex != null;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialData;
    if (initial != null) {
      _nameController.text = initial.name;
      _enrollController.text = initial.enroll;
      _emailController.text = initial.email;
      _phoneController.text = initial.phone;
      _selectedDepartment = initial.department;
      _selectedSemester = initial.semester;
      _selectedGender = initial.gender;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _enrollController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveStudent() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final student = Student(
      name: _nameController.text.trim(),
      enroll: _enrollController.text.trim(),
      department: _selectedDepartment,
      semester: _selectedSemester,
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      gender: _selectedGender,
      attendanceBySubject: widget.initialData?.attendanceBySubject,
    );

    if (_isEdit) {
      DatabaseService.instance.updateStudent(widget.editIndex!, student);
    } else {
      DatabaseService.instance.addStudent(student);
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
              DropdownButtonFormField<String>(
                initialValue: _selectedDepartment,
                decoration: const InputDecoration(labelText: 'Department'),
                items: _departments.map((department) {
                  return DropdownMenuItem(
                    value: department,
                    child: Text(department),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDepartment = value ?? _selectedDepartment;
                  });
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                initialValue: _selectedSemester,
                decoration: const InputDecoration(labelText: 'Semester'),
                items: List.generate(8, (index) {
                  final sem = index + 1;
                  return DropdownMenuItem(
                      value: sem, child: Text('Semester $sem'));
                }),
                onChanged: (value) {
                  setState(() {
                    _selectedSemester = value ?? _selectedSemester;
                  });
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _selectedGender,
                decoration: const InputDecoration(labelText: 'Gender'),
                items: _genders.map((gender) {
                  return DropdownMenuItem(
                    value: gender,
                    child: Text(gender),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value ?? _selectedGender;
                  });
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) {
                    return 'Enter email';
                  }
                  if (!text.contains('@')) {
                    return 'Enter valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter phone number';
                  }
                  if (value.trim().length < 10) {
                    return 'Enter valid phone number';
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
