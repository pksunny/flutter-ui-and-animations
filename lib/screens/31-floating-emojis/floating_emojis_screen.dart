import 'dart:math';
import 'package:flutter/material.dart';

class FloatingEmojisScreen extends StatefulWidget {
  const FloatingEmojisScreen({super.key});
  @override
  State<FloatingEmojisScreen> createState() => _FloatingEmojisScreenState();
}

class _FloatingEmojisScreenState extends State<FloatingEmojisScreen>
    with TickerProviderStateMixin {
  final List<Widget> _floatingEmojis = [];
  final GlobalKey _stackKey = GlobalKey();
  final random = Random();

  void _startEmojiFromTap(GlobalKey key, String emoji) {
    final RenderBox? stackBox = _stackKey.currentContext?.findRenderObject() as RenderBox?;
    final RenderBox? emojiBox = key.currentContext?.findRenderObject() as RenderBox?;

    if (stackBox == null || emojiBox == null) return;

    final stackOffset = stackBox.localToGlobal(Offset.zero);
    final emojiOffset = emojiBox.localToGlobal(Offset.zero);
    final positionInStack = emojiOffset - stackOffset;

    final startX = positionInStack.dx;
    final startY = MediaQuery.of(context).size.height - positionInStack.dy - 40;

    final controller = AnimationController(
      duration: Duration(milliseconds: 3000 + random.nextInt(800)),
      vsync: this,
    );

    final animation = CurvedAnimation(parent: controller, curve: Curves.easeInOut);

    final yAnim = Tween<double>(begin: startY, end: startY + 350).animate(animation);
    final xShift = random.nextBool() ? 1.0 : -1.0;
    final xAnim = Tween<double>(begin: startX, end: startX + xShift * (random.nextDouble() * 80)).animate(animation);
    final scaleAnim = Tween<double>(begin: 1.2, end: 0.6).animate(animation);
    final rotateAnim = Tween<double>(begin: -0.3, end: 0.3).animate(animation);
    final opacityAnim = Tween<double>(begin: 1, end: 0).animate(animation);

    late final Widget floating;

    floating = AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Positioned(
          left: xAnim.value,
          bottom: yAnim.value,
          child: Opacity(
            opacity: opacityAnim.value,
            child: Transform.rotate(
              angle: rotateAnim.value * sin(controller.value * pi * 2),
              child: Transform.scale(
                scale: scaleAnim.value,
                child: Text(emoji, style: const TextStyle(fontSize: 36)),
              ),
            ),
          ),
        );
      },
    );

    setState(() => _floatingEmojis.add(floating));
    controller.forward();

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
        setState(() => _floatingEmojis.remove(floating));
      }
    });
  }

  void _burstFromButton(GlobalKey key, String emoji) {
    for (int i = 0; i < 5; i++) {
      Future.delayed(Duration(milliseconds: i * 120), () {
        _startEmojiFromTap(key, emoji);
      });
    }
  }

  Widget _reactionButton(String emoji, GlobalKey key) {
    return GestureDetector(
      onTap: () => _burstFromButton(key, emoji),
      child: Container(
        key: key,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white24),
        ),
        child: Text(emoji, style: const TextStyle(fontSize: 26)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey key1 = GlobalKey();
    final GlobalKey key2 = GlobalKey();
    final GlobalKey key3 = GlobalKey();
    final GlobalKey key4 = GlobalKey();
    final GlobalKey key5 = GlobalKey();

    return Scaffold(
      backgroundColor: const Color(0xff0f0f0f),
      body: Stack(
        key: _stackKey,
        children: [
          ..._floatingEmojis,
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(bottom: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _reactionButton("❤️", key1),
                  _reactionButton("😍", key2),
                  _reactionButton("🔥", key3),
                  _reactionButton("👍", key4),
                  _reactionButton("👏", key5),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
