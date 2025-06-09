// Archivo: theme_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ThemeEvent {}

class ToggleThemeEvent extends ThemeEvent {}

class ThemeState {
  final bool isDarkMode;

  ThemeState({required this.isDarkMode});
}

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(isDarkMode: false)) {
    on<ToggleThemeEvent>((event, emit) {
      emit(ThemeState(isDarkMode: !state.isDarkMode));
    });
  }
}
