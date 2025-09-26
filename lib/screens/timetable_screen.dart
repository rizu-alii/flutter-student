import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/timetable/timetable_bloc.dart';
import '../bloc/timetable/timetable_event.dart';
import '../bloc/timetable/timetable_state.dart';
import '../models/timetable_entry.dart';

class TimetableScreen extends StatefulWidget {
  final bool isTeacher;
  final String? teacherName;
  final String? batch;
  final String? program;
  final String? sectionNumber;

  const TimetableScreen({
    super.key,
    required this.isTeacher,
    this.teacherName,
    this.batch,
    this.program,
    this.sectionNumber,
  });

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  String _selectedDay = 'Monday';
  final List<String> days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];

  @override
  void initState() {
    super.initState();
    context.read<TimetableBloc>().add(
      LoadTimetableEvent(
        isTeacher: widget.isTeacher,
        teacherName: widget.teacherName,
        batch: widget.batch,
        program: widget.program,
        sectionNumber: widget.sectionNumber,
      ),
    );
  }

  String formatTime(String time) {
    List<String> parts = time.split(':');
    int hour = int.parse(parts[0]);
    int min = int.parse(parts[1]);
    String ampm = hour >= 12 ? 'PM' : 'AM';
    hour = hour % 12;
    if (hour == 0) hour = 12;
    return '$hour:${min.toString().padLeft(2, '0')} $ampm';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isTeacher ? 'Teacher Timetable' : 'Student Timetable'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<TimetableBloc>().add(
                RefreshTimetableEvent(
                  isTeacher: widget.isTeacher,
                  teacherName: widget.teacherName,
                  batch: widget.batch,
                  program: widget.program,
                  sectionNumber: widget.sectionNumber,
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: days.map((day) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ChoiceChip(
                    label: Text(day.substring(0, 3)),
                    selected: _selectedDay == day,
                    onSelected: (_) => setState(() => _selectedDay = day),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: BlocBuilder<TimetableBloc, TimetableState>(
              builder: (context, state) {
                if (state is TimetableLoading) return const Center(child: CircularProgressIndicator());
                if (state is TimetableError) return Center(child: Text(state.message));
                if (state is TimetableLoaded) {
                  final lectures = state.timetables.where((t) => t.day.name == _selectedDay).toList();
                  if (lectures.isEmpty) return const Center(child: Text('No classes today'));
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: lectures.length,
                    itemBuilder: (_, i) => buildLectureTile(lectures[i]),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLectureTile(TimetableEntry lec) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(formatTime(lec.startTime), style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(formatTime(lec.endTime)),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(lec.course.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('Room: ${lec.room.name}'),
                  Text('Instructor: ${lec.instructor.name}'),
                  Text('Section: ${lec.section.batch}-${lec.section.program}${lec.section.sectionNumber}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
