import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

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
  String _sexe = 'Femme';

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

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CameraScreen(
          prenom: prenom,
          sexe: _sexe,
          age: age!,
          poids: poids!,
          taille: taille!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5EE),
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
                'ZÉLIOS',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF3DBE6E),
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Faisons connaissance',
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
                  'Et si tu pouvais te voir dans 3 mois ?',
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
                                    ? const Color(0xFF3DBE6E)
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

              // Bouton COMMENCER
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => _validerEtContinuer(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3DBE6E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      shadowColor:
                          const Color(0xFF3DBE6E).withOpacity(0.4),
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

class CameraScreen extends StatefulWidget {
  final String prenom;
  final String sexe;
  final int age;
  final double poids;
  final double taille;

  const CameraScreen({
    super.key,
    this.prenom = '',
    this.sexe = 'Autre',
    this.age = 25,
    this.poids = 70,
    this.taille = 170,
  });

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _laserCtrl;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _laserCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _laserCtrl.dispose();
    super.dispose();
  }

  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _PhotoOptionsSheet(onSelect: _pickImage),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    if (!kIsWeb && source == ImageSource.camera) {
      final status = await Permission.camera.status;
      if (status.isPermanentlyDenied) {
        if (mounted) _showOpenSettingsDialog();
        return;
      }
      if (status.isDenied) {
        final result = await Permission.camera.request();
        if (!result.isGranted) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Permission caméra refusée')),
            );
          }
          return;
        }
      }
    }

    try {
      final file = await _picker.pickImage(source: source, imageQuality: 90);
      if (file == null) return;
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ConfirmationScreen(
              file: file,
              prenom: widget.prenom,
              sexe: widget.sexe,
              age: widget.age,
              poids: widget.poids,
              taille: widget.taille,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de la capture photo')),
        );
      }
    }
  }

  void _showOpenSettingsDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Permission requise',
          style: TextStyle(color: Color(0xFF0D4F3C), fontWeight: FontWeight.w700),
        ),
        content: const Text(
          "L'accès à la caméra est nécessaire. Ouvrez les paramètres pour l'activer.",
          style: TextStyle(color: Color(0xFF5A8A6A)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler', style: TextStyle(color: Color(0xFF8A9E94))),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              openAppSettings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3DBE6E),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Ouvrir les paramètres', style: TextStyle(color: Colors.white)),
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
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: Container(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                padding: const EdgeInsets.all(20),
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
                  children: [
                    Text(
                      widget.prenom.isNotEmpty
                          ? 'À toi de jouer, ${widget.prenom} !'
                          : 'Capturez votre posture',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0D4F3C),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.prenom.isNotEmpty
                          ? 'Prêt(e) à te voir évoluer, ${widget.prenom} ?\nPlace-toi au centre du cadre.'
                          : 'Placez-vous bien au centre du cadre\npour une analyse 3D précise.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF8A9E94),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(child: _buildViewfinder()),
                    const SizedBox(height: 20),
                    _buildShutterButton(),
                    const SizedBox(height: 20),
                    _buildPills(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
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
              child: const Icon(
                Icons.arrow_back_ios_new,
                size: 16,
                color: Color(0xFF1A3D2B),
              ),
            ),
          ),
          const Expanded(
            child: Text(
              'Analyse Corporelle',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A3D2B),
              ),
            ),
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF3DBE6E),
            ),
            child: const Text(
              'Ignorer',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewfinder() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFE8F5EE),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Center(
              child: CustomPaint(
                size: const Size(100, 260),
                painter: _SilhouettePainter(),
              ),
            ),
            Positioned(top: 16, left: 16, child: _cornerMark(topLeft: true)),
            Positioned(top: 16, right: 16, child: _cornerMark(topRight: true)),
            Positioned(bottom: 16, left: 16, child: _cornerMark(bottomLeft: true)),
            Positioned(bottom: 16, right: 16, child: _cornerMark(bottomRight: true)),
            AnimatedBuilder(
              animation: _laserCtrl,
              builder: (ctx, _) {
                return LayoutBuilder(builder: (ctx, constraints) {
                  final y = CurvedAnimation(parent: _laserCtrl, curve: Curves.easeInOut).value * constraints.maxHeight;
                  return Stack(children: [
                    Positioned(
                      top: y - 10,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 20,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              const Color(0xFF3DBE6E).withOpacity(0),
                              const Color(0xFF3DBE6E).withOpacity(0.28),
                              const Color(0xFF3DBE6E).withOpacity(0),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: y,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 2.5,
                        color: const Color(0xFF3DBE6E),
                      ),
                    ),
                  ]);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _cornerMark({
    bool topLeft = false,
    bool topRight = false,
    bool bottomLeft = false,
    bool bottomRight = false,
  }) {
    return SizedBox(
      width: 20,
      height: 20,
      child: CustomPaint(
        painter: _CornerPainter(
          color: const Color(0xFF3DBE6E),
          thickness: 3,
          topLeft: topLeft,
          topRight: topRight,
          bottomLeft: bottomLeft,
          bottomRight: bottomRight,
        ),
      ),
    );
  }

  Widget _buildShutterButton() {
    return GestureDetector(
      onTap: _showPhotoOptions,
      child: Container(
        width: 80,
        height: 80,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFFD4F0E2),
        ),
        child: Center(
          child: Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF3DBE6E),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPills() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          Flexible(child: _PillWidget(icon: '☀️', label: 'Bonne lumière')),
          SizedBox(width: 6),
          Flexible(child: _PillWidget(icon: '▦', label: 'Corps entier')),
          SizedBox(width: 6),
          Flexible(child: _PillWidget(icon: '🖼', label: 'Fond neutre')),
        ],
      ),
    );
  }
}

