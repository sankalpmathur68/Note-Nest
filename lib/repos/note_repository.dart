import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../screens/home_screen.dart';

final _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final settings = _firestore.settings.copyWith(persistenceEnabled: false);

class NoteRepository {
  Future<List<Note>> getNotes() async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      final userId = currentUser.uid;

      final QuerySnapshot querySnapshot = await _firestore
          .collection('notes')
          .where('userId', isEqualTo: userId) // Filter notes by user ID
          .orderBy('timestamp', descending: true) // Order notes by timestamp
          .get();

      final List<Note> notes = querySnapshot.docs.map((doc) {
        return Note(
          id: doc.id,
          title: doc['title'],
          description: doc['description'],
          // You can extract the timestamp here if needed
        );
      }).toList();

      return notes;
    }

    return []; // Return an empty list if no user is logged in
  }

  Future<void> addNote(Note note) async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      final userId = currentUser.uid;
      final List<Note> list_note = await getNotes();
      final len = list_note.length;
      await _firestore.collection('notes').add({
        'userId': userId,
        'title': note.title,
        'description': note.description,
        'timestamp': FieldValue.serverTimestamp(), // Firestore server timestamp
      });

      // Save note to shared preferences
      // final List<String> existingNotes = _prefs.getStringList(userId) ?? [];
      // existingNotes.add(note.title);
      // _prefs.setStringList(userId, existingNotes);
    }
  }

  Future<void> updateNote(Note note) async {
    await _firestore.collection('notes').doc(note.id).update({
      'title': note.title,
      'description': note.description,
    });
  }

  Future<void> deleteNote(String noteId) async {
    await _firestore.collection('notes').doc(noteId).delete();
  }
}
