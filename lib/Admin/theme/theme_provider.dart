import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Screens/Profile/services/preferences_service.dart';
import 'theme.dart';

class ThemeProvider extends ChangeNotifier {
  AdminThemeMode _themeMode = AdminThemeMode.dark;
  bool _isInitialized = false;

  AdminThemeMode get themeMode => _themeMode;

  ThemeData get currentTheme {
    switch (_themeMode) {
      case AdminThemeMode.light:
        return AdminTheme.lightTheme;
      case AdminThemeMode.dark:
        return AdminTheme.darkTheme;
      case AdminThemeMode.system:
        // Get system brightness
        final brightness =
            WidgetsBinding.instance.platformDispatcher.platformBrightness;
        return brightness == Brightness.dark
            ? AdminTheme.darkTheme
            : AdminTheme.lightTheme;
    }
  }

  bool get isDarkMode {
    switch (_themeMode) {
      case AdminThemeMode.light:
        return false;
      case AdminThemeMode.dark:
        return true;
      case AdminThemeMode.system:
        final brightness =
            WidgetsBinding.instance.platformDispatcher.platformBrightness;
        return brightness == Brightness.dark;
    }
  }

  // Initialize theme from saved preferences
  Future<void> initializeTheme() async {
    if (_isInitialized) return;

    try {
      _themeMode = await PreferencesService.getThemeMode();
      _updateSystemUI();
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      // If loading fails, use default dark theme
      _themeMode = AdminThemeMode.dark;
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> setThemeMode(AdminThemeMode mode) async {
    if (_themeMode != mode) {
      _themeMode = mode;
      _updateSystemUI();

      // Save to preferences
      try {
        await PreferencesService.saveThemeMode(mode);
      } catch (e) {
        // Handle save error silently
        debugPrint('Failed to save theme preference: $e');
      }

      notifyListeners();
    }
  }

  void toggleTheme() {
    switch (_themeMode) {
      case AdminThemeMode.light:
        setThemeMode(AdminThemeMode.dark);
        break;
      case AdminThemeMode.dark:
        setThemeMode(AdminThemeMode.system);
        break;
      case AdminThemeMode.system:
        setThemeMode(AdminThemeMode.light);
        break;
    }
  }

  void _updateSystemUI() {
    // Update system UI overlay style based on theme
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDarkMode
            ? Brightness.light
            : Brightness.dark,
        statusBarBrightness: isDarkMode ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: isDarkMode
            ? AdminTheme.darkBackground
            : AdminTheme.lightBackground,
        systemNavigationBarIconBrightness: isDarkMode
            ? Brightness.light
            : Brightness.dark,
      ),
    );
  }

  // Get colors based on current theme
  Color get backgroundColor =>
      isDarkMode ? AdminTheme.darkBackground : AdminTheme.lightBackground;

  Color get surfaceColor =>
      isDarkMode ? AdminTheme.darkSurface : AdminTheme.lightSurface;

  Color get borderColor =>
      isDarkMode ? AdminTheme.darkBorder : AdminTheme.lightBorder;

  Color get textColor => isDarkMode ? Colors.white : Colors.black;

  Color get subtitleColor => isDarkMode ? Colors.grey : Colors.grey.shade600;
}
