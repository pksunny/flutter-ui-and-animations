import 'package:flutter/material.dart';
import 'dart:math' as math;

class ShimmerColorSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A0A0A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Shimmer Color Splash',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w300,
                letterSpacing: 2,
              ),
            ),
            SizedBox(height: 60),
            
            // Demo buttons with different configurations
            ShimmerColorSplashButton(
              onPressed: () => print('Button 1 pressed'),
              splashColors: [
                Color(0xFF6B73FF),
                Color(0xFF9B59B6),
                Color(0xFFE91E63),
                Color(0xFFFF5722),
                Color(0xFFFF9800),
                Color(0xFFFFEB3B),
                Color(0xFF4CAF50),
                Color(0xFF00BCD4),
              ],
              child: Text(
                'COSMIC SPLASH',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            
            SizedBox(height: 30),
            
            ShimmerColorSplashButton(
              onPressed: () => print('Button 2 pressed'),
              buttonSize: Size(80, 80),
              borderRadius: 40,
              splashIntensity: 1.5,
              waveCount: 12,
              splashColors: [
                Color(0xFFFF6B9D),
                Color(0xFFC44569),
                Color(0xFF6C5CE7),
                Color(0xFF74B9FF),
                Color(0xFF00CEC9),
                Color(0xFF55E6C1),
              ],
              child: Icon(Icons.favorite, color: Colors.white, size: 24),
            ),
            
            SizedBox(height: 30),
            
            ShimmerColorSplashButton(
              onPressed: () => print('Button 3 pressed'),
              buttonSize: Size(140, 50),
              splashDuration: Duration(milliseconds: 2000),
              glowIntensity: 2.0,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'PREMIUM',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
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

/// Ultra-stylish Shimmer Color Splash Button Widget
/// Creates mesmerizing rainbow shimmer waves that spread on button press
class ShimmerColorSplashButton extends StatefulWidget {
  /// Callback function when button is pressed
  final VoidCallback? onPressed;
  
  /// Child widget to display inside the button
  final Widget child;
  
  /// Size of the button (default: 200x60)
  final Size buttonSize;
  
  /// Border radius of the button (default: 30)
  final double borderRadius;
  
  /// List of colors for the shimmer waves (default: rainbow colors)
  final List<Color> splashColors;
  
  /// Duration of the splash animation (default: 1500ms)
  final Duration splashDuration;
  
  /// Number of waves to create (default: 8)
  final int waveCount;
  
  /// Intensity of the splash effect (default: 1.0)
  final double splashIntensity;
  
  /// Background color of the button (default: transparent with white border)
  final Color backgroundColor;
  
  /// Border color of the button (default: white30)
  final Color borderColor;
  
  /// Glow intensity around the button (default: 1.0)
  final double glowIntensity;
  
  /// Enable/disable haptic feedback (default: true)
  final bool enableHapticFeedback;

  const ShimmerColorSplashButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.buttonSize = const Size(200, 60),
    this.borderRadius = 30,
    this.splashColors = const [
      Color(0xFF6B73FF),
      Color(0xFF9B59B6),
      Color(0xFFE91E63),
      Color(0xFFFF5722),
      Color(0xFFFF9800),
      Color(0xFFFFEB3B),
      Color(0xFF4CAF50),
      Color(0xFF00BCD4),
    ],
    this.splashDuration = const Duration(milliseconds: 1500),
    this.waveCount = 8,
    this.splashIntensity = 1.0,
    this.backgroundColor = const Color(0x1AFFFFFF),
    this.borderColor = const Color(0x4DFFFFFF),
    this.glowIntensity = 1.0,
    this.enableHapticFeedback = true,
  }) : super(key: key);

  @override
  _ShimmerColorSplashButtonState createState() => _ShimmerColorSplashButtonState();
}

class _ShimmerColorSplashButtonState extends State<ShimmerColorSplashButton>
    with TickerProviderStateMixin {
  
  late AnimationController _splashController;
  late AnimationController _buttonController;
  late AnimationController _glowController;
  
  late Animation<double> _splashAnimation;
  late Animation<double> _buttonScaleAnimation;
  late Animation<double> _glowAnimation;
  
  List<ShimmerWave> _waves = [];
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controllers
    _splashController = AnimationController(
      duration: widget.splashDuration,
      vsync: this,
    );
    
    _buttonController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    
    _glowController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    // Initialize animations
    _splashAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _splashController,
      curve: Curves.easeOutQuart,
    ));

    _buttonScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _buttonController,
      curve: Curves.easeInOut,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    // Listen to splash animation to update waves
    _splashAnimation.addListener(() {
      setState(() {
        _updateWaves();
      });
    });

    _glowController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _splashController.dispose();
    _buttonController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  /// Creates shimmer waves for the splash effect
  void _createWaves() {
    _waves.clear();
    final random = math.Random();
    
    for (int i = 0; i < widget.waveCount; i++) {
      final angle = (2 * math.pi / widget.waveCount) * i;
      final colorIndex = i % widget.splashColors.length;
      final delay = random.nextDouble() * 0.3; // Random delay up to 300ms
      
      _waves.add(ShimmerWave(
        angle: angle,
        color: widget.splashColors[colorIndex],
        delay: delay,
        intensity: widget.splashIntensity,
      ));
    }
  }

  /// Updates wave positions based on animation progress
  void _updateWaves() {
    for (var wave in _waves) {
      final adjustedProgress = math.max(0.0, _splashAnimation.value - wave.delay);
      wave.updatePosition(adjustedProgress);
    }
  }

  /// Handles button press with haptic feedback and animations
  void _handlePress() async {
    if (widget.onPressed == null) return;

    setState(() {
      _isPressed = true;
    });

    // Haptic feedback
    if (widget.enableHapticFeedback) {
      // Note: Import 'package:flutter/services.dart' for HapticFeedback
      // HapticFeedback.lightImpact();
    }

    // Button press animation
    await _buttonController.forward();
    await _buttonController.reverse();

    // Create and start splash animation
    _createWaves();
    await _splashController.forward();
    _splashController.reset();

    // Call the callback
    widget.onPressed?.call();

    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _handlePress(),
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _buttonScaleAnimation,
          _glowAnimation,
          _splashAnimation,
        ]),
        builder: (context, child) {
          return Transform.scale(
            scale: _buttonScaleAnimation.value,
            child: Container(
              width: widget.buttonSize.width,
              height: widget.buttonSize.height,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  // Glow effect
                  Container(
                    width: widget.buttonSize.width + (20 * widget.glowIntensity * _glowAnimation.value),
                    height: widget.buttonSize.height + (10 * widget.glowIntensity * _glowAnimation.value),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(widget.borderRadius + 10),
                      boxShadow: [
                        BoxShadow(
                          color: widget.splashColors.first.withOpacity(0.3 * _glowAnimation.value),
                          blurRadius: 20 * widget.glowIntensity,
                          spreadRadius: 5 * widget.glowIntensity * _glowAnimation.value,
                        ),
                      ],
                    ),
                  ),

                  // Shimmer waves
                  if (_splashAnimation.value > 0)
                    ..._waves.map((wave) => _buildWave(wave)).toList(),

                  // Main button
                  Container(
                    width: widget.buttonSize.width,
                    height: widget.buttonSize.height,
                    decoration: BoxDecoration(
                      color: widget.backgroundColor,
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      border: Border.all(
                        color: widget.borderColor,
                        width: 1,
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.1),
                          Colors.transparent,
                          Colors.black.withOpacity(0.1),
                        ],
                      ),
                    ),
                    child: Center(
                      child: widget.child,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Builds individual shimmer wave widget
  Widget _buildWave(ShimmerWave wave) {
    if (wave.progress <= 0) return SizedBox.shrink();

    final maxRadius = math.max(widget.buttonSize.width, widget.buttonSize.height) * 3;
    final currentRadius = maxRadius * wave.progress;
    final opacity = (1.0 - wave.progress) * 0.8;

    return Positioned(
      left: wave.x - currentRadius / 2,
      top: wave.y - currentRadius / 2,
      child: Container(
        width: currentRadius,
        height: currentRadius,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            center: Alignment.center,
            colors: [
              wave.color.withOpacity(opacity),
              wave.color.withOpacity(opacity * 0.5),
              Colors.transparent,
            ],
            stops: [0.0, 0.7, 1.0],
          ),
        ),
      ),
    );
  }
}

