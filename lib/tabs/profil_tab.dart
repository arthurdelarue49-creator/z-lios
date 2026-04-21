import 'package:flutter/material.dart';
import '../theme.dart';
import '../models/user_profile.dart';

class ProfilTab extends StatelessWidget {
  final UserProfile profile;
  const ProfilTab({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SonaColors.background,
      body: Center(
        child: Text(
          '${profile.prenom} · ${profile.age} ans',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0F6E56),
          ),
        ),
      ),
    );
  }
}
