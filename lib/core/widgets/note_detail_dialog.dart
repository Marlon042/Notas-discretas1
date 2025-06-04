import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prueba/features/notes/bloc/note_bloc.dart';
import 'package:prueba/features/notes/bloc/note_event.dart';
import 'package:prueba/features/notes/screens/note_editor_screen.dart';

class NoteDetailDialog extends StatelessWidget {
  final dynamic note;
  final String dateStr;

  const NoteDetailDialog({
    super.key,
    required this.note,
    required this.dateStr,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.yellow[100],
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  note.title.isNotEmpty ? note.title : 'Sin título',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.brown,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Confirmar eliminación'),
                          content: const Text(
                            '¿Estás seguro de que deseas eliminar esta nota?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('No'),
                            ),
                            TextButton(
                              onPressed: () {
                                context.read<NoteBloc>().add(
                                  DeleteNote(note.id),
                                );
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Sí',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              note.content,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.brown),
                const SizedBox(width: 6),
                Text(
                  dateStr,
                  style: const TextStyle(fontSize: 14, color: Colors.brown),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cerrar'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NoteEditorScreen(note: note),
                      ),
                    ).then((_) {
                      context.read<NoteBloc>().add(DeselectNote());
                    });
                  },
                  child: const Text('Editar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
