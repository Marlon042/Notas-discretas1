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
      print('Estado NoteLoading emitido');
      try {
        await emit.forEach<List<Note>>(
          noteRepository.getNotes(event.userId),
          onData: (notes) {
            print('Notas cargadas: $notes');
            return NoteLoaded(notes);
          },
        );
      } catch (e) {
        print('Error al cargar notas: $e');
        emit(NoteError('Error al cargar notas'));
      }
    });

    on<SearchNotes>((event, emit) async {
      emit(NoteLoading());
      try {
        final filteredNotes = await noteRepository.searchNotesByTitle(
          event.title,
        );
        emit(NoteLoaded(filteredNotes));
      } catch (e) {
        emit(NoteError('Error al buscar notas'));
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
        print('Evento UpdateNote recibido: ${event.note}');
        await noteRepository.updateNote(event.note);
        print('Nota actualizada correctamente: ${event.note}');
        // Recargar las notas después de actualizar
        if (event.note is Note && event.note.userId != null) {
          print(
            'Disparando evento LoadNotes para userId: ${event.note.userId}',
          );
          add(LoadNotes(event.note.userId));
        }
        emit(
          NoteLoaded(await noteRepository.getNotes(event.note.userId!).first),
        );
        print('Estado NoteLoaded emitido después de actualizar');
      } catch (e) {
        if (event.note.id.isNotEmpty) {
          emit(NoteError('Error al actualizar nota: $e'));
        } else {
          print('Error ignorado porque la nota no fue guardada.');
        }
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
