import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../theme.dart';

class LegalScreenNative extends StatefulWidget {
  final String title;
  final String url;

  const LegalScreenNative({super.key, required this.title, required this.url});

  @override
  State<LegalScreenNative> createState() => _LegalScreenNativeState();
}

class _LegalScreenNativeState extends State<LegalScreenNative> {
  late final WebViewController _controller;
  bool _loading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (_) => setState(() {
          _loading = true;
          _hasError = false;
        }),
        onPageFinished: (_) => setState(() => _loading = false),
        onWebResourceError: (_) => setState(() {
          _loading = false;
          _hasError = true;
        }),
      ))
      ..loadRequest(Uri.parse(widget.url));
  }

  void _retry() {
    setState(() {
      _loading = true;
      _hasError = false;
    });
    _controller.loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1A3D2B),
        elevation: 0,
      ),
      body: Stack(
        children: [
          if (!_hasError) WebViewWidget(controller: _controller),
          if (_loading)
            const Center(
              child: CircularProgressIndicator(color: SonaColors.primary),
            ),
          if (_hasError)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.wifi_off_rounded,
                        size: 56, color: Color(0xFFB0B0B0)),
                    const SizedBox(height: 16),
                    const Text(
                      'Impossible de charger le document.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A3D2B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Vérifie ta connexion internet et réessaie.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Color(0xFF9E9E9E)),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _retry,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SonaColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 14),
                        elevation: 0,
                      ),
                      child: const Text('Réessayer',
                          style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
