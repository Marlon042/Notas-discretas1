import '../models/note_model.dart';
import 'package:equatable/equatable.dart';

abstract class NoteEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadNotes extends NoteEvent {
  final String userId;
  LoadNotes(this.userId);
  @override
  List<Object?> get props => [userId];
}

class AddNote extends NoteEvent {
  final Note note;
  final String userId;
  AddNote(this.note, this.userId);
  @override
  List<Object?> get props => [note, userId];
}

class UpdateNote extends NoteEvent {
  final Note note;
  UpdateNote(this.note);
  @override
  List<Object?> get props => [note];
}

class DeleteNote extends NoteEvent {
  final String noteId;
  DeleteNote(this.noteId);
  @override
  List<Object?> get props => [noteId];
}
