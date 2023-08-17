import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scicalci/blocs/auth_bloc.dart';
import 'package:scicalci/blocs/note_bloc.dart';
import 'package:scicalci/screens/loadingScreen.dart';

class NotesHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notes',
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
      body: BlocBuilder<NoteCubit, NoteState>(
        builder: (context, state) {
          if (state is NoteLoadSuccess) {
            return NotesList(state.notes);
          } else if (state is NoteLoadFailure) {
            return LoadingScreen();
          } else {
            return LoadingScreen();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade100,
        onPressed: () {
          BlocProvider.of<NoteCubit>(context).addnoteState();
          // context.go("/addNotePage");
        },
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }
}

class CustomNoteContainer extends StatelessWidget {
  final String title;
  final String id;
  final String description;
  final Function onDelete;

  CustomNoteContainer({
    required this.title,
    required this.id,
    required this.description,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;
    final currentwidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.all(20.0),
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: 4,
              blurRadius: 10,
              offset: Offset(6, 6),
            ),
          ],
          // border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Stack(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Positioned(
              top: 20,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: SizedBox(
                  width: currentwidth / 3,
                  child: Text(
                    description,
                    overflow: TextOverflow.fade,
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Text(
                                "Do You Want To Delete This Note With Title \n'${title}'",
                                style: GoogleFonts.lato(
                                    color: Colors.red.shade700),
                              ),
                              actions: [
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.blue.shade100),
                                    onPressed: () {
                                      onDelete();
                                      Navigator.pop(context);
                                    },
                                    child: Icon(Icons.delete,
                                        color: Colors.red.shade500)),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.blue.shade100),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "No",
                                      style: GoogleFonts.lato(
                                          color: Colors.green.shade700),
                                    ))
                              ],
                            );
                          });
                    },
                    child: CircleAvatar(
                        backgroundColor: Colors.blue.shade100,
                        child: Icon(Icons.delete, color: Colors.red.shade500)),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      BlocProvider.of<NoteCubit>(context).updateNoteState(
                          Note(title: title, description: description, id: id));
                    },
                    child: CircleAvatar(
                        backgroundColor: Colors.blue.shade100,
                        child: Icon(Icons.edit, color: Colors.white)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotesList extends StatelessWidget {
  List notes;
  NotesList(this.notes);
  @override
  Widget build(BuildContext context) {
    // Replace this with your actual list of notes

    List<Note> notes_list = [];
    notes_list = [...notes];
    return notes_list.length > 0
        ? GridView.builder(
            itemCount: notes.length,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (context, index) {
              return CustomNoteContainer(
                id: notes[index].id,
                title: notes[index].title,
                description: notes[index].description,
                onDelete: () {
                  BlocProvider.of<NoteCubit>(context)
                      .deleteNote(notes[index].id);
                },
              );
            })
        : Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(
                CupertinoIcons.textbox,
                size: 30,
              ),
              Text(
                "Add Your First Note Using The Button At The Bottom",
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(fontSize: 20),
              )
            ]),
          );
  }
}

class Note {
  final String title;
  final String description;
  final id;
  Note({required this.title, required this.description, this.id});
}
