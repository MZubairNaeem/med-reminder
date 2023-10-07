import 'package:flutter/material.dart';
import 'package:medreminder/constants/colors/colors.dart';
import 'package:medreminder/controllers/services/notes_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

// ignore: must_be_immutable
class NotesAdd extends StatefulWidget {
  const NotesAdd({super.key});

  @override
  State<NotesAdd> createState() => _NotesAddState();
}

class _NotesAddState extends State<NotesAdd> {
  final title = TextEditingController();

  final description = TextEditingController();

  //form key
  final _formKey = GlobalKey<FormState>();

  bool load = true;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 100), () {
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
        title: const Text('Add a Note'),
        centerTitle: true,
        backgroundColor: secondary,
      ),
      body: Stack(
        children: [
          Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.all(10.sp),
                child: Column(
                  children: [
                    TextFormField(
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
                    TextFormField(
                      controller: description,
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
              ))
        ],
      ),
    );
  }
}
