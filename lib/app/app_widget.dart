import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prueba/features/auth/bloc/auth_bloc.dart';
import 'package:prueba/features/auth/repositories/auth_repository.dart';
import 'package:prueba/features/auth/screens/auth_screen.dart';
import 'package:prueba/features/auth/screens/home_screen.dart';
import 'package:prueba/features/auth/screens/register_screen.dart';

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
          },
        ),
      ),
    );
  }
}
