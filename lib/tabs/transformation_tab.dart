import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../theme.dart';
import '../models/user_profile.dart';

class ResultatScreen extends StatelessWidget {
  final UserProfile profile;

  const ResultatScreen({
    super.key,
    required this.profile,
  });

  Map<String, double> get _indicateursProgress {
    switch (profile.niveau) {
      case 'douceur': return {'souffle': 0.38, 'energie': 0.40, 'glycemie': 0.53};
      case 'actif': return {'souffle': 0.63, 'energie': 0.70, 'glycemie': 0.80};
      case 'tonification': return {'souffle': 0.75, 'energie': 0.80, 'glycemie': 0.67};
      default: return {'souffle': 0.50, 'energie': 0.50, 'glycemie': 0.33};
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
        width: 150,
        height: 200,
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
    final base = ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: useNetwork
          ? Image.network(profile.photoPath!, width: 150, height: 200, fit: BoxFit.cover)
          : Image.file(File(profile.photoPath!), width: 150, height: 200, fit: BoxFit.cover),
    );
    if (!isAfter) return base;
    return Stack(
      children: [
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
              color: SonaColors.primary.withOpacity(0.08),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildIndicateur(
      String icon, String label, String valeur, double progress) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: progress),
      duration: const Duration(milliseconds: 1500),
      curve: Curves.easeOut,
      builder: (_, value, __) => Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = _indicateursProgress;
    final programme = _programme;

    return Scaffold(
      backgroundColor: SonaColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back_ios_new,
                          size: 16, color: Color(0xFF1A3D2B)),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Ton résultat',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A3D2B)),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                      decoration: BoxDecoration(
                        color: SonaColors.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        '✨ Projection personnalisée',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ta transformation en 3 mois',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0D4F3C)),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(children: [
                                const Text('Aujourd\'hui',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF8A9E94))),
                                const SizedBox(height: 8),
                                _buildPhoto(false),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
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
                            'Projection estimée basée sur le programme Sona.\nRésultats individuels variables.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF8A9E94),
                                fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    _buildCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tes indicateurs santé',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0D4F3C)),
                          ),
                          const SizedBox(height: 16),
                          _buildIndicateur('💨', 'Souffle',
                              profile.indicateurSouffle, progress['souffle']!),
                          const SizedBox(height: 12),
                          _buildIndicateur('⚡', 'Énergie',
                              profile.indicateurEnergie, progress['energie']!),
                          const SizedBox(height: 12),
                          _buildIndicateur('🩸', 'Glycémie',
                              profile.indicateurGlycemie, progress['glycemie']!),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    _buildCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ton programme de départ 🌱',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0D4F3C)),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Semaines 1 à 4 — adapté à ton profil',
                            style: TextStyle(
                                fontSize: 12, color: Color(0xFF8A9E94)),
                          ),
                          const SizedBox(height: 16),
                          ...programme.map(
                            (item) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item['icon']!,
                                      style: const TextStyle(fontSize: 16)),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      item['text']!,
                                      style: const TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF1A3D2B),
                                          height: 1.4),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF1B5E20), Color(0xFF4CAF50)],
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFD700),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              '⭐ PREMIUM',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF7A5500),
                                  letterSpacing: 1),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Débloquer ton programme complet',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Programme semaine par semaine · Projections 6 et 12 mois · Suivi de progression · Programme d\'entraînement personnalisé',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.85),
                                height: 1.5),
                          ),
                          const SizedBox(height: 16),
                          ...[
                            'Programme semaine par semaine',
                            'Projections à 6 et 12 mois',
                            'Suivi de progression',
                            'Entraînement personnalisé',
                          ].map(
                            (f) => Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Row(children: [
                                const Icon(Icons.check,
                                    color: Colors.white, size: 16),
                                const SizedBox(width: 8),
                                Text(f,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 13)),
                              ]),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () =>
                                  ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('🚧 Paiement à venir !')),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF1B5E20),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14)),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Commencer — 4.99€/mois',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Résiliable à tout moment · 7 jours gratuits',
                            style: TextStyle(
                                fontSize: 11,
                                color: Colors.white.withOpacity(0.7)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    OutlinedButton(
                      onPressed: () =>
                          Navigator.of(context).popUntil((r) => r.isFirst),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: SonaColors.primary,
                        side: const BorderSide(
                            color: SonaColors.primary, width: 1.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 14),
                      ),
                      child: const Text(
                        'Recommencer une analyse',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
