import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prueba/core/widgets/category_icon.dart';
import 'package:prueba/core/widgets/current_date_time_widget.dart';
import 'package:prueba/core/widgets/note_detail_dialog.dart';
import 'package:prueba/features/auth/bloc/auth_bloc.dart';
import 'package:prueba/features/notes/bloc/note_bloc.dart';
import 'package:prueba/features/notes/bloc/note_event.dart';
import 'package:prueba/features/notes/bloc/note_state.dart';
import 'package:prueba/features/notes/screens/note_editor_screen.dart';
import 'package:prueba/features/profile/profile_screen.dart';
import 'package:prueba/features/settings/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const List<Map<String, dynamic>> kCategories = [
    {'label': 'General', 'icon': Icons.notes, 'color': Colors.blueGrey},
    {'label': 'Trabajo', 'icon': Icons.work, 'color': Colors.blue},
    {'label': 'Escuela', 'icon': Icons.school, 'color': Colors.red},
    {'label': 'Personal', 'icon': Icons.person, 'color': Colors.green},
    // Puedes agregar más categorías aquí
  ];

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'Todas';

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Center(child: Text('Usuario no autenticado'));
    }

    context.read<NoteBloc>().add(LoadNotes(user.uid));

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4A6FA5), Color(0xFF003366)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: const Text(
            'Notas Discretas',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              fontSize: 26,
              color: Colors.white,
              shadows: [
                Shadow(
                  blurRadius: 8,
                  color: Colors.black38,
                  offset: Offset(1, 2),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.transparent,
        ),
      ),
      drawer: SizedBox(width: 260, child: _CustomDrawer(user: user)),
      backgroundColor: const Color(0xFFF2F6FC),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4A6FA5), // Azul del gradiente
        child: const Icon(Icons.add, color: Colors.white, size: 32),
        tooltip: 'Nueva Nota',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (_) => NoteEditorScreen(
                    initialCategory:
                        selectedCategory == "Todas" ? null : selectedCategory,
                  ),
            ),
          );
        },
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 90.0, left: 8, right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // BARRA DE BUSQUEDA
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar notas...',
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
                // TODO: Implementar búsqueda si lo deseas
              ),
            ),
            const SizedBox(height: 12),
            // "CATEGORIAS"
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.0),
              child: Text(
                'Categorías',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // FILA DE ICONOS DE CATEGORIAS (ahora interactiva)
            SizedBox(
              height: 88, // Ajustado para evitar overflow
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  GestureDetector(
                    onTap: () => setState(() => selectedCategory = 'Todas'),
                    child: Column(
                      children: [
                        CategoryIcon(
                          icon: Icons.all_inclusive,
                          label: "Todas",
                          color: Colors.grey,
                        ),
                        if (selectedCategory == 'Todas')
                          Container(width: 48, height: 4, color: Colors.grey),
                      ],
                    ),
                  ),
                  ...HomeScreen.kCategories.map((cat) {
                    final isSelected = selectedCategory == cat['label'];
                    return GestureDetector(
                      onTap:
                          () => setState(() => selectedCategory = cat['label']),
                      child: Column(
                        children: [
                          CategoryIcon(
                            icon: cat['icon'],
                            label: cat['label'],
                            color: cat['color'],
                          ),
                          if (isSelected)
                            Container(
                              width: 48,
                              height: 4,
                              color: cat['color'],
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // NOTAS (usa tu BlocBuilder aquí)
            Expanded(
              child: BlocBuilder<NoteBloc, NoteState>(
                builder: (context, state) {
                  if (state is NoteLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is NoteLoaded) {
                    final notes = state.notes;
                    final filteredNotes =
                        selectedCategory == 'Todas'
                            ? notes
                            : notes
                                .where((n) => n.category == selectedCategory)
                                .toList();

                    if (filteredNotes.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.note_add,
                              size: 80,
                              color: Colors.blueGrey[200],
                            ),
                            const SizedBox(height: 18),
                            const Text(
                              'No tienes notas en esta categoría.',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '¡Empieza creando tu primera nota!',
                              style: TextStyle(color: Colors.blueGrey[400]),
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.only(bottom: 90, top: 10),
                      itemCount: filteredNotes.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 18),
                      itemBuilder: (context, index) {
                        final note = filteredNotes[index];
                        final date = note.createdAt;
                        final dateStr =
                            '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}';

                        final category = HomeScreen.kCategories.firstWhere(
                          (c) => c['label'] == note.category,
                          orElse: () => HomeScreen.kCategories[0],
                        );

                        return GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return NoteDetailDialog(
                                  note: note,
                                  dateStr: dateStr,
                                );
                              },
                            );
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(24),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 8,
                                      sigmaY: 8,
                                    ),
                                    child: Container(
                                      height: 120,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.82),
                                        borderRadius: BorderRadius.circular(24),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.blueGrey.withOpacity(
                                              0.12,
                                            ),
                                            blurRadius: 16,
                                            offset: const Offset(0, 6),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 120,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        radius: 28,
                                        backgroundColor: category['color']
                                            .withOpacity(0.13),
                                        child: Icon(
                                          category['icon'],
                                          color: category['color'],
                                          size: 30,
                                        ),
                                      ),
                                      const SizedBox(width: 18),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    note.title.isNotEmpty
                                                        ? note.title
                                                        : 'Sin título',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 19,
                                                      color: Colors.black87,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 7,
                                                        vertical: 1,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue[50],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.access_time,
                                                        size: 14,
                                                        color: Colors.blueGrey,
                                                      ),
                                                      const SizedBox(width: 3),
                                                      Text(
                                                        dateStr,
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          color:
                                                              Colors.blueGrey,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 7),
                                            Expanded(
                                              child: Text(
                                                note.content,
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                  if (state is NoteError) {
                    return Center(child: Text(state.message));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomDrawer extends StatelessWidget {
  final User user;
  const _CustomDrawer({required this.user});

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
            // Header con avatar, nombre y correo
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.transparent),
              currentAccountPicture: const CircleAvatar(
                radius: 28,
                backgroundImage: AssetImage(
                  'assets/images/default_avatar.jpeg',
                ),
                backgroundColor: Colors.white,
              ),
              accountEmail: Text(
                user.email ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              accountName: const Text(
                'Usuario',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            // Aquí la fecha y hora, fuera del header
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 18),
              child: CurrentDateTimeWidget(), // Widget de fecha y hora
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
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
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
