import 'package:flutter/material.dart';

class BouncingTextLoadingAnimationScreen extends StatefulWidget {
  @override
  _BouncingTextLoadingAnimationScreenState createState() => _BouncingTextLoadingAnimationScreenState();
}

class _BouncingTextLoadingAnimationScreenState extends State<BouncingTextLoadingAnimationScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _glowController;
  late AnimationController _particleController;
  List<AnimationController> _letterControllers = [];
  List<Animation<double>> _bounceAnimations = [];
  List<Animation<double>> _scaleAnimations = [];
  List<Animation<Color?>> _colorAnimations = [];
  
  final String alphabet = 'MUHAMMAD';
  final List<Color> _neonColors = [
    Color(0xFF00F5FF), // Cyan
    Color(0xFF8A2BE2), // Blue Violet
    Color(0xFFFF1493), // Deep Pink
    Color(0xFF00FF00), // Lime
    Color(0xFFFFD700), // Gold
    Color(0xFFFF4500), // Orange Red
  ];

  @override
  void initState() {
    super.initState();
    
    _mainController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    
    _glowController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );
    
    _particleController = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    );
    
    _initializeLetterAnimations();
    _startAnimations();
  }

  void _initializeLetterAnimations() {
    for (int i = 0; i < alphabet.length; i++) {
      final controller = AnimationController(
        duration: Duration(milliseconds: 800),
        vsync: this,
      );
      _letterControllers.add(controller);
      
      // Bounce animation
      final bounceAnimation = Tween<double>(
        begin: 0.0,
        end: -30.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.elasticOut,
      ));
      _bounceAnimations.add(bounceAnimation);
      
      // Scale animation
      final scaleAnimation = Tween<double>(
        begin: 0.8,
        end: 1.2,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.elasticOut,
      ));
      _scaleAnimations.add(scaleAnimation);
      
      // Color animation
      final colorAnimation = ColorTween(
        begin: Colors.grey.withOpacity(0.3),
        end: _neonColors[i % _neonColors.length],
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ));
      _colorAnimations.add(colorAnimation);
    }
  }

  void _startAnimations() {
    _glowController.repeat(reverse: true);
    _particleController.repeat();
    _animateLetters();
  }

  void _animateLetters() async {
    while (mounted) {
      for (int i = 0; i < alphabet.length; i++) {
        if (mounted) {
          _letterControllers[i].forward().then((_) {
            if (mounted) {
              _letterControllers[i].reverse();
            }
          });
          await Future.delayed(Duration(milliseconds: 100));
        }
      }
      await Future.delayed(Duration(milliseconds: 500));
    }
  }

  @override
  void dispose() {
    _mainController.dispose();
    _glowController.dispose();
    _particleController.dispose();
    for (var controller in _letterControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF0F0F0F),
              Color(0xFF000000),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Animated particles background
            AnimatedBuilder(
              animation: _particleController,
              builder: (context, child) {
                return CustomPaint(
                  painter: ParticlePainter(_particleController.value),
                  size: Size.infinite,
                );
              },
            ),
            
            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title with glow effect
                  AnimatedBuilder(
                    animation: _glowController,
                    builder: (context, child) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 60),
                        child: ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [
                              Colors.cyanAccent,
                              Colors.purpleAccent,
                              Colors.pinkAccent,
                            ],
                            stops: [
                              0.0,
                              _glowController.value,
                              1.0,
                            ],
                          ).createShader(bounds),
                          child: Text(
                            'LOADING',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 8,
                              shadows: [
                                Shadow(
                                  blurRadius: 20 * _glowController.value,
                                  color: Colors.cyanAccent.withOpacity(0.8),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  
                  // Alphabet animation
                  Container(
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(alphabet.length, (index) {
                        return AnimatedBuilder(
                          animation: Listenable.merge([
                            _bounceAnimations[index],
                            _scaleAnimations[index],
                            _colorAnimations[index],
                          ]),
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(0, _bounceAnimations[index].value),
                              child: Transform.scale(
                                scale: _scaleAnimations[index].value,
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  margin: EdgeInsets.symmetric(horizontal: 2),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: _colorAnimations[index].value ?? Colors.transparent,
                                        blurRadius: 15,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      alphabet[index],
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: _colorAnimations[index].value,
                                        shadows: [
                                          Shadow(
                                            blurRadius: 10,
                                            color: (_colorAnimations[index].value ?? Colors.transparent)
                                                .withOpacity(0.8),
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
                      }),
                    ),
                  ),
                  
                  // Loading progress indicator
                  Container(
                    margin: EdgeInsets.only(top: 40),
                    child: AnimatedBuilder(
                      animation: _glowController,
                      builder: (context, child) {
                        return Container(
                          width: 200,
                          height: 4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.cyanAccent,
                                Colors.transparent,
                              ],
                              stops: [
                                0.0,
                                _glowController.value,
                                1.0,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.cyanAccent.withOpacity(0.6),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  
                  // Status text
                  Container(
                    margin: EdgeInsets.only(top: 30),
                    child: AnimatedBuilder(
                      animation: _glowController,
                      builder: (context, child) {
                        return Text(
                          'Initializing Amazing Experience...',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.6 + 0.4 * _glowController.value),
                            letterSpacing: 2,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ParticlePainter extends CustomPainter {
  final double animationValue;
  
  ParticlePainter(this.animationValue);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.cyanAccent.withOpacity(0.3)
      ..strokeWidth = 1;
    
    // Draw floating particles
    for (int i = 0; i < 20; i++) {
      final x = (size.width * (i * 0.1 + animationValue * 0.3)) % size.width;
      final y = (size.height * (i * 0.15 + animationValue * 0.2)) % size.height;
      
      canvas.drawCircle(
        Offset(x, y),
        2 + (animationValue * 3),
        paint..color = Color.lerp(
          Colors.cyanAccent.withOpacity(0.2),
          Colors.purpleAccent.withOpacity(0.4),
          (i * 0.1) % 1.0,
        )!,
      );
    }
    
    // Draw connecting lines
    paint.strokeWidth = 0.5;
    for (int i = 0; i < 10; i++) {
      final startX = (size.width * (i * 0.2 + animationValue * 0.1)) % size.width;
      final startY = (size.height * (i * 0.3 + animationValue * 0.15)) % size.height;
      final endX = (startX + 50 * animationValue) % size.width;
      final endY = (startY + 30 * animationValue) % size.height;
      
      canvas.drawLine(
        Offset(startX, startY),
        Offset(endX, endY),
        paint..color = Colors.cyanAccent.withOpacity(0.1),
      );
    }
  }
  
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}