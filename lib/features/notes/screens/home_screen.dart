import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prueba/features/notes/widgets/note_search_bar.dart';
import 'package:prueba/features/notes/widgets/category_selector.dart';
import 'package:prueba/core/widgets/note_detail_dialog.dart';
import 'package:prueba/core/widgets/custom_drawer.dart';
import 'package:prueba/features/notes/bloc/note_bloc.dart';
import 'package:prueba/features/notes/bloc/note_event.dart';
import 'package:prueba/features/notes/bloc/note_state.dart';
import 'package:prueba/features/notes/screens/note_editor_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const List<Map<String, dynamic>> kCategories = [
    {'label': 'General', 'icon': Icons.notes, 'color': Colors.blueGrey},
    {'label': 'Trabajo', 'icon': Icons.work, 'color': Colors.blue},
    {'label': 'Escuela', 'icon': Icons.school, 'color': Colors.red},
    {'label': 'Personal', 'icon': Icons.person, 'color': Colors.green},
  ];

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'Todas';

  String? _avatarPath;
  String? _userName;
  bool _loadingUser = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        _loadingUser = false;
      });
      return;
    }
    final doc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
    setState(() {
      _avatarPath = doc.data()?['avatar'] as String?;
      _userName = doc.data()?['name'] as String?;
      _loadingUser = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Center(child: Text('Usuario no autenticado'));
    }

    if (_loadingUser) {
      return const Center(child: CircularProgressIndicator());
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
      drawer: SizedBox(
        width: 260,
        child: CustomDrawer(
          user: user,
          avatarPath: _avatarPath,
          userName: _userName,
        ),
      ),
      backgroundColor: const Color(0xFFF2F6FC),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(
          0xFF4A6FA5,
        ).withAlpha((0.85 * 255).toInt()),
        icon: const Icon(Icons.add, color: Colors.white, size: 32),
        label: const Text(
          'Nueva Nota',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        tooltip: 'Nueva Nota',
        onPressed: () {
          final user = FirebaseAuth.instance.currentUser;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (_) => NoteEditorScreen(
                    initialCategory:
                        selectedCategory == "Todas" ? null : selectedCategory,
                  ),
            ),
          ).then((_) {
            if (user != null && mounted) {
              setState(() {
                context.read<NoteBloc>().add(LoadNotes(user.uid));
              });
            }
          });
        },
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 90.0, left: 8, right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const NoteSearchBar(),
            const SizedBox(height: 12),
            CategorySelector(
              selectedCategory: selectedCategory,
              onCategorySelected: (category) {
                setState(() {
                  selectedCategory = category;
                });
              },
            ),
            const SizedBox(height: 8),
            Expanded(
              child: BlocBuilder<NoteBloc, NoteState>(
                builder: (context, state) {
                  if (state is NoteDeselected) {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  }
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
