// theme_state.dart
part of 'theme_cubit.dart';

class ThemeState extends Equatable {
  final ThemeData themeData;
  final ThemeMode themeMode;

  const ThemeState(this.themeData, this.themeMode);

  @override
  List<Object> get props => [themeData, themeMode];
}

