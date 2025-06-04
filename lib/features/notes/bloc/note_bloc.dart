import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/note_repository.dart';
import 'note_event.dart';
import 'note_state.dart';
import '../models/note_model.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final NoteRepository noteRepository;

  NoteBloc(this.noteRepository) : super(NoteInitial()) {
    on<LoadNotes>((event, emit) async {
      emit(NoteLoading());
      try {
        await emit.forEach<List<Note>>(
          noteRepository.getNotes(event.userId),
          onData: (notes) => NoteLoaded(notes),
        );
      } catch (e) {
        emit(NoteError('Error al cargar notas'));
      }
    });

    on<AddNote>((event, emit) async {
      try {
        await noteRepository.addNote(event.note, event.userId);
      } catch (e) {
        emit(NoteError('Error al agregar nota'));
      }
    });

    on<UpdateNote>((event, emit) async {
      try {
        await noteRepository.updateNote(event.note);
        // Recargar las notas después de actualizar
        if (event.note is Note && event.note.userId != null) {
          add(LoadNotes(event.note.userId));
        }
        emit(NoteDeselected());
      } catch (e) {
        emit(NoteError('Error al actualizar nota'));
      }
    });

    on<DeleteNote>((event, emit) async {
      try {
        await noteRepository.deleteNote(event.noteId);
      } catch (e) {
        emit(NoteError('Error al eliminar nota'));
      }
    });
    on<DeselectNote>((event, emit) {
      emit(NoteDeselected());
    });
  }
}
