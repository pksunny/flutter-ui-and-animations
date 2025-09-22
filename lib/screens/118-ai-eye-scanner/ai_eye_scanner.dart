import 'package:flutter/material.dart';
import 'dart:math' as math;

class AiEyeScanner extends StatelessWidget {
  const AiEyeScanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF0A0A0F),
            ],
          ),
        ),
        child: Center(
          child: AIEyeScanner(
            profileImage: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300&h=300&fit=crop&crop=face',
            size: 280,
            onScanComplete: (result) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Scan Complete: $result'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
            scanDuration: const Duration(seconds: 3),
            glowColor: const Color(0xFF00FF88),
            pulseColor: const Color(0xFF0080FF),
          ),
        ),
      ),
    );
  }
}

/// 🚀 Ultra-Stylish AI Eye Scanner Widget
/// 
/// A next-generation profile scanner with laser animation effects
/// Features:
/// - Magical laser scanning animation
/// - Customizable colors, size, and duration
/// - Smooth micro-interactions and transitions
/// - Reusable and production-ready
/// - Stunning visual effects with particle systems
class AIEyeScanner extends StatefulWidget {
  /// Profile image URL or asset path
  final String profileImage;
  
  /// Size of the scanner widget
  final double size;
  
  /// Duration of the scanning animation
  final Duration scanDuration;
  
  /// Primary glow color for laser effect
  final Color glowColor;
  
  /// Secondary pulse color
  final Color pulseColor;
  
  /// Background color for the scanner frame
  final Color frameColor;
  
  /// Callback when scan is complete
  final Function(String result)? onScanComplete;
  
  /// Auto start scanning on widget load
  final bool autoStart;
  
  /// Show scanning particles effect
  final bool showParticles;
  
  /// Laser line thickness
  final double laserThickness;

  const AIEyeScanner({
    Key? key,
    required this.profileImage,
    this.size = 250,
    this.scanDuration = const Duration(seconds: 2),
    this.glowColor = const Color(0xFF00FF88),
    this.pulseColor = const Color(0xFF0080FF),
    this.frameColor = const Color(0xFF1E1E2E),
    this.onScanComplete,
    this.autoStart = true,
    this.showParticles = true,
    this.laserThickness = 3.0,
  }) : super(key: key);

  @override
  State<AIEyeScanner> createState() => _AIEyeScannerState();
}

