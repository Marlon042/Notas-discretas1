import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prueba/core/widgets/avatar_notifier.dart';
import 'package:prueba/core/widgets/current_date_time_widget.dart';
import 'package:prueba/features/profile/profile_screen.dart';
import 'package:prueba/features/settings/settings_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prueba/features/auth/bloc/auth_bloc.dart';

class CustomDrawer extends StatelessWidget {
  final User user;
  final String? avatarPath;
  final String? userName;

  const CustomDrawer({
    required this.user,
    required this.avatarPath,
    required this.userName,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4A6FA5), Color(0xFF003366)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.transparent),
              currentAccountPicture: ValueListenableBuilder<String>(
                valueListenable: AvatarNotifier.avatarPath,
                builder: (context, avatarValue, _) {
                  final String path =
                      avatarValue.isNotEmpty
                          ? avatarValue
                          : (avatarPath ?? 'assets/images/default_avatar.jpeg');
                  return CircleAvatar(
                    radius: 28,
                    backgroundImage: AssetImage(path),
                    backgroundColor: Colors.white,
                  );
                },
              ),
              accountEmail: Text(
                user.email ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              accountName: StreamBuilder<DocumentSnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final name = snapshot.data?.get('name') ?? 'Usuario';
                    return Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    );
                  }
                  return Text(
                    userName ?? 'Usuario',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 18),
              child: CurrentDateTimeWidget(),
            ),
            _buildDrawerItem(
              context,
              icon: Icons.note,
              text: 'Notas',
              onTap: () => Navigator.pop(context),
            ),
            _buildDrawerItem(
              context,
              icon: Icons.person,
              text: 'Perfil',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.settings,
              text: 'Configuración',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
            ),
            const Divider(color: Colors.white60, indent: 16, endIndent: 16),
            _buildDrawerItem(
              context,
              icon: Icons.logout,
              text: 'Cerrar sesión',
              color: Colors.redAccent,
              onTap: () async {
                Navigator.pop(context);
                context.read<AuthBloc>().add(SignOutRequested());
                await Future.delayed(const Duration(milliseconds: 200));
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String text,
    Color? color,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.white),
      title: Text(
        text,
        style: TextStyle(
          color: color ?? Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: onTap,
      hoverColor: Colors.white24,
    );
  }
}
