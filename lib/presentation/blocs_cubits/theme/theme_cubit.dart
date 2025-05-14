
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chiragar_chiragar_spacex_explore/core/theme/app_theme.dart';

part 'theme_state.dart';

const String _themePrefsKey = 'appTheme';

@injectable
class ThemeCubit extends Cubit<ThemeState> {
  final SharedPreferences _prefs;

  ThemeCubit(this._prefs) : super(_loadInitialTheme(_prefs));

  static ThemeState _loadInitialTheme(SharedPreferences prefs) {
    final isDarkMode = prefs.getBool(_themePrefsKey) ?? false; // false means light
    return ThemeState(
      isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
      isDarkMode ? ThemeMode.dark : ThemeMode.light,
    );
  }

  void toggleTheme() {
    final newThemeMode = state.themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    final newThemeData = newThemeMode == ThemeMode.dark ? AppTheme.darkTheme : AppTheme.lightTheme;
    _prefs.setBool(_themePrefsKey, newThemeMode == ThemeMode.dark);
    emit(ThemeState(newThemeData, newThemeMode));
  }
}