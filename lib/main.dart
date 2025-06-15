import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import necesario para Firestore
import 'package:prueba/app/app_widget.dart';
// Importación necesaria para el ThemeBloc
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prueba/features/settings/bloc/theme_bloc.dart';
import 'package:prueba/core/widgets/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Configuración para habilitar el modo offline en Firestore
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  runApp(
    BlocProvider(
      create: (_) => ThemeBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreenWrapper(),
      ),
    ),
  );
}

class SplashScreenWrapper extends StatefulWidget {
  const SplashScreenWrapper({super.key});

  @override
  State<SplashScreenWrapper> createState() => _SplashScreenWrapperState();
}

class _SplashScreenWrapperState extends State<SplashScreenWrapper> {
  @override
  void initState() {
    super.initState();
    // Navegar a AppWidget después de 2 segundos
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const AppWidget()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}
