import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedTextMaskingScreen extends StatefulWidget {
  @override
  _AnimatedTextMaskingScreenState createState() => _AnimatedTextMaskingScreenState();
}

class _AnimatedTextMaskingScreenState extends State<AnimatedTextMaskingScreen>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _glowController;
  late AnimationController _particleController;
  
  late Animation<double> _waveAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _particleAnimation;
  
  int _currentIndex = 0;
  
  final List<String> _texts = [
    'AMAZING',
    'STYLISH',
    'UNIQUE',
    'BEAUTIFUL'
  ];
  
  final List<Color> _colors = [
    Color(0xFF6C5CE7),
    Color(0xFF00B894),
    Color(0xFFE17055),
    Color(0xFF0984E3),
    Color(0xFFE84393),
  ];

  @override
  void initState() {
    super.initState();
    
    _waveController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    )..repeat();
    
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _glowController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
    
    _particleController = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    )..repeat();
    
    _waveAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _waveController,
      curve: Curves.easeInOut,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));
    
    _slideAnimation = Tween<double>(
      begin: -1,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));
    
    _glowAnimation = Tween<double>(
      begin: 0.5,
      end: 1.5,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));
    
    _particleAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_particleController);
    
    _startAnimations();
  }
  
  void _startAnimations() {
    _fadeController.forward();
    _slideController.forward();
    
    // Auto-cycle through texts
    Future.delayed(Duration(seconds: 3), () {
      _cycleText();
    });
  }
  
  void _cycleText() {
    if (mounted) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % _texts.length;
      });
      
      _fadeController.reset();
      _slideController.reset();
      _fadeController.forward();
      _slideController.forward();
      
      Future.delayed(Duration(seconds: 3), () {
        _cycleText();
      });
    }
  }

  @override
  void dispose() {
    _waveController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _glowController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.2,
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
              Color(0xFF0F0F23),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Animated particles background
            AnimatedBuilder(
              animation: _particleAnimation,
              builder: (context, child) {
                return CustomPaint(
                  painter: ParticlePainter(_particleAnimation.value),
                  size: Size.infinite,
                );
              },
            ),
            
            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Main text with masking animation
                  AnimatedBuilder(
                    animation: Listenable.merge([
                      _waveAnimation,
                      _fadeAnimation,
                      _slideAnimation,
                      _glowAnimation,
                    ]),
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(
                          _slideAnimation.value * MediaQuery.of(context).size.width,
                          0,
                        ),
                        child: Opacity(
                          opacity: _fadeAnimation.value,
                          child: ShaderMask(
                            shaderCallback: (bounds) {
                              return LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  _colors[_currentIndex].withOpacity(0.8),
                                  _colors[_currentIndex],
                                  Colors.white,
                                  _colors[_currentIndex],
                                  _colors[_currentIndex].withOpacity(0.8),
                                ],
                                stops: [
                                  0.0,
                                  0.2 + (_waveAnimation.value * 0.3),
                                  0.5 + (_waveAnimation.value * 0.2),
                                  0.8 + (_waveAnimation.value * 0.1),
                                  1.0,
                                ],
                              ).createShader(bounds);
                            },
                            child: Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: _colors[_currentIndex].withOpacity(0.3 * _glowAnimation.value),
                                    blurRadius: 30 * _glowAnimation.value,
                                    spreadRadius: 10 * _glowAnimation.value,
                                  ),
                                ],
                              ),
                              child: Text(
                                _texts[_currentIndex],
                                style: TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 8,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  
                  SizedBox(height: 60),
                  
                  // Subtitle with typewriter effect
                  AnimatedBuilder(
                    animation: _fadeAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value * 0.8,
                        child: Text(
                          'Text Masking Animation',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w300,
                            color: Colors.white70,
                            letterSpacing: 4,
                          ),
                        ),
                      );
                    },
                  ),
                  
                  SizedBox(height: 80),
                  
                  // Interactive buttons
                  AnimatedBuilder(
                    animation: _fadeAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: _texts.asMap().entries.map((entry) {
                            int index = entry.key;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _currentIndex = index;
                                });
                                _fadeController.reset();
                                _slideController.reset();
                                _fadeController.forward();
                                _slideController.forward();
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: _currentIndex == index 
                                        ? _colors[index]
                                        : Colors.white24,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(25),
                                  color: _currentIndex == index 
                                      ? _colors[index].withOpacity(0.2)
                                      : Colors.transparent,
                                ),
                                child: Text(
                                  entry.value,
                                  style: TextStyle(
                                    color: _currentIndex == index 
                                        ? _colors[index]
                                        : Colors.white54,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            
            // Floating geometric shapes
            AnimatedBuilder(
              animation: _waveAnimation,
              builder: (context, child) {
                return Positioned(
                  top: 100 + (math.sin(_waveAnimation.value * 2 * math.pi) * 20),
                  left: 50 + (math.cos(_waveAnimation.value * 2 * math.pi) * 30),
                  child: Transform.rotate(
                    angle: _waveAnimation.value * 2 * math.pi,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            _colors[_currentIndex].withOpacity(0.3),
                            _colors[_currentIndex].withOpacity(0.1),
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              },
            ),
            
            AnimatedBuilder(
              animation: _waveAnimation,
              builder: (context, child) {
                return Positioned(
                  bottom: 150 + (math.cos(_waveAnimation.value * 2 * math.pi) * 25),
                  right: 80 + (math.sin(_waveAnimation.value * 2 * math.pi) * 40),
                  child: Transform.rotate(
                    angle: -_waveAnimation.value * 2 * math.pi,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            _colors[(_currentIndex + 1) % _colors.length].withOpacity(0.4),
                            _colors[(_currentIndex + 1) % _colors.length].withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8),
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
}

class ParticlePainter extends CustomPainter {
  final double animationValue;
  
  ParticlePainter(this.animationValue);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;
    
    final random = math.Random(42); // Fixed seed for consistent particles
    
    for (int i = 0; i < 50; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      
      final offsetX = math.sin(animationValue * 2 * math.pi + i) * 20;
      final offsetY = math.cos(animationValue * 2 * math.pi + i) * 15;
      
      final opacity = (math.sin(animationValue * 4 * math.pi + i) + 1) * 0.1;
      
      paint.color = Colors.white.withOpacity(opacity);
      
      canvas.drawCircle(
        Offset(x + offsetX, y + offsetY),
        1 + (math.sin(animationValue * 3 * math.pi + i) * 0.5),
        paint,
      );
    }
  }
  
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}