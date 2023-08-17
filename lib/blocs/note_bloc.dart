// lib/blocs/note_bloc.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scicalci/blocs/auth_bloc.dart';
import 'package:scicalci/screens/update_note.dart';

import '../repos/note_repository.dart';
import '../screens/home_screen.dart';

class NoteCubit extends Cubit<NoteState> {
  final NoteRepository noteRepository;

  NoteCubit({required this.noteRepository}) : super(NoteInitial()) {
    getNotes();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  getNotes() async {
    emit(NoteLoading());
    final list_notes = await noteRepository.getNotes();

    emit(NoteLoadSuccess(list_notes));
  }

  void addnoteState() {
    emit(NoteAddState());
  }

  void updateNoteState(Note note) {
    emit(NoteUpdateState(note));
  }

  Future<void> addNote(Note note) async {
    emit(NoteLoading());
    await noteRepository.addNote(note);
    emit(NoteLoadSuccess(await noteRepository.getNotes()));
  }

  Future<void> deleteNote(String noteId) async {
    await noteRepository.deleteNote(noteId);
    getNotes(); //Fetch updated notes after deletion
  }

  Future<void> UpdateNotes(Note note) async {
    await noteRepository.updateNote(note);
    getNotes(); //Fetch updated notes after deletion
  }
}

// lib/blocs/note_state.dart

abstract class NoteState {}

class NoteInitial extends NoteState {}

class NoteLoadSuccess extends NoteState {
  final List<Note> notes;

  NoteLoadSuccess(this.notes);
}

class NoteLoadFailure extends NoteState {
  final String error;

  NoteLoadFailure(this.error);
}

class NoteAddState extends NoteState {}

class NoteUpdateState extends NoteState {
  Note note;

  NoteUpdateState(this.note);
}

class NoteLoading extends NoteState {}
