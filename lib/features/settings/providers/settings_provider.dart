import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  final SharedPreferences _prefs;
  
  SettingsProvider(this._prefs);

  ThemeMode _themeMode = ThemeMode.system;
  bool _biometricEnabled = false;
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;

  ThemeMode get themeMode => _themeMode;
  bool get biometricEnabled => _biometricEnabled;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get soundEnabled => _soundEnabled;

  Future<void> loadSettings() async {
    _themeMode = ThemeMode.values[_prefs.getInt('theme_mode') ?? 0];
    _biometricEnabled = _prefs.getBool('biometric_enabled') ?? false;
    _notificationsEnabled = _prefs.getBool('notifications_enabled') ?? true;
    _soundEnabled = _prefs.getBool('sound_enabled') ?? true;
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _prefs.setInt('theme_mode', mode.index);
    notifyListeners();
  }

  Future<void> setBiometricEnabled(bool enabled) async {
    _biometricEnabled = enabled;
    await _prefs.setBool('biometric_enabled', enabled);
    notifyListeners();
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    _notificationsEnabled = enabled;
    await _prefs.setBool('notifications_enabled', enabled);
    notifyListeners();
  }

  Future<void> setSoundEnabled(bool enabled) async {
    _soundEnabled = enabled;
    await _prefs.setBool('sound_enabled', enabled);
    notifyListeners();
  }
}
