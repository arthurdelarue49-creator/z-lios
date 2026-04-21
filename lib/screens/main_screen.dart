import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../tabs/accueil_tab.dart';
import '../tabs/programme_tab.dart';
import '../tabs/transformation_tab.dart';
import '../tabs/profil_tab.dart';

class MainScreen extends StatefulWidget {
  final String prenom;
  final String sexe;
  final int age;
  final double poids;
  final double taille;
  final String? photoPath;

  const MainScreen({
    super.key,
    required this.prenom,
    required this.sexe,
    required this.age,
    required this.poids,
    required this.taille,
    this.photoPath,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  late final UserProfile _profile;

  @override
  void initState() {
    super.initState();
    _profile = UserProfile(
      prenom: widget.prenom,
      sexe: widget.sexe,
      age: widget.age,
      poids: widget.poids,
      taille: widget.taille,
      photoPath: widget.photoPath,
    );
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      AccueilTab(
        profile: _profile,
        onTabChange: (i) => setState(() => _currentIndex = i),
      ),
      ProgrammeTab(profile: _profile),
      TransformationTab(profile: _profile),
      ProfilTab(
        prenom: _profile.prenom,
        sexe: _profile.sexe,
        age: _profile.age,
        poids: _profile.poids,
        taille: _profile.taille,
      ),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: tabs),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 12,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF1D9E75),
          unselectedItemColor: const Color(0xFFB0B0B0),
          selectedFontSize: 11,
          unselectedFontSize: 11,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded), label: 'Accueil'),
            BottomNavigationBarItem(
                icon: Icon(Icons.list_alt_rounded), label: 'Programme'),
            BottomNavigationBarItem(
                icon: Icon(Icons.photo_camera_rounded),
                label: 'Transformation'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded), label: 'Profil'),
          ],
        ),
      ),
    );
  }
}
