import 'package:shared_preferences/shared_preferences.dart';

class UserProfile {
  final String prenom;
  final String sexe;
  final int age;
  final double poids;
  final double taille;
  final String? photoPath;

  UserProfile({
    required this.prenom,
    required this.sexe,
    required this.age,
    required this.poids,
    required this.taille,
    this.photoPath,
  });

  static Future<void> save(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('prenom', profile.prenom);
    await prefs.setString('sexe', profile.sexe);
    await prefs.setInt('age', profile.age);
    await prefs.setDouble('poids', profile.poids);
    await prefs.setDouble('taille', profile.taille);
    if (profile.photoPath != null) {
      await prefs.setString('photoPath', profile.photoPath!);
    } else {
      await prefs.remove('photoPath');
    }
  }

  static Future<UserProfile?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final prenom = prefs.getString('prenom');
    if (prenom == null) return null;
    return UserProfile(
      prenom: prenom,
      sexe: prefs.getString('sexe') ?? 'Femme',
      age: prefs.getInt('age') ?? 25,
      poids: prefs.getDouble('poids') ?? 70,
      taille: prefs.getDouble('taille') ?? 170,
      photoPath: prefs.getString('photoPath'),
    );
  }

  UserProfile copyWith({String? photoPath}) => UserProfile(
        prenom: prenom,
        sexe: sexe,
        age: age,
        poids: poids,
        taille: taille,
        photoPath: photoPath ?? this.photoPath,
      );

  double get imc => poids / ((taille / 100) * (taille / 100));

  String get niveau {
    if (imc >= 35) return 'douceur';
    if (imc >= 30) return 'actif';
    if (imc >= 25) return 'tonification';
    return 'maintien';
  }

  double get poidsCible {
    switch (niveau) {
      case 'douceur': return poids * 0.96;
      case 'actif': return poids * 0.94;
      case 'tonification': return poids * 0.95;
      default: return poids * 0.98;
    }
  }

  String get indicateurSouffle {
    switch (niveau) {
      case 'douceur': return '+15%';
      case 'actif': return '+25%';
      case 'tonification': return '+30%';
      default: return '+20%';
    }
  }

  String get indicateurEnergie {
    switch (niveau) {
      case 'douceur': return '+20%';
      case 'actif': return '+35%';
      case 'tonification': return '+40%';
      default: return '+25%';
    }
  }

  String get indicateurGlycemie {
    switch (niveau) {
      case 'douceur': return '-8%';
      case 'actif': return '-12%';
      case 'tonification': return '-10%';
      default: return '-5%';
    }
  }

  String get tempsMarche {
    switch (niveau) {
      case 'douceur':      return '15 min';
      case 'actif':        return '20 min';
      case 'tonification': return '30 min';
      default:             return '45 min';
    }
  }

  String get cardio {
    switch (niveau) {
      case 'douceur':      return '1x/sem';
      case 'actif':        return '2x/sem';
      case 'tonification': return '3x/sem';
      default:             return '2x/sem';
    }
  }

  String get eauParJour {
    switch (niveau) {
      case 'douceur': return '1.5L';
      case 'actif':   return '1.5L';
      default:        return '2L';
    }
  }

  String get calories {
    switch (niveau) {
      case 'douceur':      return '1 400';
      case 'actif':        return '1 600';
      case 'tonification': return '1 800';
      default:             return '2 000';
    }
  }
}
