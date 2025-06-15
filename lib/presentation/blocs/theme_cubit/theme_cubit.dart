import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final SharedPreferences prefs;
  static const String _themeKey = 'theme_mode';

  ThemeCubit(this.prefs)
    : super(ThemeState(isDarkMode: prefs.getBool(_themeKey) ?? false));

  void toggleTheme() {
    final newMode = !state.isDarkMode;
    prefs.setBool(_themeKey, newMode);
    emit(ThemeState(isDarkMode: newMode));
  }
}
