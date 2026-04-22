import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme.dart';

// webview_flutter is only available on mobile
import 'legal_screen_webview.dart' if (dart.library.html) 'legal_screen_stub.dart';

class LegalScreen extends StatelessWidget {
  final String title;
  final String url;

  const LegalScreen({super.key, required this.title, required this.url});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return _LegalScreenWeb(title: title, url: url);
    }
    return LegalScreenNative(title: title, url: url);
  }
}

class _LegalScreenWeb extends StatelessWidget {
  final String title;
  final String url;

  const _LegalScreenWeb({required this.title, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1A3D2B),
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.article_outlined,
                  size: 64, color: SonaColors.primaryLight),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F6E56),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Ce document va s\'ouvrir dans votre navigateur.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Color(0xFF9E9E9E)),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => launchUrl(
                  Uri.parse(url),
                  mode: LaunchMode.externalApplication,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: SonaColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 14),
                  elevation: 0,
                ),
                child: const Text('Ouvrir le document',
                    style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
