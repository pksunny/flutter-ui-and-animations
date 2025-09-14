import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math' as math;
class RatingBarDialogAnimationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Futuristic Rating System',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w300,
                color: Colors.white.withOpacity(0.9),
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => _showRatingDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                  side: BorderSide(color: Colors.cyan.withOpacity(0.5)),
                ),
              ),
              child: Text('Show Rating Dialog'),
            ),
          ],
        ),
      ),
    );
  }

  void _showRatingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (context) => FuturisticRatingDialog(
        title: 'Rate Your Experience',
        subtitle: 'Your feedback helps us improve',
        onRatingChanged: (rating) {
          print('Rating: $rating');
        },
        onSubmit: (rating) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Thank you for rating: $rating stars'),
              backgroundColor: Colors.cyan.withOpacity(0.8),
            ),
          );
        },
      ),
    );
  }
}

/// Configuration class for customizing the rating dialog appearance and behavior
class RatingDialogConfig {
  final Color primaryColor;
  final Color secondaryColor;
  final Color backgroundColor;
  final Color textColor;
  final Color glowColor;
  final Duration animationDuration;
  final Curve animationCurve;
  final double borderRadius;
  final double starSize;
  final bool enableGlowEffect;
  final bool enableParticleEffect;
  final bool enableGlassmorphism;
  final FontWeight fontWeight;
  final double fontSize;

  const RatingDialogConfig({
    this.primaryColor = const Color(0xFF00FFFF),
    this.secondaryColor = const Color(0xFF0080FF),
    this.backgroundColor = const Color(0xFF1A1A1A),
    this.textColor = Colors.white,
    this.glowColor = const Color(0xFF00FFFF),
    this.animationDuration = const Duration(milliseconds: 600),
    this.animationCurve = Curves.elasticOut,
    this.borderRadius = 20.0,
    this.starSize = 40.0,
    this.enableGlowEffect = true,
    this.enableParticleEffect = true,
    this.enableGlassmorphism = true,
    this.fontWeight = FontWeight.w300,
    this.fontSize = 16.0,
  });
}

/// Futuristic Animated Rating Dialog Widget
class FuturisticRatingDialog extends StatefulWidget {
  final String title;
  final String subtitle;
  final Function(int rating) onRatingChanged;
  final Function(int rating) onSubmit;
  final RatingDialogConfig config;
  final int maxRating;

  const FuturisticRatingDialog({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.onRatingChanged,
    required this.onSubmit,
    this.config = const RatingDialogConfig(),
    this.maxRating = 5,
  }) : super(key: key);

  @override
  State<FuturisticRatingDialog> createState() => _FuturisticRatingDialogState();
}

