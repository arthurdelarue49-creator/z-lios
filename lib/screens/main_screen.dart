import 'package:flutter/material.dart';
import '../theme.dart';

class MainScreen extends StatelessWidget {
  final String prenom;
  final String sexe;
  final int age;
  final double poids;
  final double taille;
  final String? photoPath;

  const MainScreen({
    super.key,
    required this.prenom,
    required this.sexe,
    required this.age,
    required this.poids,
    required this.taille,
    this.photoPath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SonaColors.background,
      body: Center(
        child: Text(
          'Bonjour $prenom 👋',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F6E56),
          ),
        ),
      ),
    );
  }
}
