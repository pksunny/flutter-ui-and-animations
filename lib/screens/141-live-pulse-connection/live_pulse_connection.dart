import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Demo screen showcasing the Live Pulse Connection widget
class LivePulseConnectionDemoScreen extends StatefulWidget {
  const LivePulseConnectionDemoScreen({Key? key}) : super(key: key);

  @override
  State<LivePulseConnectionDemoScreen> createState() => _LivePulseConnectionDemoScreenState();
}

class _LivePulseConnectionDemoScreenState extends State<LivePulseConnectionDemoScreen> {
  bool isConnecting = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Example 1: Horizontal Connection
            LivePulseConnection(
              isConnecting: isConnecting,
              startIcon: Icons.smartphone,
              endIcon: Icons.cloud,
              startColor: const Color(0xFF6C5CE7),
              endColor: const Color(0xFF00B894),
              connectionText: isConnecting ? 'Syncing...' : 'Connected',
              onTap: () {
                setState(() {
                  isConnecting = !isConnecting;
                });
              },
            ),
            
            const SizedBox(height: 60),
            
            // Example 2: Vertical Connection
            LivePulseConnection(
              isConnecting: isConnecting,
              startIcon: Icons.person,
              endIcon: Icons.wifi,
              startColor: const Color(0xFFFF6B6B),
              endColor: const Color(0xFF4ECDC4),
              direction: PulseDirection.vertical,
              lineLength: 150,
              connectionText: isConnecting ? 'Connecting...' : 'Online',
              pulseSpeed: const Duration(milliseconds: 1200),
              onTap: () {
                setState(() {
                  isConnecting = !isConnecting;
                });
              },
            ),
            
            const SizedBox(height: 60),
            
            // Control Button
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isConnecting = !isConnecting;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C5CE7),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                isConnecting ? 'Stop Connection' : 'Start Connection',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Direction of the pulse connection line
enum PulseDirection { horizontal, vertical }

/// Ultra-stylish Live Pulse Connection Widget
/// Shows animated dotted line between two icons to indicate connection/syncing status
class LivePulseConnection extends StatefulWidget {
  /// Whether the connection is actively connecting/syncing
  final bool isConnecting;
  
  /// Icon for the start point
  final IconData startIcon;
  
  /// Icon for the end point
  final IconData endIcon;
  
  /// Color for the start icon and its glow
  final Color startColor;
  
  /// Color for the end icon and its glow
  final Color endColor;
  
  /// Direction of the connection line (horizontal or vertical)
  final PulseDirection direction;
  
  /// Length of the connection line
  final double lineLength;
  
  /// Size of the icons
  final double iconSize;
  
  /// Text to display below the connection
  final String? connectionText;
  
  /// Speed of the pulse animation
  final Duration pulseSpeed;
  
  /// Number of dots in the dotted line
  final int dotCount;
  
  /// Size of each dot
  final double dotSize;
  
  /// Callback when the connection is tapped
  final VoidCallback? onTap;
  
  /// Whether to show a glow effect around icons
  final bool showGlow;
  
  /// Whether to show particle effects during connection
  final bool showParticles;

  const LivePulseConnection({
    Key? key,
    required this.isConnecting,
    required this.startIcon,
    required this.endIcon,
    this.startColor = const Color(0xFF6C5CE7),
    this.endColor = const Color(0xFF00B894),
    this.direction = PulseDirection.horizontal,
    this.lineLength = 200,
    this.iconSize = 40,
    this.connectionText,
    this.pulseSpeed = const Duration(milliseconds: 1500),
    this.dotCount = 20,
    this.dotSize = 4,
    this.onTap,
    this.showGlow = true,
    this.showParticles = true,
  }) : super(key: key);

  @override
  State<LivePulseConnection> createState() => _LivePulseConnectionState();
}

