import 'dart:async';
import 'package:flutter/material.dart';
import '../theme.dart';
import 'main_screen.dart';

class LoadingScreen extends StatefulWidget {
  final String prenom;
  final String sexe;
  final int age;
  final double poids;
  final double taille;
  final String? photoPath;

  const LoadingScreen({
    super.key,
    required this.prenom,
    required this.sexe,
    required this.age,
    required this.poids,
    required this.taille,
    this.photoPath,
  });

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bounceController;
  late final Animation<double> _bounceAnimation;
  int _textIndex = 0;
  Timer? _textTimer;

  static const _texts = [
    'Analyse de ton profil...',
    'Calcul de ton programme...',
    'Préparation de ta transformation...',
    'Tout est prêt !',
  ];

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _bounceAnimation = Tween<double>(begin: 0, end: -12).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );

    _textTimer = Timer.periodic(const Duration(milliseconds: 800), (_) {
      if (mounted) setState(() => _textIndex = (_textIndex + 1) % _texts.length);
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MainScreen(
            prenom: widget.prenom,
            sexe: widget.sexe,
            age: widget.age,
            poids: widget.poids,
            taille: widget.taille,
            photoPath: widget.photoPath,
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _textTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FBF5),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Prêt ${widget.prenom} ? 🌱',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F6E56),
              ),
            ),
            const SizedBox(height: 32),
            AnimatedBuilder(
              animation: _bounceAnimation,
              builder: (_, child) => Transform.translate(
                offset: Offset(0, _bounceAnimation.value),
                child: child,
              ),
              child: Container(
                width: 140,
                height: 140,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 20,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.network(
                    'https://i.imgur.com/xYXzVvh.png',
                    width: 140,
                    height: 140,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                _texts[_textIndex],
                key: ValueKey(_textIndex),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF0F6E56),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(seconds: 3),
              curve: Curves.easeInOut,
              builder: (_, value, __) => ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: SizedBox(
                  width: 200,
                  height: 4,
                  child: LinearProgressIndicator(
                    value: value,
                    backgroundColor: const Color(0xFFD0EEE0),
                    valueColor: const AlwaysStoppedAnimation(
                        Color(0xFF1D9E75)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
