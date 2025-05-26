import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note_model.dart';

class NoteRepository {
  final notesRef = FirebaseFirestore.instance.collection('notes');

  Future<void> addNote(Note note, String userId) async {
    await notesRef.add({
      ...note.toMap(),
      'userId': userId,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateNote(Note note) async {
    await notesRef.doc(note.id).update(note.toMap());
  }

  Future<void> deleteNote(String noteId) async {
    await notesRef.doc(noteId).delete();
  }

  Stream<List<Note>> getNotes(String userId) {
    return notesRef
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => Note.fromFirestore(doc.data(), doc.id))
                  .toList(),
        );
  }
}
