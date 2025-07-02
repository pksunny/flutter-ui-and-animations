import 'dart:math';
import 'dart:math' as math;

import 'package:flutter/material.dart';

class EmojiBounceWheelScreen extends StatefulWidget {
  const EmojiBounceWheelScreen({super.key});

  @override
  State<EmojiBounceWheelScreen> createState() => _EmojiBounceWheelScreenState();
}

class _EmojiBounceWheelScreenState extends State<EmojiBounceWheelScreen>
    with TickerProviderStateMixin {
  late AnimationController _wheelController;
  late AnimationController _backgroundController;
  late Animation<double> _wheelAnimation;
  late Animation<Color?> _backgroundAnimation;
  
  final List<String> emojis = [
    '😀', '😍', '🤩', '😎', '🥳', '😇', '🤪', '😋',
    '🤗', '🥰', '😘', '🙃', '😊', '😄', '🤣', '😂'
  ];
  
  final List<AnimationController> _bounceControllers = [];
  final List<Animation<double>> _bounceAnimations = [];
  
  int selectedIndex = -1;
  
  @override
  void initState() {
    super.initState();
    
    // Wheel rotation animation
    _wheelController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
    
    _wheelAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _wheelController,
      curve: Curves.linear,
    ));
    
    // Background color animation
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat(reverse: true);
    
    _backgroundAnimation = ColorTween(
      begin: const Color(0xFF1a1a2e),
      end: const Color(0xFF16213e),
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));
    
    // Initialize bounce animations for each emoji
    for (int i = 0; i < emojis.length; i++) {
      final controller = AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      );
      
      final animation = Tween<double>(
        begin: 1.0,
        end: 1.5,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.elasticOut,
      ));
      
      _bounceControllers.add(controller);
      _bounceAnimations.add(animation);
    }
  }
  
  @override
  void dispose() {
    _wheelController.dispose();
    _backgroundController.dispose();
    for (final controller in _bounceControllers) {
      controller.dispose();
    }
    super.dispose();
  }
  
  void _onEmojiTap(int index) {
    setState(() {
      selectedIndex = index;
    });
    
    _bounceControllers[index].forward().then((_) {
      _bounceControllers[index].reverse();
    });
    
    // Add haptic feedback
    // HapticFeedback.mediumImpact();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.0,
                colors: [
                  _backgroundAnimation.value ?? const Color(0xFF1a1a2e),
                  const Color(0xFF0f0f23),
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        const Text(
                          'Emoji Bounce Wheel',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap any emoji to see it bounce!',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Emoji Wheel
                  SizedBox(
                    height: 300,
                    child: AnimatedBuilder(
                      animation: _wheelAnimation,
                      builder: (context, child) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            // Outer glow effect
                            Container(
                              width: 280,
                              height: 280,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue.withOpacity(0.3),
                                    blurRadius: 30,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                            ),
                            
                            // Emoji circle
                            SizedBox(
                              width: 250,
                              height: 250,
                              child: Stack(
                                children: List.generate(emojis.length, (index) {
                                  final angle = (2 * 3.14159 / emojis.length) * index + 
                                              _wheelAnimation.value * 2 * 3.14159;
                                  final x = 100 * (1 + 0.8 * math.cos(angle));
                                  final y = 100 * (1 + 0.8 * math.sin(angle));
                                  
                                  return AnimatedBuilder(
                                    animation: _bounceAnimations[index],
                                    builder: (context, child) {
                                      return Positioned(
                                        left: x,
                                        top: y,
                                        child: Transform.scale(
                                          scale: _bounceAnimations[index].value,
                                          child: GestureDetector(
                                            onTap: () => _onEmojiTap(index),
                                            child: Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: selectedIndex == index
                                                    ? Colors.white.withOpacity(0.2)
                                                    : Colors.transparent,
                                                border: selectedIndex == index
                                                    ? Border.all(
                                                        color: Colors.white.withOpacity(0.5),
                                                        width: 2,
                                                      )
                                                    : null,
                                                boxShadow: selectedIndex == index
                                                    ? [
                                                        BoxShadow(
                                                          color: Colors.white.withOpacity(0.3),
                                                          blurRadius: 15,
                                                          spreadRadius: 2,
                                                        ),
                                                      ]
                                                    : null,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  emojis[index],
                                                  style: const TextStyle(fontSize: 24),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }),
                              ),
                            ),
                            
                            // Center dot
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.5),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Selected emoji display
                  Container(
                    height: 100,
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: selectedIndex >= 0
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  emojis[selectedIndex],
                                  style: const TextStyle(fontSize: 40),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Emoji ${selectedIndex + 1} selected!',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white.withOpacity(0.8),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              'Select an emoji above',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white.withOpacity(0.6),
                              ),
                            ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}