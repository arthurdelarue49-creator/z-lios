import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/onboarding_screen.dart';

void main() {
  runApp(const ZeliosApp());
}

class ZeliosApp extends StatelessWidget {
  const ZeliosApp({super.key});

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
