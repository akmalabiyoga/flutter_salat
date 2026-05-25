import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/theme_service.dart';

final themeServiceProvider = Provider((ref) => ThemeService());

class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    // We start with system and then load from preferences
    _loadTheme();
    return ThemeMode.system;
  }

  Future<void> _loadTheme() async {
    final mode = await ref.read(themeServiceProvider).getThemeMode();
    state = mode;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await ref.read(themeServiceProvider).setThemeMode(mode);
  }
}

final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(() {
  return ThemeNotifier();
});
