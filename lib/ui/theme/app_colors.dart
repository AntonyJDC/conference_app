import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,

      primary: Color(0xFF292929),
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFF444444),
      onPrimaryContainer: Color(0xFFFFFFFF),

      secondary: Color(0xFF383838),
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFF5E5E5E),
      onSecondaryContainer: Color(0xFFFFFFFF),

      tertiary: Color(0xFFF7F7F7), //base-200
      onTertiary: Color(0xFFF0F0F0), //base-300
      tertiaryContainer: Color(0xFF5E5E5E),
      onTertiaryContainer: Color(0xFF000000),

      error: Color(0xFFF6A59B),
      onError: Color(0xFF29100E),
      errorContainer: Color(0xFFB00020),
      onErrorContainer: Color(0xFFFFFFFF),

      surface: Color(0xFFFFFFFF),
      onSurface: Color(0xFF000000),
      onSurfaceVariant: Color(0xFF444444),

      surfaceTint: Color(0xFF90C9F8), // info
      outline: Color(0xFFAAAAAA),
      outlineVariant: Color(0xFFCCCCCC),

      shadow: Colors.black12,
      scrim: Colors.black12,

      inverseSurface: Color(0xFF121212),
      inversePrimary: Color(0xFF8BBBE2),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,

      // Colores principales neutros
      primary: Color(
          0xFFEDEDED), // Texto y elementos clave (claro sobre fondo oscuro)
      onPrimary: Color(0xFF000000),
      primaryContainer: Color(0xFF292929),
      onPrimaryContainer: Color(0xFFFFFFFF),

      // Secundario suave
      secondary: Color(0xFFB0B0B0),
      onSecondary: Color(0xFF000000),
      secondaryContainer: Color(0xFF3A3A3A),
      onSecondaryContainer: Color(0xFFFFFFFF),

      // Terciario gris claro (accent)
      tertiary: Color(0xFF262626),
      onTertiary: Color(0xFF383838),
      tertiaryContainer: Color(0xFF4B4B4B),
      onTertiaryContainer: Color(0xFFFFFFFF),

      // Error, warning, info, success en tonos suaves
      error: Color(0xFFF6A59B),
      onError: Color(0xFF2B1A18),
      errorContainer: Color(0xFF8C1D18),
      onErrorContainer: Color(0xFFFFFFFF),

      surface: Color(0xFF000000),
      onSurface: Color(0xFFFFFFFF),
      onSurfaceVariant: Color(0xFFCCCCCC),

      surfaceTint: Color(0xFF90C9F8), // tono suave azul info
      outline: Color(0xFF444444),
      outlineVariant: Color(0xFF666666),

      shadow: Colors.white,
      scrim: Colors.white,

      inverseSurface: Color(0xFFF8F8F8),
      inversePrimary: Color(0xFF444444),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
      );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
