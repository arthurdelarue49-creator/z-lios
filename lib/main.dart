import 'package:flutter/material.dart';
import 'theme.dart';
import 'models/user_profile.dart';
import 'screens/onboarding_screen.dart';
import 'screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SonaApp());
}

class SonaApp extends StatelessWidget {
  const SonaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sona',
      debugShowCheckedModeBanner: false,
      theme: SonaTheme.theme,
      home: FutureBuilder<UserProfile?>(
        future: UserProfile.load(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Scaffold(
              backgroundColor: Color(0xFFF0FBF5),
              body: SizedBox.shrink(),
            );
          }
          final profile = snapshot.data;
          if (profile != null) {
            return MainScreen(
              prenom: profile.prenom,
              sexe: profile.sexe,
              age: profile.age,
              poids: profile.poids,
              taille: profile.taille,
              photoPath: profile.photoPath,
            );
          }
          return const SplashScreen();
        },
      ),
    );
  }
}