/// Helper class for individual shimmer wave properties and animation
class ShimmerWave {
  final double angle;
  final Color color;
  final double delay;
  final double intensity;
  
  double progress = 0.0;
  double x = 0.0;
  double y = 0.0;

  ShimmerWave({
    required this.angle,
    required this.color,
    required this.delay,
    required this.intensity,
  });

  /// Updates wave position based on animation progress
  void updatePosition(double animationProgress) {
    progress = math.min(1.0, animationProgress * intensity);
    
    if (progress > 0) {
      final distance = 150 * progress * intensity;
      x = math.cos(angle) * distance;
      y = math.sin(angle) * distance;
    }
  }
}

/// Advanced shimmer gradient painter for additional effects (optional)
class ShimmerGradientPainter extends CustomPainter {
  final Animation<double> animation;
  final List<Color> colors;
  
  ShimmerGradientPainter({
    required this.animation,
    required this.colors,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final progress = animation.value;
    if (progress <= 0) return;

    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment(-1.0 + (2.0 * progress), -1.0),
        end: Alignment(1.0 + (2.0 * progress), 1.0),
        colors: colors,
        stops: List.generate(colors.length, (i) => i / (colors.length - 1)),
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..blendMode = BlendMode.overlay;

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(30),
    );
    
    canvas.drawRRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}