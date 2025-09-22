import 'package:flutter/material.dart';
import 'dart:math' as math;

class AiFaceScanner extends StatefulWidget {
  const AiFaceScanner({Key? key}) : super(key: key);

  @override
  State<AiFaceScanner> createState() => _AiFaceScannerState();
}

class _AiFaceScannerState extends State<AiFaceScanner> {
  bool _isScanning = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A0A0F),
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Main AI Face Scanner Loader
              AIFaceScannerLoader(
                isScanning: _isScanning,
                size: 280,
                scanLineColor: const Color(0xFF00F5FF),
                faceFrameColor: const Color(0xFF00D4AA),
                particleColor: const Color(0xFF7C3AED),
                glowColor: const Color(0xFF00F5FF),
                backgroundColor: Colors.black.withOpacity(0.3),
                onScanComplete: () {
                  // Handle scan completion
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Face Scan Complete! ✨'),
                      backgroundColor: Color(0xFF00D4AA),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 60),
              
              // Control Button
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isScanning = !_isScanning;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isScanning 
                        ? const Color(0xFFFF6B6B) 
                        : const Color(0xFF00F5FF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32, 
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 8,
                  ),
                  child: Text(
                    _isScanning ? 'Stop Scanning' : 'Start Face Scan',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
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

/// Ultra-stylish AI Face Scanner Loader Widget
/// 
/// A stunning, customizable face scanner with smooth animations,
/// particle effects, and mesmerizing visual feedback.
/// 
/// Features:
/// - Smooth scanning line animation
/// - Particle system with floating effects
/// - Corner frame animations
/// - Glow effects and gradients
/// - Fully customizable colors and size
/// - Production-ready and reusable
class AIFaceScannerLoader extends StatefulWidget {
  /// Whether the scanner is actively scanning
  final bool isScanning;
  
  /// Size of the scanner (width and height)
  final double size;
  
  /// Color of the scanning line
  final Color scanLineColor;
  
  /// Color of the face frame corners
  final Color faceFrameColor;
  
  /// Color of the floating particles
  final Color particleColor;
  
  /// Color of the glow effect
  final Color glowColor;
  
  /// Background color of the scanner area
  final Color backgroundColor;
  
  /// Duration of one complete scan cycle
  final Duration scanDuration;
  
  /// Callback when scan cycle completes
  final VoidCallback? onScanComplete;
  
  /// Enable/disable particle effects
  final bool showParticles;
  
  /// Enable/disable glow effects
  final bool showGlow;
  
  /// Thickness of the scan line
  final double scanLineThickness;
  
  /// Corner frame size
  final double cornerSize;

  const AIFaceScannerLoader({
    Key? key,
    required this.isScanning,
    this.size = 250.0,
    this.scanLineColor = const Color(0xFF00F5FF),
    this.faceFrameColor = const Color(0xFF00D4AA),
    this.particleColor = const Color(0xFF7C3AED),
    this.glowColor = const Color(0xFF00F5FF),
    this.backgroundColor = const Color(0x33000000),
    this.scanDuration = const Duration(seconds: 2),
    this.onScanComplete,
    this.showParticles = true,
    this.showGlow = true,
    this.scanLineThickness = 3.0,
    this.cornerSize = 30.0,
  }) : super(key: key);

  @override
  State<AIFaceScannerLoader> createState() => _AIFaceScannerLoaderState();
}

class _AIFaceScannerLoaderState extends State<AIFaceScannerLoader>
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
  
  // Particle system
  final List<Particle> _particles = [];
  final int _maxParticles = 20;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeParticles();
  }

  void _initializeAnimations() {
    // Scan line animation (up-down movement)
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

    // Pulse animation for glow effects
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Rotation animation for corner frames
    _rotationController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));

    // Particle animation
    _particleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _particleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_particleController);

    // Animation listeners
    _scanController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _scanController.reverse();
        widget.onScanComplete?.call();
      } else if (status == AnimationStatus.dismissed) {
        if (widget.isScanning) {
          _scanController.forward();
        }
      }
    });
  }

  void _initializeParticles() {
    for (int i = 0; i < _maxParticles; i++) {
      _particles.add(Particle.random());
    }
  }

  @override
  void didUpdateWidget(AIFaceScannerLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.isScanning != oldWidget.isScanning) {
      if (widget.isScanning) {
        _startScanning();
      } else {
        _stopScanning();
      }
    }
  }

  void _startScanning() {
    _scanController.forward();
    _pulseController.repeat(reverse: true);
    _rotationController.repeat();
    if (widget.showParticles) {
      _particleController.repeat();
    }
  }

  void _stopScanning() {
    _scanController.stop();
    _pulseController.stop();
    _rotationController.stop();
    _particleController.stop();
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
    return AnimatedBuilder(
      animation: Listenable.merge([
        _scanAnimation,
        _pulseAnimation,
        _rotationAnimation,
        _particleAnimation,
      ]),
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background glow effect
              if (widget.showGlow)
                _buildGlowEffect(),
              
              // Main scanner container
              _buildScannerContainer(),
              
              // Floating particles
              if (widget.showParticles)
                ..._buildParticles(),
              
              // Corner frames
              _buildCornerFrames(),
              
              // Scanning line
              if (widget.isScanning)
                _buildScanLine(),
              
              // Center face icon
              _buildCenterIcon(),
              
              // Status indicator
              _buildStatusIndicator(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGlowEffect() {
    return Container(
      width: widget.size + 40,
      height: widget.size + 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: widget.glowColor.withOpacity(0.3 * _pulseAnimation.value),
            blurRadius: 30 + (20 * _pulseAnimation.value),
            spreadRadius: 10 + (5 * _pulseAnimation.value),
          ),
        ],
      ),
    );
  }

  Widget _buildScannerContainer() {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: widget.faceFrameColor.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildParticles() {
    return _particles.map((particle) {
      final animatedParticle = particle.animate(_particleAnimation.value);
      return Positioned(
        left: animatedParticle.x * widget.size,
        top: animatedParticle.y * widget.size,
        child: Container(
          width: animatedParticle.size,
          height: animatedParticle.size,
          decoration: BoxDecoration(
            color: widget.particleColor.withOpacity(animatedParticle.opacity),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: widget.particleColor.withOpacity(0.5),
                blurRadius: 4,
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  Widget _buildCornerFrames() {
    return Transform.rotate(
      angle: _rotationAnimation.value * 0.1, // Subtle rotation
      child: Container(
        width: widget.size - 40,
        height: widget.size - 40,
        child: Stack(
          children: [
            // Top-left corner
            _buildCorner(Alignment.topLeft, 0),
            // Top-right corner
            _buildCorner(Alignment.topRight, math.pi / 2),
            // Bottom-right corner
            _buildCorner(Alignment.bottomRight, math.pi),
            // Bottom-left corner
            _buildCorner(Alignment.bottomLeft, 3 * math.pi / 2),
          ],
        ),
      ),
    );
  }

  Widget _buildCorner(Alignment alignment, double rotation) {
    return Align(
      alignment: alignment,
      child: Transform.rotate(
        angle: rotation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: widget.cornerSize,
          height: widget.cornerSize,
          child: CustomPaint(
            painter: CornerPainter(
              color: widget.faceFrameColor,
              pulseValue: _pulseAnimation.value,
              isScanning: widget.isScanning,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScanLine() {
    final scanProgress = _scanAnimation.value;
    final scanY = (widget.size - 80) * scanProgress + 40;
    
    return Positioned(
      top: scanY,
      left: 40,
      right: 40,
      child: Container(
        height: widget.scanLineThickness,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              widget.scanLineColor,
              widget.scanLineColor,
              Colors.transparent,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: widget.scanLineColor,
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterIcon() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: widget.isScanning 
            ? widget.scanLineColor.withOpacity(0.2)
            : Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: widget.isScanning 
              ? widget.scanLineColor
              : Colors.white.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Icon(
        Icons.face_retouching_natural,
        color: widget.isScanning 
            ? widget.scanLineColor
            : Colors.white.withOpacity(0.7),
        size: 30,
      ),
    );
  }

  Widget _buildStatusIndicator() {
    return Positioned(
      bottom: 10,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: widget.isScanning 
              ? widget.scanLineColor.withOpacity(0.2)
              : Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: widget.isScanning 
                ? widget.scanLineColor
                : Colors.grey.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: widget.isScanning 
                    ? widget.scanLineColor
                    : Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              widget.isScanning ? 'Scanning...' : 'Ready',
              style: TextStyle(
                color: widget.isScanning 
                    ? widget.scanLineColor
                    : Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom painter for corner frames
class CornerPainter extends CustomPainter {
  final Color color;
  final double pulseValue;
  final bool isScanning;

  CornerPainter({
    required this.color,
    required this.pulseValue,
    required this.isScanning,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(isScanning ? pulseValue : 0.7)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    
    // Draw L-shaped corner
    path.moveTo(0, size.height * 0.6);
    path.lineTo(0, 0);
    path.lineTo(size.width * 0.6, 0);

    canvas.drawPath(path, paint);
    
    // Add glow effect
    if (isScanning) {
      final glowPaint = Paint()
        ..color = color.withOpacity(0.3 * pulseValue)
        ..strokeWidth = 6.0
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 3);
      
      canvas.drawPath(path, glowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CornerPainter oldDelegate) {
    return oldDelegate.pulseValue != pulseValue ||
           oldDelegate.isScanning != isScanning;
  }
}

/// Particle class for floating effects
class Particle {
  double x, y;
  double size;
  double opacity;
  double velocityX, velocityY;
  double lifespan;
  double age = 0;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.opacity,
    required this.velocityX,
    required this.velocityY,
    required this.lifespan,
  });

  factory Particle.random() {
    final random = math.Random();
    return Particle(
      x: random.nextDouble(),
      y: random.nextDouble(),
      size: 2 + random.nextDouble() * 4,
      opacity: 0.3 + random.nextDouble() * 0.7,
      velocityX: (random.nextDouble() - 0.5) * 0.02,
      velocityY: (random.nextDouble() - 0.5) * 0.02,
      lifespan: 2 + random.nextDouble() * 2,
    );
  }

  Particle animate(double time) {
    age = time * lifespan;
    final newOpacity = opacity * (1 - (age % 1)) * 
                      (age < 1 ? 1 : (2 - age).clamp(0.0, 1.0));
    
    return Particle(
      x: (x + velocityX * time) % 1,
      y: (y + velocityY * time) % 1,
      size: size * (0.5 + 0.5 * math.sin(time * math.pi * 4)),
      opacity: newOpacity.clamp(0.0, 1.0),
      velocityX: velocityX,
      velocityY: velocityY,
      lifespan: lifespan,
    );
  }
}