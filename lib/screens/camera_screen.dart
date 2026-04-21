import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../theme.dart';
import '../models/user_profile.dart';
import 'loading_screen.dart';

class CameraScreen extends StatefulWidget {
  final UserProfile profile;

  const CameraScreen({
    super.key,
    required this.profile,
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
              profile: widget.profile,
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
              backgroundColor: SonaColors.primary,
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
      backgroundColor: SonaColors.background,
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
                      widget.profile.prenom.isNotEmpty
                          ? 'À toi de jouer, ${widget.profile.prenom} !'
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
                      widget.profile.prenom.isNotEmpty
                          ? 'Prêt(e) à te voir évoluer, ${widget.profile.prenom} ?\nPlace-toi au centre du cadre.'
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
              foregroundColor: SonaColors.primary,
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
          color: SonaColors.primaryLight,
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
                              SonaColors.primary.withOpacity(0),
                              SonaColors.primary.withOpacity(0.28),
                              SonaColors.primary.withOpacity(0),
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
                        color: SonaColors.primary,
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
          color: SonaColors.primary,
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
              color: SonaColors.primary,
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
      ..color = SonaColors.primary
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
          color: SonaColors.background,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: SonaColors.primaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: SonaColors.primary, size: 22),
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
  final UserProfile profile;

  const ConfirmationScreen({
    super.key,
    required this.file,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
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
                              foregroundColor: SonaColors.primary,
                              side: const BorderSide(color: SonaColors.primary, width: 1.5),
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
                            onPressed: () {
                              final p = profile.copyWith(photoPath: file.path);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => LoadingScreen(
                                    prenom: p.prenom,
                                    sexe: p.sexe,
                                    age: p.age,
                                    poids: p.poids,
                                    taille: p.taille,
                                    photoPath: p.photoPath,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: SonaColors.primary,
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
                color: SonaColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
