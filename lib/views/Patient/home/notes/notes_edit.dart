import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medreminder/constants/colors/colors.dart';
import 'package:medreminder/controllers/providers/notes_provider.dart';
import 'package:medreminder/controllers/services/notes_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

// ignore: must_be_immutable
class NotesEdit extends StatefulWidget {
  String id;
  String? title;
  String? description;
  NotesEdit({super.key, required this.id, this.title, this.description});

  @override
  State<NotesEdit> createState() => _NotesEditState();
}

class _NotesEditState extends State<NotesEdit> {
  dynamic refresh;
  final title = TextEditingController();

  final description = TextEditingController();

  //form key
  final _formKey = GlobalKey<FormState>();

  bool load = true;

  @override
  void initState() {
    //assign value to controllers
    title.text = widget.title!;
    description.text = widget.description!;
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        load = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //to remove keyboard when user clicks outside the textfield
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Update this Note', style: TextStyle(color: white)),
          centerTitle: true,
          backgroundColor: secondary,
        ),
        body: Stack(
          children: [
            Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.all(15.sp),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          TextFormField(
                            // initialValue: widget.title,
                            controller: title,
                            maxLength: 20,
                            decoration: const InputDecoration(
                              hintText: "Note Title",
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a title';
                              } else if (value.length > 20) {
                                return 'Title must be less than 20 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: description,
                            // initialValue: widget.description,
                            maxLines: 10,
                            decoration: const InputDecoration(
                              hintText: "Note Description",
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a description';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 90.w,
                        child: ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              load = true;
                            });
                            if (!_formKey.currentState!.validate()) {
                              setState(() {
                                load = false;
                              });
                              return;
                            }
                            await Notes().updateNote(
                              context,
                              widget.id,
                              title.text.trim(),
                              description.text.trim(),
                            );
                            setState(() {
                              load = false;
                            });
                            title.clear();
                            description.clear();
                            refresh;
                            Navigator.pop(context);
                          },
                          child: load
                              ? Consumer(
                                  builder: (context, ref, _) {
                                    final userResult = ref.watch(notesProvider);
                                    refresh = ref.refresh(notesProvider);
                                    return userResult.when(
                                      data: (notes) {
                                        return const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        );
                                      },
                                      loading: () => const Text("..."),
                                      error: (error, stackTrace) =>
                                          Text('Error: $error'),
                                    );
                                  },
                                )
                              : const Text('Update'),
                        ),
                      )
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