class _SilhouettePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF3DBE6E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    void drawDashed(Path path) {
      for (final m in path.computeMetrics()) {
        double dist = 0;
        while (dist < m.length) {
          final end = (dist + 8).clamp(0.0, m.length);
          canvas.drawPath(m.extractPath(dist, end), paint);
          dist += 14;
        }
      }
    }

    drawDashed(Path()
      ..addOval(Rect.fromCenter(
        center: Offset(size.width / 2, size.height * 0.08),
        width: size.width * 0.30,
        height: size.height * 0.13,
      )));

    drawDashed(Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.18, size.height * 0.16,
            size.width * 0.64, size.height * 0.35),
        const Radius.circular(8),
      )));

    drawDashed(Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.18, size.height * 0.54,
            size.width * 0.27, size.height * 0.42),
        const Radius.circular(6),
      )));

    drawDashed(Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.55, size.height * 0.54,
            size.width * 0.27, size.height * 0.42),
        const Radius.circular(6),
      )));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CornerPainter extends CustomPainter {
  final Color color;
  final double thickness;
  final bool topLeft, topRight, bottomLeft, bottomRight;

  const _CornerPainter({
    required this.color,
    required this.thickness,
    this.topLeft = false,
    this.topRight = false,
    this.bottomLeft = false,
    this.bottomRight = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final w = size.width;
    final h = size.height;

    if (topLeft) {
      canvas.drawLine(Offset(0, h), Offset(0, 0), p);
      canvas.drawLine(Offset(0, 0), Offset(w, 0), p);
    }
    if (topRight) {
      canvas.drawLine(Offset(0, 0), Offset(w, 0), p);
      canvas.drawLine(Offset(w, 0), Offset(w, h), p);
    }
    if (bottomLeft) {
      canvas.drawLine(Offset(0, 0), Offset(0, h), p);
      canvas.drawLine(Offset(0, h), Offset(w, h), p);
    }
    if (bottomRight) {
      canvas.drawLine(Offset(w, 0), Offset(w, h), p);
      canvas.drawLine(Offset(0, h), Offset(w, h), p);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PhotoOptionsSheet extends StatelessWidget {
  final void Function(ImageSource) onSelect;

  const _PhotoOptionsSheet({required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
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
          const Text(
            'Comment veux-tu prendre la photo ?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0D4F3C),
            ),
          ),
          const SizedBox(height: 20),
          _SheetOption(
            icon: Icons.camera_alt_outlined,
            label: 'Prendre une photo',
            onTap: () {
              Navigator.pop(context);
              onSelect(ImageSource.camera);
            },
          ),
          const SizedBox(height: 12),
          _SheetOption(
            icon: Icons.photo_library_outlined,
            label: 'Choisir depuis la galerie',
            onTap: () {
              Navigator.pop(context);
              onSelect(ImageSource.gallery);
            },
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Annuler',
              style: TextStyle(fontSize: 15, color: Color(0xFF8A9E94)),
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SheetOption({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5EE),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFF3DBE6E), size: 22),
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A3D2B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ConfirmationScreen extends StatelessWidget {
  final XFile file;
  final String prenom;
  final String sexe;
  final int age;
  final double poids;
  final double taille;

  const ConfirmationScreen({
    super.key,
    required this.file,
    required this.prenom,
    required this.sexe,
    required this.age,
    required this.poids,
    required this.taille,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
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
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 16,
                        color: Color(0xFF1A3D2B),
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Analyse Corporelle',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A3D2B),
                      ),
                    ),
                  ),
                  const SizedBox(width: 60),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                padding: const EdgeInsets.all(20),
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
                  children: [
                    const Text(
                      'Parfait !',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0D4F3C),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'On va maintenant analyser ta posture\net créer ta projection santé.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF8A9E94),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: kIsWeb
                            ? Image.network(
                                file.path,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              )
                            : Image.file(
                                File(file.path),
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF3DBE6E),
                              side: const BorderSide(color: Color(0xFF3DBE6E), width: 1.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text(
                              'Reprendre',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProgrammeScreen(
                                  prenom: prenom,
                                  age: age,
                                  poids: poids,
                                  taille: taille,
                                  photoPath: file.path,
                                ),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3DBE6E),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Continuer',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ],
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

class _PillWidget extends StatelessWidget {
  final String icon;
  final String label;

  const _PillWidget({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFDDEEE5), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Color(0xFF3DBE6E),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── ÉCRAN RÉSULTAT ───────────────────────────────────────────────────────────

class ResultatScreen extends StatelessWidget {
  final String prenom;
  final String sexe;
  final int age;
  final double poids;
  final double taille;
  final String? photoPath;

  const ResultatScreen({
    super.key,
    required this.prenom,
    required this.sexe,
    required this.age,
    required this.poids,
    required this.taille,
    this.photoPath,
  });

  String get _niveau {
    final imc = poids / ((taille / 100) * (taille / 100));
    if (imc >= 35) return 'douceur';
    if (imc >= 30) return 'actif';
    if (imc >= 25) return 'tonification';
    return 'maintien';
  }

  double get _poidsCible {
    switch (_niveau) {
      case 'douceur': return poids * 0.96;
      case 'actif': return poids * 0.94;
      case 'tonification': return poids * 0.95;
      default: return poids * 0.98;
    }
  }

  Map<String, String> get _indicateurs {
    switch (_niveau) {
      case 'douceur': return {'souffle': '+15%', 'energie': '+20%', 'glycemie': '-8%'};
      case 'actif': return {'souffle': '+25%', 'energie': '+35%', 'glycemie': '-12%'};
      case 'tonification': return {'souffle': '+30%', 'energie': '+40%', 'glycemie': '-10%'};
      default: return {'souffle': '+20%', 'energie': '+25%', 'glycemie': '-5%'};
    }
  }

  Map<String, double> get _indicateursProgress {
    switch (_niveau) {
      case 'douceur': return {'souffle': 0.38, 'energie': 0.40, 'glycemie': 0.53};
      case 'actif': return {'souffle': 0.63, 'energie': 0.70, 'glycemie': 0.80};
      case 'tonification': return {'souffle': 0.75, 'energie': 0.80, 'glycemie': 0.67};
      default: return {'souffle': 0.50, 'energie': 0.50, 'glycemie': 0.33};
    }
  }

  List<Map<String, String>> get _programme {
    switch (_niveau) {
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
    Widget img;
    if (photoPath == null) {
      return Container(
        width: 150,
        height: 200,
        decoration: BoxDecoration(
          color: const Color(0xFFE8F5EE),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.person, size: 60, color: Color(0xFF3DBE6E)),
      );
    }
    final useNetwork = kIsWeb ||
        photoPath!.startsWith('blob:') ||
        photoPath!.startsWith('http');
    final base = ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: useNetwork
          ? Image.network(photoPath!, width: 150, height: 200, fit: BoxFit.cover)
          : Image.file(File(photoPath!), width: 150, height: 200, fit: BoxFit.cover),
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
              color: const Color(0xFF3DBE6E).withOpacity(0.08),
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
                            color: Color(0xFF3DBE6E))),
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
    final niveau = _niveau;
    final poidsCible = _poidsCible;
    final indicateurs = _indicateurs;
    final progress = _indicateursProgress;
    final programme = _programme;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // Header
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
            // Scrollable body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                child: Column(
                  children: [
                    // Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 7),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3DBE6E),
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

                    // ── Avant / Après ──
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
                              // Avant
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
                                    '${poids.toStringAsFixed(1)} kg',
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
                                    color: Color(0xFF3DBE6E), size: 22),
                              ),
                              // Après
                              Column(children: [
                                const Text('Dans 3 mois',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF3DBE6E),
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
                                    '${poidsCible.toStringAsFixed(1)} kg',
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
                            'Projection estimée basée sur le programme Zélios.\nRésultats individuels variables.',
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

                    // ── Indicateurs santé ──
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
                              indicateurs['souffle']!, progress['souffle']!),
                          const SizedBox(height: 12),
                          _buildIndicateur('⚡', 'Énergie',
                              indicateurs['energie']!, progress['energie']!),
                          const SizedBox(height: 12),
                          _buildIndicateur('🩸', 'Glycémie',
                              indicateurs['glycemie']!, progress['glycemie']!),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ── Programme ──
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

                    // ── Paywall ──
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

                    // ── Recommencer ──
                    OutlinedButton(
                      onPressed: () =>
                          Navigator.of(context).popUntil((r) => r.isFirst),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF3DBE6E),
                        side: const BorderSide(
                            color: Color(0xFF3DBE6E), width: 1.5),
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

// ─── ÉCRAN PROGRAMME ──────────────────────────────────────────────────────────

class ProgrammeScreen extends StatefulWidget {
  final String prenom;
  final int age;
  final double poids;
  final double taille;
  final String? photoPath;

  const ProgrammeScreen({
    super.key,
    required this.prenom,
    required this.age,
    required this.poids,
    required this.taille,
    this.photoPath,
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

  double get _imc =>
      widget.poids / ((widget.taille / 100) * (widget.taille / 100));

  @override
  void initState() {
    super.initState();
    final imc = _imc;
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
          prenom: widget.prenom,
          poids: widget.poids,
          taille: widget.taille,
          age: widget.age,
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
                        color: Color(0xFF3DBE6E), size: 18),
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
                  backgroundColor: const Color(0xFF1D9E75),
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

  String get _niveau {
    final imc = _imc;
    if (imc >= 35) return 'douceur';
    if (imc >= 30) return 'actif';
    if (imc >= 25) return 'tonification';
    return 'maintien';
  }

  double get _poidsCible {
    switch (_niveau) {
      case 'douceur': return widget.poids * 0.96;
      case 'actif': return widget.poids * 0.94;
      case 'tonification': return widget.poids * 0.95;
      default: return widget.poids * 0.98;
    }
  }

  Widget _buildPhoto(bool isAfter) {
    final path = widget.photoPath;
    if (path == null) {
      return Container(
        width: 140,
        height: 190,
        decoration: BoxDecoration(
          color: const Color(0xFFE8F5EE),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.person, size: 52, color: Color(0xFF3DBE6E)),
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
            color: const Color(0xFF3DBE6E).withOpacity(0.06),
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
                      '${widget.poids.toStringAsFixed(1)} kg',
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
                    color: Color(0xFF3DBE6E), size: 20),
              ),
              Expanded(
                child: Column(children: [
                  const Text('Dans 3 mois',
                      style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF3DBE6E),
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
                      '${_poidsCible.toStringAsFixed(1)} kg',
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
                          ? const Color(0xFF1D9E75)
                          : const Color(0xFFE8F5EE),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: sel
                            ? const Color(0xFF1D9E75)
                            : const Color(0xFF5DCAA5),
                      ),
                    ),
                    child: Text(v,
                        style: TextStyle(
                          color: sel
                              ? Colors.white
                              : const Color(0xFF0F6E56),
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
      backgroundColor: const Color(0xFFF5F5F5),
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
                              color: const Color(0xFFF5F5F5),
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
                          backgroundColor: const Color(0xFF1D9E75),
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
  final String prenom;
  final double poids;
  final double taille;
  final int age;
  final String pas;
  final String footing;
  final String eau;
  final String sommeil;
  final String calories;

  const ResultatProgrammeScreen({
    super.key,
    required this.prenom,
    required this.poids,
    required this.taille,
    required this.age,
    required this.pas,
    required this.footing,
    required this.eau,
    required this.sommeil,
    required this.calories,
  });

  double get _imc => poids / ((taille / 100) * (taille / 100));

  String get _niveau {
    final imc = _imc;
    if (imc >= 35) return 'douceur';
    if (imc >= 30) return 'actif';
    if (imc >= 25) return 'tonification';
    return 'maintien';
  }

  Map<String, String> get _indicateurs {
    switch (_niveau) {
      case 'douceur':
        return {'souffle': '+15%', 'energie': '+20%', 'glycemie': '-8%'};
      case 'actif':
        return {'souffle': '+25%', 'energie': '+35%', 'glycemie': '-12%'};
      case 'tonification':
        return {'souffle': '+30%', 'energie': '+40%', 'glycemie': '-10%'};
      default:
        return {'souffle': '+20%', 'energie': '+25%', 'glycemie': '-5%'};
    }
  }

  Map<String, double> get _progress {
    switch (_niveau) {
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
                            color: Color(0xFF3DBE6E))),
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
    final indicateurs = _indicateurs;
    final prog = _progress;
    final etapes = [
      ('Mois 1', 'Mise en route', 'Installer les habitudes'),
      ('Mois 2', 'Accélération', 'Le corps s\'adapte'),
      ('Mois 3', 'Transformation', 'Les vrais résultats arrivent'),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
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
                                          color: Color(0xFF1D9E75))),
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
                              indicateurs['souffle']!, prog['souffle']!),
                          const SizedBox(height: 12),
                          _buildIndicateur('⚡', 'Énergie',
                              indicateurs['energie']!, prog['energie']!),
                          const SizedBox(height: 12),
                          _buildIndicateur('🩸', 'Glycémie',
                              indicateurs['glycemie']!, prog['glycemie']!),
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
                                        color: Color(0xFF1D9E75),
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
                                color: Color(0xFFE8F5EE),
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
                              color: Color(0xFF1D9E75)),
                        ]),
                      ),
                    ),
                    const SizedBox(height: 24),
                    OutlinedButton(
                      onPressed: () => Navigator.of(context)
                          .popUntil((r) => r.isFirst),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF3DBE6E),
                        side: const BorderSide(
                            color: Color(0xFF3DBE6E), width: 1.5),
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