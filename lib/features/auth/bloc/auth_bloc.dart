import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:prueba/features/auth/repositories/auth_repository.dart';

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
      await authRepository.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthFailure(error: _mapAuthError(e.toString())));
    }
  }

  // Cambiar el método _onSignUpRequested:
  void _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await authRepository.signUpWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      emit(RegistrationSuccess()); // Nuevo estado para registro exitoso
    } catch (e) {
      emit(AuthFailure(error: _mapAuthError(e.toString())));
    }
  }

  void _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await authRepository.signOut();
    emit(AuthInitial());
  }

  String _mapAuthError(String error) {
    if (error.contains('weak-password')) {
      return 'La contraseña es demasiado débil';
    } else if (error.contains('email-already-in-use')) {
      return 'El correo ya está en uso';
    } else if (error.contains('invalid-email')) {
      return 'Correo electrónico inválido';
    } else if (error.contains('user-not-found')) {
      return 'Usuario no encontrado';
    } else if (error.contains('wrong-password')) {
      return 'Contraseña incorrecta';
    }
    return 'Error de autenticación';
  }
}
