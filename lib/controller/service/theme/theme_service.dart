// ignore_for_file: constant_identifier_names
import '../../../../core/services/local_storage/local_keys.dart';
import '../../../../core/services/local_storage/local_storage_service.dart';

class ThemeService {
  //! Theme mode constants
  static const int SYSTEM_MODE = 0;
  static const int LIGHT_MODE = 1;
  static const int DARK_MODE = 2;

  Future<bool> getTheme() async {
    //! Get current theme mode
    int mode = await LocalStorageService.getInt(
      LocalStorageKey.THEME_MODE_KEY,
      defaultValue: SYSTEM_MODE,
    );

    //! For backward compatibility
    if (mode == SYSTEM_MODE) {
      //! Return stored preference for backward compatibility
      return LocalStorageService.getBool(
        LocalStorageKey.THEME_KEY,
        defaultValue: false,
      );
    }

    return mode == DARK_MODE;
  }

  Future<bool> setDarkTheme(bool value) async {
    //! Store as explicit mode
    int mode = value ? DARK_MODE : LIGHT_MODE;
    await LocalStorageService.setInt(LocalStorageKey.THEME_MODE_KEY, mode);

    //! Also update legacy key for backward compatibility
    return await LocalStorageService.setBool(LocalStorageKey.THEME_KEY, value);
  }

  Future<int> getCurrentThemeMode() async {
    return await LocalStorageService.getInt(
      LocalStorageKey.THEME_MODE_KEY,
      defaultValue: SYSTEM_MODE,
    );
  }

  Future<bool> setThemeMode(int mode) async {
    //! When setting mode, also update the theme key for compatibility
    bool isDark = mode == DARK_MODE;
    if (mode != SYSTEM_MODE) {
      await LocalStorageService.setBool(LocalStorageKey.THEME_KEY, isDark);
    }

    return await LocalStorageService.setInt(
      LocalStorageKey.THEME_MODE_KEY,
      mode,
    );
  }
}
