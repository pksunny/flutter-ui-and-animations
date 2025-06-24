import 'package:flutter/material.dart';
import 'package:futurecore_codex/screens/10-cyberpunk_neon_ui/cyberpunk_neon_ui_screen.dart';
import 'package:futurecore_codex/screens/11-usage-of-const/usage_of_const_screen.dart';
import 'package:futurecore_codex/screens/12-setstate-vs-valuenotifier/setstate_vs_valuenotifierscreen.dart';
import 'package:futurecore_codex/screens/14-future-builder-dark-side/futurebuilder_darkside_screen.dart.dart';
import 'package:futurecore_codex/screens/15-butterfly-animation/butterfly_animation_screen.dart';
import 'package:futurecore_codex/screens/16-tool-tip/tool_tip_screen.dart';
import 'package:futurecore_codex/screens/17-liquid-glass/liquid_glass_screen.dart';
import 'package:futurecore_codex/screens/18-flip-card/flip_card_screen.dart';
import 'package:futurecore_codex/screens/19-page-flip/page_flip_screen.dart';
import 'package:futurecore_codex/screens/20-loop-text-animation/loop_text_animation_screen.dart';
import 'package:futurecore_codex/screens/21-origami-fold-ui/origami_fold_ui_screen.dart';
import 'package:futurecore_codex/screens/22-ink-drop-navigation/ink_drop_navigation_screen.dart';
import 'package:futurecore_codex/screens/3-six_nill/six_nill_screen.dart';
import 'package:futurecore_codex/screens/2-PAF/paf_screen.dart';
import 'package:futurecore_codex/screens/4-rabbit_loading_animation/rabbit_animations_screen.dart';
import 'package:futurecore_codex/screens/5-deadline_loading_animation%20copy/deadline_animations_screen.dart';
import 'package:futurecore_codex/screens/6-free_palestine/free_palestine_screen.dart';
import 'package:futurecore_codex/screens/7-3d_album/3d_album_screen.dart';
import 'package:futurecore_codex/screens/8-lamp_on_off/lamp_on_off_screen.dart';
import 'package:futurecore_codex/screens/9-neon_squares/neon_square_screen.dart';
import 'screens/home_screen.dart';

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
      home:  InkDropNavigationScreen()
    );
  }
}
