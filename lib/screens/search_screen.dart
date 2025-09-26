// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../bloc/search/search_bloc.dart';
// import '../bloc/search/search_event.dart';
// import '../bloc/search/search_state.dart';
// import 'timetable_screen.dart';
//
// class SearchScreen extends StatefulWidget {
//   const SearchScreen({super.key});
//
//   @override
//   State<SearchScreen> createState() => _SearchScreenState();
// }
//
// class _SearchScreenState extends State<SearchScreen> {
//   bool isTeacher = true; // toggle teacher/student
//   String query = '';
//   String batch = '', program = '', section = '';
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Search")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // Toggle Teacher/Student
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ChoiceChip(
//                   label: const Text("Teacher"),
//                   selected: isTeacher,
//                   onSelected: (_) => setState(() => isTeacher = true),
//                 ),
//                 const SizedBox(width: 8),
//                 ChoiceChip(
//                   label: const Text("Student"),
//                   selected: !isTeacher,
//                   onSelected: (_) => setState(() => isTeacher = false),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//
//             // Input Fields
//             if (isTeacher)
//               TextField(
//                 decoration: const InputDecoration(
//                   labelText: "Search Teacher Name",
//                   border: OutlineInputBorder(),
//                 ),
//                 onChanged: (val) {
//                   query = val;
//                   context.read<SearchBloc>().add(SearchTeachersEvent(val));
//                 },
//               )
//             else
//               Column(
//                 children: [
//                   TextField(
//                     decoration: const InputDecoration(
//                       labelText: "Batch",
//                       border: OutlineInputBorder(),
//                     ),
//                     onChanged: (val) => batch = val,
//                   ),
//                   const SizedBox(height: 8),
//                   TextField(
//                     decoration: const InputDecoration(
//                       labelText: "Program",
//                       border: OutlineInputBorder(),
//                     ),
//                     onChanged: (val) => program = val,
//                   ),
//                   const SizedBox(height: 8),
//                   TextField(
//                     decoration: const InputDecoration(
//                       labelText: "Section",
//                       border: OutlineInputBorder(),
//                     ),
//                     onChanged: (val) => section = val,
//                   ),
//                 ],
//               ),
//
//             const SizedBox(height: 16),
//
//             // Display Search Results for Teacher
//             if (isTeacher)
//               Expanded(
//                 child: BlocBuilder<SearchBloc, SearchState>(
//                   builder: (context, state) {
//                     if (state is SearchLoading) {
//                       return const Center(child: CircularProgressIndicator());
//                     } else if (state is SearchLoaded) {
//                       if (state.results.isEmpty) {
//                         return const Center(child: Text("No teacher found"));
//                       }
//                       return ListView.builder(
//                         itemCount: state.results.length,
//                         itemBuilder: (_, index) {
//                           final name = state.results[index];
//                           return ListTile(
//                             title: Text(name),
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (_) => TimetableScreen(
//                                     isTeacher: true,
//                                     teacherName: name,
//                                   ),
//                                 ),
//                               );
//                             },
//                           );
//                         },
//                       );
//                     } else if (state is SearchError) {
//                       return Center(child: Text(state.message));
//                     }
//                     return const SizedBox();
//                   },
//                 ),
//               ),
//
//             // Student Button
//             if (!isTeacher)
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => TimetableScreen(
//                         isTeacher: false,
//                         batch: batch,
//                         program: program,
//                         sectionNumber: section,
//                       ),
//                     ),
//                   );
//                 },
//                 child: const Text("View Timetable"),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/search/search_bloc.dart';
import '../bloc/search/search_event.dart';
import '../bloc/search/search_state.dart';
import 'timetable_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isTeacher = true; // toggle teacher/student
  String query = '';
  String batch = 'FA25', program = 'BBA', section = 'A';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Toggle Teacher/Student
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  label: const Text("Teacher"),
                  selected: isTeacher,
                  onSelected: (_) => setState(() => isTeacher = true),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text("Student"),
                  selected: !isTeacher,
                  onSelected: (_) => setState(() => isTeacher = false),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Input Fields
            if (isTeacher)
              TextField(
                decoration: const InputDecoration(
                  labelText: "Search Teacher Name",
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) {
                  query = val;
                  context.read<SearchBloc>().add(SearchTeachersEvent(val));
                },
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DropdownButton<String>(
                    value: batch,
                    items: [
                      'FA25', 'FA24', 'SP24', 'FA23', 'SP23', 'FA22', 'SP22', 'FA21', 'SP21', 'FA20'
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        batch = newValue!;
                      });
                    },
                  ),
                  SizedBox(
                    width: 80,
                    child: DropdownButton<String>(
                      value: program,
                      isExpanded: false,
                      items: [
                        'BBA', 'BBC', 'BCE', 'BCS', 'BEE', 'BEN', 'BMD', 'BME', 'BSE', 'BSM',
                        'BTY', 'CVE', 'FSN', 'PCS', 'PMI', 'PMS', 'PMT', 'RBS', 'RCS', 'REE', 'RMS', 'RMT'
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          program = newValue!;
                        });
                      },
                      menuMaxHeight: 200,
                    ),
                  ),
                  DropdownButton<String>(
                    value: section,
                    items: ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        section = newValue!;
                      });
                    },
                  ),
                ],
              ),
            const SizedBox(height: 16),
            // Display Search Results for Teacher
            if (isTeacher)
              Expanded(
                child: BlocBuilder<SearchBloc, SearchState>(
                  builder: (context, state) {
                    if (state is SearchLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is SearchLoaded) {
                      if (state.results.isEmpty) {
                        return const Center(child: Text("No teacher found"));
                      }
                      return ListView.builder(
                        itemCount: state.results.length,
                        itemBuilder: (_, index) {
                          final name = state.results[index];
                          return ListTile(
                            title: Text(name),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => TimetableScreen(
                                    isTeacher: true,
                                    teacherName: name,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    } else if (state is SearchError) {
                      return Center(child: Text(state.message));
                    }
                    return const SizedBox();
                  },
                ),
              ),
            // Student Button
            if (!isTeacher)
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TimetableScreen(
                        isTeacher: false,
                        batch: batch,
                        program: program,
                        sectionNumber: section,
                      ),
                    ),
                  );
                },
                child: const Text("View Timetable"),
              ),
          ],
        ),
      ),
    );
  }
}
