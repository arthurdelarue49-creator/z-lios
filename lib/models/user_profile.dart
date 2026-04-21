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
      case 'actif':        return '30 min';
      case 'tonification': return '45 min';
      default:             return '1h';
    }
  }

  String get eauParJour {
    if (imc >= 35) return '1.5L';
    return '2L';
  }

  String get calories {
    switch (niveau) {
      case 'douceur': return '1 400';
      case 'actif': return '1 700';
      case 'tonification': return '2 000';
      default: return '2 300';
    }
  }
}
