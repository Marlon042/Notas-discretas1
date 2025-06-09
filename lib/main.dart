import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import necesario para Firestore
import 'package:prueba/app/app_widget.dart';
// Importación necesaria para el ThemeBloc
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prueba/features/settings/bloc/theme_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Configuración para habilitar el modo offline en Firestore
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  runApp(BlocProvider(create: (_) => ThemeBloc(), child: const AppWidget()));
}
