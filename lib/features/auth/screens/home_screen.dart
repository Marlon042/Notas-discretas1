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
          // Botón de búsqueda
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.pushNamed(context, '/search'),
            tooltip: 'Buscar notas',
          ),

          // Botón de perfil
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
            tooltip: 'Mi perfil',
          ),

          // Menú desplegable (con logout)
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            itemBuilder:
                (context) => [
                  const PopupMenuItem(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout, color: Colors.red),
                        SizedBox(width: 8),
                        Text(
                          'Cerrar sesión',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
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

      // Botón flotante para crear notas
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4A6FA5),
        onPressed: () => Navigator.pushNamed(context, '/edit-note'),
        tooltip: 'Crear nueva nota',
        child: const Icon(Icons.add, color: Colors.white),
      ),

      // Contenido principal
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
              child: const Text(
                'CREAR PRIMERA NOTA',
                style: TextStyle(color: Color(0xFF4A6FA5)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
