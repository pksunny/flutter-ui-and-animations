import 'package:flutter/material.dart';
import 'dart:math' as math;

/// 🎨 Amazing Splash Screen Widget
/// 
/// A fully customizable, production-ready splash screen with:
/// - Morphing gradient backgrounds
/// - Particle system animation
/// - Logo reveal with scale & fade effects
/// - Text animations with stagger effects
/// - Shimmer effects
/// - Smooth transitions
/// 
/// Parameters:
/// - [brandName]: Your app/brand name
/// - [tagline]: Tagline or slogan
/// - [logoIcon]: Icon to display as logo
/// - [duration]: Total animation duration
/// - [primaryColor], [secondaryColor], [accentColor]: Color scheme
/// - [particleCount]: Number of floating particles
/// - [onAnimationComplete]: Callback when animation finishes
class AmazingSplashScreen extends StatefulWidget {
  final String brandName;
  final String tagline;
  final IconData logoIcon;
  final Duration duration;
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final int particleCount;
  final VoidCallback? onAnimationComplete;

  const AmazingSplashScreen({
    Key? key,
    required this.brandName,
    required this.tagline,
    required this.logoIcon,
    this.duration = const Duration(seconds: 4),
    this.primaryColor = const Color(0xFF6C63FF),
    this.secondaryColor = const Color(0xFFFF6584),
    this.accentColor = const Color(0xFF4ECDC4),
    this.particleCount = 50,
    this.onAnimationComplete,
  }) : super(key: key);

  @override
  State<AmazingSplashScreen> createState() => _AmazingSplashScreenState();
}

