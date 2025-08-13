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
import 'package:futurecore_codex/screens/23-wave-hand/wave_hand_screen.dart';
import 'package:futurecore_codex/screens/24-emoji-bounce-wheel/emoji_bounce_wheel_screen.dart';
import 'package:futurecore_codex/screens/25-slide-to-confirm-action-bar/slide_to_confirm_action_bar_screen.dart';
import 'package:futurecore_codex/screens/26-fluid-progress-bar/fluid_progress_bar_screen.dart';
import 'package:futurecore_codex/screens/27-success-checkmark-explosion/success_checkmark_explosion_screen.dart';
import 'package:futurecore_codex/screens/28-story-style-stepper/story_style_stepper_screen.dart';
import 'package:futurecore_codex/screens/29-liquid-switch-toggle/liquid_switch_toggle_screen.dart';
import 'package:futurecore_codex/screens/3-six_nill/six_nill_screen.dart';
import 'package:futurecore_codex/screens/30-blobby-button-expansion/blobby_button_expansion_screen.dart';
import 'package:futurecore_codex/screens/31-floating-emojis/floating_emojis_screen.dart';
import 'package:futurecore_codex/screens/32-goeey_menu_expansion/goeey_menu_expansion_screen.dart';
import 'package:futurecore_codex/screens/33-fluid-slider/fluid_slider_screen.dart';
import 'package:futurecore_codex/screens/34-liquid-password-reveal/liquid_password_reveal_screen.dart';
import 'package:futurecore_codex/screens/35-floating-add-to-cart/floating-add_to_cart_screen.dart';
import 'package:futurecore_codex/screens/36-ink-magnet-login-animation/ink_magnet_login_animation_screen.dart';
import 'package:futurecore_codex/screens/37-pulse-absorb-animation/pulse_absorb_animation_screen.dart';
import 'package:futurecore_codex/screens/38-breathing-cards/breating_cards_screen.dart';
import 'package:futurecore_codex/screens/39-finger-trail-liquid-drag/finger_trail_liquid_drag_screen.dart';   
import 'package:futurecore_codex/screens/4-rabbit_loading_animation/rabbit_animations_screen.dart';
import 'package:futurecore_codex/screens/40-mood-responsive-fluid-ui/mood_responsive_fluid_ui.dart';
import 'package:futurecore_codex/screens/41-quantum-matrix-code-breaker-animation/quantum_matrix_code_breaker_animation_screen.dart';
import 'package:futurecore_codex/screens/42-neon-photo-gallery/neon_photo_gallery_screen.dart';
import 'package:futurecore_codex/screens/43-text-flip-animation/text_flip_animation_screen.dart';
import 'package:futurecore_codex/screens/44-ripple-heatmap/ripple_heatmap_screen.dart';
import 'package:futurecore_codex/screens/45-auto-fill-form/auto_fill_form_screen.dart';
import 'package:futurecore_codex/screens/46-letter-growing-animation/letter_growing_animation_screen.dart';
import 'package:futurecore_codex/screens/47-rolling-switch-toggle/rolling_switch_toggle_screen.dart';
import 'package:futurecore_codex/screens/48-shake-delete/shake_delete_screen.dart';
import 'package:futurecore_codex/screens/49-elevator-style-text-reveal/elevator_style_text_reveal.dart';
import 'package:futurecore_codex/screens/5-deadline_loading_animation%20copy/deadline_animations_screen.dart';
import 'package:futurecore_codex/screens/50-throw-away/throw_away_screen.dart';
import 'package:futurecore_codex/screens/51-aura-card-generator/aura_card_generator_screen.dart';
import 'package:futurecore_codex/screens/52-emoji-explosion/emoji_explosion_screen.dart';
import 'package:futurecore_codex/screens/53-grid-detail/grid_detail_screen.dart';
import 'package:futurecore_codex/screens/54-pin-drop-animation/pin_drop_animation_screen.dart';
import 'package:futurecore_codex/screens/55-ai-chat-bubble-morphing-animation/ai_chat_bubble_morphing_animation_screen.dart';
import 'package:futurecore_codex/screens/56-scroll-animation/scroll_animation_screen.dart';
import 'package:futurecore_codex/screens/57-emotional-emoji/emotional_emoji_screen.dart';
import 'package:futurecore_codex/screens/58-card-expansion/card_expansion_animation_screen.dart';
import 'package:futurecore_codex/screens/59-password-reveal/password_reveal_animation_screen.dart';
import 'package:futurecore_codex/screens/6-free_palestine/free_palestine_screen.dart';
import 'package:futurecore_codex/screens/60-unlock-card-animation/unlock_card_animation_screen.dart';
import 'package:futurecore_codex/screens/61-unlock-animation/unlock_animation_screen.dart';
import 'package:futurecore_codex/screens/62-orbiting-avatar-badge/oribiting_avatar_badge_animation_screen.dart';
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
      home: OribitingAvatarBadgeAnimationScreen(),
    );
  }
}
