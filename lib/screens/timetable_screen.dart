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
    this.isTeacher = false,
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

    return BlocProvider(
      create: (_) => TimetableBloc(
        isTeacher: widget.isTeacher,
        teacherName: widget.teacherName,
        batch: widget.batch,
        program: widget.program,
        sectionNumber: widget.sectionNumber,
      )..add(LoadTimetableEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.isTeacher ? 'Teacher Timetable' : 'Student Timetable'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                context.read<TimetableBloc>().add(RefreshTimetableEvent());
              },
            )
          ],
        ),
        body: Column(
          children: [
            // Day selector
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: days.map((day) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedDay = day),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: _selectedDay == day
                              ? colorScheme.primary
                              : colorScheme.primary.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          day.substring(0, 3),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Expanded(
              child: BlocBuilder<TimetableBloc, TimetableState>(
                builder: (context, state) {
                  if (state is TimetableLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is TimetableLoaded) {
                    final lectures = state.timetables
                        .where((lec) => lec.day.name == _selectedDay)
                        .toList();

                    if (lectures.isEmpty) return const Center(child: Text('No classes today'));

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: lectures.length,
                      itemBuilder: (context, index) {
                        final TimetableEntry lec = lectures[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: ListTile(
                            title: Text('${lec.course.name} (${lec.course.code})'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Time: ${formatTime(lec.startTime)} - ${formatTime(lec.endTime)}'),
                                if (!widget.isTeacher) Text('Instructor: ${lec.instructor.name}'),
                                Text('Room: ${lec.room.name}'),
                                Text('Section: ${lec.section.batch} ${lec.section.program} ${lec.section.sectionNumber}'),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is TimetableError) {
                    return Center(child: Text(state.message));
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