class _AmazingSplashScreenState extends State<AmazingSplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _masterController;
  late AnimationController _particleController;
  late AnimationController _shimmerController;
  
  // Animation objects
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _logoRotationAnimation;
  late Animation<double> _brandNameAnimation;
  late Animation<double> _taglineAnimation;
  late Animation<Offset> _brandNameSlideAnimation;
  late Animation<Offset> _taglineSlideAnimation;
  late Animation<double> _glowAnimation;
  
  // Particle system
  late List<Particle> _particles;

  @override
  void initState() {
    super.initState();
    
    // Master animation controller
    _masterController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    // Particle animation controller (continuous)
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    // Shimmer effect controller
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    // Logo animations
    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );

    _logoOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    _logoRotationAnimation = Tween<double>(begin: -0.5, end: 0.0).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    // Brand name animation
    _brandNameAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.3, 0.6, curve: Curves.easeOut),
      ),
    );

    _brandNameSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.3, 0.6, curve: Curves.easeOut),
      ),
    );

    // Tagline animation
    _taglineAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.5, 0.8, curve: Curves.easeOut),
      ),
    );

    _taglineSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.5, 0.8, curve: Curves.easeOut),
      ),
    );

    // Glow pulse animation
    _glowAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Initialize particles
    _particles = List.generate(
      widget.particleCount,
      (index) => Particle(
        color: _getRandomColor(),
        size: math.Random().nextDouble() * 4 + 2,
        initialX: math.Random().nextDouble(),
        initialY: math.Random().nextDouble(),
        speedX: (math.Random().nextDouble() - 0.5) * 0.3,
        speedY: (math.Random().nextDouble() - 0.5) * 0.3,
        phase: math.Random().nextDouble() * math.pi * 2,
      ),
    );

    // Start animation
    _masterController.forward();

    // Call completion callback
    _masterController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onAnimationComplete?.call();
      }
    });
  }

  Color _getRandomColor() {
    final colors = [
      widget.primaryColor,
      widget.secondaryColor,
      widget.accentColor,
    ];
    return colors[math.Random().nextInt(colors.length)].withOpacity(0.6);
  }

  @override
  void dispose() {
    _masterController.dispose();
    _particleController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: AnimatedBuilder(
        animation: _masterController,
        builder: (context, child) {
          return Container(
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(Colors.white, widget.primaryColor.withOpacity(0.1),
                      _masterController.value * 0.3)!,
                  Color.lerp(Colors.white, widget.secondaryColor.withOpacity(0.1),
                      _masterController.value * 0.2)!,
                  Color.lerp(Colors.white, widget.accentColor.withOpacity(0.1),
                      _masterController.value * 0.3)!,
                ],
                stops: [
                  0.0 + (_masterController.value * 0.1),
                  0.5 - (_masterController.value * 0.1),
                  1.0,
                ],
              ),
            ),
            child: Stack(
              children: [
                // Particle system background
                _buildParticleSystem(size),
                
                // Main content
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo with glow effect
                      _buildAnimatedLogo(),
                      
                      const SizedBox(height: 40),
                      
                      // Brand name
                      _buildAnimatedBrandName(),
                      
                      const SizedBox(height: 16),
                      
                      // Tagline
                      _buildAnimatedTagline(),
                      
                      const SizedBox(height: 60),
                      
                      // Loading indicator
                      _buildLoadingIndicator(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Particle system with floating animation
  Widget _buildParticleSystem(Size size) {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return CustomPaint(
          size: size,
          painter: ParticlePainter(
            particles: _particles,
            animationValue: _particleController.value,
            opacity: _masterController.value,
          ),
        );
      },
    );
  }

  // Animated logo with scale, rotation, glow effects
  Widget _buildAnimatedLogo() {
    return FadeTransition(
      opacity: _logoOpacityAnimation,
      child: ScaleTransition(
        scale: _logoScaleAnimation,
        child: RotationTransition(
          turns: _logoRotationAnimation,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  widget.primaryColor,
                  widget.secondaryColor,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.primaryColor.withOpacity(0.6 * _glowAnimation.value),
                  blurRadius: 40 * _glowAnimation.value,
                  spreadRadius: 10 * _glowAnimation.value,
                ),
                BoxShadow(
                  color: widget.secondaryColor.withOpacity(0.4 * _glowAnimation.value),
                  blurRadius: 60 * _glowAnimation.value,
                  spreadRadius: 5 * _glowAnimation.value,
                ),
              ],
            ),
            child: Icon(
              widget.logoIcon,
              size: 60,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  // Animated brand name with shimmer effect
  Widget _buildAnimatedBrandName() {
    return FadeTransition(
      opacity: _brandNameAnimation,
      child: SlideTransition(
        position: _brandNameSlideAnimation,
        child: AnimatedBuilder(
          animation: _shimmerController,
          builder: (context, child) {
            return ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    widget.primaryColor,
                    widget.secondaryColor,
                    widget.accentColor,
                    widget.primaryColor,
                  ],
                  stops: [
                    _shimmerController.value - 0.3,
                    _shimmerController.value,
                    _shimmerController.value + 0.3,
                    _shimmerController.value + 0.6,
                  ],
                  tileMode: TileMode.mirror,
                ).createShader(bounds);
              },
              child: Text(
                widget.brandName,
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  color: Colors.white,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Animated tagline
  Widget _buildAnimatedTagline() {
    return FadeTransition(
      opacity: _taglineAnimation,
      child: SlideTransition(
        position: _taglineSlideAnimation,
        child: Text(
          widget.tagline,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            letterSpacing: 1,
            color: Colors.black87.withOpacity(0.7),
          ),
        ),
      ),
    );
  }

  // Custom loading indicator
  Widget _buildLoadingIndicator() {
    return FadeTransition(
      opacity: _taglineAnimation,
      child: SizedBox(
        width: 200,
        child: AnimatedBuilder(
          animation: _masterController,
          builder: (context, child) {
            return Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: _masterController.value,
                    backgroundColor: Colors.black12,
                    valueColor: AlwaysStoppedAnimation(
                      Color.lerp(
                        widget.primaryColor,
                        widget.secondaryColor,
                        _masterController.value,
                      ),
                    ),
                    minHeight: 4,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '${(_masterController.value * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                    letterSpacing: 1,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Particle data class
class Particle {
  final Color color;
  final double size;
  final double initialX;
  final double initialY;
  final double speedX;
  final double speedY;
  final double phase;

  Particle({
    required this.color,
    required this.size,
    required this.initialX,
    required this.initialY,
    required this.speedX,
    required this.speedY,
    required this.phase,
  });
}

/// Custom painter for particle system
class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;
  final double opacity;

  ParticlePainter({
    required this.particles,
    required this.animationValue,
    required this.opacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      // Calculate particle position with wave motion
      final x = (particle.initialX +
              particle.speedX * animationValue +
              math.sin(animationValue * math.pi * 2 + particle.phase) * 0.05) *
          size.width;
      
      final y = (particle.initialY +
              particle.speedY * animationValue +
              math.cos(animationValue * math.pi * 2 + particle.phase) * 0.05) *
          size.height;

      // Wrap particles around screen
      final wrappedX = x % size.width;
      final wrappedY = y % size.height;

      // Draw particle with glow
      final paint = Paint()
        ..color = particle.color.withOpacity(opacity * 0.6)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

      canvas.drawCircle(
        Offset(wrappedX, wrappedY),
        particle.size,
        paint,
      );

      // Draw inner bright core
      final corePaint = Paint()
        ..color = particle.color.withOpacity(opacity * 0.9);

      canvas.drawCircle(
        Offset(wrappedX, wrappedY),
        particle.size * 0.5,
        corePaint,
      );
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}