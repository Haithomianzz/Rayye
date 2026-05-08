import 'package:flutter/material.dart';

class AppTheme {
  static const Color soil       = Color(0xFF3B2A1A);
  static const Color bark       = Color(0xFF5C3D22);
  static const Color moss       = Color(0xFF2D5016);
  static const Color leaf       = Color(0xFF4A7C2F);
  static const Color sprout     = Color(0xFF7DB554);
  static const Color mist       = Color(0xFFD4E8C2);
  static const Color clay       = Color(0xFFF0E6D3);
  static const Color sand       = Color(0xFFF5EDD8);
  static const Color water      = Color(0xFF4A9EBF);
  static const Color waterLight = Color(0xFFB3DFF0);
  static const Color amber      = Color(0xFFD4860A);
  static const Color charcoal   = Color(0xFF1C1C1E);

  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: sand,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: leaf,
      onPrimary: Colors.white,
      primaryContainer: mist,
      onPrimaryContainer: moss,
      secondary: water,
      onSecondary: Colors.white,
      secondaryContainer: waterLight,
      onSecondaryContainer: Color(0xFF003A4F),
      tertiary: amber,
      onTertiary: Colors.white,
      tertiaryContainer: Color(0xFFFFE0A3),
      onTertiaryContainer: Color(0xFF3A2000),
      error: Color(0xFFBA1A1A),
      onError: Colors.white,
      errorContainer: Color(0xFFFFDAD6),
      onErrorContainer: Color(0xFF410002),
      surface: sand,
      onSurface: charcoal,
      surfaceContainerHighest: clay,
      outline: Color(0xFF8A7A6A),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: moss,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: mist, width: 1.5),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: leaf,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: mist, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: mist, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: leaf, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? leaf : Colors.grey[400]),
      trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? mist : Colors.grey[200]),
    ),
    sliderTheme: const SliderThemeData(
      activeTrackColor: leaf,
      thumbColor: sprout,
      inactiveTrackColor: mist,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: mist,
    ),
  );
}
