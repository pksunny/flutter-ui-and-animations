import 'package:flutter/material.dart';
import 'package:futurecore_codex/screens/117-bubble-timer/bubble_timer.dart';
import 'package:futurecore_codex/screens/118-ai-eye-scanner/ai_eye_scanner.dart';
import 'package:futurecore_codex/screens/119-ai-face-scanner/ai_face_scanner.dart';
import 'package:futurecore_codex/screens/120-popcorn-loader/popcorn_loader.dart';
import 'package:futurecore_codex/screens/121-like-firework/like_firework.dart';
import 'package:futurecore_codex/screens/122-fingerprint-pulse/fingerprint_pulse.dart';
import 'package:futurecore_codex/screens/123-electric-shock-progressbar/electric_shock_progressbar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FutureCore Codex',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          secondary: const Color(0xFFFF6584),
        ),
        useMaterial3: true,
      ),
      home: ElectricShockProgressbar()
    );
  }
}
