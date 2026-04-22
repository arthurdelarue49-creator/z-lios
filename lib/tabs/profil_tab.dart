import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme.dart';
import '../screens/legal_screen.dart';

class ProfilTab extends StatelessWidget {
  final String prenom;
  final String sexe;
  final int age;
  final double poids;
  final double taille;

  const ProfilTab({
    super.key,
    required this.prenom,
    required this.sexe,
    required this.age,
    required this.poids,
    required this.taille,
  });

  double get _imc => poids / ((taille / 100) * (taille / 100));

  String get _niveau {
    if (_imc >= 35) return 'Douceur';
    if (_imc >= 30) return 'Actif';
    if (_imc >= 25) return 'Tonification';
    return 'Maintien';
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

  Widget _buildLigne(String icon, String label, String valeur) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Row(children: [
          Text(icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label,
                style: const TextStyle(
                    fontSize: 14, color: Color(0xFF5A8A6A))),
          ),
          Text(valeur,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A3D2B))),
        ]),
      );

  Widget _buildLien(
          String icon, String label, VoidCallback onTap) =>
      InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(children: [
            Text(icon, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label,
                  style: const TextStyle(
                      fontSize: 14, color: Color(0xFF1A3D2B))),
            ),
            const Icon(Icons.chevron_right,
                size: 20, color: Color(0xFFB0B0B0)),
          ]),
        ),
      );

  void _supprimerDonnees(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Supprimer mes données',
            style: TextStyle(
                fontWeight: FontWeight.w700, color: Color(0xFF1A3D2B))),
        content: const Text(
          'Cette action est irréversible. Toutes tes données seront définitivement effacées.',
          style: TextStyle(fontSize: 14, color: Color(0xFF5A8A6A), height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler',
                style: TextStyle(color: Color(0xFF9E9E9E))),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('🗑️ Données supprimées')));
                Navigator.of(context).popUntil((r) => r.isFirst);
              }
            },
            child: const Text('Supprimer',
                style: TextStyle(
                    color: Color(0xFFD32F2F),
                    fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
          child: Column(
            children: [
              // ── SECTION 1 : Avatar & nom ──
              Column(children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: SonaColors.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      prenom.isNotEmpty
                          ? prenom[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F6E56),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  prenom,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F6E56),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'IMC ${_imc.toStringAsFixed(1)} · $_niveau',
                  style: const TextStyle(
                      fontSize: 13, color: Color(0xFF9E9E9E)),
                ),
              ]),
              const SizedBox(height: 24),

              // ── SECTION 2 : Mes données ──
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Mes données',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F6E56))),
                    const SizedBox(height: 16),
                    _buildLigne('👤', 'Prénom', prenom),
                    _buildLigne('⚥', 'Sexe', sexe),
                    _buildLigne('🎂', 'Âge', '$age ans'),
                    _buildLigne('⚖️', 'Poids', '${poids.toStringAsFixed(1)} kg'),
                    _buildLigne('📏', 'Taille', '${taille.toStringAsFixed(0)} cm'),
                    _buildLigne('📊', 'IMC', _imc.toStringAsFixed(1)),
                    const SizedBox(height: 4),
                    TextButton(
                      onPressed: () =>
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('✏️ Modification à venir'))),
                      child: const Text('Modifier mes données',
                          style: TextStyle(
                              color: SonaColors.primary,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),

              // ── SECTION 3 : Paramètres ──
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Paramètres',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F6E56))),
                    const SizedBox(height: 8),
                    _buildLien('🔒', 'Politique de confidentialité', () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const LegalScreen(
                                    title: 'Politique de confidentialité',
                                    url: 'https://www.notion.so/348dae09b61b81c0a0f2c4fe1fb75d55',
                                  )));
                    }),
                    const Divider(height: 1, color: Color(0xFFF0F0F0)),
                    _buildLien('⚖️', 'CGU', () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const LegalScreen(
                                    title: 'Conditions générales d\'utilisation',
                                    url: 'https://www.notion.so/348dae09b61b81f993d0f55ec9212551',
                                  )));
                    }),
                    const Divider(height: 1, color: Color(0xFFF0F0F0)),
                    _buildLien('📋', 'Mentions légales', () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const LegalScreen(
                                    title: 'Mentions légales',
                                    url: 'https://www.notion.so/348dae09b61b81abbebaddfab86f641e',
                                  )));
                    }),
                    const Divider(height: 1, color: Color(0xFFF0F0F0)),
                    _buildLien('🗑️', 'Supprimer mes données',
                        () => _supprimerDonnees(context)),
                  ],
                ),
              ),

              // ── SECTION 5 : Version ──
              const SizedBox(height: 8),
              const Text(
                'Sona v1.0.0 · Fait avec 🌿 en France',
                style: TextStyle(fontSize: 12, color: Color(0xFFCCCCCC)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
