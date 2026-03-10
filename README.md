# Student Management App

A mini college management system built with Flutter and Hive for local data storage.

## Student Details

- Name: Tanmay Khambhadiya
- Enrollment: 20230905050507

## Project Overview

This app is upgraded from a simple CRUD demo into a practical student administration tool.
It manages:

- Student records
- Attendance tracking
- Department and semester data
- Dashboard statistics and charts

## Core Features

- Dashboard with summary cards:
	- Total students
	- Male students
	- Female students
	- Average attendance
- Add and edit student with detailed fields:
	- Name
	- Enrollment number
	- Department
	- Semester
	- Email
	- Phone number
	- Gender
- Student profile screen with full details
- Attendance management by subject (Present/Absent)
- Search by name or enrollment
- Filter by department and semester
- Statistics charts using `fl_chart`:
	- Students per department
	- Students per semester

## Application Workflow

1. App launch
- `main.dart` initializes Hive and opens the `students` box.
- User lands on the Dashboard screen.

2. Dashboard
- Summary cards are generated from stored student records.
- Charts visualize department and semester distribution.
- User can navigate to Add Student or Student List.

3. Add Student
- User fills in the student form.
- Data is validated and saved to Hive.
- User returns to Dashboard/List with updated data.

4. Student List
- All students are shown in card format.
- Search and filters narrow the student list.
- User can open profile or edit directly.

5. Student Profile
- Displays complete student information.
- User can edit, delete, or open attendance screen.

6. Attendance Screen
- User adds subjects.
- For each subject, attendance is marked Present/Absent.
- Percentage is calculated automatically and reflected across app screens.

## Tech Stack

- Flutter
- Dart
- Hive (`hive`, `hive_flutter`)
- Charts: `fl_chart`

## Project Structure

```text
lib/
	main.dart
	models/
		student_model.dart
	services/
		database_service.dart
	screens/
		dashboard.dart
		add_student.dart
		student_list.dart
		student_profile.dart
		attendance_screen.dart
	widgets/
		summary_card.dart
		student_card.dart
```

## How to Run

```bash
flutter pub get
flutter run
```

Optional checks:

```bash
flutter analyze
```

## Screenshots

### Dashboard

![Dashboard](Screenshot%202026-03-10%20235203.png)

### Student List / Filters

![Student List](Screenshot%202026-03-10%20235251.png)

### Student Profile / Attendance

![Student Profile](Screenshot%202026-03-10%20235306.png)

## Documentation

- [Project Documentation PDF](documnetataon.pdf)
