import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prueba/features/notes/bloc/note_bloc.dart';
import 'package:prueba/features/notes/bloc/note_event.dart';
import 'package:prueba/features/auth/bloc/auth_bloc.dart';

class NoteSearchBar extends StatelessWidget {
  const NoteSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Buscar notas...',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (value) {
          final userId = context.read<AuthBloc>().state.user?.uid ?? '';
          context.read<NoteBloc>().add(SearchNotes(value, userId));
        },
      ),
    );
  }
}
