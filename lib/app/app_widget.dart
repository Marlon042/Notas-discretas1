import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prueba/features/auth/bloc/auth_bloc.dart';
import 'package:prueba/features/auth/repositories/auth_repository.dart';
import 'package:prueba/features/auth/screens/auth_screen.dart';
import 'package:prueba/features/auth/screens/register_screen.dart';
import 'package:prueba/features/notes/screens/home_screen.dart';
import 'package:prueba/features/notes/screens/note_editor_screen.dart';
import 'package:prueba/features/profile/profile_screen.dart';
import 'package:prueba/features/settings/settings_screen.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthRepository(),
      child: BlocProvider(
        create:
            (context) => AuthBloc(
              authRepository: RepositoryProvider.of<AuthRepository>(context),
            ),
        child: MaterialApp(
          title: 'Notas Discretas',
          theme: ThemeData(primarySwatch: Colors.blue),
          initialRoute: '/',
          routes: {
            '/': (context) => const AuthScreen(),
            '/home': (context) => const HomeScreen(),
            '/login': (context) => const AuthScreen(),
            '/register': (context) => const RegisterScreen(),
            '/edit-note': (context) => const NoteEditorScreen(),
            '/profile': (context) => const ProfileScreen(),
            '/settings': (context) => const SettingsScreen(),
          },
        ),
      ),
    );
  }
}
