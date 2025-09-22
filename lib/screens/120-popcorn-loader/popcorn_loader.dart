import 'package:flutter/material.dart';
import 'dart:math' as math;


class PopcornLoaderDemo extends StatelessWidget {
  const PopcornLoaderDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Amazing Popcorn Loader',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 40),
            // Default Popcorn Loader
            const PopcornLoader(),
            const SizedBox(height: 60),
            // Customized Popcorn Loader
            const PopcornLoader(
              size: 120,
              kernelColor: Colors.amber,
              popcornColor: Colors.white,
              backgroundColor: Color(0xFF1A1A1A),
              particleColors: [Colors.yellow, Colors.orange, Colors.red],
              animationDuration: Duration(milliseconds: 2000),
              kernelCount: 6,
            ),
            const SizedBox(height: 40),
            const Text(
              'Customizable & Reusable',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 🍿 Amazing Popcorn Loader Widget
/// 
/// A stunning loading indicator that animates corn kernels popping into popcorn
/// with beautiful particle effects, smooth transitions, and magical visual appeal.
/// 
/// Features:
/// - Fully customizable colors, size, and animation duration
/// - Smooth kernel-to-popcorn transformation
/// - Beautiful particle explosion effects
/// - Rotation and scaling animations
/// - Production-ready and reusable
class PopcornLoader extends StatefulWidget {
  /// Size of the loader container
  final double size;
  
  /// Color of the corn kernels
  final Color kernelColor;
  
  /// Color of the popped popcorn
  final Color popcornColor;
  
  /// Background color of the loader
  final Color backgroundColor;
  
  /// Colors for particle effects
  final List<Color> particleColors;
  
  /// Duration of the complete animation cycle
  final Duration animationDuration;
  
  /// Number of kernels to animate
  final int kernelCount;
  
  /// Whether to show the container background
  final bool showBackground;
  
  /// Loading text to display (optional)
  final String? loadingText;
  
  /// Text style for loading text
  final TextStyle? loadingTextStyle;

  const PopcornLoader({
    super.key,
    this.size = 100,
    this.kernelColor = const Color(0xFFFFD700),
    this.popcornColor = const Color(0xFFFFFAF0),
    this.backgroundColor = const Color(0xFF1A1A2E),
    this.particleColors = const [
      Color(0xFFFFD700),
      Color(0xFFFFA500),
      Color(0xFFFF6B6B),
      Color(0xFF4ECDC4),
    ],
    this.animationDuration = const Duration(milliseconds: 1500),
    this.kernelCount = 5,
    this.showBackground = true,
    this.loadingText,
    this.loadingTextStyle,
  });

  @override
  State<PopcornLoader> createState() => _PopcornLoaderState();
}

class _PopcornLoaderState extends State<PopcornLoader>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _particleController;
  late AnimationController _rotationController;
  
  late List<AnimationController> _kernelControllers;
  late List<Animation<double>> _kernelAnimations;
  late List<Animation<double>> _scaleAnimations;
  late List<Animation<double>> _opacityAnimations;
  
  late Animation<double> _particleAnimation;
  late Animation<double> _rotationAnimation;
  
  final List<PopcornParticle> _particles = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimation();
  }

