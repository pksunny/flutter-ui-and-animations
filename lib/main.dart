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
import 'package:futurecore_codex/screens/139-smart-highlight/smart_highlight.dart';
import 'package:futurecore_codex/screens/140-reward-badge/reward_badge.dart';
import 'package:futurecore_codex/screens/141-live-pulse-connection/live_pulse_connection.dart';
import 'package:futurecore_codex/screens/142-smart-loading-swap/smart_loading_swap.dart';
import 'package:futurecore_codex/screens/143-reaction-glow/reaction_glow.dart';
import 'package:futurecore_codex/screens/144-textfield-border-flow-animation/textfield_border_flow_animation.dart';
import 'package:futurecore_codex/screens/145-morphing/morphing.dart';
import 'package:futurecore_codex/screens/146-smart-page-loader/smart_page_loader.dart';
import 'package:futurecore_codex/screens/147-confetti-reward-system/confetti_reward_system.dart';
import 'package:futurecore_codex/screens/148-lightning-text-reveal/lightning_text_reveal.dart';
import 'package:futurecore_codex/screens/149-mood-adaptive-loader/mood_adaptive_loader.dart';
import 'package:futurecore_codex/screens/150-sliding-onboarding/sliding_onboarding.dart';
import 'package:futurecore_codex/screens/151-splash-animation/splash_animation.dart';
import 'package:futurecore_codex/screens/152-logo-reveal/logo_reveal.dart';
import 'package:futurecore_codex/screens/153-floating-notes/floating_notes.dart';
import 'package:futurecore_codex/screens/154-illustration-style-onboarding/illustration_style_onboarding.dart';
import 'package:futurecore_codex/screens/155-e-commerce-shopping/e_commerce_shopping.dart';
import 'package:futurecore_codex/screens/156-product-360-view/product_360_view.dart';
import 'package:futurecore_codex/screens/157-check-out-flow/check_out_flow.dart.dart';

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
      home: AnimatedCheckoutFlow()
    );
  }
}