class _FuturisticRatingDialogState extends State<FuturisticRatingDialog>
    with TickerProviderStateMixin {
  late AnimationController _dialogController;
  late AnimationController _starController;
  late AnimationController _glowController;
  late AnimationController _particleController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _glowAnimation;

  int _currentRating = 0;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startEntryAnimation();
  }

  void _initializeAnimations() {
    // Main dialog animation controller
    _dialogController = AnimationController(
      duration: widget.config.animationDuration,
      vsync: this,
    );

    // Star animation controller
    _starController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    // Glow effect controller
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Particle effect controller
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    // Scale animation for dialog entrance
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _dialogController,
      curve: widget.config.animationCurve,
    ));

    // Fade animation
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _dialogController,
      curve: Curves.easeInOut,
    ));

    // Slide animation
    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _dialogController,
      curve: Curves.elasticOut,
    ));

    // Glow animation
    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));
  }

  void _startEntryAnimation() {
    _dialogController.forward();
    if (widget.config.enableGlowEffect) {
      _glowController.repeat(reverse: true);
    }
    if (widget.config.enableParticleEffect) {
      _particleController.repeat();
    }
  }

  @override
  void dispose() {
    _dialogController.dispose();
    _starController.dispose();
    _glowController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  void _onStarTapped(int rating) {
    setState(() {
      _currentRating = rating;
    });
    _starController.forward().then((_) {
      _starController.reverse();
    });
    widget.onRatingChanged(rating);
  }

  void _onSubmit() {
    if (_currentRating == 0) return;
    
    setState(() {
      _isSubmitting = true;
    });
    
    // Simulate submission delay
    Future.delayed(const Duration(milliseconds: 800), () {
      widget.onSubmit(_currentRating);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnimatedBuilder(
        animation: _dialogController,
        builder: (context, child) {
          return Stack(
            children: [
              // Particle background effect
              if (widget.config.enableParticleEffect)
                _buildParticleBackground(),
              
              // Main dialog
              Center(
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Transform.translate(
                    offset: Offset(0, _slideAnimation.value),
                    child: Opacity(
                      opacity: _fadeAnimation.value,
                      child: _buildDialogContent(),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildParticleBackground() {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return CustomPaint(
          painter: ParticlePainter(
            animationValue: _particleController.value,
            particleColor: widget.config.primaryColor,
          ),
          size: MediaQuery.of(context).size,
        );
      },
    );
  }

  Widget _buildDialogContent() {
    return Container(
      width: 320,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.config.borderRadius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            widget.config.backgroundColor,
            widget.config.backgroundColor.withOpacity(0.8),
          ],
        ),
        border: Border.all(
          color: widget.config.primaryColor.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: widget.config.enableGlowEffect
            ? [
                BoxShadow(
                  color: widget.config.glowColor.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ]
            : [],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.config.borderRadius),
        child: BackdropFilter(
          filter: widget.config.enableGlassmorphism
              ? ImageFilter.blur(sigmaX: 10, sigmaY: 10)
              : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
          child: Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.1),
                  Colors.white.withOpacity(0.05),
                ],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(),
                const SizedBox(height: 30),
                _buildStarRating(),
                const SizedBox(height: 30),
                _buildButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _glowController,
          builder: (context, child) {
            return Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    widget.config.primaryColor.withOpacity(_glowAnimation.value * 0.3),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Icon(
                Icons.star,
                size: 40,
                color: widget.config.primaryColor,
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        Text(
          widget.title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: widget.config.fontWeight,
            color: widget.config.textColor,
            letterSpacing: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          widget.subtitle,
          style: TextStyle(
            fontSize: widget.config.fontSize,
            color: widget.config.textColor.withOpacity(0.7),
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildStarRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.maxRating, (index) {
        final starIndex = index + 1;
        final isSelected = starIndex <= _currentRating;
        
        return AnimatedBuilder(
          animation: _starController,
          builder: (context, child) {
            return GestureDetector(
              onTap: () => _onStarTapped(starIndex),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: AnimatedStar(
                  isSelected: isSelected,
                  size: widget.config.starSize,
                  animationValue: _starController.value,
                  primaryColor: widget.config.primaryColor,
                  secondaryColor: widget.config.secondaryColor,
                  enableGlow: widget.config.enableGlowEffect,
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildButton(
            text: 'Cancel',
            onPressed: () => Navigator.of(context).pop(),
            isPrimary: false,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _buildButton(
            text: _isSubmitting ? 'Submitting...' : 'Submit',
            onPressed: _isSubmitting ? null : _onSubmit,
            isPrimary: true,
          ),
        ),
      ],
    );
  }

  Widget _buildButton({
    required String text,
    required VoidCallback? onPressed,
    required bool isPrimary,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary
              ? widget.config.primaryColor.withOpacity(0.2)
              : Colors.transparent,
          foregroundColor: isPrimary
              ? widget.config.primaryColor
              : widget.config.textColor.withOpacity(0.7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
            side: BorderSide(
              color: isPrimary
                  ? widget.config.primaryColor
                  : widget.config.textColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          elevation: 0,
        ),
        child: _isSubmitting && isPrimary
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    widget.config.primaryColor,
                  ),
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  fontSize: widget.config.fontSize,
                  fontWeight: widget.config.fontWeight,
                  letterSpacing: 0.5,
                ),
              ),
      ),
    );
  }
}

/// Animated Star Widget with customizable effects
class AnimatedStar extends StatelessWidget {
  final bool isSelected;
  final double size;
  final double animationValue;
  final Color primaryColor;
  final Color secondaryColor;
  final bool enableGlow;

  const AnimatedStar({
    Key? key,
    required this.isSelected,
    required this.size,
    required this.animationValue,
    required this.primaryColor,
    required this.secondaryColor,
    required this.enableGlow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scale = isSelected ? 1.0 + (animationValue * 0.3) : 1.0;
    final opacity = isSelected ? 1.0 : 0.3;
    
    return Transform.scale(
      scale: scale,
      child: Container(
        width: size,
        height: size,
        decoration: enableGlow && isSelected
            ? BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.5),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              )
            : null,
        child: Icon(
          isSelected ? Icons.star : Icons.star_border,
          size: size,
          color: isSelected
              ? primaryColor.withOpacity(opacity)
              : Colors.white.withOpacity(opacity),
        ),
      ),
    );
  }
}

/// Custom Painter for Particle Background Effect
class ParticlePainter extends CustomPainter {
  final double animationValue;
  final Color particleColor;
  final List<Particle> particles;

  ParticlePainter({
    required this.animationValue,
    required this.particleColor,
  }) : particles = _generateParticles();

  static List<Particle> _generateParticles() {
    final particles = <Particle>[];
    final random = math.Random();
    
    for (int i = 0; i < 30; i++) {
      particles.add(Particle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: random.nextDouble() * 3 + 1,
        speed: random.nextDouble() * 0.5 + 0.2,
        opacity: random.nextDouble() * 0.5 + 0.2,
      ));
    }
    
    return particles;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..blendMode = BlendMode.screen;

    for (final particle in particles) {
      final x = (particle.x * size.width) +
          (math.sin(animationValue * 2 * math.pi + particle.x * 10) * 20);
      final y = (particle.y * size.height) +
          (animationValue * particle.speed * size.height * 0.1);
      
      final adjustedY = y % size.height;
      
      paint.color = particleColor.withOpacity(
        particle.opacity * (1 - (adjustedY / size.height)),
      );
      
      canvas.drawCircle(
        Offset(x, adjustedY),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

/// Particle data class
class Particle {
  final double x;
  final double y;
  final double size;
  final double speed;
  final double opacity;

  const Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
  });
}