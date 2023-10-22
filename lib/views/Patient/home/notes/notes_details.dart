import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medreminder/constants/colors/colors.dart';
import 'package:medreminder/controllers/providers/notes_provider.dart';
import 'package:medreminder/controllers/services/notes_controller.dart';
import 'package:medreminder/models/notes_model.dart';
import 'package:medreminder/views/Patient/home/notes/notes_edit.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class NotesDetails extends StatefulWidget {
  String? time;
  NotesModel notesModel;
  NotesDetails({
    super.key,
    this.time,
    required this.notesModel,
  });

  @override
  State<NotesDetails> createState() => _NotesDetailsState();
}

class _NotesDetailsState extends State<NotesDetails> {
  bool? val = false;
  @override
  void initState() {
    val = widget.notesModel.status;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          title: const Text('Notes'),
          centerTitle: true,
          backgroundColor: secondary,
          actions: [],
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.notesModel.title!,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Consumer(
                        builder: (context, ref, _) {
                          final userResult = ref.watch(notesProvider);
                          // ref.refresh(notesProvider);
                          return userResult.when(
                              data: (notes) {
                                return Checkbox(
                                  value: val,
                                  onChanged: (value) async {
                                    val = value!;
                                    Notes().changeStatus(
                                      context,
                                      widget.notesModel.id!,
                                      widget.notesModel.status! ? false : true,
                                    );
                                    ref.refresh(notesProvider);
                                    ref.refresh(pendingNotesProvider);
                                    ref.refresh(completedNotesProvider);
                                  },
                                  activeColor: secondary,
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
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.notesModel.description!,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => NotesEdit(
                          id: widget.notesModel.id!,
                          title: widget.notesModel.title!,
                          description: widget.notesModel.description!,
                        )));
            // Navigator.pop(context);
          },
          backgroundColor: secondary,
          child: const Icon(Icons.edit),
        ));
  }
}
