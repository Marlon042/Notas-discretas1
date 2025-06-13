import 'package:equatable/equatable.dart';

abstract class NoteEvent extends Equatable {
  const NoteEvent();

  @override
  List<Object?> get props => [];
}

class SearchNotes extends NoteEvent {
  final String title;
  final String userId;

  const SearchNotes(this.title, this.userId);

  @override
  List<Object?> get props => [title, userId];
}

class DeleteNote extends NoteEvent {
  final String noteId;

  const DeleteNote(this.noteId);

  @override
  List<Object?> get props => [noteId];
}

class DeselectNote extends NoteEvent {
  const DeselectNote();
}

class LoadNotes extends NoteEvent {
  final String userId;

  const LoadNotes(this.userId);

  @override
  List<Object?> get props => [userId];
}

class AddNote extends NoteEvent {
  final dynamic note;
  final String userId;

  const AddNote(this.note, this.userId);

  @override
  List<Object?> get props => [note, userId];
}

class UpdateNote extends NoteEvent {
  final dynamic note;

  const UpdateNote(this.note);

  @override
  List<Object?> get props => [note];
}
