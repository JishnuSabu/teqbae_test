// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:teqbae_test/controller/service/theme/theme_service.dart';

class ThemeProvider with ChangeNotifier {
  ThemeService themeService = ThemeService();
  ThemeProvider();

  bool _darkTheme = false;
  bool get darkTheme => _darkTheme;
  int _themeMode = ThemeService.SYSTEM_MODE;
  int get themeMode => _themeMode;

  //* Add a stream subscription to listen for platform brightness changes
  StreamSubscription? _brightnessSubscription;
  //* Initialize with context and set up listeners
  Future<void> initialize(BuildContext context) async {
    _themeMode = await themeService.getCurrentThemeMode();
    updateThemeBasedOnMode(context);
    //* Set up a listener for system brightness changes
    _setupBrightnessListener(context);
    notifyListeners();
  }

  void _setupBrightnessListener(BuildContext context) {
    //* Clean up any existing subscription
    _brightnessSubscription?.cancel();
    //* Use a WidgetsBinding observer to detect platform brightness changes
    WidgetsBinding.instance.addObserver(
      _PlatformBrightnessObserver(
        onBrightnessChanged: (brightness) {
          if (_themeMode == ThemeService.SYSTEM_MODE) {
            _darkTheme = brightness == Brightness.dark;
            notifyListeners();
          }
        },
      ),
    );
  }

  void updateThemeBasedOnMode(BuildContext context) {
    if (_themeMode == ThemeService.SYSTEM_MODE) {
      //* Use system setting
      Brightness systemBrightness = MediaQuery.of(context).platformBrightness;
      _darkTheme = systemBrightness == Brightness.dark;
    } else {
      //* Use explicit setting
      _darkTheme = _themeMode == ThemeService.DARK_MODE;
    }
    notifyListeners();
  }

  //* Original setter for backward compatibility
  set setDarkTheme(bool value) {
    _darkTheme = value;
    _themeMode = value ? ThemeService.DARK_MODE : ThemeService.LIGHT_MODE;
    themeService.setDarkTheme(value);
    notifyListeners();
  }

  //* Set theme mode directly
  Future<void> setThemeMode(int mode, BuildContext context) async {
    _themeMode = mode;
    await themeService.setThemeMode(mode);
    updateThemeBasedOnMode(context);
  }

  //* Modified toggle to handle system mode
  void toggleTheme(BuildContext context) {
    if (_themeMode == ThemeService.SYSTEM_MODE) {
      //* Toggle system mode to explicit mode based on current appearance
      bool isDark =
          MediaQuery.of(context).platformBrightness == Brightness.dark;
      //* Toggle to opposite of system
      setThemeMode(
        isDark ? ThemeService.LIGHT_MODE : ThemeService.DARK_MODE,
        context,
      );
    } else {
      //* Toggle between light and dark
      setThemeMode(
        _themeMode == ThemeService.LIGHT_MODE
            ? ThemeService.DARK_MODE
            : ThemeService.LIGHT_MODE,
        context,
      );
    }
  }

  @override
  void dispose() {
    _brightnessSubscription?.cancel();
    super.dispose();
  }
}

//* Add this helper class to monitor platform brightness changes
class _PlatformBrightnessObserver extends WidgetsBindingObserver {
  final void Function(Brightness brightness) onBrightnessChanged;
  _PlatformBrightnessObserver({required this.onBrightnessChanged});
  @override
  void didChangePlatformBrightness() {
    final brightness = WidgetsBinding.instance.window.platformBrightness;
    onBrightnessChanged(brightness);
    super.didChangePlatformBrightness();
  }
}
