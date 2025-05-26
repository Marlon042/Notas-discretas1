import '../models/note_model.dart';
import 'package:equatable/equatable.dart';

abstract class NoteState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NoteInitial extends NoteState {}

class NoteLoading extends NoteState {}

class NoteLoaded extends NoteState {
  final List<Note> notes;
  NoteLoaded(this.notes);
  @override
  List<Object?> get props => [notes];
}

class NoteError extends NoteState {
  final String message;
  NoteError(this.message);
  @override
  List<Object?> get props => [message];
}
