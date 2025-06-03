import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Leer el nombre desde Firestore
      final userDoc =
          await _firestore
              .collection('users')
              .doc(userCredential.user!.uid)
              .get();
      final name = userDoc.data()?['name'] ?? '';
      return {'user': userCredential.user, 'name': name};
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw Exception('Error desconocido al iniciar sesión');
    }
  }

  Future<User?> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Guardar el nombre en Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'createdAt': DateTime.now(),
      });
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      rethrow;
    } catch (e) {
      throw Exception('Error desconocido al registrarse');
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
