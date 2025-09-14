import 'package:flutter/material.dart';
import 'dart:math' as math;

class ProfileCompletionWheelScreen extends StatefulWidget {
  @override
  _ProfileCompletionWheelScreenState createState() => _ProfileCompletionWheelScreenState();
}

class _ProfileCompletionWheelScreenState extends State<ProfileCompletionWheelScreen> {
  bool hasPhoto = false;
  bool hasBio = false;
  bool hasEmail = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A0A0F),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Complete Your Profile',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w300,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 40),
            
            // Interactive Profile Completion Wheel
            InteractiveProfileCompletionWheel(
              size: 350,
              hasPhoto: hasPhoto,
              hasBio: hasBio,
              hasEmail: hasEmail,
              avatarImage: NetworkImage('https://images.unsplash.com/photo-1633332755192-727a05c4013d?w=150&h=150&fit=crop&crop=face'),
              onPhotoTap: () => setState(() => hasPhoto = !hasPhoto),
              onBioTap: () => setState(() => hasBio = !hasBio),
              onEmailTap: () => setState(() => hasEmail = !hasEmail),
            ),
            
            SizedBox(height: 60),
            
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton('Add Photo', Icons.camera_alt, () {
                  setState(() => hasPhoto = !hasPhoto);
                }),
                _buildActionButton('Write Bio', Icons.edit, () {
                  setState(() => hasBio = !hasBio);
                }),
                _buildActionButton('Add Email', Icons.email, () {
                  setState(() => hasEmail = !hasEmail);
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: LinearGradient(
            colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF6366F1).withOpacity(0.3),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 🎯 Interactive Profile Completion Wheel Widget
/// 
/// A stunning, customizable circular progress wheel that shows profile completion
/// with beautiful animations and interactive elements.
class InteractiveProfileCompletionWheel extends StatefulWidget {
  /// Size of the wheel
  final double size;
  
  /// Profile completion states
  final bool hasPhoto;
  final bool hasBio;
  final bool hasEmail;
  
  /// Avatar image
  final ImageProvider? avatarImage;
  
  /// Callbacks for interactions
  final VoidCallback? onPhotoTap;
  final VoidCallback? onBioTap;
  final VoidCallback? onEmailTap;
  
  /// Customization options
  final Color primaryColor;
  final Color secondaryColor;
  final Color backgroundColor;
  final Color completedColor;
  final double strokeWidth;
  final Duration animationDuration;
  
  const InteractiveProfileCompletionWheel({
    Key? key,
    this.size = 250,
    required this.hasPhoto,
    required this.hasBio,
    required this.hasEmail,
    this.avatarImage,
    this.onPhotoTap,
    this.onBioTap,
    this.onEmailTap,
    this.primaryColor = const Color(0xFF6366F1),
    this.secondaryColor = const Color(0xFF8B5CF6),
    this.backgroundColor = const Color(0xFF1F2937),
    this.completedColor = const Color(0xFF10B981),
    this.strokeWidth = 8.0,
    this.animationDuration = const Duration(milliseconds: 800),
  }) : super(key: key);

  @override
  _InteractiveProfileCompletionWheelState createState() =>
      _InteractiveProfileCompletionWheelState();
}

class _InteractiveProfileCompletionWheelState
    extends State<InteractiveProfileCompletionWheel>
    with TickerProviderStateMixin {
  
  late AnimationController _progressController;
  late AnimationController _glowController;
  late AnimationController _pulseController;
  
  late Animation<double> _progressAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _progressController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    
    _glowController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.elasticOut,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.elasticInOut,
    ));

    _glowController.repeat(reverse: true);
    _updateProgress();
  }

  @override
  void didUpdateWidget(InteractiveProfileCompletionWheel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.hasPhoto != widget.hasPhoto ||
        oldWidget.hasBio != widget.hasBio ||
        oldWidget.hasEmail != widget.hasEmail) {
      _updateProgress();
      _triggerPulse();
    }
  }

  void _updateProgress() {
    double targetProgress = _calculateProgress();
    print(targetProgress);
    _progressController.animateTo(targetProgress);
  }

  void _triggerPulse() {
    _pulseController.forward().then((_) {
      _pulseController.reverse();
    });
  }

  double _calculateProgress() {
    int completed = 0;
    if (widget.hasPhoto) completed++;
    if (widget.hasBio) completed++;
    if (widget.hasEmail) completed++;
    return completed / 3.0;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _progressAnimation,
        _glowAnimation,
        _pulseAnimation,
      ]),
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            width: widget.size,
            height: widget.size,
            padding: EdgeInsets.all(0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background glow effect
                _buildGlowEffect(),
                
                // Progress wheel
                _buildProgressWheel(),
                
                // Interactive icons
                _buildInteractiveIcons(),
                
                // Center avatar
                _buildCenterAvatar(),
                
                // Completion percentage
                _buildCompletionText(),
              ],
            ),
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
            color: widget.primaryColor.withOpacity(0.3 * _glowAnimation.value),
            blurRadius: 30,
            spreadRadius: 10,
          ),
          BoxShadow(
            color: widget.secondaryColor.withOpacity(0.2 * _glowAnimation.value),
            blurRadius: 60,
            spreadRadius: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressWheel() {
    return CustomPaint(
      size: Size(widget.size, widget.size),
      painter: ProgressWheelPainter(
        progress: _progressController.value,
        backgroundColor: widget.backgroundColor,
        primaryColor: widget.primaryColor,
        secondaryColor: widget.secondaryColor,
        completedColor: widget.completedColor,
        strokeWidth: widget.strokeWidth,
        hasPhoto: widget.hasPhoto,
        hasBio: widget.hasBio,
        hasEmail: widget.hasEmail,
      ),
    );
  }

  Widget _buildInteractiveIcons() {
    return Stack(
      children: [
        _buildIcon(
          Icons.camera_alt,
          30, // Top position
          widget.hasPhoto,
          widget.onPhotoTap,
        ),
        _buildIcon(
          Icons.edit,
          130, // Right position (120 degrees)
          widget.hasBio,
          widget.onBioTap,
        ),
        _buildIcon(
          Icons.email,
          255, // Left position (240 degrees)
          widget.hasEmail,
          widget.onEmailTap,
        ),
      ],
    );
  }

  Widget _buildIcon(IconData icon, double angle, bool isCompleted, VoidCallback? onTap) {
    double radians = (angle * math.pi) / 180;
    double radius = widget.size / 2 - 20;
    double x = radius * math.cos(radians - math.pi / 2);
    double y = radius * math.sin(radians - math.pi / 2);

    return Positioned(
      left: widget.size / 2 + x - 25,
      top: widget.size / 2 + y - 25,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: isCompleted
                ? LinearGradient(
                    colors: [widget.completedColor, widget.completedColor.withOpacity(0.8)],
                  )
                : LinearGradient(
                    colors: [widget.backgroundColor, widget.backgroundColor.withOpacity(0.8)],
                  ),
            border: Border.all(
              color: isCompleted ? widget.completedColor : widget.primaryColor,
              width: 2,
            ),
            boxShadow: isCompleted ? [
              BoxShadow(
                color: widget.completedColor.withOpacity(0.4),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ] : [],
          ),
          child: Icon(
            icon,
            color: isCompleted ? Colors.white : widget.primaryColor,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildCenterAvatar() {
    return Container(
      width: widget.size * 0.35,
      height: widget.size * 0.35,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            widget.primaryColor.withOpacity(0.8),
            widget.secondaryColor.withOpacity(0.8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: widget.primaryColor.withOpacity(0.4),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(4),
        child: ClipOval(
          child: widget.avatarImage != null
              ? Image(
                  image: widget.avatarImage!,
                  fit: BoxFit.cover,
                )
              : Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.backgroundColor,
                  ),
                  child: Icon(
                    Icons.person,
                    size: widget.size * 0.15,
                    color: widget.primaryColor,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildCompletionText() {
    int percentage = (_progressController.value * 100).round();
    
    return Positioned(
      bottom: 30,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              widget.primaryColor.withOpacity(0.2),
              widget.secondaryColor.withOpacity(0.2),
            ],
          ),
          border: Border.all(
            color: widget.primaryColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Text(
          '$percentage% Complete',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _progressController.dispose();
    _glowController.dispose();
    _pulseController.dispose();
    super.dispose();
  }
}

/// Custom painter for the progress wheel
class ProgressWheelPainter extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final Color primaryColor;
  final Color secondaryColor;
  final Color completedColor;
  final double strokeWidth;
  final bool hasPhoto;
  final bool hasBio;
  final bool hasEmail;

  ProgressWheelPainter({
    required this.progress,
    required this.backgroundColor,
    required this.primaryColor,
    required this.secondaryColor,
    required this.completedColor,
    required this.strokeWidth,
    required this.hasPhoto,
    required this.hasBio,
    required this.hasEmail,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress segments
    _drawProgressSegment(canvas, center, radius, 30, hasPhoto);
    _drawProgressSegment(canvas, center, radius, 130, hasBio);
    _drawProgressSegment(canvas, center, radius, 255, hasEmail);

    // Overall progress arc
    if (progress > 0) {
      final progressPaint = Paint()
        ..shader = LinearGradient(
          colors: [primaryColor, secondaryColor],
        ).createShader(Rect.fromCircle(center: center, radius: radius))
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth / 2
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 4),
        -math.pi / 2,
        2 * math.pi * progress,
        false,
        progressPaint,
      );
    }
  }

  void _drawProgressSegment(Canvas canvas, Offset center, double radius, double startAngle, bool isCompleted) {
    final segmentPaint = Paint()
      ..color = isCompleted ? completedColor : primaryColor.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth - 2
      ..strokeCap = StrokeCap.round;

    double startRadians = (startAngle - 30) * math.pi / 180 - math.pi / 2;
    double sweepRadians = 60 * math.pi / 180;

    if (isCompleted) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startRadians,
        sweepRadians,
        false,
        segmentPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}