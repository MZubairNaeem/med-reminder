import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medreminder/controllers/providers/notes_provider.dart';
import 'package:medreminder/controllers/services/notes_controller.dart';
import 'package:medreminder/views/Patient/home/notes/notes_edit.dart';
import 'package:medreminder/widgets/todolist_tile.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CompletedNotes extends StatefulWidget {
  const CompletedNotes({super.key});

  @override
  State<CompletedNotes> createState() => _CompletedNotesState();
}

class _CompletedNotesState extends State<CompletedNotes> {
  bool select = false;
  bool checkList = false;
  List<String> selectedNotes = [];
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
                final userResult = ref.watch(completedNotesProvider);
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
                                return GestureDetector(
                                  onLongPress: () {
                                    setState(() {
                                      select = true;
                                    });
                                  },
                                  child: ToDoList(
                                    taskName: notes[index].title!,
                                    description: notes[index].description!,
                                    taskCompleted: notes[index].status!,
                                    time: (time.year == now.year &&
                                            time.month == now.month &&
                                            time.day == now.day)
                                        ? formattedTime
                                        : formattedDate,
                                    select: select,
                                    onSelect: (c) async {
                                      if (c!) {
                                        selectedNotes.add(notes[index].id!);
                                      } else {
                                        selectedNotes.removeWhere((element) =>
                                            element == notes[index].id!);
                                      }
                                      //empty the list
                                      setState(() {});
                                    },
                                    checkList: //checkList,
                                        selectedNotes.contains(notes[index].id!)
                                            ? true
                                            : false,
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
                                  ),
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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
            visible: select,
            child: Align(
              alignment: Alignment.centerRight,
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    select = false;
                  });
                },
                child: const Icon(
                    Icons.clear), // You can change the icon as needed
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Visibility(
            visible: select,
            child: Align(
              alignment: Alignment.centerRight,
              child: FloatingActionButton(
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromARGB(255, 221, 42, 30),
                onPressed: () {
                  if (selectedNotes.isEmpty) {
                    Get.snackbar(
                      'Error',
                      'No note selected',
                      snackPosition: SnackPosition.BOTTOM,
                      colorText: Colors.white,
                      backgroundColor: Colors.orange,
                    );
                    return;
                  }
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          'Delete ${selectedNotes.length} notes?',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: Text(
                          'Are you sure you want to delete these notes?',
                          style: TextStyle(
                            fontSize: 14.sp,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Consumer(
                            builder: (context, ref, _) {
                              final userResult = ref.watch(notesProvider);
                              // ref.refresh(notesProvider);
                              return userResult.when(
                                  data: (notes) {
                                    return TextButton(
                                      onPressed: () async {
                                        await Notes().deleteMultipleNotes(
                                          context,
                                          selectedNotes,
                                        );
                                        setState(() {
                                          select = false;
                                        });
                                        ref.refresh(notesProvider);
                                        ref.refresh(pendingNotesProvider);
                                        ref.refresh(completedNotesProvider);
                                        selectedNotes.clear();
                                        // ignore: use_build_context_synchronously
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'Delete',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    );
                                  },
                                  loading: () => const Text("..."),
                                  error: (error, stackTrace) {
                                    print('Error: $error');
                                    return Text('Error: $error');
                                  });
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Icon(
                  Icons.delete_rounded,
                ), // You can change the icon as needed
              ),
            ),
          ),
        ],
      ),
    );
  }
}
