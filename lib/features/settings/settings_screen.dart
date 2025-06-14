import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: ListView(
        children: [
          const ListTile(
            leading: Icon(Icons.palette),
            title: Text('Tema'),
            subtitle: Text('Claro/Oscuro'),
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
