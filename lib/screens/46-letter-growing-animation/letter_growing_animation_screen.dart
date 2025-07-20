import 'dart:math';

import 'package:flutter/material.dart';

class GrowingTextWidget extends StatefulWidget {
  final String text;
  final TextStyle? baseStyle;
  final Duration animationDuration;
  final Duration letterDelay;
  final double growthFactor;
  final Color? glowColor;
  final bool autoStart;

  const GrowingTextWidget({
    Key? key,
    required this.text,
    this.baseStyle,
    this.animationDuration = const Duration(milliseconds: 800),
    this.letterDelay = const Duration(milliseconds: 150),
    this.growthFactor = 1.3,
    this.glowColor,
    this.autoStart = true,
  }) : super(key: key);

  @override
  State<GrowingTextWidget> createState() => _GrowingTextWidgetState();
}

class _GrowingTextWidgetState extends State<GrowingTextWidget>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _scaleAnimations;
  late List<Animation<double>> _opacityAnimations;
  late List<Animation<double>> _glowAnimations;
  
  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    if (widget.autoStart) {
      _startAnimation();
    }
  }

  void _initializeAnimations() {
    _controllers = List.generate(
      widget.text.length,
      (index) => AnimationController(
        duration: widget.animationDuration,
        vsync: this,
      ),
    );

    _scaleAnimations = _controllers.map((controller) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.elasticOut,
      ));
    }).toList();

    _opacityAnimations = _controllers.map((controller) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ));
    }).toList();

    _glowAnimations = _controllers.map((controller) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeInOut),
      ));
    }).toList();
  }

  void _startAnimation() async {
    for (int i = 0; i < _controllers.length; i++) {
      await Future.delayed(widget.letterDelay);
      if (mounted) {
        _controllers[i].forward();
      }
    }
  }

  void resetAnimation() {
    for (var controller in _controllers) {
      controller.reset();
    }
    _startAnimation();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultStyle = TextStyle(
      fontSize: 48,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      letterSpacing: 2.0,
    );

    final textStyle = widget.baseStyle ?? defaultStyle;
    final glowColor = widget.glowColor ?? Colors.cyanAccent;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(widget.text.length, (index) {
          final char = widget.text[index];
          
          return AnimatedBuilder(
            animation: Listenable.merge([
              _scaleAnimations[index],
              _opacityAnimations[index],
              _glowAnimations[index],
            ]),
            builder: (context, child) {
              final scale = _scaleAnimations[index].value;
              final opacity = _opacityAnimations[index].value;
              final glowIntensity = _glowAnimations[index].value;
              
              return Transform.scale(
                scale: scale * widget.growthFactor,
                child: Opacity(
                  opacity: opacity,
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: glowColor.withOpacity(glowIntensity * 0.6),
                          blurRadius: 20 * glowIntensity,
                          spreadRadius: 2 * glowIntensity,
                        ),
                        BoxShadow(
                          color: glowColor.withOpacity(glowIntensity * 0.3),
                          blurRadius: 40 * glowIntensity,
                          spreadRadius: 5 * glowIntensity,
                        ),
                      ],
                    ),
                    child: Text(
                      char,
                      style: textStyle.copyWith(
                        shadows: [
                          Shadow(
                            color: glowColor.withOpacity(glowIntensity * 0.8),
                            blurRadius: 10 * glowIntensity,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

// Example usage widget

class LetterGrowingAnimationScreen extends StatefulWidget {
  const LetterGrowingAnimationScreen({Key? key}) : super(key: key);

  @override
  State<LetterGrowingAnimationScreen> createState() => _LetterGrowingAnimationScreenState();
}

class _LetterGrowingAnimationScreenState extends State<LetterGrowingAnimationScreen> {
  Key _growingTextKey = UniqueKey();
  Key _advancedTextKey = UniqueKey();

  void _restartAnimations() {
    setState(() {
      _growingTextKey = UniqueKey();
      _advancedTextKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            colors: [
              Colors.blue.withOpacity(0.1),
              Colors.purple.withOpacity(0.05),
              Colors.black,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GrowingTextWidget(
                key: _growingTextKey,
                text: "FUTURE",
                baseStyle: TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 8.0,
                ),
                animationDuration: Duration(milliseconds: 1000),
                letterDelay: Duration(milliseconds: 200),
                growthFactor: 1.4,
                glowColor: Colors.cyanAccent,
              ),
              SizedBox(height: 40),
              AdvancedGrowingTextWidget(
                key: _advancedTextKey,
                text: "TECH",
                baseStyle: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                  letterSpacing: 4.0,
                ),
                animationDuration: Duration(milliseconds: 800),
                letterDelay: Duration(milliseconds: 150),
                growthFactor: 1.3,
              ),
              SizedBox(height: 60),
              ElevatedButton(
                onPressed: _restartAnimations,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.cyanAccent,
                  side: BorderSide(color: Colors.cyanAccent, width: 2),
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  "RESTART ANIMATION",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// Advanced version with more effects
class AdvancedGrowingTextWidget extends StatefulWidget {
  final String text;
  final TextStyle? baseStyle;
  final Duration animationDuration;
  final Duration letterDelay;
  final double growthFactor;
  final List<Color> gradientColors;
  final bool enableParticles;
  final bool enableWave;

  const AdvancedGrowingTextWidget({
    Key? key,
    required this.text,
    this.baseStyle,
    this.animationDuration = const Duration(milliseconds: 1200),
    this.letterDelay = const Duration(milliseconds: 100),
    this.growthFactor = 1.5,
    this.gradientColors = const [Colors.cyanAccent, Colors.purpleAccent],
    this.enableParticles = true,
    this.enableWave = true,
  }) : super(key: key);

  @override
  State<AdvancedGrowingTextWidget> createState() => _AdvancedGrowingTextWidgetState();
}

class _AdvancedGrowingTextWidgetState extends State<AdvancedGrowingTextWidget>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _scaleAnimations;
  late List<Animation<double>> _opacityAnimations;
  late List<Animation<double>> _rotationAnimations;
  late List<Animation<Offset>> _slideAnimations;
  late AnimationController _waveController;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimation();
  }

  void _initializeAnimations() {
    _controllers = List.generate(
      widget.text.length,
      (index) => AnimationController(
        duration: widget.animationDuration,
        vsync: this,
      ),
    );

    _waveController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _waveAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_waveController);

    _scaleAnimations = _controllers.map((controller) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.bounceOut,
      ));
    }).toList();

    _opacityAnimations = _controllers.map((controller) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
      ));
    }).toList();

    _rotationAnimations = _controllers.map((controller) {
      return Tween<double>(
        begin: -0.5,
        end: 0.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.elasticOut,
      ));
    }).toList();

    _slideAnimations = _controllers.map((controller) {
      return Tween<Offset>(
        begin: Offset(0, 1),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutBack,
      ));
    }).toList();
  }

  void _startAnimation() async {
    for (int i = 0; i < _controllers.length; i++) {
      await Future.delayed(widget.letterDelay);
      if (mounted) {
        _controllers[i].forward();
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultStyle = TextStyle(
      fontSize: 56,
      fontWeight: FontWeight.w900,
      letterSpacing: 4.0,
    );

    final textStyle = widget.baseStyle ?? defaultStyle;

    return AnimatedBuilder(
      animation: _waveAnimation,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(30),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(widget.text.length, (index) {
              final char = widget.text[index];
              final waveOffset = widget.enableWave 
                  ? sin((_waveAnimation.value * 2 * pi) + (index * 0.5)) * 10
                  : 0.0;
              
              return AnimatedBuilder(
                animation: Listenable.merge([
                  _scaleAnimations[index],
                  _opacityAnimations[index],
                  _rotationAnimations[index],
                  _slideAnimations[index],
                ]),
                builder: (context, child) {
                  final scale = _scaleAnimations[index].value;
                  final opacity = _opacityAnimations[index].value;
                  final rotation = _rotationAnimations[index].value;
                  final slide = _slideAnimations[index].value;
                  
                  return Transform.translate(
                    offset: Offset(0, waveOffset + (slide.dy * 50)),
                    child: Transform.rotate(
                      angle: rotation,
                      child: Transform.scale(
                        scale: scale * widget.growthFactor,
                        child: Opacity(
                          opacity: opacity,
                          child: ShaderMask(
                            shaderCallback: (bounds) {
                              return LinearGradient(
                                colors: widget.gradientColors,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(bounds);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: widget.gradientColors.first.withOpacity(opacity * 0.5),
                                    blurRadius: 25 * opacity,
                                    spreadRadius: 3 * opacity,
                                  ),
                                ],
                              ),
                              child: Text(
                                char,
                                style: textStyle.copyWith(
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      color: widget.gradientColors.last.withOpacity(opacity * 0.8),
                                      blurRadius: 15 * opacity,
                                    ),
                                  ],
                                ),
                              ),
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
        );
      },
    );
  }
}
