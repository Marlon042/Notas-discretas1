import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prueba/features/auth/bloc/auth_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Listas de avatares (asegúrate de tener estas imágenes en assets/images/)
  final List<String> maleAvatars = [
    'assets/images/male_avatar1.png',
    'assets/images/male_avatar2.png',
    'assets/images/male_avatar3.png',
    'assets/images/male_avatar4.png',
    'assets/images/male_avatar5.png',
  ];
  final List<String> femaleAvatars = [
    'assets/images/female_avatar1.png',
    'assets/images/female_avatar2.png',
    'assets/images/female_avatar3.png',
    'assets/images/female_avatar4.png',
    'assets/images/female_avatar5.png',
  ];

  String? _selectedAvatar;
  String? _userName;
  bool _loadingAvatar = true;

  @override
  void initState() {
    super.initState();
    _loadAvatarFromFirestore();
  }

  Future<void> _loadAvatarFromFirestore() async {
    final user = context.read<AuthBloc>().state.user;
    if (user == null) {
      setState(() {
        _selectedAvatar = null;
        _loadingAvatar = false;
      });
      return;
    }
    final doc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
    setState(() {
      _selectedAvatar = doc.data()?['avatar'] as String?;
      _userName = doc.data()?['name'] as String?;
      _loadingAvatar = false;
    });
  }

  Future<void> _saveAvatarToFirestore(String avatarPath) async {
    final user = context.read<AuthBloc>().state.user;
    if (user == null) return;
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'avatar': avatarPath,
    }, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthBloc>().state.user;

    // Si el usuario ya tiene un avatar, úsalo; si no, usa el seleccionado localmente o el default
    ImageProvider avatarImage;
    if (user?.photoURL != null) {
      avatarImage = NetworkImage(user!.photoURL!);
    } else if (_selectedAvatar != null) {
      avatarImage = AssetImage(_selectedAvatar!);
    } else {
      avatarImage = const AssetImage('assets/images/default_avatar.jpeg');
    }

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
        child:
            _loadingAvatar
                ? const Center(child: CircularProgressIndicator())
                : Column(
                  children: [
                    // Avatar
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: avatarImage,
                          child:
                              user?.photoURL == null && _selectedAvatar == null
                                  ? const Icon(Icons.person, size: 0)
                                  : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 4,
                          child: InkWell(
                            onTap: () => _showAvatarPicker(context),
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.white,
                              child: const Icon(
                                Icons.camera_alt,
                                size: 20,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user?.displayName ?? 'Discrete User',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user?.email ?? 'No email',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 32),
                    _buildSettingsCard(context),
                  ],
                ),
      ),
    );
  }

  void _showAvatarPicker(BuildContext context) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 320,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Escoge tu avatar',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 5,
                  children: [
                    ...maleAvatars.map((path) => _avatarOption(path)),
                    ...femaleAvatars.map((path) => _avatarOption(path)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
    if (selected != null) {
      setState(() {
        _selectedAvatar = selected;
      });
      await _saveAvatarToFirestore(selected);
    }
  }

  Widget _avatarOption(String assetPath) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context, assetPath);
      },
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: CircleAvatar(backgroundImage: AssetImage(assetPath), radius: 30),
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
