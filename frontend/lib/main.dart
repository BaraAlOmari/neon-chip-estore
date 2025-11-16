import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app.dart';
import 'state/cart_store.dart';
import 'state/order_store.dart';
import 'state/product_store.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NeonChipApp());
}

class NeonChipApp extends StatelessWidget {
  const NeonChipApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartStore()..initialize()),
        ChangeNotifierProvider(create: (_) => ProductStore()..load()),
        ChangeNotifierProvider(create: (_) => OrderStore()),
      ],
      child: MaterialApp(
        title: 'Neon Chip E-shop',
        theme: _neonDarkTheme(),
        home: const AppShell(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

ThemeData _neonDarkTheme() {
  const bg = Color(0xFF0B0F1A);
  const surface = Color(0xFF11162A);
  const neonCyan = Color(0xFF00E5FF);
  const neonPink = Color(0xFFFF00D4);
  final scheme = ColorScheme.fromSeed(
    seedColor: neonCyan,
    brightness: Brightness.dark,
    background: bg,
    primary: neonCyan,
    secondary: neonPink,
  );
  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: scheme,
    scaffoldBackgroundColor: bg,
    cardColor: surface,
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFF0F1530),
      border: OutlineInputBorder(borderSide: BorderSide(color: Color(0x3300E5FF))),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: neonCyan,
        foregroundColor: Colors.black,
        shadowColor: neonCyan,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: neonCyan,
        foregroundColor: Colors.black,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: neonCyan),
        foregroundColor: neonCyan,
      ),
    ),
  );

  final jersey = GoogleFonts.jersey25TextTheme(base.textTheme);
  final jerseyPrimary = GoogleFonts.jersey25TextTheme(base.primaryTextTheme);
  final bumped = _bumpTextTheme(jersey, 3);
  final bumpedPrimary = _bumpTextTheme(jerseyPrimary, 3);

  return base.copyWith(
    textTheme: bumped,
    primaryTextTheme: bumpedPrimary,
    appBarTheme: base.appBarTheme.copyWith(
      // Explicit 28px title for the app bar
      titleTextStyle: bumped.titleLarge?.copyWith(
        color: Colors.white,
        fontSize: 28,
      ),
    ),
  );
}

TextTheme _bumpTextTheme(TextTheme theme, double delta) {
  TextStyle? bump(TextStyle? style) =>
      style?.copyWith(fontSize: (style.fontSize ?? 14) + delta);

  return theme.copyWith(
    displayLarge: bump(theme.displayLarge),
    displayMedium: bump(theme.displayMedium),
    displaySmall: bump(theme.displaySmall),
    headlineLarge: bump(theme.headlineLarge),
    headlineMedium: bump(theme.headlineMedium),
    headlineSmall: bump(theme.headlineSmall),
    titleLarge: bump(theme.titleLarge),
    titleMedium: bump(theme.titleMedium),
    titleSmall: bump(theme.titleSmall),
    bodyLarge: bump(theme.bodyLarge),
    bodyMedium: bump(theme.bodyMedium),
    bodySmall: bump(theme.bodySmall),
    labelLarge: bump(theme.labelLarge),
    labelMedium: bump(theme.labelMedium),
    labelSmall: bump(theme.labelSmall),
  );
}
