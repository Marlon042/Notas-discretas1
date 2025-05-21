import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prueba/features/auth/bloc/auth_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user =
        context
            .read<AuthBloc>()
            .state
            .user; // Asume que guardas el User en el estado

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.pushNamed(context, '/edit-profile'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Avatar
            CircleAvatar(
              radius: 50,
              backgroundImage:
                  user?.photoURL != null
                      ? NetworkImage(user!.photoURL!)
                      : const AssetImage('assets/images/default_avatar.jpeg')
                          as ImageProvider,
              child:
                  user?.photoURL == null
                      ? const Icon(Icons.person, size: 0)
                      : null,
            ),
            const SizedBox(height: 16),

            // Nombre
            Text(
              user?.displayName ?? 'Discrete User',

              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),

            // Email
            Text(
              user?.email ?? 'No email',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),

            // Sección de ajustes
            _buildSettingsCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Seguridad'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.pushNamed(context, '/security'),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notificaciones'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.pushNamed(context, '/notifications'),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text(
              'Cerrar sesión',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              context.read<AuthBloc>().add(SignOutRequested());
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}
