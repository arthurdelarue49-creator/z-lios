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
  String _sexe = 'Homme';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              const Text('🌿', style: TextStyle(fontSize: 80)),
              const SizedBox(height: 8),
              const Text(
                'Zélios',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3DBE6E),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Et si tu pouvais te voir dans 3 mois ?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Color(0xFF2D6A4F)),
              ),
              const SizedBox(height: 32),
              _buildLabel('Prénom'),
              _buildTextField(_prenomController, 'Ex: Arthur', false),
              const SizedBox(height: 20),
              _buildLabel('Sexe'),
              const SizedBox(height: 8),
              Row(
                children: ['Homme', 'Femme'].map((s) {
                  final selected = _sexe == s;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _sexe = s),
                      child: Container(
                        margin: EdgeInsets.only(right: s == 'Homme' ? 8 : 0),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: selected ? const Color(0xFF3DBE6E) : const Color(0xFFEEF8F1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(s,
                            style: TextStyle(
                              color: selected ? Colors.white : const Color(0xFF2D6A4F),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              _buildLabel('Âge'),
              _buildTextField(_ageController, 'Ex: 28', true),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Poids (kg)'),
                        _buildTextField(_poidsController, 'Ex: 85', true),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Taille (cm)'),
                        _buildTextField(_tailleController, 'Ex: 175', true),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const CameraScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3DBE6E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('COMMENCER',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D6A4F),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, bool numbers) {
    return TextField(
      controller: controller,
      keyboardType: numbers ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFFEEF8F1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            const Text(
              'Prends-toi en photo en pied',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D6A4F),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF8F1),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFF3DBE6E), width: 2),
                  ),
                  child: const Center(
                    child: Text('🧍', style: TextStyle(fontSize: 80)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: () {},
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: const Color(0xFF3DBE6E),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFB7E5C8), width: 6),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                _TipWidget(emoji: '☀️', label: 'Bon éclairage'),
                _TipWidget(emoji: '🧍', label: 'Corps entier'),
                _TipWidget(emoji: '🖼️', label: 'Fond neutre'),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _TipWidget extends StatelessWidget {
  final String emoji;
  final String label;

  const _TipWidget({required this.emoji, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFEEF8F1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(emoji, style: const TextStyle(fontSize: 24)),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF2D6A4F))),
      ],
    );
  }
}