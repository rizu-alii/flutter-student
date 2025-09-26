import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studentapp/bloc/search/search_bloc.dart';
import 'package:studentapp/data/network/ApiService.dart';
import 'package:studentapp/screens/search_screen.dart';
import 'package:studentapp/screens/timetable_screen.dart';
import 'package:studentapp/utils/TimetableQueries.dart';

import 'bloc/timetable/timetable_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final response = await ApiService.fetechApi();
  await ApiService.saveApiDataToDb(response);

  final result = await TimetableQueries.getTeacherTimetable("Mr. Husnain Raza");
  // final resultStudents =      await TimetableQueries.getStudentTimetable("FA25", "BCS", "A");
  for (var row in result) {
    print(
        "Day: ${row['day']} | ${row['startTime']} - ${row['endTime']} | "
            "Course: ${row['course']} (${row['code']}) | "
            "Room: ${row['room']} | "
            "Section: ${row['batch']} ${row['program']} ${row['sectionNumber']}");
  }

  // ✅ Student timetable
  final resultStudents = await TimetableQueries.getStudentTimetable("FA25", "BCS", "A");
  print("\nStudent Timetable:");
  for (var row in resultStudents) {
    print(
        "Day: ${row['day']} | ${row['startTime']} - ${row['endTime']} | "
            "Course: ${row['course']} (${row['code']}) | "
            "Instructor: ${row['instructor']} | "
            "Room: ${row['room']}"
    );
  }


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SearchBloc>(
          create: (_) => SearchBloc(),
        ),
        BlocProvider<TimetableBloc>(
          create: (_) => TimetableBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Student App',
        home: const SearchScreen(),
      ),
    );
  }
}
