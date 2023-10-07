import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:medreminder/constants/colors/colors.dart';
import 'package:medreminder/controllers/providers/notes_provider.dart';
import 'package:medreminder/controllers/services/notes_controller.dart';
import 'package:medreminder/views/Patient/home/notes/notes_add.dart';
import 'package:medreminder/views/Patient/home/notes/notes_edit.dart';
import 'package:medreminder/widgets/todolist_tile.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

// ignore: must_be_immutable
class NotesList extends StatefulWidget {
  const NotesList({super.key});

  @override
  State<NotesList> createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  final title = TextEditingController();

  final description = TextEditingController();

  //form key
  final _formKey = GlobalKey<FormState>();

  bool load = true;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        load = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        centerTitle: true,
        backgroundColor: secondary,
      ),
      body: Stack(
        children: [
          Visibility(
            visible: !load,
            child: Padding(
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
          ),
          Visibility(
            visible: !load,
            child: Padding(
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
                                    },
                                    deleteFunction: (context) async {
                                      await Notes().deleteNote(
                                        context,
                                        notes[index].id!,
                                      );
                                      ref.refresh(notesProvider);
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
          ),
          Visibility(
            visible: load,
            child: const Center(
              child: CircularProgressIndicator(
                color: tertiary,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Visibility(
        visible: !load,
        child: FloatingActionButton.extended(
          backgroundColor: secondary,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotesAdd(),
              ),
            );
          },
          label: const Text('Add Note'),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _showAddNoteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Form(
          key: _formKey,
          child: AlertDialog(
            title: const Text('Add a Note'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                  controller: title,
                  onChanged: (value) {},
                  decoration:
                      const InputDecoration(hintText: 'Enter your title...'),
                ),
                TextFormField(
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  controller: description,
                  onChanged: (value) {},
                  decoration: const InputDecoration(
                      hintText: 'Enter your description...'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }
                  Notes().addNote(
                    context,
                    title.text,
                    description.text,
                  );
                  title.clear();
                  description.clear();
                  Navigator.pop(context);
                },
                child: const Text('Add'),
              ),
            ],
          ),
        );
      },
    );
  }
}
