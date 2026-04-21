import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../theme.dart';
import '../models/user_profile.dart';

// ─── ÉCRAN PROGRAMME ─────────────────────────────────────────────────────────

class ProgrammeScreen extends StatefulWidget {
  final UserProfile profile;

  const ProgrammeScreen({
    super.key,
    required this.profile,
  });

  @override
  State<ProgrammeScreen> createState() => _ProgrammeScreenState();
}

class _ProgrammeScreenState extends State<ProgrammeScreen> {
  late String _pas;
  late String _footing;
  late String _eau;
  late String _sommeil;
  late String _calories;
  final _sportController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final imc = widget.profile.imc;
    _pas = imc >= 35 ? '3 000' : imc >= 30 ? '5 000' : imc >= 25 ? '7 500' : '10 000';
    _footing = imc >= 35 ? '1x' : imc >= 30 ? '2x' : '3x';
    _eau = imc >= 35 ? '1.5L' : '2L';
    _sommeil = '7h';
    _calories = imc >= 35
        ? '1 400'
        : imc >= 30
            ? '1 700'
            : imc >= 25
                ? '2 000'
                : '2 300';
  }

  @override
  void dispose() {
    _sportController.dispose();
    super.dispose();
  }

  void _naviguerVersResultat() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultatProgrammeScreen(
          profile: widget.profile,
          pas: _pas,
          footing: _footing,
          eau: _eau,
          sommeil: _sommeil,
          calories: _calories,
        ),
      ),
    );
  }

  void _lancerProgramme() {
    final sport = _sportController.text.trim();
    if (sport.isEmpty) {
      _naviguerVersResultat();
      return;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
            24, 16, 24, MediaQuery.of(ctx).viewInsets.bottom + 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFDDEEE5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFFD700),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text('⭐ PREMIUM',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF7A5500),
                      letterSpacing: 1)),
            ),
            const SizedBox(height: 16),
            const Text(
              'Un sport en plus, des résultats en plus',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0D4F3C)),
            ),
            const SizedBox(height: 8),
            Text(
              "Ajouter '$sport' à ton programme et accéder aux projections avancées.",
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 13, color: Color(0xFF8A9E94), height: 1.5),
            ),
            const SizedBox(height: 16),
            ...[
              "Sport '$sport' intégré au programme",
              'Projections 6 et 12 mois débloquées',
              'Suivi semaine par semaine',
              "Programme d'entraînement personnalisé",
            ].map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(children: [
                    const Icon(Icons.check_circle,
                        color: SonaColors.primary, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                        child: Text(f,
                            style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF1A3D2B)))),
                  ]),
                )),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('🚧 Paiement à venir !')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: SonaColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                ),
                child: const Text('Débloquer — 4.99€/mois',
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                _naviguerVersResultat();
              },
              child: const Text('Continuer sans ce sport',
                  style: TextStyle(color: Color(0xFF8A9E94))),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoto(bool isAfter) {
    final path = widget.profile.photoPath;
    if (path == null) {
      return Container(
        width: 140,
        height: 190,
        decoration: BoxDecoration(
          color: SonaColors.primaryLight,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.person, size: 52, color: SonaColors.primary),
      );
    }
    final useNetwork = kIsWeb || path.startsWith('blob:') || path.startsWith('http');
    final base = ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: useNetwork
          ? Image.network(path, width: 140, height: 190, fit: BoxFit.cover)
          : Image.file(File(path), width: 140, height: 190, fit: BoxFit.cover),
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
            borderRadius: BorderRadius.circular(16),
            color: SonaColors.primary.withOpacity(0.06),
          ),
        ),
      ),
    ]);
  }

  Widget _buildAvantApres() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ta transformation en 3 mois',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0D4F3C)),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Column(children: [
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
                      '${widget.profile.poids.toStringAsFixed(1)} kg',
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF555555)),
                    ),
                  ),
                ]),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(Icons.arrow_forward,
                    color: SonaColors.primary, size: 20),
              ),
              Expanded(
                child: Column(children: [
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
                      '${widget.profile.poidsCible.toStringAsFixed(1)} kg',
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1B8A4F)),
                    ),
                  ),
                ]),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Projection estimée — résultats individuels variables.',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 11,
                color: Color(0xFF8A9E94),
                fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required Widget child}) => Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
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

  Widget _buildCategorie(
    String titre,
    String sousTitre,
    List<String> valeurs,
    String selected,
    void Function(String) onSelect,
  ) =>
      _buildCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titre,
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0D4F3C))),
            const SizedBox(height: 4),
            Text(sousTitre,
                style: const TextStyle(
                    fontSize: 12, color: Color(0xFF8A9E94))),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: valeurs.map((v) {
                final sel = v == selected;
                return GestureDetector(
                  onTap: () => onSelect(v),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 9),
                    decoration: BoxDecoration(
                      color: sel
                          ? SonaColors.primary
                          : SonaColors.primaryLight,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: sel
                            ? SonaColors.primary
                            : SonaColors.primaryBorder,
                      ),
                    ),
                    child: Text(v,
                        style: TextStyle(
                          color: sel
                              ? Colors.white
                              : SonaColors.primaryDark,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        )),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SonaColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                      child: const Icon(Icons.arrow_back_ios_new,
                          size: 16, color: Color(0xFF1A3D2B)),
                    ),
                  ),
                  const Expanded(
                    child: Text('Mon programme',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A3D2B))),
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
                    _buildAvantApres(),
                    _buildCategorie(
                      'Nombre de pas / jour',
                      'Objectif quotidien recommandé',
                      ['3 000', '5 000', '7 500', '10 000'],
                      _pas,
                      (v) => setState(() => _pas = v),
                    ),
                    _buildCategorie(
                      'Footing / semaine',
                      'Sorties course à pied',
                      ['1x', '2x', '3x', '4x'],
                      _footing,
                      (v) => setState(() => _footing = v),
                    ),
                    _buildCategorie(
                      'Eau / jour',
                      'Hydratation quotidienne',
                      ['1L', '1.5L', '2L', '2.5L'],
                      _eau,
                      (v) => setState(() => _eau = v),
                    ),
                    _buildCategorie(
                      'Sommeil / nuit',
                      'Durée de sommeil visée',
                      ['6h', '7h', '8h', '9h'],
                      _sommeil,
                      (v) => setState(() => _sommeil = v),
                    ),
                    _buildCategorie(
                      'Calories / jour',
                      'Objectif calorique indicatif',
                      ['1 400', '1 700', '2 000', '2 300'],
                      _calories,
                      (v) => setState(() => _calories = v),
                    ),
                    _buildCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Ajouter un sport',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0D4F3C))),
                          const SizedBox(height: 4),
                          const Text('Envie d\'aller plus loin ?',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF8A9E94))),
                          const SizedBox(height: 12),
                          Container(
                            decoration: BoxDecoration(
                              color: SonaColors.background,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextField(
                              controller: _sportController,
                              decoration: const InputDecoration(
                                hintText: 'Ex: piscine, vélo, yoga...',
                                hintStyle: TextStyle(
                                    color: Color(0xFFAACCBB), fontSize: 14),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 14),
                              ),
                              style: const TextStyle(
                                  fontSize: 14, color: Color(0xFF1A3D2B)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _lancerProgramme,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: SonaColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          padding:
                              const EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                        ),
                        child: const Text('Lancer mon programme 🚀',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700)),
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

// ─── ÉCRAN RÉSULTAT DU PROGRAMME ─────────────────────────────────────────────

class ResultatProgrammeScreen extends StatelessWidget {
  final UserProfile profile;
  final String pas;
  final String footing;
  final String eau;
  final String sommeil;
  final String calories;

  const ResultatProgrammeScreen({
    super.key,
    required this.profile,
    required this.pas,
    required this.footing,
    required this.eau,
    required this.sommeil,
    required this.calories,
  });

  Map<String, double> get _progress {
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

  Widget _buildCard({required Widget child}) => Container(
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
    final prog = _progress;
    final etapes = [
      ('Mois 1', 'Mise en route', 'Installer les habitudes'),
      ('Mois 2', 'Accélération', 'Le corps s\'adapte'),
      ('Mois 3', 'Transformation', 'Les vrais résultats arrivent'),
    ];

    return Scaffold(
      backgroundColor: SonaColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                      child: const Icon(Icons.arrow_back_ios_new,
                          size: 16, color: Color(0xFF1A3D2B)),
                    ),
                  ),
                  const Expanded(
                    child: Text('Ton programme est prêt !',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A3D2B))),
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
                    _buildCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Tes objectifs semaine 1-4 🌱',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0D4F3C))),
                          const SizedBox(height: 16),
                          ...[
                            ('🚶', 'Pas / jour', pas),
                            ('🏃', 'Footing', footing),
                            ('💧', 'Eau', eau),
                            ('😴', 'Sommeil', sommeil),
                            ('🍽️', 'Calories', calories),
                          ].map((e) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(children: [
                                  Text(e.$1,
                                      style:
                                          const TextStyle(fontSize: 18)),
                                  const SizedBox(width: 10),
                                  Expanded(
                                      child: Text(e.$2,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFF1A3D2B)))),
                                  Text(e.$3,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: SonaColors.primary)),
                                ]),
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Tes indicateurs à 3 mois',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0D4F3C))),
                          const SizedBox(height: 16),
                          _buildIndicateur('💨', 'Souffle',
                              profile.indicateurSouffle, prog['souffle']!),
                          const SizedBox(height: 12),
                          _buildIndicateur('⚡', 'Énergie',
                              profile.indicateurEnergie, prog['energie']!),
                          const SizedBox(height: 12),
                          _buildIndicateur('🩸', 'Glycémie',
                              profile.indicateurGlycemie, prog['glycemie']!),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Ta feuille de route 🗺️',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0D4F3C))),
                          const SizedBox(height: 20),
                          ...etapes.asMap().entries.map((entry) {
                            final i = entry.key;
                            final e = entry.value;
                            final isLast = i == etapes.length - 1;
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: const BoxDecoration(
                                        color: SonaColors.primary,
                                        shape: BoxShape.circle),
                                    child: Center(
                                      child: Text('${i + 1}',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14)),
                                    ),
                                  ),
                                  if (!isLast)
                                    Container(
                                        width: 2,
                                        height: 44,
                                        color: const Color(0xFF5DCAA5)),
                                ]),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        bottom: isLast ? 0 : 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(e.$1,
                                            style: const TextStyle(
                                                fontSize: 11,
                                                color: Color(0xFF8A9E94))),
                                        Text(e.$2,
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xFF0D4F3C))),
                                        Text(e.$3,
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF8A9E94))),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () =>
                          ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('🚧 Paiement à venir !')),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: const Color(0xFF5DCAA5), width: 1.5),
                        ),
                        child: Row(children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                                color: SonaColors.primaryLight,
                                shape: BoxShape.circle),
                            child: const Center(
                                child: Text('⭐',
                                    style: TextStyle(fontSize: 18))),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Voir ta projection à 6 et 12 mois',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF0D4F3C))),
                                Text(
                                    'Sport personnalisé · Suivi avancé · 4.99€/mois',
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF8A9E94))),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right,
                              color: SonaColors.primary),
                        ]),
                      ),
                    ),
                    const SizedBox(height: 24),
                    OutlinedButton(
                      onPressed: () => Navigator.of(context)
                          .popUntil((r) => r.isFirst),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: SonaColors.primary,
                        side: const BorderSide(
                            color: SonaColors.primary, width: 1.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 14),
                      ),
                      child: const Text('Recommencer une analyse',
                          style: TextStyle(fontWeight: FontWeight.w600)),
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
