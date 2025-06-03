part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  final User? user;
  const AuthState({this.user});

  @override
  List<Object?> get props => [user];
}

class AuthInitial extends AuthState {
  const AuthInitial() : super(user: null);
}

class AuthLoading extends AuthState {
  const AuthLoading() : super(user: null);
}

class AuthSuccess extends AuthState {
  final String name;
  const AuthSuccess(User user, this.name) : super(user: user);

  @override
  List<Object?> get props => [user, name];
}

class RegistrationSuccess extends AuthState {
  const RegistrationSuccess(User user) : super(user: user);
}

class AuthFailure extends AuthState {
  final String error;
  const AuthFailure(this.error) : super(user: null);
}
