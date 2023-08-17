import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scicalci/blocs/auth_bloc.dart';
import 'package:scicalci/screens/home_screen.dart';

import '../blocs/note_bloc.dart';

class UpdateNotes extends StatelessWidget {
  final Note note;

  final TextEditingController _descriptionController = TextEditingController();
  UpdateNotes(this.note) {
    _descriptionController.text = note.description;
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _titleController = TextEditingController();

    final height = MediaQuery.of(context).size.height;
    void _saveNote(id, title) {
      final description = _descriptionController.text;
      final note = Note(id: id, title: title, description: description);

      BlocProvider.of<NoteCubit>(context).UpdateNotes(note);

      // Navigator.pop(context); // Navigate back to Notes Screen
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${note.title}',
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
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
                    _saveNote(note.id, note.title);
                  },
                  style: ButtonStyle(),
                  child: Text(
                    "Update Note",
                    style: GoogleFonts.lato(color: Colors.black, fontSize: 20),
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
                    style: GoogleFonts.lato(color: Colors.black, fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                    readOnly: true,
                    controller: _titleController,
                    style: GoogleFonts.lato(
                        fontSize: 30, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      hintStyle: GoogleFonts.lato(
                          fontSize: 30, fontWeight: FontWeight.bold),
                      hintText: "${note.title}",
                      // labelText: 'Title..',
                      border: InputBorder.none,

                      // border: OutlineInputBorder(
                      //     borderRadius: BorderRadius.circular(90)),
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                  maxLines: (height / 25).toInt(),
                  controller: _descriptionController,
                  onChanged: (value) {
                    // _descriptionController.text = note.description + value;
                  },
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    floatingLabelAlignment: FloatingLabelAlignment.center,
                    labelStyle: GoogleFonts.lato(fontSize: 20),
                    // border: InputBorder.none,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
