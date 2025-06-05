import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String id;
  final String title;
  final String content;
  final String category; // Nuevo campo
  final String userId; // Campo agregado
  final DateTime createdAt;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.category, // Nuevo campo requerido
    required this.userId, // Nuevo campo requerido
    required this.createdAt,
  });

  factory Note.fromFirestore(Map<String, dynamic> data, String id) {
    return Note(
      id: id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      category: data['category'] ?? 'General', // Default si no existe
      userId: data['userId'] ?? '', // Default vacío si no existe
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'category': category, // Guardar la categoría
      'userId': userId, // Guardar el userId
      'createdAt': createdAt,
    };
  }
}
