import 'package:flutter/material.dart';

enum PaperMode { morning, night }

@immutable
class PaperColors extends ThemeExtension<PaperColors> {
  const PaperColors({
    required this.bg,
    required this.surface,
    required this.fg,
    required this.muted,
    required this.border,
    required this.accent,
    required this.accentSoft,
  });

  final Color bg;
  final Color surface;
  final Color fg;
  final Color muted;
  final Color border;
  final Color accent;
  final Color accentSoft;

  static const morning = PaperColors(
    bg: Color(0xFFF3EEE2),
    surface: Color(0xFFF8F5ED),
    fg: Color(0xFF3A3832),
    muted: Color(0xFF6D695F),
    border: Color(0xFFC9C2B4),
    accent: Color(0xFFC0562A),
    accentSoft: Color(0x24C0562A),
  );

  static const night = PaperColors(
    bg: Color(0xFF1C2030),
    surface: Color(0xFF262B3C),
    fg: Color(0xFFE6E2D4),
    muted: Color(0xFFB4AFA0),
    border: Color(0xFF3A4154),
    accent: Color(0xFFD4A45A),
    accentSoft: Color(0x2ED4A45A),
  );

  @override
  PaperColors copyWith({
    Color? bg,
    Color? surface,
    Color? fg,
    Color? muted,
    Color? border,
    Color? accent,
    Color? accentSoft,
  }) {
    return PaperColors(
      bg: bg ?? this.bg,
      surface: surface ?? this.surface,
      fg: fg ?? this.fg,
      muted: muted ?? this.muted,
      border: border ?? this.border,
      accent: accent ?? this.accent,
      accentSoft: accentSoft ?? this.accentSoft,
    );
  }

  @override
  PaperColors lerp(ThemeExtension<PaperColors>? other, double t) {
    if (other is! PaperColors) return this;
    return PaperColors(
      bg: Color.lerp(bg, other.bg, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      fg: Color.lerp(fg, other.fg, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      border: Color.lerp(border, other.border, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentSoft: Color.lerp(accentSoft, other.accentSoft, t)!,
    );
  }
}

class PaperFonts {
  static const display = <String>[
    'Iowan Old Style',
    'Hiragino Mincho ProN',
    'Noto Serif CJK SC',
    'Songti SC',
    'Georgia',
    'serif',
  ];

  static const body = <String>[
    'Hiragino Sans',
    'PingFang SC',
    'Noto Sans CJK SC',
    'Source Han Sans SC',
    'sans-serif',
  ];

  static const mono = <String>['SF Mono', 'Menlo', 'ui-monospace', 'monospace'];
}

ThemeData buildPaperTheme(PaperMode mode) {
  final paper = mode == PaperMode.morning
      ? PaperColors.morning
      : PaperColors.night;
  final brightness = mode == PaperMode.morning
      ? Brightness.light
      : Brightness.dark;

  TextStyle serif({
    required double size,
    FontWeight weight = FontWeight.w600,
    double height = 1.12,
    double letterSpacing = -0.4,
  }) {
    return TextStyle(
      fontFamily: PaperFonts.display.first,
      fontFamilyFallback: PaperFonts.display.sublist(1),
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: letterSpacing,
      color: paper.fg,
    );
  }

  TextStyle sans({
    required double size,
    FontWeight weight = FontWeight.w400,
    double height = 1.5,
  }) {
    return TextStyle(
      fontFamily: PaperFonts.body.first,
      fontFamilyFallback: PaperFonts.body.sublist(1),
      fontSize: size,
      fontWeight: weight,
      height: height,
      color: paper.fg,
    );
  }

  TextStyle mono({
    required double size,
    Color? color,
    double letterSpacing = 1.2,
  }) {
    return TextStyle(
      fontFamily: PaperFonts.mono.first,
      fontFamilyFallback: PaperFonts.mono.sublist(1),
      fontSize: size,
      letterSpacing: letterSpacing,
      height: 1.3,
      color: color ?? paper.muted,
    );
  }

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    scaffoldBackgroundColor: paper.bg,
    canvasColor: paper.bg,
    splashFactory: InkRipple.splashFactory,
    colorScheme: ColorScheme(
      brightness: brightness,
      primary: paper.accent,
      onPrimary: paper.surface,
      secondary: paper.fg,
      onSecondary: paper.surface,
      error: paper.accent,
      onError: paper.surface,
      surface: paper.surface,
      onSurface: paper.fg,
    ),
    textTheme: TextTheme(
      displayLarge: serif(size: 34, height: 1.08, letterSpacing: -0.8),
      displayMedium: serif(size: 28, height: 1.1, letterSpacing: -0.6),
      headlineLarge: serif(size: 32, height: 1.12, letterSpacing: -0.7),
      headlineMedium: serif(size: 20, height: 1.2, letterSpacing: -0.3),
      headlineSmall: serif(size: 17, height: 1.28, letterSpacing: -0.2),
      titleLarge: serif(size: 18, height: 1.25, letterSpacing: -0.3),
      bodyLarge: sans(size: 15, height: 1.55),
      bodyMedium: sans(size: 14, height: 1.5),
      bodySmall: sans(size: 12, height: 1.45),
      labelSmall: mono(size: 10),
    ),
    dividerColor: paper.border,
    iconTheme: IconThemeData(color: paper.fg, size: 18),
    extensions: <ThemeExtension<dynamic>>[paper],
  );
}

extension PaperThemeContext on BuildContext {
  PaperColors get paper => Theme.of(this).extension<PaperColors>()!;
}
