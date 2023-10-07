import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:medreminder/controllers/providers/notes_provider.dart';
import 'package:medreminder/controllers/services/notes_controller.dart';
import 'package:medreminder/views/Patient/home/notes/notes_edit.dart';
import 'package:medreminder/widgets/todolist_tile.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AllNotes extends StatefulWidget {
  const AllNotes({super.key});

  @override
  State<AllNotes> createState() => _AllNotesState();
}

class _AllNotesState extends State<AllNotes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 4.0,
              right: 4.0,
            ),
            child: Align(
              alignment: Alignment.topRight,
              child: Text(
                '<== Swipe left for more options',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 12.0,
            ),
            child: Consumer(
              builder: (context, ref, _) {
                final userResult = ref.watch(notesProvider);
                // ref.refresh(notesProvider);
                return userResult.when(
                    data: (notes) {
                      return notes.isEmpty
                          ? Center(
                              child: Text(
                                '-- You have no notes yet --',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: notes.length,
                              itemBuilder: (context, index) {
                                DateTime time =
                                    notes[index].timestamp!.toDate();
                                DateTime now = DateTime.now();
                                String formattedTime =
                                    DateFormat.jm().format(time);
                                String formattedDate =
                                    DateFormat.yMd().format(time);
                                return ToDoList(
                                  taskName: notes[index].title!,
                                  description: notes[index].description!,
                                  taskCompleted: notes[index].status!,
                                  time: (time.year == now.year &&
                                          time.month == now.month &&
                                          time.day == now.day)
                                      ? formattedTime
                                      : formattedDate,
                                  onChanged: (value) async {
                                    //change status of task to completed
                                    await Notes().changeStatus(
                                      context,
                                      notes[index].id!,
                                      notes[index].status! ? false : true,
                                    );
                                    ref.refresh(notesProvider);
                                    ref.refresh(pendingNotesProvider);
                                    ref.refresh(completedNotesProvider);
                                  },
                                  deleteFunction: (context) async {
                                    await Notes().deleteNote(
                                      context,
                                      notes[index].id!,
                                    );
                                    ref.refresh(notesProvider);
                                    ref.refresh(pendingNotesProvider);
                                    ref.refresh(completedNotesProvider);
                                  },
                                  editFunction: (context) {
                                    // Notes().updateNote(
                                    //   context,
                                    //   notes[index].id!,
                                    //   title.text,
                                    //   description.text,
                                    // );
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NotesEdit(
                                          id: notes[index].id!,
                                          title: notes[index].title!,
                                          description:
                                              notes[index].description!,
                                        ),
                                      ),
                                    );
                                    ref.refresh(notesProvider);
                                    ref.refresh(pendingNotesProvider);
                                    ref.refresh(completedNotesProvider);
                                  },
                                );
                              },
                            );
                    },
                    loading: () => const Text("..."),
                    error: (error, stackTrace) {
                      print('Error: $error');
                      return Text('Error: $error');
                    });
              },
            ),
          ),
        ],
      ),
    );
  }
}
