import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../theme.dart';
import '../models/user_profile.dart';

class AccueilTab extends StatelessWidget {
  final UserProfile profile;
  final void Function(int) onTabChange;

  const AccueilTab({
    super.key,
    required this.profile,
    required this.onTabChange,
  });

  String _formatDate() {
    final now = DateTime.now();
    const days = ['lun.', 'mar.', 'mer.', 'jeu.', 'ven.', 'sam.', 'dim.'];
    const months = [
      'janv.', 'févr.', 'mars', 'avr.', 'mai', 'juin',
      'juil.', 'août', 'sept.', 'oct.', 'nov.', 'déc.'
    ];
    return '${days[now.weekday - 1]} ${now.day} ${months[now.month - 1]}';
  }

  String get _pas {
    final i = profile.imc;
    return i >= 35 ? '3 000' : i >= 30 ? '5 000' : i >= 25 ? '7 500' : '10 000';
  }

  String get _eau => profile.imc >= 35 ? '1.5' : '2';

  String get _cal {
    final i = profile.imc;
    return i >= 35 ? '1 400' : i >= 30 ? '1 700' : i >= 25 ? '2 000' : '2 300';
  }

  String get _foot {
    final i = profile.imc;
    return i >= 35 ? '1x' : i >= 30 ? '2x' : '3x';
  }

  Widget _buildPhoto(bool isAfter) {
    final path = profile.photoPath;
    if (path == null) {
      return Container(
        width: double.infinity,
        height: 150,
        decoration: BoxDecoration(
          color: SonaColors.primaryLight,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.person, size: 48, color: SonaColors.primary),
      );
    }
    final useNetwork =
        kIsWeb || path.startsWith('blob:') || path.startsWith('http');
    final base = ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: useNetwork
          ? Image.network(path,
              width: double.infinity, height: 150, fit: BoxFit.cover)
          : Image.file(File(path),
              width: double.infinity, height: 150, fit: BoxFit.cover),
    );
    if (!isAfter) return base;
    return Stack(children: [
      ColorFiltered(
        colorFilter: const ColorFilter.matrix([
          1.05, 0, 0, 0, 10,
          0, 1.05, 0, 0, 10,
          0, 0, 1.05, 0, 10,
          0, 0, 0, 1, 0,
        ]),
        child: base,
      ),
      Positioned.fill(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: SonaColors.primary.withValues(alpha: 0.06),
          ),
        ),
      ),
    ]);
  }

  Widget _buildCard({required Widget child}) => Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: child,
      );

  @override
  Widget build(BuildContext context) {
    final objectifs = [
      ('🚶', 'Marche', '$_pas pas aujourd\'hui'),
      ('💧', 'Eau', '$_eau L d\'eau'),
      ('🍽️', 'Calories', '$_cal kcal max'),
      ('😴', 'Sommeil', '7h cette nuit'),
      ('🏃', 'Footing', '$_foot /semaine'),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: Column(
            children: [
              // ── SECTION 1 : HEADER ──
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Bonjour ${profile.prenom} 👋',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F6E56),
                          ),
                        ),
                        Text(
                          _formatDate(),
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF9E9E9E),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: SonaColors.primaryLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'IMC ${profile.imc.toStringAsFixed(1)} — Niveau ${profile.niveau}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0F6E56),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── SECTION 2 : AVANT/APRÈS ──
              GestureDetector(
                onTap: () => onTabChange(1),
                child: _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ta transformation',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F6E56),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Column(children: [
                              const Text('Aujourd\'hui',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF8A9E94))),
                              const SizedBox(height: 6),
                              _buildPhoto(false),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0F0F0),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '${profile.poids.toStringAsFixed(1)} kg',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF555555)),
                                ),
                              ),
                            ]),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Icon(Icons.arrow_forward,
                                color: SonaColors.primary, size: 18),
                          ),
                          Expanded(
                            child: Column(children: [
                              const Text('Dans 3 mois',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: SonaColors.primary,
                                      fontWeight: FontWeight.w600)),
                              const SizedBox(height: 6),
                              _buildPhoto(true),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDDF5E8),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '${profile.poidsCible.toStringAsFixed(1)} kg',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1B8A4F)),
                                ),
                              ),
                            ]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Projection estimée — résultats individuels variables.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF8A9E94),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── SECTION 3 : OBJECTIFS DU JOUR ──
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tes objectifs aujourd\'hui 🎯',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F6E56),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Programme de base — semaine 1',
                      style:
                          TextStyle(fontSize: 12, color: Color(0xFF9E9E9E)),
                    ),
                    const SizedBox(height: 14),
                    ...objectifs.map((e) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(children: [
                            Text(e.$1,
                                style: const TextStyle(fontSize: 18)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                e.$2,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF1A3D2B),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Text(
                              e.$3,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: SonaColors.primary,
                              ),
                            ),
                          ]),
                        )),
                  ],
                ),
              ),

              // ── SECTION 4 : BOUTON PERSONNALISER ──
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => onTabChange(2),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF1D9E75),
                    side: const BorderSide(
                        color: Color(0xFF1D9E75), width: 1.5),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Personnaliser mon programme →',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
