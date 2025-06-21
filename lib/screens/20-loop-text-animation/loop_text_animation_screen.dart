import 'package:flutter/material.dart';
import 'dart:math' as math;

class LoopTextAnimationScreen extends StatefulWidget {
  const LoopTextAnimationScreen({Key? key}) : super(key: key);

  @override
  State<LoopTextAnimationScreen> createState() =>
      _LoopTextAnimationScreenState();
}

class _LoopTextAnimationScreenState extends State<LoopTextAnimationScreen>
    with TickerProviderStateMixin {
  late AnimationController _textController;
  late AnimationController _backgroundController;
  late AnimationController _particleController;
  late AnimationController _glowController;

  late Animation<double> _textOpacity;
  late Animation<double> _textScale;
  late Animation<double> _backgroundRotation;
  late Animation<double> _particleAnimation;
  late Animation<double> _glowAnimation;

  int _currentTextIndex = 0;
  final List<String> _texts = [
    'LIKE',
    'FOLLOW',
    'SHARE',
    'COMMENT',
    'SUPPORT'
  ];

  final List<Color> _colors = [
    const Color(0xFF00D4FF),
    const Color(0xFFFF6B6B),
    const Color(0xFF4ECDC4),
    const Color(0xFFFFE66D),
    const Color(0xFF95E1D3),
  ];

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startTextLoop();
  }

  void _initAnimations() {
    _textController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _backgroundController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _particleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeInOut),
      ),
    );

    _textScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );

    _backgroundRotation = Tween<double>(begin: 0.0, end: 2 * math.pi)
        .animate(_backgroundController);

    _particleAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(_particleController);

    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0)
        .animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));
  }

  void _startTextLoop() {
    _textController.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 1500), () {
        _textController.reverse().then((_) {
          setState(() {
            _currentTextIndex = (_currentTextIndex + 1) % _texts.length;
          });
          _startTextLoop();
        });
      });
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _backgroundController.dispose();
    _particleController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.0,
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
              Color(0xFF0F0F23),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Animated Background
            AnimatedBuilder(
              animation: _backgroundController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _backgroundRotation.value,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: SweepGradient(
                        colors: [
                          Colors.transparent,
                          _colors[_currentTextIndex].withOpacity(0.1),
                          Colors.transparent,
                          _colors[_currentTextIndex].withOpacity(0.05),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            // Floating Particles
            ...List.generate(20, (index) => _buildParticle(index)),

            // Main Content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Main Text Animation
                  AnimatedBuilder(
                    animation: Listenable.merge([
                      _textController,
                      _glowController,
                    ]),
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _textScale.value,
                        child: Opacity(
                          opacity: _textOpacity.value,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 20,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  _colors[_currentTextIndex].withOpacity(0.2),
                                  _colors[_currentTextIndex].withOpacity(0.1),
                                ],
                              ),
                              border: Border.all(
                                color: _colors[_currentTextIndex]
                                    .withOpacity(_glowAnimation.value * 0.8),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: _colors[_currentTextIndex]
                                      .withOpacity(_glowAnimation.value * 0.5),
                                  blurRadius: 30,
                                  spreadRadius: 5,
                                ),
                                BoxShadow(
                                  color: _colors[_currentTextIndex]
                                      .withOpacity(_glowAnimation.value * 0.3),
                                  blurRadius: 60,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                            child: ShaderMask(
                              shaderCallback: (bounds) => LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  _colors[_currentTextIndex],
                                  _colors[_currentTextIndex].withOpacity(0.7),
                                  Colors.white,
                                  _colors[_currentTextIndex],
                                ],
                                stops: const [0.0, 0.3, 0.6, 1.0],
                              ).createShader(bounds),
                              child: Text(
                                _texts[_currentTextIndex],
                                style: const TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 4,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  // Liquid Wave Indicator
                  AnimatedBuilder(
                    animation: _particleController,
                    builder: (context, child) {
                      return Container(
                        width: 200,
                        height: 6,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Colors.transparent,
                              _colors[_currentTextIndex],
                              Colors.transparent,
                            ],
                            stops: [
                              0.0,
                              _particleAnimation.value,
                              math.min(1.0, _particleAnimation.value + 0.3),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // Progress Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_texts.length, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: index == _currentTextIndex ? 20 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: index == _currentTextIndex
                              ? _colors[_currentTextIndex]
                              : _colors[_currentTextIndex].withOpacity(0.3),
                          boxShadow: index == _currentTextIndex
                              ? [
                                  BoxShadow(
                                    color: _colors[_currentTextIndex]
                                        .withOpacity(0.5),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : null,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),

            // Glossy Overlay Effect
            AnimatedBuilder(
              animation: _glowController,
              builder: (context, child) {
                return Positioned.fill(
                  child: IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(_glowAnimation.value * 0.05),
                            Colors.transparent,
                            Colors.white.withOpacity(_glowAnimation.value * 0.03),
                          ],
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
    );
  }

  Widget _buildParticle(int index) {
    final random = math.Random(index);
    final size = random.nextDouble() * 4 + 2;
    final startX = random.nextDouble();
    final startY = random.nextDouble();
    final speed = random.nextDouble() * 0.5 + 0.5;

    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        final progress = (_particleAnimation.value * speed) % 1.0;
        final opacity = math.sin(progress * math.pi);

        return Positioned(
          left: MediaQuery.of(context).size.width * startX,
          top: MediaQuery.of(context).size.height * 
              ((startY + progress * 2) % 1.0),
          child: Opacity(
            opacity: opacity * 0.6,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _colors[_currentTextIndex].withOpacity(0.7),
                boxShadow: [
                  BoxShadow(
                    color: _colors[_currentTextIndex].withOpacity(0.3),
                    blurRadius: size * 2,
                    spreadRadius: size * 0.5,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}