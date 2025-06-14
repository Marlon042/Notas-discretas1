import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prueba/app/app_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prueba/features/settings/bloc/theme_bloc.dart';
import 'package:prueba/core/widgets/splash_screen.dart';

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Configuración para habilitar el modo offline en Firestore
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
}

void main() {
  runApp(
    BlocProvider(
      create: (_) => ThemeBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FutureBuilder(
          future: initializeApp(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return const AppWidget();
            }
            return const SplashScreen();
          },
        ),
      ),
    ),
  );
}
