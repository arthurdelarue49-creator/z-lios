import 'package:flutter/material.dart';

void main() {
  runApp(const ZeliosApp());
}

class ZeliosApp extends StatelessWidget {
  const ZeliosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zélios',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3DBE6E)),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Spacer(),
              const Text(
                '🌿',
                style: TextStyle(fontSize: 120),
              ),
              const SizedBox(height: 32),
              const Text(
                'Zélios',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3DBE6E),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Et si tu pouvais te voir dans 3 mois ?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF2D6A4F),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3DBE6E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'COMMENCER',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}