import 'package:flutter/material.dart';
import 'package:futurecore_codex/screens/117-bubble-timer/bubble_timer.dart';
import 'package:futurecore_codex/screens/118-ai-eye-scanner/ai_eye_scanner.dart';
import 'package:futurecore_codex/screens/119-ai-face-scanner/ai_face_scanner.dart';
import 'package:futurecore_codex/screens/120-popcorn-loader/popcorn_loader.dart';
import 'package:futurecore_codex/screens/121-like-firework/like_firework.dart';
import 'package:futurecore_codex/screens/122-fingerprint-pulse/fingerprint_pulse.dart';
import 'package:futurecore_codex/screens/123-electric-shock-progressbar/electric_shock_progressbar.dart';
import 'package:futurecore_codex/screens/124-font-size-adjuster/font_size_adjuster_screen.dart';
import 'package:futurecore_codex/screens/125-mini-habit-tracker/mini_habit_tracker_screen.dart';
import 'package:futurecore_codex/screens/126-focus-timer-shield/focus_timer_shield_screen.dart';
import 'package:futurecore_codex/screens/127-auto-save-indicator/auto_save_indicator_screen.dart';
import 'package:futurecore_codex/screens/128-predictive-search-bar/predictive_search_bar_screen.dart';
import 'package:futurecore_codex/screens/129-unlock-ui/unlock_ui_screen.dart';
import 'package:futurecore_codex/screens/130-weather-ui/adaptive_weather_ui_screen.dart';
import 'package:futurecore_codex/screens/131-empty-list/empty_list.dart';
import 'package:futurecore_codex/screens/132-validation-field/validation_field.dart';
import 'package:futurecore_codex/screens/133-scroll-indicator/scroll_indicator.dart';
import 'package:futurecore_codex/screens/134-copy-animation/copy_animation.dart';
import 'package:futurecore_codex/screens/134-retry-animation/retry_animation.dart';
import 'package:futurecore_codex/screens/135-collapse-transition/collapse_transition.dart';
import 'package:futurecore_codex/screens/136-tab-switch-animatioj/tab_switch_animation.dart';
import 'package:futurecore_codex/screens/137-step-progress/step_progress.dart';
import 'package:futurecore_codex/screens/138-notification-animation/notification_animation.dart';

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
      home: NotificationAnimation(),
    );
  }
}
