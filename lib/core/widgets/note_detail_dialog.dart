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
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        note.title.isNotEmpty ? note.title : 'Sin título',
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(note.content, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  dateStr,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('CERRAR'),
        ),
        TextButton(
          onPressed: () {
            context.read<NoteBloc>().add(DeleteNote(note.id));
            Navigator.pop(context);
          },
          child: const Text('ELIMINAR', style: TextStyle(color: Colors.red)),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => NoteEditorScreen(note: note)),
            );
          },
          child: const Text('EDITAR'),
        ),
      ],
    );
  }
}
