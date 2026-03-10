# Student Management System (Flutter + Hive)

This project is a simple Flutter beginner activity submission that demonstrates local CRUD operations using Hive.

## Objective

Implement a basic Student Management System with local storage support.

## Features Implemented

- Add Student
- View Students
- Update Student
- Local data persistence using Hive

Each student record stores:

- Student Name
- Enrollment Number
- Course

## Tech Stack

- Flutter
- Dart
- Hive (`hive`, `hive_flutter`)

## Project Structure

```text
lib
|- main.dart
|- models
|  |- student_model.dart
|- screens
|  |- home_screen.dart
|  |- add_student.dart
|  |- student_list.dart
```

## CRUD Mapping

- Create (Store): `box.add(student.toMap())`
- Read (Retrieve): `box.getAt(index)` and `box.length`
- Update: `box.putAt(index, student.toMap())`

## How to Run

1. Install dependencies:

```bash
flutter pub get
```

2. Check available devices:

```bash
flutter devices
```

3. Run app:

```bash
flutter run -d chrome
```

Optional (Windows desktop):

```bash
flutter run -d windows
```

Note: Windows desktop build requires Visual Studio Build Tools with "Desktop development with C++" workload.

## Screenshots

### Home Screen

![Home Screen](Screenshot%202026-03-10%20200112.png)

### Add Student Screen

![Add Student Screen](Screenshot%202026-03-10%20200139.png)

### Student List Screen

![Student List Screen](Screenshot%202026-03-10%20200151.png)

## Attached Documentation

- [Project Documentation PDF](documnetataon.pdf)

## Submission Summary

This activity successfully demonstrates a basic Flutter Student Management System with Hive-based local storage and CRUD functionality suitable for beginner-level submission.
# flutter-ala-3-
