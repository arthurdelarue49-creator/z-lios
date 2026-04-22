import 'package:flutter/material.dart';

// Stub used on Flutter Web — LegalScreen handles web via kIsWeb,
// so this widget is never instantiated at runtime.
class LegalScreenNative extends StatelessWidget {
  final String title;
  final String url;

  const LegalScreenNative({super.key, required this.title, required this.url});

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
