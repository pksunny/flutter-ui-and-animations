import 'package:flutter/material.dart';
import 'package:futurecore_codex/screens/160-ai-assistant-dashboard/ai_assisstant_dashboard.dart';
import 'package:futurecore_codex/screens/161-smart-planner-ui/smart_planner_ui.dart';
import 'package:futurecore_codex/screens/162-minimal-wallet-app-ui/minimal_wallet_app_ui.dart';
import 'package:futurecore_codex/screens/163-social-feed-ui/social_feed_ui.dart';

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
      home: SocialFeedScreen(),
    );
  }
}
