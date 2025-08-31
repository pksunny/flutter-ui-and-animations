import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;

class TypingTextAnimationScreen extends StatefulWidget {
  @override
  _TypingTextAnimationScreenState createState() => _TypingTextAnimationScreenState();
}

class _TypingTextAnimationScreenState extends State<TypingTextAnimationScreen>
    with TickerProviderStateMixin {
  
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _rotationController;
  late AnimationController _colorController;
  late AnimationController _cursorController;
  late AnimationController _particleController;
  
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _cursorAnimation;
  late Animation<double> _particleAnimation;
  
  String _currentText = '';
  int _currentIndex = 0;
  Timer? _typingTimer;
  bool _isDeleting = false;
  
  final List<String> _texts = [
    'Welcome to the Future',
    'Amazing Animations',
    'Beautiful UI Design',
    'Flutter Magic',
    'Endless Possibilities'
  ];
  
  final List<Particle> _particles = [];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _generateParticles();
    _startTyping();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _rotationController = AnimationController(
      duration: Duration(seconds: 20),
      vsync: this,
    );
    
    _colorController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );
    
    _cursorController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    
    _particleController = AnimationController(
      duration: Duration(seconds: 10),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );
    
    _rotationAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );
    
    _colorAnimation = ColorTween(
      begin: Colors.cyan,
      end: Colors.purple,
    ).animate(CurvedAnimation(parent: _colorController, curve: Curves.easeInOut));
    
    _cursorAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _cursorController, curve: Curves.easeInOut),
    );
    
    _particleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _particleController, curve: Curves.linear),
    );

    _rotationController.repeat();
    _colorController.repeat(reverse: true);
    _cursorController.repeat(reverse: true);
    _particleController.repeat();
  }

  void _generateParticles() {
    for (int i = 0; i < 50; i++) {
      _particles.add(Particle());
    }
  }

  void _startTyping() {
    _typingTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        if (!_isDeleting) {
          if (_currentText.length < _texts[_currentIndex].length) {
            _currentText = _texts[_currentIndex].substring(0, _currentText.length + 1);
            _fadeController.forward();
            _scaleController.forward();
          } else {
            timer.cancel();
            Timer(Duration(milliseconds: 2000), () {
              _isDeleting = true;
              _startDeleting();
            });
          }
        }
      });
    });
  }

  void _startDeleting() {
    _typingTimer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      setState(() {
        if (_currentText.length > 0) {
          _currentText = _currentText.substring(0, _currentText.length - 1);
        } else {
          timer.cancel();
          _isDeleting = false;
          _currentIndex = (_currentIndex + 1) % _texts.length;
          _fadeController.reset();
          _scaleController.reset();
          Timer(Duration(milliseconds: 500), () {
            _startTyping();
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _rotationController.dispose();
    _colorController.dispose();
    _cursorController.dispose();
    _particleController.dispose();
    _typingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            colors: [
              Color(0xFF1a1a2e),
              Color(0xFF16213e),
              Color(0xFF0f3460),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Animated Background Particles
            AnimatedBuilder(
              animation: _particleAnimation,
              builder: (context, child) {
                return CustomPaint(
                  painter: ParticlePainter(_particles, _particleAnimation.value),
                  size: Size.infinite,
                );
              },
            ),
            
            // Rotating Background Elements
            AnimatedBuilder(
              animation: _rotationAnimation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _rotationAnimation.value,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: SweepGradient(
                        colors: [
                          Colors.transparent,
                          Colors.cyan.withOpacity(0.1),
                          Colors.transparent,
                          Colors.purple.withOpacity(0.1),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            
            // Main Content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Glowing Container
                  Container(
                    padding: EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.cyan.withOpacity(0.3),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.1),
                          Colors.white.withOpacity(0.05),
                        ],
                      ),
                    ),
                    child: AnimatedBuilder(
                      animation: Listenable.merge([
                        _fadeAnimation,
                        _scaleAnimation,
                        _colorAnimation,
                        _cursorAnimation,
                      ]),
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _scaleAnimation.value,
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  // Main Text
                                  TextSpan(
                                    text: _currentText,
                                    style: TextStyle(
                                      fontSize: 48,
                                      fontWeight: FontWeight.bold,
                                      foreground: Paint()
                                        ..shader = LinearGradient(
                                          colors: [
                                            _colorAnimation.value ?? Colors.cyan,
                                            Colors.white,
                                            _colorAnimation.value?.withOpacity(0.8) ?? Colors.purple.withOpacity(0.8),
                                          ],
                                        ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
                                      shadows: [
                                        Shadow(
                                          color: (_colorAnimation.value ?? Colors.cyan).withOpacity(0.8),
                                          blurRadius: 20,
                                          offset: Offset(0, 0),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Animated Cursor
                                  TextSpan(
                                    text: '|',
                                    style: TextStyle(
                                      fontSize: 48,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white.withOpacity(_cursorAnimation.value),
                                      shadows: [
                                        Shadow(
                                          color: Colors.white.withOpacity(0.8),
                                          blurRadius: 10,
                                          offset: Offset(0, 0),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  
                  SizedBox(height: 50),
                  
                  // Subtitle with wave animation
                  AnimatedBuilder(
                    animation: _colorController,
                    builder: (context, child) {
                      return ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [
                            Colors.white70,
                            _colorAnimation.value?.withOpacity(0.8) ?? Colors.cyan.withOpacity(0.8),
                            Colors.white70,
                          ],
                          stops: [0.0, 0.5, 1.0],
                        ).createShader(bounds),
                        child: Text(
                          'Experience the magic of animated typography',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                          textAlign: TextAlign.center,
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
}

class Particle {
  double x;
  double y;
  double size;
  double speed;
  double opacity;
  Color color;

  Particle()
      : x = math.Random().nextDouble(),
        y = math.Random().nextDouble(),
        size = math.Random().nextDouble() * 3 + 1,
        speed = math.Random().nextDouble() * 0.02 + 0.01,
        opacity = math.Random().nextDouble() * 0.5 + 0.3,
        color = [Colors.cyan, Colors.purple, Colors.white][math.Random().nextInt(3)];

  void update() {
    y -= speed;
    if (y < 0) {
      y = 1;
      x = math.Random().nextDouble();
    }
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;

  ParticlePainter(this.particles, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      particle.update();
      
      final paint = Paint()
        ..color = particle.color.withOpacity(particle.opacity * 0.6)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(particle.x * size.width, particle.y * size.height),
        particle.size,
        paint,
      );
      
      // Add glow effect
      final glowPaint = Paint()
        ..color = particle.color.withOpacity(particle.opacity * 0.3)
        ..style = PaintingStyle.fill
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3);

      canvas.drawCircle(
        Offset(particle.x * size.width, particle.y * size.height),
        particle.size * 2,
        glowPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}