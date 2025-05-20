// lib/features/notes/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prueba/features/auth/bloc/auth_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mis notas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.pushNamed(context, '/search'),
          ),
          PopupMenuButton(
            itemBuilder:
                (context) => [
                  const PopupMenuItem(
                    value: 'logout',
                    child: Text('Cerrar sesión'),
                  ),
                ],
            onSelected: (value) {
              if (value == 'logout') {
                context.read<AuthBloc>().add(SignOutRequested());
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4A6FA5),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => Navigator.pushNamed(context, '/edit-note'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.note_add, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            const Text(
              'No hay notas aún',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/edit-note'),
              child: const Text('CREAR PRIMERA NOTA'),
            ),
          ],
        ),
      ),
    );
  }
}
