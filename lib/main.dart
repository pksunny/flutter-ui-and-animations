import 'package:flutter/material.dart';
import 'package:futurecore_codex/screens/160-ai-assistant-dashboard/ai_assisstant_dashboard.dart';
import 'package:futurecore_codex/screens/161-smart-planner-ui/smart_planner_ui.dart';
import 'package:futurecore_codex/screens/162-minimal-wallet-app-ui/minimal_wallet_app_ui.dart';
import 'package:futurecore_codex/screens/163-social-feed-ui/social_feed_ui.dart';
import 'package:futurecore_codex/screens/164-package-tracking-app-ui/package_tracking_app_ui.dart';
import 'package:futurecore_codex/screens/165-travel-app-ui/travel_app_ui.dart';
import 'package:futurecore_codex/screens/166-story-onboarding/story_onboarding.dart';
import 'package:futurecore_codex/screens/167-smart-home-dashboard/smart_home_dashboard.dart';
import 'package:futurecore_codex/screens/168-ai-morphing-ui/ai_morphing_ui.dart';
import 'package:futurecore_codex/screens/170-floating-e-commerce-world/floating_e_commerce_world.dart';
import 'package:futurecore_codex/screens/171-neurawear-clothing-store/neurawear_clothing_store.dart';
import 'package:futurecore_codex/screens/172-asia-cup-2026-live-score/asia_cup_2026_live_score.dart';
import 'package:futurecore_codex/screens/173-soft-card-tap/soft_card_tap.dart';
import 'package:futurecore_codex/screens/174-scale-transition/scale_transition.dart';
import 'package:futurecore_codex/screens/175-boune-on-tap/bounce_on_tap.dart';
import 'package:futurecore_codex/screens/176-smooth-scroll-animation/smooth_scroll_animation.dart';
import 'package:futurecore_codex/screens/177-breathing-border-radius/breathing_border_radius.dart';
import 'package:futurecore_codex/screens/178-page-transition/page_transition.dart';
import 'package:futurecore_codex/screens/179-list-item-add-animation/list_item_add_animation.dart';
import 'package:futurecore_codex/screens/180-delete-undo-snackbar/delete_undo_snackbar.dart';

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
      home: DeleteUndoDemo(),
    );
  }
}