  void _initializeAnimations() {
    // Main animation controller
    _mainController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    // Particle animation controller
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Rotation animation controller
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    // Individual kernel controllers
    _kernelControllers = List.generate(
      widget.kernelCount,
      (index) => AnimationController(
        duration: Duration(milliseconds: 300 + (index * 100)),
        vsync: this,
      ),
    );

    // Kernel transformation animations
    _kernelAnimations = _kernelControllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.elasticOut),
      );
    }).toList();

    // Scale animations for popping effect
    _scaleAnimations = _kernelControllers.map((controller) {
      return Tween<double>(begin: 0.5, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.bounceOut),
      );
    }).toList();

    // Opacity animations for fade effects
    _opacityAnimations = _kernelControllers.map((controller) {
      return Tween<double>(begin: 0.3, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();

    // Particle explosion animation
    _particleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _particleController, curve: Curves.easeOut),
    );

    // Rotation animation
    _rotationAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );
  }

  void _startAnimation() {
    _rotationController.repeat();
    
    _mainController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _generateParticles();
        _particleController.forward().then((_) {
          _particleController.reset();
          _resetKernels();
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) _startAnimation();
          });
        });
      }
    });

    _animateKernelsSequentially();
  }

  void _animateKernelsSequentially() async {
    for (int i = 0; i < _kernelControllers.length; i++) {
      await Future.delayed(Duration(milliseconds: 150 + (i * 100)));
      if (mounted) {
        _kernelControllers[i].forward();
      }
    }
    _mainController.forward();
  }

  void _resetKernels() {
    for (var controller in _kernelControllers) {
      controller.reset();
    }
    _mainController.reset();
    _particles.clear();
  }

  void _generateParticles() {
    _particles.clear();
    for (int i = 0; i < 15; i++) {
      _particles.add(PopcornParticle(
        startX: widget.size / 2,
        startY: widget.size / 2,
        endX: widget.size / 2 + (_random.nextDouble() - 0.5) * widget.size * 1.5,
        endY: widget.size / 2 + (_random.nextDouble() - 0.5) * widget.size * 1.5,
        color: widget.particleColors[_random.nextInt(widget.particleColors.length)],
        size: 2 + _random.nextDouble() * 4,
      ));
    }
  }

  @override
  void dispose() {
    _mainController.dispose();
    _particleController.dispose();
    _rotationController.dispose();
    for (var controller in _kernelControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: widget.size + 20,
          height: widget.size + 20,
          decoration: widget.showBackground
              ? BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: BorderRadius.circular(widget.size / 2 + 10),
                  boxShadow: [
                    BoxShadow(
                      color: widget.backgroundColor.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                )
              : null,
          child: AnimatedBuilder(
            animation: Listenable.merge([
              _mainController,
              _particleController,
              _rotationController,
              ..._kernelControllers,
            ]),
            builder: (context, child) {
              return CustomPaint(
                size: Size(widget.size, widget.size),
                painter: PopcornPainter(
                  kernelAnimations: _kernelAnimations,
                  scaleAnimations: _scaleAnimations,
                  opacityAnimations: _opacityAnimations,
                  particleAnimation: _particleAnimation,
                  rotationAnimation: _rotationAnimation,
                  particles: _particles,
                  kernelColor: widget.kernelColor,
                  popcornColor: widget.popcornColor,
                  size: widget.size,
                  kernelCount: widget.kernelCount,
                ),
              );
            },
          ),
        ),
        if (widget.loadingText != null) ...[
          const SizedBox(height: 16),
          Text(
            widget.loadingText!,
            style: widget.loadingTextStyle ??
                TextStyle(
                  color: widget.popcornColor.withOpacity(0.8),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ],
    );
  }
}

/// Custom painter for the popcorn loader
class PopcornPainter extends CustomPainter {
  final List<Animation<double>> kernelAnimations;
  final List<Animation<double>> scaleAnimations;
  final List<Animation<double>> opacityAnimations;
  final Animation<double> particleAnimation;
  final Animation<double> rotationAnimation;
  final List<PopcornParticle> particles;
  final Color kernelColor;
  final Color popcornColor;
  final double size;
  final int kernelCount;

  PopcornPainter({
    required this.kernelAnimations,
    required this.scaleAnimations,
    required this.opacityAnimations,
    required this.particleAnimation,
    required this.rotationAnimation,
    required this.particles,
    required this.kernelColor,
    required this.popcornColor,
    required this.size,
    required this.kernelCount,
  });

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final center = Offset(canvasSize.width / 2, canvasSize.height / 2);
    
    // Draw particles
    _drawParticles(canvas, center);
    
    // Draw kernels/popcorn
    _drawKernels(canvas, center);
  }

  void _drawParticles(Canvas canvas, Offset center) {
    final particlePaint = Paint()..style = PaintingStyle.fill;
    
    for (var particle in particles) {
      final progress = particleAnimation.value;
      final x = particle.startX + (particle.endX - particle.startX) * progress;
      final y = particle.startY + (particle.endY - particle.startY) * progress;
      final opacity = (1.0 - progress).clamp(0.0, 1.0);
      
      particlePaint.color = particle.color.withOpacity(opacity);
      canvas.drawCircle(
        Offset(x, y),
        particle.size * (1.0 - progress * 0.5),
        particlePaint,
      );
    }
  }

  void _drawKernels(Canvas canvas, Offset center) {
    final kernelPaint = Paint()..style = PaintingStyle.fill;
    final popcornPaint = Paint()..style = PaintingStyle.fill;
    
    for (int i = 0; i < kernelCount; i++) {
      final angle = (2 * math.pi * i / kernelCount) + rotationAnimation.value;
      final radius = size * 0.3;
      final x = center.dx + math.cos(angle) * radius;
      final y = center.dy + math.sin(angle) * radius;
      
      final kernelProgress = kernelAnimations[i].value;
      final scale = scaleAnimations[i].value;
      final opacity = opacityAnimations[i].value;
      
      canvas.save();
      canvas.translate(x, y);
      canvas.scale(scale);
      
      if (kernelProgress < 0.5) {
        // Draw kernel
        kernelPaint.color = kernelColor.withOpacity(opacity);
        _drawKernel(canvas, kernelPaint, kernelProgress);
      } else {
        // Draw popcorn
        popcornPaint.color = popcornColor.withOpacity(opacity);
        _drawPopcorn(canvas, popcornPaint, kernelProgress);
      }
      
      canvas.restore();
    }
  }

  void _drawKernel(Canvas canvas, Paint paint, double progress) {
    final kernelSize = 4.0 + (progress * 4.0);
    final path = Path();
    
    // Draw teardrop-shaped kernel
    path.addOval(Rect.fromCenter(
      center: const Offset(0, 2),
      width: kernelSize,
      height: kernelSize * 1.5,
    ));
    
    canvas.drawPath(path, paint);
  }

  void _drawPopcorn(Canvas canvas, Paint paint, double progress) {
    final popProgress = (progress - 0.5) * 2.0;
    final popcornSize = 6.0 + (popProgress * 4.0);
    
    // Draw multiple overlapping circles for popcorn texture
    final offsets = [
      const Offset(0, 0),
      const Offset(-2, -3),
      const Offset(2, -2),
      const Offset(-1, 3),
      const Offset(3, 1),
    ];
    
    for (var offset in offsets) {
      final size = popcornSize * (0.7 + math.Random().nextDouble() * 0.6);
      canvas.drawCircle(offset, size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Data class for particle effects
class PopcornParticle {
  final double startX;
  final double startY;
  final double endX;
  final double endY;
  final Color color;
  final double size;

  PopcornParticle({
    required this.startX,
    required this.startY,
    required this.endX,
    required this.endY,
    required this.color,
    required this.size,
  });
}