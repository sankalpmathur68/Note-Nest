import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scicalci/blocs/note_bloc.dart';

import '../blocs/auth_bloc.dart';
import 'home_screen.dart';

class AddNoteScreen extends StatefulWidget {
  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void _saveNote() {
    final title = _titleController.text;
    final description = _descriptionController.text;
    final note = Note(title: title, description: description);

    context.read<NoteCubit>().addNote(note);

    // Navigator.pop(context); // Navigate back to Notes Screen
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Notes',
          style: GoogleFonts.lato(color: Colors.black, fontSize: 30),
        ),
        actions: [
          IconButton(
              onPressed: () {
                BlocProvider.of<AuthCubit>(context).signout();
              },
              icon: Icon(Icons.logout, color: Colors.black))
        ],
        backgroundColor: Colors.blue.shade100,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                    controller: _titleController,
                    textCapitalization: TextCapitalization.sentences,
                    style: GoogleFonts.lato(
                        fontSize: 30, fontWeight: FontWeight.w400),
                    decoration: InputDecoration(
                      hintStyle: GoogleFonts.lato(
                          fontSize: 30, fontWeight: FontWeight.w400),
                      hintText: "Title...",
                      // labelText: 'Title..',
                      border: InputBorder.none,
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                  maxLines: (height / 25).toInt(),
                  controller: _descriptionController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                      alignLabelWithHint: true,
                      floatingLabelAlignment: FloatingLabelAlignment.center,
                      labelStyle: GoogleFonts.lato(fontSize: 20),
                      // border: InputBorder.none,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      labelText: 'Description...')),
              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    // border: Border.all(),
                    borderRadius: BorderRadius.circular(90)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextButton(
                      onPressed: () {
                        if (_titleController.text != '' &&
                            _descriptionController.text != '') {
                          _saveNote();
                        }
                      },
                      style: ButtonStyle(),
                      child: Text(
                        "Add Note",
                        style:
                            GoogleFonts.lato(color: Colors.black, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    // border: Border.all(),
                    borderRadius: BorderRadius.circular(90)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextButton(
                      onPressed: () {
                        BlocProvider.of<NoteCubit>(context).getNotes();
                      },
                      style: ButtonStyle(),
                      child: Text(
                        "Cancle",
                        style:
                            GoogleFonts.lato(color: Colors.black, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
