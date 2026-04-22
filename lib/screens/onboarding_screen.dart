import 'package:flutter/material.dart';
import '../theme.dart';
import '../models/user_profile.dart';
import 'camera_screen.dart';
import 'legal_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _prenomController = TextEditingController();
  final _ageController = TextEditingController();
  final _poidsController = TextEditingController();
  final _tailleController = TextEditingController();
  String _sexe = 'Femme';
  bool _acceptedTerms = false;
  bool _acceptedMarketing = false;

  void _validerEtContinuer(BuildContext context) {
    final prenom = _prenomController.text.trim();
    final ageStr = _ageController.text.trim();
    final poidsStr = _poidsController.text.trim();
    final tailleStr = _tailleController.text.trim();

    void snack(String msg) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg),
        backgroundColor: const Color(0xFFD32F2F),
        behavior: SnackBarBehavior.floating,
      ));
    }

    if (prenom.isEmpty) {
      snack('👤 Entre ton prénom pour continuer');
      return;
    }

    final age = int.tryParse(ageStr);
    if (ageStr.isEmpty || age == null || age < 10 || age > 120) {
      snack('🎂 Vérifie ton âge (entre 10 et 120 ans)');
      return;
    }

    final poids = double.tryParse(poidsStr);
    if (poidsStr.isEmpty || poids == null || poids < 20 || poids > 300) {
      snack('⚖️ Vérifie ton poids (entre 20 et 300 kg)');
      return;
    }

    final taille = double.tryParse(tailleStr);
    if (tailleStr.isEmpty || taille == null || taille < 50 || taille > 250) {
      snack('📏 Vérifie ta taille (entre 50 et 250 cm)');
      return;
    }

    final profile = UserProfile(
      prenom: prenom,
      sexe: _sexe,
      age: age,
      poids: poids,
      taille: taille,
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CameraScreen(profile: profile),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SonaColors.primaryLight,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 32),
              // Mascotte dans cercle blanc
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Image.network(
                    'https://i.imgur.com/xYXzVvh.png',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Nom app
              const Text(
                'Sona',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: SonaColors.primary,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Commençons ensemble',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A3D2B),
                ),
              ),
              const SizedBox(height: 6),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'Toi, dans 3 mois.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF5A8A6A),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Carte formulaire
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Prénom
                    _buildLabel('PRÉNOM'),
                    _buildTextField(
                      controller: _prenomController,
                      hint: 'Entrez votre prénom...',
                      isNumber: false,
                    ),
                    const SizedBox(height: 20),

                    // Sexe
                    _buildLabel('SEXE'),
                    const SizedBox(height: 8),
                    Row(
                      children: ['Femme', 'Homme', 'Autre'].map((s) {
                        final selected = _sexe == s;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _sexe = s),
                            child: Container(
                              margin: EdgeInsets.only(
                                right: s != 'Autre' ? 8 : 0,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: selected
                                    ? SonaColors.primary
                                    : const Color(0xFFF0F7F3),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  s,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: selected
                                        ? Colors.white
                                        : const Color(0xFF5A8A6A),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    // Âge
                    _buildLabel('ÂGE'),
                    _buildTextField(
                      controller: _ageController,
                      hint: '28',
                      isNumber: true,
                      suffix: 'ans',
                    ),
                    const SizedBox(height: 20),

                    // Poids + Taille
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('POIDS'),
                              _buildTextField(
                                controller: _poidsController,
                                hint: '65',
                                isNumber: true,
                                suffix: 'kg',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('TAILLE'),
                              _buildTextField(
                                controller: _tailleController,
                                hint: '168',
                                isNumber: true,
                                suffix: 'cm',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Cases à cocher légales
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // CGU + Politique de confidentialité
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: _acceptedTerms,
                          activeColor: SonaColors.primary,
                          onChanged: (v) =>
                              setState(() => _acceptedTerms = v ?? false),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Wrap(
                              children: [
                                const Text(
                                  'J\'accepte que mes photos et données corporelles soient utilisées uniquement pour générer ma projection personnalisée. ',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF5A8A6A)),
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const LegalScreen(
                                        title:
                                            'Politique de confidentialité',
                                        url:
                                            'https://www.notion.so/348dae09b61b81c0a0f2c4fe1fb75d55',
                                      ),
                                    ),
                                  ),
                                  child: const Text(
                                    'Politique de confidentialité',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: SonaColors.primary,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                                const Text(
                                  ' · ',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF5A8A6A)),
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const LegalScreen(
                                        title:
                                            'Conditions générales d\'utilisation',
                                        url:
                                            'https://www.notion.so/348dae09b61b81f993d0f55ec9212551',
                                      ),
                                    ),
                                  ),
                                  child: const Text(
                                    'CGU',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: SonaColors.primary,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Marketing
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: _acceptedMarketing,
                          activeColor: SonaColors.primary,
                          onChanged: (v) =>
                              setState(() => _acceptedMarketing = v ?? false),
                        ),
                        const Expanded(
                          child: Text(
                            'J\'accepte de recevoir des conseils et offres Sona par email',
                            style: TextStyle(
                                fontSize: 12, color: Color(0xFF5A8A6A)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Bouton COMMENCER
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      if (!_acceptedTerms) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Veuillez accepter les conditions pour continuer'),
                            backgroundColor: Color(0xFFF57C00),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        return;
                      }
                      _validerEtContinuer(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _acceptedTerms
                          ? SonaColors.primary
                          : const Color(0xFFB0B0B0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: _acceptedTerms ? 4 : 0,
                      shadowColor: SonaColors.primary.withOpacity(0.4),
                    ),
                    child: const Text(
                      'C\'est parti ! 🚀',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              // Mentions légales
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LegalScreen(
                      title: 'Mentions légales',
                      url:
                          'https://www.notion.so/348dae09b61b81abbebaddfab86f641e',
                    ),
                  ),
                ),
                child: const Text(
                  'Mentions légales',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFFB0B0B0),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Color(0xFF5A8A6A),
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required bool isNumber,
    String? suffix,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7F3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType:
                  isNumber ? TextInputType.number : TextInputType.text,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(
                    color: Color(0xFFAACCBB), fontSize: 15),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1A3D2B)),
            ),
          ),
          if (suffix != null)
            Text(
              suffix,
              style: const TextStyle(
                  color: Color(0xFF5A8A6A),
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
        ],
      ),
    );
  }
}
