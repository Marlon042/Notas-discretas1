import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prueba/features/auth/repositories/auth_repository.dart';
import 'package:prueba/core/widgets/avatar_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<SignInRequested>(_onSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<SignOutRequested>(_onSignOutRequested);
  }

  void _onSignInRequested(
    SignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final result = await authRepository.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      // Recuperar el avatar del usuario desde Firestore
      final user = result!['user'];
      final name = result['name'];
      String avatarPath = 'assets/images/default_avatar.jpeg';
      try {
        final doc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();
        if (doc.exists && doc.data()?['avatar'] != null) {
          avatarPath = doc.data()!['avatar'] as String;
        }
      } catch (_) {}
      AvatarNotifier.avatarPath.value = avatarPath;
      emit(AuthSuccess(user, name));
    } catch (e) {
      emit(AuthFailure(_mapAuthError(e.toString())));
    }
  }

  void _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.signUpWithEmailAndPassword(
        name: event.name,
        email: event.email,
        password: event.password,
      );
      emit(RegistrationSuccess(user!));
    } catch (e) {
      emit(AuthFailure(_mapAuthError(e.toString())));
    }
  }

  void _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await authRepository.signOut();
    // Reinicia el avatar al cerrar sesión
    AvatarNotifier.avatarPath.value = 'assets/images/default_avatar.jpeg';
    emit(AuthInitial());
  }

  String _mapAuthError(String error) {
    if (error.contains('weak-password') ||
        error.contains('[firebase_auth/weak-password]')) {
      return 'La contraseña es demasiado débil';
    } else if (error.contains('email-already-in-use') ||
        error.contains('[firebase_auth/email-already-in-use]')) {
      return 'El correo ya está en uso';
    } else if (error.contains('invalid-email') ||
        error.contains('[firebase_auth/invalid-email]')) {
      return 'Correo electrónico inválido';
    } else if (error.contains('user-not-found') ||
        error.contains('[firebase_auth/user-not-found]')) {
      return 'Correo no encontrado o no existe en el sistema';
    } else if (error.contains('wrong-password') ||
        error.contains('[firebase_auth/wrong-password]')) {
      return 'Contraseña incorrecta';
    } else if (error.contains('auth credential is incorrect') ||
        error.contains('malformed or has expired')) {
      return 'Las credenciales son incorrectas o han expirado';
    }
    return 'Error de autenticación';
  }
}
