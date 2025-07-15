import 'package:flutter/material.dart';
import 'dart:math' as math;

class InkMagnetLoginAnimationScreen extends StatefulWidget {
  @override
  _InkMagnetLoginAnimationScreenState createState() =>
      _InkMagnetLoginAnimationScreenState();
}

class _InkMagnetLoginAnimationScreenState
    extends State<InkMagnetLoginAnimationScreen>
    with TickerProviderStateMixin {
  late AnimationController _inkController;
  late AnimationController _buttonController;
  late AnimationController _avatarController;
  late AnimationController _particleController;

  late Animation<double> _inkAnimation;
  late Animation<double> _buttonAnimation;
  late Animation<double> _avatarAnimation;
  late Animation<double> _particleAnimation;

  bool _isAnimating = false;
  bool _showAvatar = false;
  List<InkParticle> _particles = [];

  @override
  void initState() {
    super.initState();

    _inkController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    _buttonController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _avatarController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _particleController = AnimationController(
      duration: Duration(milliseconds: 2500),
      vsync: this,
    );

    _inkAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _inkController, curve: Curves.easeInOut));

    _buttonAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );

    _avatarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _avatarController, curve: Curves.elasticOut),
    );

    _particleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _particleController, curve: Curves.easeOut),
    );

    _generateParticles();
  }

  void _generateParticles() {
    _particles.clear();
    for (int i = 0; i < 50; i++) {
      _particles.add(
        InkParticle(
          startX: math.Random().nextDouble() * 400,
          startY: math.Random().nextDouble() * 800,
          targetX: 200,
          targetY: 300,
          size: math.Random().nextDouble() * 4 + 2,
          delay: math.Random().nextDouble() * 0.5,
        ),
      );
    }
  }

  void _startAnimation() async {
    if (_isAnimating) return;

    setState(() {
      _isAnimating = true;
    });

    // Button press animation
    await _buttonController.forward();
    await _buttonController.reverse();

    // Start particle and ink animation
    _particleController.forward();
    _inkController.forward();

    // Show avatar after delay
    Future.delayed(Duration(milliseconds: 1200), () {
      setState(() {
        _showAvatar = true;
      });
      _avatarController.forward();
    });

    // Reset after completion
    Future.delayed(Duration(milliseconds: 4000), () {
      _resetAnimation();
    });
  }

  void _resetAnimation() {
    setState(() {
      _isAnimating = false;
      _showAvatar = false;
    });
    _inkController.reset();
    _avatarController.reset();
    _particleController.reset();
    _generateParticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F0F23)],
          ),
        ),
        child: Stack(
          children: [
            // Background particles
            ...List.generate(
              20,
              (index) => Positioned(
                left: math.Random().nextDouble() * 400,
                top: math.Random().nextDouble() * 800,
                child: Container(
                  width: 2,
                  height: 2,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),

            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo/Title
                  Container(
                    margin: EdgeInsets.only(bottom: 80),
                    child: Column(
                      children: [
                        Text(
                          'INK MAGNET',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                            letterSpacing: 8,
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          width: 60,
                          height: 2,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.deepPurple, Colors.cyan],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Animation Area
                  Container(
                    width: 200,
                    height: 200,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Ink particles
                        AnimatedBuilder(
                          animation: _particleAnimation,
                          builder: (context, child) {
                            return Stack(
                              children:
                                  _particles.map((particle) {
                                    double progress = (_particleAnimation
                                                .value -
                                            particle.delay)
                                        .clamp(0.0, 1.0);

                                    double currentX =
                                        particle.startX +
                                        (particle.targetX - particle.startX) *
                                            Curves.easeInOut.transform(
                                              progress,
                                            );

                                    double currentY =
                                        particle.startY +
                                        (particle.targetY - particle.startY) *
                                            Curves.easeInOut.transform(
                                              progress,
                                            );

                                    return Positioned(
                                      left: currentX,
                                      top: currentY,
                                      child: Container(
                                        width:
                                            particle.size *
                                            (1 - progress * 0.5),
                                        height:
                                            particle.size *
                                            (1 - progress * 0.5),
                                        decoration: BoxDecoration(
                                          color: Colors.deepPurple.withOpacity(
                                            0.7 * progress,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                            );
                          },
                        ),

                        // Ink formation circle
                        AnimatedBuilder(
                          animation: _inkAnimation,
                          builder: (context, child) {
                            return Container(
                              width: 120 * _inkAnimation.value,
                              height: 120 * _inkAnimation.value,
                              decoration: BoxDecoration(
                                gradient: RadialGradient(
                                  colors: [
                                    Colors.deepPurple.withOpacity(0.8),
                                    Colors.cyan.withOpacity(0.6),
                                    Colors.transparent,
                                  ],
                                  stops: [0.0, 0.7, 1.0],
                                ),
                                shape: BoxShape.circle,
                              ),
                            );
                          },
                        ),

                        // Avatar
                        if (_showAvatar)
                          AnimatedBuilder(
                            animation: _avatarAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _avatarAnimation.value,
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [Colors.deepPurple, Colors.cyan],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.deepPurple.withOpacity(
                                          0.5,
                                        ),
                                        blurRadius: 20,
                                        spreadRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.person,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),

                  SizedBox(height: 80),

                  // Login Button
                  AnimatedBuilder(
                    animation: _buttonAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _buttonAnimation.value,
                        child: GestureDetector(
                          onTap: _startAnimation,
                          child: Container(
                            width: 200,
                            height: 60,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.deepPurple, Colors.cyan],
                              ),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.deepPurple.withOpacity(0.3),
                                  blurRadius: 15,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                _isAnimating ? 'CONNECTING...' : 'LOGIN',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _inkController.dispose();
    _buttonController.dispose();
    _avatarController.dispose();
    _particleController.dispose();
    super.dispose();
  }
}

class InkParticle {
  final double startX;
  final double startY;
  final double targetX;
  final double targetY;
  final double size;
  final double delay;

  InkParticle({
    required this.startX,
    required this.startY,
    required this.targetX,
    required this.targetY,
    required this.size,
    required this.delay,
  });
}
