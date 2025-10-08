import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../theme/theme.dart';

class PreferencesService {
  static const String _themeKey = 'theme_mode';
  static const String _profileKey = 'user_profile';
  static const String _notificationKey = 'notification_settings';
  static const String _languageKey = 'selected_language';
  static const String _connectedAccountsKey = 'connected_accounts';
  static const String _biometricKey = 'biometric_enabled';
  static const String _securitySettingsKey = 'security_settings';

  // Theme Preferences
  static Future<void> saveThemeMode(AdminThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, mode.name);
  }

  static Future<AdminThemeMode> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeName = prefs.getString(_themeKey) ?? 'dark';

    try {
      return AdminThemeMode.values.firstWhere((mode) => mode.name == themeName);
    } catch (e) {
      return AdminThemeMode.dark;
    }
  }

  // Profile Data
  static Future<void> saveProfileData(Map<String, dynamic> profileData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileKey, jsonEncode(profileData));
  }

  static Future<Map<String, dynamic>?> getProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    final profileJson = prefs.getString(_profileKey);

    if (profileJson != null) {
      try {
        return jsonDecode(profileJson) as Map<String, dynamic>;
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // Notification Settings
  static Future<void> saveNotificationSettings(
    Map<String, bool> settings,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_notificationKey, jsonEncode(settings));
  }

  static Future<Map<String, bool>> getNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = prefs.getString(_notificationKey);

    if (settingsJson != null) {
      try {
        final decoded = jsonDecode(settingsJson) as Map<String, dynamic>;
        return decoded.map((key, value) => MapEntry(key, value as bool));
      } catch (e) {
        return _getDefaultNotificationSettings();
      }
    }
    return _getDefaultNotificationSettings();
  }

  static Map<String, bool> _getDefaultNotificationSettings() {
    return {
      'emailNotifications': true,
      'accountActivity': true,
      'securityAlerts': true,
      'productUpdates': false,
      'weeklyDigest': true,
      'pushNotifications': true,
      'messages': true,
      'accountActivityPush': true,
      'securityAlertsPush': true,
      'promotions': false,
      'smsNotifications': false,
      'quietHours': false,
    };
  }

  // Language Preference
  static Future<void> saveLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, language);
  }

  static Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey) ?? 'English';
  }

  // Connected Accounts
  static Future<void> saveConnectedAccounts(
    List<Map<String, dynamic>> accounts,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_connectedAccountsKey, jsonEncode(accounts));
  }

  static Future<List<Map<String, dynamic>>> getConnectedAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    final accountsJson = prefs.getString(_connectedAccountsKey);

    if (accountsJson != null) {
      try {
        final decoded = jsonDecode(accountsJson) as List<dynamic>;
        return decoded.cast<Map<String, dynamic>>();
      } catch (e) {
        return [];
      }
    }
    return [];
  }

  // Biometric Settings
  static Future<void> setBiometricEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_biometricKey, enabled);
  }

  static Future<bool> isBiometricEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_biometricKey) ?? false;
  }

  // Security Settings
  static Future<void> saveSecuritySettings(
    Map<String, dynamic> settings,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_securitySettingsKey, jsonEncode(settings));
  }

  static Future<Map<String, dynamic>> getSecuritySettings() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = prefs.getString(_securitySettingsKey);

    if (settingsJson != null) {
      try {
        return jsonDecode(settingsJson) as Map<String, dynamic>;
      } catch (e) {
        return {};
      }
    }
    return {};
  }

  // Clear all preferences (for logout)
  static Future<void> clearAllPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Backup and restore
  static Future<Map<String, dynamic>> exportAllSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    final Map<String, dynamic> allSettings = {};

    for (String key in keys) {
      allSettings[key] = prefs.get(key);
    }

    return allSettings;
  }

  static Future<void> importAllSettings(Map<String, dynamic> settings) async {
    final prefs = await SharedPreferences.getInstance();

    for (String key in settings.keys) {
      final value = settings[key];
      if (value is String) {
        await prefs.setString(key, value);
      } else if (value is bool) {
        await prefs.setBool(key, value);
      } else if (value is int) {
        await prefs.setInt(key, value);
      } else if (value is double) {
        await prefs.setDouble(key, value);
      } else if (value is List<String>) {
        await prefs.setStringList(key, value);
      }
    }
  }
}
