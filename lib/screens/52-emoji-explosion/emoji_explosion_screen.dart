import 'package:flutter/material.dart';
import 'dart:math';

class EmojiExplosionScreen extends StatefulWidget {
  const EmojiExplosionScreen({Key? key}) : super(key: key);

  @override
  State<EmojiExplosionScreen> createState() => _EmojiExplosionScreenState();
}

class _EmojiExplosionScreenState extends State<EmojiExplosionScreen>
    with TickerProviderStateMixin {
  List<EmojiParticle> particles = [];
  final Random random = Random();
  
  final List<String> emojis = [
    '✨', '🎉', '🎊', '💫', '⭐', '🌟', '💥', '🔥',
    '❤️', '💜', '💙', '💚', '💛', '🧡', '🤍', '🖤',
    '🦄', '🌈', '🎯', '🎨', '🎭', '🎪', '🎢', '🎡',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F0C29),
              Color(0xFF24243e),
              Color(0xFF302B63),
              Color(0xFF0F0C29),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Animated background elements
            ...List.generate(20, (index) => AnimatedBackground(index: index)),
            
            // Main content
            GestureDetector(
              onTapDown: (details) => _createExplosion(details.localPosition),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Title with glow effect
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.purple.withOpacity(0.3),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Text(
                        'EMOJI EXPLOSION',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 3,
                          shadows: [
                            Shadow(
                              offset: Offset(0, 0),
                              blurRadius: 20,
                              color: Colors.purpleAccent,
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 50),
                    
                    // Interactive elements
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildInteractiveButton('🎯', 'TAP ME'),
                        _buildInteractiveButton('💥', 'BOOM'),
                        _buildInteractiveButton('✨', 'MAGIC'),
                      ],
                    ),
                    
                    const SizedBox(height: 50),
                    
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        'Tap anywhere to create magical emoji explosions',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.w300,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Particle system
            ...particles.map((particle) => particle.widget),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractiveButton(String emoji, String text) {
    return GestureDetector(
      onTap: () {
        // Create explosion at button center
        final RenderBox renderBox = context.findRenderObject() as RenderBox;
        final size = renderBox.size;
        _createExplosion(Offset(size.width / 2, size.height / 2));
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 5),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _createExplosion(Offset position) {
    const int particleCount = 15;
    
    for (int i = 0; i < particleCount; i++) {
      final emoji = emojis[random.nextInt(emojis.length)];
      final particle = EmojiParticle(
        emoji: emoji,
        startPosition: position,
        random: random,
        onComplete: _removeParticle,
        vsync: this,
      );
      
      setState(() {
        particles.add(particle);
      });
    }
  }

  void _removeParticle(EmojiParticle particle) {
    if (mounted) {
      setState(() {
        particles.remove(particle);
      });
    }
  }
}

class EmojiParticle {
  final String emoji;
  final Offset startPosition;
  final Random random;
  final Function(EmojiParticle) onComplete;
  late final AnimationController controller;
  late final Animation<double> animation;
  late final Animation<double> fadeAnimation;
  late final Animation<double> scaleAnimation;
  late final Animation<double> rotationAnimation;
  late final double velocityX;
  late final double velocityY;
  late final double gravity;

  EmojiParticle({
    required this.emoji,
    required this.startPosition,
    required this.random,
    required this.onComplete,
    required TickerProvider vsync,
  }) {
    controller = AnimationController(
      duration: Duration(milliseconds: 2000 + random.nextInt(1000)),
      vsync: vsync,
    );

    animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeOut),
    );

    fadeAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
      ),
    );

    scaleAnimation = Tween<double>(begin: 0.5, end: 1.5).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.3, curve: Curves.elasticOut),
      ),
    );

    rotationAnimation = Tween<double>(begin: 0, end: 2 * pi).animate(
      CurvedAnimation(parent: controller, curve: Curves.linear),
    );

    // Random velocity and physics
    final angle = random.nextDouble() * 2 * pi;
    final speed = 50 + random.nextDouble() * 100;
    velocityX = cos(angle) * speed;
    velocityY = sin(angle) * speed - 50; // Slight upward bias
    gravity = 200 + random.nextDouble() * 100;

    controller.forward().then((_) {
      controller.dispose();
      onComplete(this);
    });
  }

  Widget get widget {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final progress = animation.value;
        final currentX = startPosition.dx + velocityX * progress;
        final currentY = startPosition.dy + velocityY * progress + 0.5 * gravity * progress * progress;

        return Positioned(
          left: currentX - 15,
          top: currentY - 15,
          child: Opacity(
            opacity: fadeAnimation.value,
            child: Transform.scale(
              scale: scaleAnimation.value,
              child: Transform.rotate(
                angle: rotationAnimation.value,
                child: Text(
                  emoji,
                  style: const TextStyle(
                    fontSize: 30,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 0),
                        blurRadius: 10,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class AnimatedBackground extends StatefulWidget {
  final int index;
  const AnimatedBackground({Key? key, required this.index}) : super(key: key);

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final Random random = Random();
  late double x, y, size;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 10 + random.nextInt(10)),
      vsync: this,
    );
    
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );
    
    x = random.nextDouble();
    y = random.nextDouble();
    size = 2 + random.nextDouble() * 4;
    
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          left: MediaQuery.of(context).size.width * x,
          top: MediaQuery.of(context).size.height * (y + _animation.value * 0.1) % 1,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1 + random.nextDouble() * 0.1),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.purpleAccent.withOpacity(0.3),
                  blurRadius: size * 2,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}