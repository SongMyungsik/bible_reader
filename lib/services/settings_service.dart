import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 메인 색상으로 선택할 수 있는 6가지 색상.
const List<Color> accentColorOptions = [
  Color(0xFF14B8A6), // 청록
  Color(0xFF3B82F6), // 파랑
  Color(0xFF8B5CF6), // 보라
  Color(0xFF22C55E), // 초록
  Color(0xFFF97316), // 주황
  Color(0xFFEF4444), // 빨강
];

/// 성경 본문 글씨 크기 5단계.
const List<double> verseFontSizes = [14, 17.5, 21, 24.5, 28];

const int _defaultFontSizeIndex = 1;

/// 테마, 메인 색상, 본문 글씨 크기 설정을 보관하고
/// SharedPreferences에 영구 저장하는 앱 전역 설정.
class AppSettings extends ChangeNotifier {
  static const _themeModeKey = 'settings_theme_mode';
  static const _accentIndexKey = 'settings_accent_index';
  static const _fontSizeIndexKey = 'settings_font_size_index';

  ThemeMode themeMode = ThemeMode.dark;
  int accentIndex = 0;
  int fontSizeIndex = _defaultFontSizeIndex;

  Color get accentColor => accentColorOptions[accentIndex];
  double get verseFontSize => verseFontSizes[fontSizeIndex];

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final modeName = prefs.getString(_themeModeKey);
    themeMode = ThemeMode.values.firstWhere(
      (m) => m.name == modeName,
      orElse: () => ThemeMode.dark,
    );
    accentIndex = (prefs.getInt(_accentIndexKey) ?? 0)
        .clamp(0, accentColorOptions.length - 1);
    fontSizeIndex = (prefs.getInt(_fontSizeIndexKey) ?? _defaultFontSizeIndex)
        .clamp(0, verseFontSizes.length - 1);
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (themeMode == mode) return;
    themeMode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, mode.name);
  }

  Future<void> setAccentIndex(int index) async {
    if (accentIndex == index) return;
    accentIndex = index;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_accentIndexKey, index);
  }

  Future<void> setFontSizeIndex(int index) async {
    if (fontSizeIndex == index) return;
    fontSizeIndex = index;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_fontSizeIndexKey, index);
  }
}
