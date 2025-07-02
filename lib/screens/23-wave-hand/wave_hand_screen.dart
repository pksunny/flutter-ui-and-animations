import 'package:flutter/material.dart';
import 'dart:math' as math;

class WaveHandScreen extends StatefulWidget {
  @override
  _WaveHandScreenState createState() => _WaveHandScreenState();
}

class _WaveHandScreenState extends State<WaveHandScreen>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late AnimationController _backgroundController;
  
  late Animation<double> _waveAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Color?> _backgroundAnimation;
  
  @override
  void initState() {
    super.initState();
    
    // Wave animation controller
    _waveController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    
    // Scale animation controller
    _scaleController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );
    
    // Fade animation controller
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    
    // Background animation controller
    _backgroundController = AnimationController(
      duration: Duration(milliseconds: 3000),
      vsync: this,
    );
    
    // Wave animation (rotation)
    _waveAnimation = Tween<double>(
      begin: -0.3,
      end: 0.3,
    ).animate(CurvedAnimation(
      parent: _waveController,
      curve: Curves.easeInOut,
    ));
    
    // Scale animation (pulsing effect)
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));
    
    // Fade animation
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    // Background gradient animation
    _backgroundAnimation = ColorTween(
      begin: Color(0xFF667eea),
      end: Color(0xFF764ba2),
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));
    
    // Start animations
    _startAnimations();
  }
  
  void _startAnimations() async {
    // Start fade in
    _fadeController.forward();
    
    // Start background animation
    _backgroundController.repeat(reverse: true);
    
    // Wait a bit then start scale animation
    await Future.delayed(Duration(milliseconds: 300));
    _scaleController.forward();
    
    // Start wave animation loop
    _waveController.repeat(reverse: true);
  }
  
  @override
  void dispose() {
    _waveController.dispose();
    _scaleController.dispose();
    _fadeController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _waveController,
          _scaleController,
          _fadeController,
          _backgroundController,
        ]),
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _backgroundAnimation.value ?? Color(0xFF667eea),
                  Color(0xFF764ba2),
                  Color(0xFFf093fb),
                ],
              ),
            ),
            child: Stack(
              children: [
                // Floating particles background
                ...List.generate(20, (index) => 
                  Positioned(
                    left: (index * 50.0) % MediaQuery.of(context).size.width,
                    top: (index * 80.0) % MediaQuery.of(context).size.height,
                    child: AnimatedBuilder(
                      animation: _backgroundController,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(
                            20 * math.sin(_backgroundController.value * 2 * math.pi + index),
                            20 * math.cos(_backgroundController.value * 2 * math.pi + index),
                          ),
                          child: Opacity(
                            opacity: 0.1,
                            child: Container(
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                
                // Main content
                Center(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Waving hand emoji with animations
                        Transform.scale(
                          scale: _scaleAnimation.value,
                          child: Transform.rotate(
                            angle: _waveAnimation.value,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 5,
                                    blurRadius: 20,
                                    offset: Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  '👋',
                                  style: TextStyle(
                                    fontSize: 60,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 40),
                        
                        // Welcome text with shimmer effect
                        ShaderMask(
                          shaderCallback: (bounds) {
                            return LinearGradient(
                              colors: [
                                Colors.white,
                                Colors.white.withOpacity(0.8),
                                Colors.white,
                              ],
                              stops: [
                                0.0,
                                _backgroundController.value,
                                1.0,
                              ],
                            ).createShader(bounds);
                          },
                          child: Text(
                            'Hi There!',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 16),
                        
                        // Subtitle with fade animation
                        AnimatedBuilder(
                          animation: _fadeController,
                          builder: (context, child) {
                            return Opacity(
                              opacity: _fadeAnimation.value * 0.8,
                              child: Text(
                                'Welcome to something amazing',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white.withOpacity(0.9),
                                  letterSpacing: 0.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            );
                          },
                        ),
                        
                        SizedBox(height: 60),
                        
                        // Animated dots indicator
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(3, (index) {
                            return AnimatedBuilder(
                              animation: _backgroundController,
                              builder: (context, child) {
                                double delay = index * 0.3;
                                double animValue = (_backgroundController.value + delay) % 1.0;
                                
                                return Container(
                                  margin: EdgeInsets.symmetric(horizontal: 4),
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(
                                      0.3 + (0.7 * (1 - animValue.abs())),
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                );
                              },
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}