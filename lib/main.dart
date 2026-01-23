import 'package:flutter/material.dart';
import 'package:futurecore_codex/screens/185-gesture-confidence-meter/gesture_confidence_meter.dart';
import 'package:futurecore_codex/screens/186-section-divider-shapes/section_divider_shapes.dart';
import 'package:futurecore_codex/screens/187-hand-drawn-button-outline-animation/hand_drawn_button_outline_animation.dart';
import 'package:futurecore_codex/screens/188-progress-shape/progress_shape.dart';
import 'package:futurecore_codex/screens/189-gradient-edge-flow/gradient_edge_flow.dart';

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
      home: GradientEdgeFlow(),
    );
  }
}
