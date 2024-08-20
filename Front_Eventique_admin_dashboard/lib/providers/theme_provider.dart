//taghreed
import '/shared_preferencess/storage_manager.dart';
import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode? _themeMode;

  ThemeProvider() {
    StorageManager.readData('themeMode').then((value) {
      var themeMode = value ?? 'system';
      if (themeMode == 'light') {
        _themeMode = ThemeMode.light;
      } else if (themeMode == 'dark') {
        _themeMode = ThemeMode.dark;
      } else {
        _themeMode = ThemeMode.system;
      }
      notifyListeners();
    });
  }

  ThemeMode? getThemeMode() => _themeMode;

  void setDarkMode() async {
    _themeMode = ThemeMode.dark;
    StorageManager.saveData('themeMode', 'dark');
    notifyListeners();
  }

  void setLightMode() async {
    _themeMode = ThemeMode.light;
    StorageManager.saveData('themeMode', 'light');
    notifyListeners();
  }

  void setSystemMode() async {
    _themeMode = ThemeMode.system;
    StorageManager.saveData('themeMode', 'system');
    notifyListeners();
  }
}
