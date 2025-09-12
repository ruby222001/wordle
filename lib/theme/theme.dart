import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordle_app/theme/dark_mode.dart';
import 'package:wordle_app/theme/light_mode.dart';

// EVENTS
abstract class ThemeEvent {}

class ToggleThemeEvent extends ThemeEvent {}

// STATE
class ThemeState {
  final ThemeData themeData;
  const ThemeState({required this.themeData});

  bool get isDarkMode => themeData == darkMode;
}

// BLOC
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(themeData: lightMode)) {
    on<ToggleThemeEvent>((event, emit) {
      if (state.themeData == lightMode) {
        emit(ThemeState(themeData: darkMode));
      } else {
        emit(ThemeState(themeData: lightMode));
      }
    });
  }
}
