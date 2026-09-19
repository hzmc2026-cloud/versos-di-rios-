import 'package:flutter/material.dart';
import 'package:versos_diarios/services/notification_service.dart';
import 'package:versos_diarios/views/card_creator_screen.dart';
import 'package:versos_diarios/views/devotional_screen.dart';
import 'package:versos_diarios/views/home_screen.dart';
import 'package:versos_diarios/views/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await NotificationService.instance.init();
  } catch (_) {
    // Notificações são opcionais: o app segue funcionando sem elas.
  }
  runApp(const VersosDiariosApp());
}

/// Identidade visual do "Versos Diários":
/// - Azul Celestial/Nobre #1E3A8A como cor principal
/// - Dourado suave #D97706 nos destaques
/// - Fundo creme/claro acolhedor #FDF6E9
class VersosDiariosApp extends StatelessWidget {
  const VersosDiariosApp({super.key});

  static const Color celestialBlue = Color(0xFF1E3A8A);
  static const Color softGold = Color(0xFFD97706);
  static const Color creamBackground = Color(0xFFFDF6E9);
  static const Color goldLight = Color(0xFFFBBF24);

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: celestialBlue,
      primary: celestialBlue,
      secondary: softGold,
      surface: creamBackground,
    );

    return MaterialApp(
      title: 'Versos Diários',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: creamBackground,
        appBarTheme: const AppBarTheme(
          backgroundColor: celestialBlue,
          foregroundColor: Colors.white,
          elevation: 2,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: celestialBlue,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: celestialBlue,
            side: const BorderSide(color: softGold, width: 1.5),
            textStyle: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: softGold,
          foregroundColor: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        cardTheme: const CardThemeData(color: Colors.white),
        textTheme: ThemeData.light().textTheme.apply(
              bodyColor: const Color(0xFF3E3226),
              displayColor: celestialBlue,
            ),
      ),
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (_) => const SplashScreen(),
        HomeScreen.routeName: (_) => const HomeScreen(),
        DevotionalScreen.routeName: (_) => const DevotionalScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == CardCreatorScreen.routeName) {
          final args = settings.arguments;
          if (args is Map && args['verse'] != null) {
            return MaterialPageRoute(
              builder: (_) => CardCreatorScreen(verse: args['verse']),
            );
          }
        }
        return null;
      },
    );
  }
}
