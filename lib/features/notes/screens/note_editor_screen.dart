import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prueba/features/notes/bloc/note_bloc.dart';
import 'package:prueba/features/notes/bloc/note_event.dart';
import 'package:prueba/features/notes/models/note_model.dart';
import 'package:prueba/core/widgets/category_icon.dart';

class NoteEditorScreen extends StatefulWidget {
  final Note? note;
  final String? initialCategory; // NUEVO

  static const List<Map<String, dynamic>> kCategories = [
    {'label': 'General', 'icon': Icons.notes, 'color': Colors.blueGrey},
    {'label': 'Trabajo', 'icon': Icons.work, 'color': Colors.blue},
    {'label': 'Escuela', 'icon': Icons.school, 'color': Colors.red},
    {'label': 'Personal', 'icon': Icons.person, 'color': Colors.green},
    // Agrega más si lo deseas
  ];

  const NoteEditorScreen({super.key, this.note, this.initialCategory});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  bool _saving = false;
  late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(
      text: widget.note?.content ?? '',
    );
    if (widget.note != null) {
      _selectedCategory = widget.note!.category;
    } else if (widget.initialCategory != null) {
      _selectedCategory = widget.initialCategory!;
    } else {
      _selectedCategory = NoteEditorScreen.kCategories[0]['label'] as String;
    }
  }

  Future<void> _saveNote() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty && content.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('La nota está vacía')));
      return;
    }

    setState(() => _saving = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('Usuario no autenticado');
      debugPrint('Usuario autenticado: ${user.uid}');

      // Eliminado manejo de conectividad y logs relacionados

      if (widget.note == null) {
        final note = Note(
          id: '',
          title: title,
          content: content,
          category: _selectedCategory,
          userId: user.uid, // Agregado userId
          createdAt: DateTime.now(),
        );
        debugPrint('Creando nueva nota: $note');
        context.read<NoteBloc>().add(AddNote(note, user.uid));
      } else {
        final updatedNote = Note(
          id: widget.note!.id,
          title: title,
          content: content,
          category: _selectedCategory,
          userId: widget.note!.userId, // Agregado userId
          createdAt: widget.note!.createdAt,
        );
        debugPrint('Actualizando nota existente: $updatedNote');
        context.read<NoteBloc>().add(UpdateNote(updatedNote));
        context.read<NoteBloc>().add(DeselectNote());
      }

      // Eliminado manejo de Snackbars para sincronización

      Navigator.pop(context, true);
    } catch (e) {
      debugPrint('Error al guardar nota: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al guardar: $e')));
    } finally {
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.note != null;
    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        // Al regresar, recargar notas en el HomeScreen
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          context.read<NoteBloc>().add(LoadNotes(user.uid));
        }
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset:
            true, // Permitir que el diseño se ajuste al teclado
        backgroundColor: Colors.blueGrey[50],
        appBar: AppBar(
          backgroundColor: Colors.blue[700],
          elevation: 0,
          title: Text(
            isEditing ? 'Editar Nota' : 'Nueva Nota',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.blue[700],
          onPressed: _saving ? null : _saveNote,
          icon:
              _saving
                  ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                  : const Icon(Icons.save),
          label: Text(
            isEditing ? 'Guardar Cambios' : 'Guardar',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            physics:
                const BouncingScrollPhysics(), // Agregar desplazamiento suave
            padding: const EdgeInsets.all(24),
            child: Card(
              elevation: 9,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 32,
                  horizontal: 20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        hintText: 'Título de la nota',
                        border: InputBorder.none,
                        hintStyle: theme.textTheme.headlineSmall!.copyWith(
                          color: Colors.blueGrey[200],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: theme.textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      maxLength: 40,
                    ),
                    const SizedBox(height: 18),
                    Divider(
                      height: 1,
                      color: Colors.blueGrey[100],
                      thickness: 1.5,
                    ),
                    const SizedBox(height: 18),
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        minHeight: 180,
                        maxHeight: 400,
                      ),
                      child: TextField(
                        controller: _contentController,
                        decoration: InputDecoration(
                          hintText: 'Escribe el contenido aquí...',
                          border: InputBorder.none,
                          hintStyle: theme.textTheme.titleMedium!.copyWith(
                            color: Colors.blueGrey[200],
                          ),
                        ),
                        style: theme.textTheme.titleMedium,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        minLines: 8,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Categoría',
                        style: theme.textTheme.titleMedium!.copyWith(
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      height: 88, // Ajustado para evitar overflow
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children:
                            NoteEditorScreen.kCategories.map((cat) {
                              final isSelected =
                                  _selectedCategory == cat['label'];
                              return GestureDetector(
                                onTap:
                                    () => setState(
                                      () =>
                                          _selectedCategory =
                                              cat['label'] as String,
                                    ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4.0,
                                    vertical: 2.0,
                                  ),
                                  child: Column(
                                    children: [
                                      CategoryIcon(
                                        icon: cat['icon'],
                                        label: cat['label'],
                                        color: cat['color'],
                                      ),
                                      if (isSelected)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 2.0,
                                          ),
                                          child: Container(
                                            width: 48,
                                            height: 4,
                                            decoration: BoxDecoration(
                                              color: cat['color'],
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                    if (_saving)
                      const Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: LinearProgressIndicator(minHeight: 3),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
