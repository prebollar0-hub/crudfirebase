import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Paleta única de la app (índigo + violeta sobre fondo gris claro).
class AppColors {
  static const Color primary = Color(0xFF4F46E5);
  static const Color accent = Color(0xFF7C3AED);
  static const Color background = Color(0xFFF5F6FA);
  static const Color surface = Colors.white;
  static const Color textDark = Color(0xFF1F2937);
  static const Color textMuted = Color(0xFF6B7280);
  static const Color border = Color(0xFFE5E7EB);
  static const Color danger = Color(0xFFE11D48);
}

class AppTheme {
  static const LinearGradient gradiente = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.primary, AppColors.accent],
  );

  static List<BoxShadow> get sombra => [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.08),
          blurRadius: 18,
          offset: const Offset(0, 6),
        ),
      ];

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.primary,
      secondary: AppColors.accent,
      error: AppColors.danger,
      surface: AppColors.surface,
      onSurface: AppColors.textDark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        surfaceTintColor: Colors.transparent,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 8,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.textDark,
        contentTextStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  /// AppBar con degradado, reutilizada en todas las páginas.
  static AppBar appBar(String titulo, {List<Widget>? actions}) {
    return AppBar(
      title: Text(
        titulo,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
      ),
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      flexibleSpace: Container(
        decoration: const BoxDecoration(gradient: gradiente),
      ),
      actions: actions,
    );
  }

  /// Decoración uniforme para todos los campos de texto.
  static InputDecoration campo(String label, IconData icono) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icono, color: AppColors.primary),
      filled: true,
      fillColor: const Color(0xFFF9FAFB),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: _borde(AppColors.border),
      enabledBorder: _borde(AppColors.border),
      focusedBorder: _borde(AppColors.primary, 1.8),
      errorBorder: _borde(AppColors.danger),
      focusedErrorBorder: _borde(AppColors.danger, 1.8),
    );
  }

  static OutlineInputBorder _borde(Color color, [double ancho = 1]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: color, width: ancho),
    );
  }
}