class _LivePulseConnectionState extends State<LivePulseConnection>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    // Pulse animation for the dotted line
    _pulseController = AnimationController(
      vsync: this,
      duration: widget.pulseSpeed,
    );
    
    // Rotation animation for icons
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    
    // Scale animation for connection status change
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
    
    if (widget.isConnecting) {
      _pulseController.repeat();
      _rotationController.repeat();
    }
  }

  @override
  void didUpdateWidget(LivePulseConnection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isConnecting != widget.isConnecting) {
      if (widget.isConnecting) {
        _pulseController.repeat();
        _rotationController.repeat();
      } else {
        _pulseController.stop();
        _rotationController.stop();
        _scaleController.forward().then((_) => _scaleController.reverse());
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.direction == PulseDirection.horizontal
              ? _buildHorizontalConnection()
              : _buildVerticalConnection(),
          if (widget.connectionText != null) ...[
            const SizedBox(height: 16),
            _buildConnectionText(),
          ],
        ],
      ),
    );
  }

  /// Build horizontal connection layout
  Widget _buildHorizontalConnection() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildIconWithGlow(
          icon: widget.startIcon,
          color: widget.startColor,
          isStart: true,
        ),
        SizedBox(
          width: widget.lineLength,
          height: widget.iconSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              _buildDottedLine(),
              if (widget.showParticles && widget.isConnecting)
                _buildParticles(),
            ],
          ),
        ),
        _buildIconWithGlow(
          icon: widget.endIcon,
          color: widget.endColor,
          isStart: false,
        ),
      ],
    );
  }

  /// Build vertical connection layout
  Widget _buildVerticalConnection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildIconWithGlow(
          icon: widget.startIcon,
          color: widget.startColor,
          isStart: true,
        ),
        SizedBox(
          width: widget.iconSize,
          height: widget.lineLength,
          child: Stack(
            alignment: Alignment.center,
            children: [
              _buildDottedLine(),
              if (widget.showParticles && widget.isConnecting)
                _buildParticles(),
            ],
          ),
        ),
        _buildIconWithGlow(
          icon: widget.endIcon,
          color: widget.endColor,
          isStart: false,
        ),
      ],
    );
  }

  /// Build icon with optional glow effect and animations
  Widget _buildIconWithGlow({
    required IconData icon,
    required Color color,
    required bool isStart,
  }) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: AnimatedBuilder(
        animation: _rotationController,
        builder: (context, child) {
          return Transform.rotate(
            angle: widget.isConnecting ? _rotationController.value * 2 * math.pi : 0,
            child: Container(
              width: widget.iconSize + 20,
              height: widget.iconSize + 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    color.withOpacity(0.3),
                    color.withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
                boxShadow: widget.showGlow
                    ? [
                        BoxShadow(
                          color: color.withOpacity(widget.isConnecting ? 0.6 : 0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: widget.iconSize,
                  color: color,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Build animated dotted line
  Widget _buildDottedLine() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return CustomPaint(
          size: widget.direction == PulseDirection.horizontal
              ? Size(widget.lineLength, widget.iconSize)
              : Size(widget.iconSize, widget.lineLength),
          painter: DottedLinePainter(
            progress: _pulseController.value,
            isConnecting: widget.isConnecting,
            startColor: widget.startColor,
            endColor: widget.endColor,
            dotCount: widget.dotCount,
            dotSize: widget.dotSize,
            isHorizontal: widget.direction == PulseDirection.horizontal,
          ),
        );
      },
    );
  }

  /// Build particle effects
  Widget _buildParticles() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return CustomPaint(
          size: widget.direction == PulseDirection.horizontal
              ? Size(widget.lineLength, widget.iconSize)
              : Size(widget.iconSize, widget.lineLength),
          painter: ParticlePainter(
            progress: _pulseController.value,
            startColor: widget.startColor,
            endColor: widget.endColor,
            isHorizontal: widget.direction == PulseDirection.horizontal,
          ),
        );
      },
    );
  }

  /// Build connection status text
  Widget _buildConnectionText() {
    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 300),
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: widget.isConnecting
            ? Colors.white.withOpacity(0.9)
            : widget.endColor,
        letterSpacing: 1.2,
      ),
      child: Text(widget.connectionText!),
    );
  }
}

/// Custom painter for the animated dotted line
class DottedLinePainter extends CustomPainter {
  final double progress;
  final bool isConnecting;
  final Color startColor;
  final Color endColor;
  final int dotCount;
  final double dotSize;
  final bool isHorizontal;

  DottedLinePainter({
    required this.progress,
    required this.isConnecting,
    required this.startColor,
    required this.endColor,
    required this.dotCount,
    required this.dotSize,
    required this.isHorizontal,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final lineLength = isHorizontal ? size.width : size.height;
    final spacing = lineLength / (dotCount - 1);

    for (int i = 0; i < dotCount; i++) {
      final position = i * spacing;
      final normalizedPosition = i / (dotCount - 1);
      
      // Calculate wave effect
      final wave = math.sin((normalizedPosition - progress) * math.pi * 2);
      final opacity = isConnecting
          ? ((wave + 1) / 2).clamp(0.2, 1.0)
          : 0.3;
      
      // Color gradient from start to end
      final color = Color.lerp(startColor, endColor, normalizedPosition)!;
      
      // Size pulsation (renamed to avoid shadowing the Size parameter)
      final dotRenderSize = isConnecting
          ? dotSize * (1 + wave * 0.3)
          : dotSize * 0.8;
      
      final paint = Paint()
        ..color = color.withOpacity(opacity)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

      final offset = isHorizontal
          ? Offset(position, size.height / 2)
          : Offset(size.width / 2, position);

      canvas.drawCircle(offset, dotRenderSize / 2, paint);
      
      // Add extra glow for connecting state
      if (isConnecting) {
        final glowPaint = Paint()
          ..color = color.withOpacity(opacity * 0.3)
          ..style = PaintingStyle.fill
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
        
        canvas.drawCircle(offset, dotRenderSize, glowPaint);
      }
    }
  }

  @override
  bool shouldRepaint(DottedLinePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.isConnecting != isConnecting;
  }
}

/// Custom painter for particle effects
class ParticlePainter extends CustomPainter {
  final double progress;
  final Color startColor;
  final Color endColor;
  final bool isHorizontal;

  ParticlePainter({
    required this.progress,
    required this.startColor,
    required this.endColor,
    required this.isHorizontal,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final lineLength = isHorizontal ? size.width : size.height;
    final particleCount = 8;
    
    for (int i = 0; i < particleCount; i++) {
      final particleProgress = (progress + i / particleCount) % 1.0;
      final position = lineLength * particleProgress;
      
      final color = Color.lerp(startColor, endColor, particleProgress)!;
      final opacity = (1 - (particleProgress - 0.5).abs() * 2).clamp(0.0, 0.6);
      
      final paint = Paint()
        ..color = color.withOpacity(opacity)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

      final offset = isHorizontal
          ? Offset(position, size.height / 2)
          : Offset(size.width / 2, position);

      canvas.drawCircle(offset, 3, paint);
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}