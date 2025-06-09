// Importación necesaria para usar ThemeBloc
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prueba/features/settings/bloc/theme_bloc.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('Tema'),
            subtitle: const Text('Claro/Oscuro'),
            onTap: () {
              // Implementación del cambio de tema
              final themeBloc = BlocProvider.of<ThemeBloc>(context);
              themeBloc.add(ToggleThemeEvent());
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Idioma'),
            subtitle: const Text('Español'),
            onTap: () {
              // Aquí puedes implementar el cambio de idioma
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Acerca de'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Notas Discretas',
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2024 Notas Discretas',
              );
            },
          ),
        ],
      ),
    );
  }
}
