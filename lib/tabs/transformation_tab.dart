import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../theme.dart';
import '../models/user_profile.dart';

class TransformationTab extends StatelessWidget {
  final UserProfile profile;

  const TransformationTab({super.key, required this.profile});

  Map<String, double> get _indicateursProgress {
    switch (profile.niveau) {
      case 'douceur':
        return {'souffle': 0.38, 'energie': 0.40, 'glycemie': 0.53};
      case 'actif':
        return {'souffle': 0.63, 'energie': 0.70, 'glycemie': 0.80};
      case 'tonification':
        return {'souffle': 0.75, 'energie': 0.80, 'glycemie': 0.67};
      default:
        return {'souffle': 0.50, 'energie': 0.50, 'glycemie': 0.33};
    }
  }

  List<Map<String, String>> get _programme {
    switch (profile.niveau) {
      case 'douceur':
        return [
          {'icon': '🚶', 'text': 'Marche 20 min/jour les 2 premières semaines'},
          {'icon': '💧', 'text': '1.5L d\'eau minimum par jour'},
          {'icon': '🚫', 'text': 'Supprimer sodas et jus sucrés'},
          {'icon': '😴', 'text': 'Viser 7-8h de sommeil par nuit'},
          {'icon': '🧘', 'text': '5 min d\'étirements le matin'},
        ];
      case 'actif':
        return [
          {'icon': '🚶', 'text': 'Marche rapide 30 min/jour'},
          {'icon': '🏊', 'text': '2 séances natation ou vélo par semaine'},
          {'icon': '🍽️', 'text': 'Réduire les portions de 20%'},
          {'icon': '💧', 'text': '2L d\'eau par jour'},
          {'icon': '😴', 'text': '7-8h de sommeil'},
        ];
      case 'tonification':
        return [
          {'icon': '🏃', 'text': '30 min cardio léger 4x/semaine'},
          {'icon': '💪', 'text': '2 séances muscu douce (squats, abdos, pompes)'},
          {'icon': '🥗', 'text': 'Alimentation équilibrée, léger déficit calorique'},
          {'icon': '💧', 'text': '2L d\'eau par jour'},
          {'icon': '📱', 'text': 'Tracker tes repas 3x/semaine'},
        ];
      default:
        return [
          {'icon': '🏃', 'text': '30 min activité physique 5x/semaine'},
          {'icon': '🥗', 'text': 'Maintenir l\'équilibre alimentaire actuel'},
          {'icon': '💧', 'text': '2L d\'eau par jour'},
          {'icon': '📊', 'text': 'Peser-toi 1x/semaine le matin'},
        ];
    }
  }

  Widget _buildPhoto(bool isAfter) {
    if (profile.photoPath == null) {
      return Container(
        width: isAfter ? 140 : 160,
        height: isAfter ? 185 : 210,
        decoration: BoxDecoration(
          color: SonaColors.primaryLight,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.person, size: 60, color: SonaColors.primary),
      );
    }
    final useNetwork = kIsWeb ||
        profile.photoPath!.startsWith('blob:') ||
        profile.photoPath!.startsWith('http');
    final double w = isAfter ? 140 : 160;
    final double h = isAfter ? 185 : 210;
    final base = ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: useNetwork
          ? Image.network(profile.photoPath!,
              width: w, height: h, fit: BoxFit.cover)
          : Image.file(File(profile.photoPath!),
              width: w, height: h, fit: BoxFit.cover),
    );
    if (!isAfter) return base;
    return Stack(children: [
      ColorFiltered(
        colorFilter: const ColorFilter.matrix([
          1.05, 0, 0, 0, 12,
          0, 1.05, 0, 0, 12,
          0, 0, 1.05, 0, 12,
          0, 0, 0, 1, 0,
        ]),
        child: base,
      ),
      Positioned.fill(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: SonaColors.primary.withValues(alpha: 0.08),
          ),
        ),
      ),
    ]);
  }

  Widget _buildCard({required Widget child}) => Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: child,
      );

  Widget _buildIndicateur(
      String icon, String label, String valeur, double progress) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: progress),
      duration: const Duration(milliseconds: 1500),
      curve: Curves.easeOut,
      builder: (_, value, __) => Row(children: [
        Text(icon, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF1A3D2B),
                        fontWeight: FontWeight.w500)),
                Text(valeur,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: SonaColors.primary)),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: value,
                backgroundColor: const Color(0xFFE8E8E8),
                valueColor:
                    const AlwaysStoppedAnimation(Color(0xFF4CAF50)),
                minHeight: 8,
              ),
            ),
          ]),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = _indicateursProgress;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: Column(children: [
            // ── Carte avant/après ──
            _buildCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Ta projection Sona 🌿',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F6E56))),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(children: [
                      const Text('Aujourd\'hui',
                          style: TextStyle(fontSize: 12, color: Color(0xFF8A9E94))),
                      const SizedBox(height: 8),
                      _buildPhoto(false),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F0F0),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${profile.poids.toStringAsFixed(1)} kg',
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF555555)),
                        ),
                      ),
                    ]),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Icon(Icons.arrow_forward,
                          color: SonaColors.primary, size: 22),
                    ),
                    Column(children: [
                      const Text('Dans 3 mois',
                          style: TextStyle(
                              fontSize: 12,
                              color: SonaColors.primary,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      _buildPhoto(true),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDDF5E8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${profile.poidsCible.toStringAsFixed(1)} kg',
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1B8A4F)),
                        ),
                      ),
                    ]),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Projection estimée — résultats individuels variables.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF8A9E94),
                      fontStyle: FontStyle.italic),
                ),
              ]),
            ),

            // ── Indicateurs santé ──
            _buildCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Tes indicateurs à 3 mois',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F6E56))),
                const SizedBox(height: 16),
                _buildIndicateur('💨', 'Souffle',
                    profile.indicateurSouffle, progress['souffle']!),
                const SizedBox(height: 12),
                _buildIndicateur('⚡', 'Énergie',
                    profile.indicateurEnergie, progress['energie']!),
                const SizedBox(height: 12),
                _buildIndicateur('🩸', 'Glycémie',
                    profile.indicateurGlycemie, progress['glycemie']!),
              ]),
            ),

            // ── Programme de départ ──
            _buildCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Ton programme de départ 🌱',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F6E56))),
                const SizedBox(height: 4),
                const Text('Semaines 1 à 4 — adapté à ton profil',
                    style: TextStyle(fontSize: 12, color: Color(0xFF8A9E94))),
                const SizedBox(height: 16),
                ..._programme.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['icon']!,
                              style: const TextStyle(fontSize: 16)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(item['text']!,
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF1A3D2B),
                                    height: 1.4)),
                          ),
                        ],
                      ),
                    )),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}