class _AIEyeScannerState extends State<AIEyeScanner>
    with TickerProviderStateMixin {
  
  // Animation Controllers
  late AnimationController _scanController;
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late AnimationController _particleController;
  
  // Animations
  late Animation<double> _scanAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _particleAnimation;
  
  // State variables
  bool _isScanning = false;
  bool _scanComplete = false;
  
  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    
    if (widget.autoStart) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        startScan();
      });
    }
  }
  
  /// Initialize all animation controllers and animations
  void _initializeAnimations() {
    // Laser scan animation (vertical movement)
    _scanController = AnimationController(
      duration: widget.scanDuration,
      vsync: this,
    );
    
    _scanAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scanController,
      curve: Curves.easeInOut,
    ));
    
    // Pulse animation for outer rings
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    // Rotation animation for outer frame
    _rotationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
    
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(_rotationController);
    
    // Particle animation
    _particleController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    
    _particleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _particleController,
      curve: Curves.easeOut,
    ));
  }
  
  /// Start the scanning process
  Future<void> startScan() async {
    if (_isScanning) return;
    
    setState(() {
      _isScanning = true;
      _scanComplete = false;
    });
    
    // Start particle effect
    if (widget.showParticles) {
      _particleController.repeat();
    }
    
    // Start scanning animation
    await _scanController.forward();
    
    // Scan complete
    setState(() {
      _isScanning = false;
      _scanComplete = true;
    });
    
    // Stop particles
    _particleController.stop();
    
    // Callback with result
    widget.onScanComplete?.call("Profile verified successfully");
    
    // Reset after delay
    await Future.delayed(const Duration(seconds: 1));
    _scanController.reset();
    setState(() {
      _scanComplete = false;
    });
  }
  
  @override
  void dispose() {
    _scanController.dispose();
    _pulseController.dispose();
    _rotationController.dispose();
    _particleController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => startScan(),
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Animated outer rings
            _buildPulsingRings(),
            
            // Rotating frame
            _buildRotatingFrame(),
            
            // Profile image with frame
            _buildProfileImage(),
            
            // Laser scanner overlay
            if (_isScanning) _buildLaserScanner(),
            
            // Particle effects
            if (widget.showParticles && _isScanning) _buildParticleEffect(),
            
            // Scan complete indicator
            if (_scanComplete) _buildScanCompleteIndicator(),
            
            // Status text
            _buildStatusText(),
          ],
        ),
      ),
    );
  }
  
  /// Build pulsing rings around the scanner
  Widget _buildPulsingRings() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Outer ring
            Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: widget.pulseColor.withOpacity(0.3),
                    width: 2,
                  ),
                ),
              ),
            ),
            // Inner ring
            Transform.scale(
              scale: _pulseAnimation.value * 0.8,
              child: Container(
                width: widget.size * 0.8,
                height: widget.size * 0.8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: widget.glowColor.withOpacity(0.4),
                    width: 1,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
  
  /// Build rotating hexagonal frame
  Widget _buildRotatingFrame() {
    return AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotationAnimation.value,
          child: CustomPaint(
            size: Size(widget.size, widget.size),
            painter: HexagonFramePainter(
              color: widget.frameColor,
              strokeWidth: 2,
            ),
          ),
        );
      },
    );
  }
  
  /// Build the profile image with glow effect
  Widget _buildProfileImage() {
    return Container(
      width: widget.size * 0.6,
      height: widget.size * 0.6,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: _isScanning 
              ? widget.glowColor.withOpacity(0.6)
              : widget.pulseColor.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: ClipOval(
        child: Image.network(
          widget.profileImage,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: widget.frameColor,
              child: Icon(
                Icons.person,
                size: widget.size * 0.3,
                color: Colors.white54,
              ),
            );
          },
        ),
      ),
    );
  }
  
  /// Build the laser scanning overlay
  Widget _buildLaserScanner() {
    return AnimatedBuilder(
      animation: _scanAnimation,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: LaserScannerPainter(
            progress: _scanAnimation.value,
            glowColor: widget.glowColor,
            laserThickness: widget.laserThickness,
            imageRadius: widget.size * 0.3,
          ),
        );
      },
    );
  }
  
  /// Build particle effect during scanning
  Widget _buildParticleEffect() {
    return AnimatedBuilder(
      animation: _particleAnimation,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: ParticleEffectPainter(
            animation: _particleAnimation.value,
            color: widget.glowColor,
          ),
        );
      },
    );
  }
  
  /// Build scan complete indicator
  Widget _buildScanCompleteIndicator() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: widget.glowColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: widget.glowColor.withOpacity(0.8),
                  blurRadius: 15,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: Icon(
              Icons.check,
              color: Colors.black,
              size: 30,
            ),
          ),
        );
      },
    );
  }
  
  /// Build status text
  Widget _buildStatusText() {
    String statusText = 'Tap to Scan';
    if (_isScanning) statusText = 'Scanning...';
    if (_scanComplete) statusText = 'Verified ✓';
    
    return Positioned(
      bottom: -40,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Text(
          statusText,
          key: ValueKey(statusText),
          style: TextStyle(
            color: _scanComplete ? widget.glowColor : Colors.white70,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}

/// 🎨 Custom Painter for Hexagonal Frame
class HexagonFramePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  
  HexagonFramePainter({
    required this.color,
    this.strokeWidth = 2,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;
    
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = (i * math.pi) / 3;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 🔬 Custom Painter for Laser Scanner Effect
class LaserScannerPainter extends CustomPainter {
  final double progress;
  final Color glowColor;
  final double laserThickness;
  final double imageRadius;
  
  LaserScannerPainter({
    required this.progress,
    required this.glowColor,
    required this.laserThickness,
    required this.imageRadius,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final scanY = center.dy - imageRadius + (2 * imageRadius * progress);
    
    // Create gradient for laser line
    final gradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Colors.transparent,
        glowColor.withOpacity(0.3),
        glowColor,
        glowColor.withOpacity(0.3),
        Colors.transparent,
      ],
    );
    
    // Draw laser line
    final paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromLTWH(
          center.dx - imageRadius,
          scanY - laserThickness / 2,
          2 * imageRadius,
          laserThickness,
        ),
      );
    
    canvas.drawRect(
      Rect.fromLTWH(
        center.dx - imageRadius,
        scanY - laserThickness / 2,
        2 * imageRadius,
        laserThickness,
      ),
      paint,
    );
    
    // Draw glow effect
    final glowPaint = Paint()
      ..color = glowColor.withOpacity(0.6)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    
    canvas.drawRect(
      Rect.fromLTWH(
        center.dx - imageRadius,
        scanY - laserThickness,
        2 * imageRadius,
        laserThickness * 2,
      ),
      glowPaint,
    );
  }
  
  @override
  bool shouldRepaint(covariant LaserScannerPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// ✨ Custom Painter for Particle Effects
class ParticleEffectPainter extends CustomPainter {
  final double animation;
  final Color color;
  
  ParticleEffectPainter({
    required this.animation,
    required this.color,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.8)
      ..style = PaintingStyle.fill;
    
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.3;
    
    // Draw animated particles
    for (int i = 0; i < 12; i++) {
      final angle = (i * 2 * math.pi) / 12;
      final distance = radius + (20 * animation);
      final opacity = 1 - animation;
      
      final x = center.dx + distance * math.cos(angle);
      final y = center.dy + distance * math.sin(angle);
      
      paint.color = color.withOpacity(opacity * 0.8);
      canvas.drawCircle(
        Offset(x, y),
        2 + (animation * 3),
        paint,
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant ParticleEffectPainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}