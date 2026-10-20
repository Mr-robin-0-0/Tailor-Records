import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => _build(Brightness.light);

  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final bg = isDark ? AppColors.groupedBackgroundDark : AppColors.groupedBackgroundLight;
    final surface = isDark ? AppColors.secondaryGroupedDark : AppColors.secondaryGroupedLight;
    final label = isDark ? AppColors.labelDark : AppColors.labelLight;
    final secondary = isDark ? AppColors.secondaryLabelDark : AppColors.secondaryLabelLight;

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: AppColors.systemBlue,
      onPrimary: Colors.white,
      secondary: AppColors.systemBlue,
      onSecondary: Colors.white,
      error: AppColors.systemRed,
      onError: Colors.white,
      surface: surface,
      onSurface: label,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      cupertinoOverrideTheme: CupertinoThemeData(
        brightness: brightness,
        primaryColor: AppColors.systemBlue,
        barBackgroundColor: bg,
        scaffoldBackgroundColor: bg,
      ),
      scaffoldBackgroundColor: bg,
      dividerColor: isDark ? AppColors.separatorDark : AppColors.separatorLight,
      splashFactory: InkRipple.splashFactory,
      splashColor: AppColors.pressOverlayFor(isDark),
      highlightColor: AppColors.pressHighlightFor(isDark),
      textTheme: TextTheme(
        displayLarge: TextStyle(fontSize: 34, fontWeight: FontWeight.w700, letterSpacing: 0.37, color: label),
        titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: label),
        titleMedium: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: label),
        bodyLarge: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: label),
        bodyMedium: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: secondary),
        labelLarge: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: label),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        foregroundColor: label,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.41,
          color: label,
        ),
        iconTheme: const IconThemeData(color: AppColors.systemBlue),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      dividerTheme: DividerThemeData(
        color: isDark ? AppColors.separatorDark : AppColors.separatorLight,
        thickness: 0.5,
        space: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? AppColors.tertiaryFillDark : AppColors.tertiaryFillLight,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.systemBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.systemRed),
        ),
        hintStyle: TextStyle(color: secondary, fontSize: 17),
        labelStyle: TextStyle(color: secondary, fontSize: 15),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.systemBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.systemBlue,
          textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.systemBlue,
          side: const BorderSide(color: AppColors.systemBlue),
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.systemBlue,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: isDark ? const Color(0xFF2C2C2E) : const Color(0xFF1C1C1E),
        contentTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        elevation: 6,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        iconColor: AppColors.systemBlue,
        titleTextStyle: TextStyle(fontSize: 17, color: label),
        subtitleTextStyle: TextStyle(fontSize: 15, color: secondary),
      ),
      popupMenuTheme: PopupMenuThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        color: surface,
      ),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return AppColors.pressOverlayFor(isDark);
            }
            return null;
          }),
        ),
      ),
    );
  }
}
