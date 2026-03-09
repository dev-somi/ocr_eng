import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;

  static const EdgeInsets paddingXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingMd = EdgeInsets.all(md);
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);
  static const EdgeInsets paddingXl = EdgeInsets.all(xl);
}

class AppRadius {
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 28.0;
  static const double xl = 32.0;
  static const double full = 9999.0;

  static BorderRadius get smRadius => BorderRadius.circular(sm);
  static BorderRadius get mdRadius => BorderRadius.circular(md);
  static BorderRadius get lgRadius => BorderRadius.circular(lg);
  static BorderRadius get fullRadius => BorderRadius.circular(full);
}

class AppShadows {
  static const BoxShadow sm = BoxShadow(
    color: Color(0x331D1D1F),
    offset: Offset(0, 2),
    blurRadius: 0,
    spreadRadius: 0,
  );
  static const BoxShadow md = BoxShadow(
    color: Color(0x331D1D1F),
    offset: Offset(0, 4),
    blurRadius: 0,
    spreadRadius: 0,
  );
  static const BoxShadow lg = BoxShadow(
    color: Color(0x331D1D1F),
    offset: Offset(0, 6),
    blurRadius: 0,
    spreadRadius: 0,
  );
  static const BoxShadow xl = BoxShadow(
    color: Color(0x331D1D1F),
    offset: Offset(0, 8),
    blurRadius: 0,
    spreadRadius: 0,
  );
}

class LightColors {
  static const primary = Color(0xFFE63946);
  static const onPrimary = Color(0xFFFFFFFF);
  static const secondary = Color(0xFFFFD60A);
  static const onSecondary = Color(0xFF000000);
  static const accent = Color(0xFF4CC9F0);
  static const background = Color(0xFFF8F9FA);
  static const surface = Color(0xFFFFFFFF);
  static const onSurface = Color(0xFF1D1D1F);
  static const primaryText = Color(0xFF1D1D1F);
  static const secondaryText = Color(0xFF495057);
  static const hint = Color(0xFFADB5BD);
  static const error = Color(0xFFEF476F);
  static const onError = Color(0xFFFFFFFF);
  static const success = Color(0xFF52B788);
  static const divider = Color(0xFF1D1D1F);
  static const transparent = Color(0x00000000);
}

class DarkColors {
  static const primary = Color(0xFFFF4D5A);
  static const onPrimary = Color(0xFFFFFFFF);
  static const secondary = Color(0xFFFFD60A);
  static const onSecondary = Color(0xFF000000);
  static const accent = Color(0xFF4CC9F0);
  static const background = Color(0xFF121212);
  static const surface = Color(0xFF1E1E1E);
  static const onSurface = Color(0xFFF8F9FA);
  static const primaryText = Color(0xFFF8F9FA);
  static const secondaryText = Color(0xFFDEE2E6);
  static const hint = Color(0xFF6C757D);
  static const error = Color(0xFFFF5C81);
  static const onError = Color(0xFFFFFFFF);
  static const success = Color(0xFF74C69D);
  static const divider = Color(0xFFFFFFFF);
  static const transparent = Color(0x00000000);
}

ThemeData get lightTheme => _buildTheme(Brightness.light);
ThemeData get darkTheme => _buildTheme(Brightness.dark);

ThemeData _buildTheme(Brightness brightness) {
  final isLight = brightness == Brightness.light;

  final colorScheme = isLight
      ? const ColorScheme.light(
    primary: LightColors.primary,
    onPrimary: LightColors.onPrimary,
    secondary: LightColors.secondary,
    onSecondary: LightColors.onSecondary,
    error: LightColors.error,
    onError: LightColors.onError,
    surface: LightColors.surface,
    onSurface: LightColors.onSurface,
    outline: LightColors.divider,
  )
      : const ColorScheme.dark(
    primary: DarkColors.primary,
    onPrimary: DarkColors.onPrimary,
    secondary: DarkColors.secondary,
    onSecondary: DarkColors.onSecondary,
    error: DarkColors.error,
    onError: DarkColors.onError,
    surface: DarkColors.surface,
    onSurface: DarkColors.onSurface,
    outline: DarkColors.divider,
  );

  final scaffoldBg = isLight ? LightColors.background : DarkColors.background;

  // Font config
  // Primary: Baloo 2, Secondary: Quicksand
  final primaryFont = GoogleFonts.baloo2TextTheme();
  final secondaryFont = GoogleFonts.quicksandTextTheme();

  TextStyle getStyle(String fontType, double size, FontWeight weight, double height) {
    final base = (fontType == 'primary' ? primaryFont : secondaryFont).bodyMedium!;
    return base.copyWith(
      fontSize: size,
      fontWeight: weight,
      height: height,
      color: isLight ? LightColors.primaryText : DarkColors.primaryText,
    );
  }

  final textTheme = TextTheme(
    headlineLarge: getStyle('primary', 34, FontWeight.w800, 1.2),
    headlineMedium: getStyle('primary', 28, FontWeight.w700, 1.25),
    headlineSmall: getStyle('primary', 24, FontWeight.w800, 1.25), // Added for consistency
    titleLarge: getStyle('primary', 22, FontWeight.w700, 1.3),
    titleMedium: getStyle('secondary', 18, FontWeight.w700, 1.4),
    titleSmall: getStyle('secondary', 16, FontWeight.w700, 1.4), // Added
    bodyLarge: getStyle('secondary', 17, FontWeight.w500, 1.5),
    bodyMedium: getStyle('secondary', 15, FontWeight.w500, 1.5),
    bodySmall: getStyle('secondary', 13, FontWeight.w500, 1.4),
    labelLarge: getStyle('primary', 16, FontWeight.w600, 1.2),
    labelMedium: getStyle('primary', 14, FontWeight.w600, 1.2),
    labelSmall: getStyle('primary', 11, FontWeight.w600, 1.2),
  );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: scaffoldBg,
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: isLight ? LightColors.primaryText : DarkColors.primaryText),
      titleTextStyle: textTheme.titleLarge,
    ),
    cardTheme: CardThemeData(
      color: isLight ? LightColors.surface : DarkColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(
          color: isLight ? LightColors.divider : DarkColors.divider,
          width: 3,
        ),
      ),
    ),
    // Define other component themes as needed to match the style
    iconTheme: IconThemeData(
      color: isLight ? LightColors.primaryText : DarkColors.primaryText,
    ),
  );
}
