import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/onboarding_screen.dart';

void main() {
  runApp(const SonaApp());
}

class SonaApp extends StatelessWidget {
  const SonaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sona',
      debugShowCheckedModeBanner: false,
      theme: SonaTheme.theme,
      home: const SplashScreen(),
    );
  }
}
