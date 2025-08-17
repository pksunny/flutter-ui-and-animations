import 'dart:math';

import 'package:flutter/material.dart';

class SlideUpTextAnimationScreen extends StatefulWidget {
  @override
  _SlideUpTextAnimationScreenState createState() => _SlideUpTextAnimationScreenState();
}

class _SlideUpTextAnimationScreenState extends State<SlideUpTextAnimationScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  final List<String> _words = [
    'Muhammad',
    'Hassan',
    'Hafeez',
    'Flutter',
    'Developer'
  ];

  final List<Color> _colors = [
    Color(0xFF6C5CE7), // Purple
    Color(0xFF00B894), // Green
    Color(0xFFE17055), // Orange
    Color(0xFF0984E3), // Blue
    Color(0xFFD63031), // Red
  ];

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _startAnimation();
  }

  void _startAnimation() async {
    while (mounted) {
      await _animationController.forward();
      await Future.delayed(Duration(milliseconds: 1500));
      await _animationController.reverse();
      await Future.delayed(Duration(milliseconds: 200));
      
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % _words.length;
        });
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
              Color(0xFF0F3460),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated floating dots
              _buildFloatingDots(),
              
              SizedBox(height: 60),
              
              // Main text animation
              Container(
                height: 120,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // "I'M" text - constant
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [
                          Colors.white,
                          Colors.white70,
                        ],
                      ).createShader(bounds),
                      child: Text(
                        "I'M ",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 2,
                          shadows: [
                            Shadow(
                              color: Colors.black26,
                              offset: Offset(0, 4),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Animated sliding text
                    Container(
                      width: 280,
                      height: 70,
                      child: ClipRect(
                        child: AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return SlideTransition(
                              position: _slideAnimation,
                              child: FadeTransition(
                                opacity: _fadeAnimation,
                                child: ShaderMask(
                                  shaderCallback: (bounds) => LinearGradient(
                                    colors: [
                                      _colors[_currentIndex],
                                      _colors[_currentIndex].withOpacity(0.7),
                                    ],
                                  ).createShader(bounds),
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text(
                                      _words[_currentIndex],
                                      style: TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                        letterSpacing: 1.5,
                                        shadows: [
                                          Shadow(
                                            color: _colors[_currentIndex].withOpacity(0.3),
                                            offset: Offset(0, 6),
                                            blurRadius: 12,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 40),
              
              // Subtitle with typewriter effect
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value * 0.8,
                    child: Text(
                      "Creating Amazing Mobile Experiences",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  );
                },
              ),
              
              SizedBox(height: 60),
              
              // Animated progress indicators
              _buildProgressIndicators(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingDots() {
    return Container(
      height: 100,
      child: Stack(
        children: List.generate(5, (index) {
          return AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Positioned(
                left: 50.0 + (index * 60),
                top: 20 + (sin((_animationController.value * 2 * pi) + index) * 15),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _colors[index].withOpacity(0.6),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: _colors[index].withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  Widget _buildProgressIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_words.length, (index) {
        bool isActive = index == _currentIndex;
        return AnimatedContainer(
          duration: Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? _colors[index] : Colors.white24,
            borderRadius: BorderRadius.circular(4),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: _colors[index].withOpacity(0.4),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
        );
      }),
    );
  }
}