import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PasswordRevealAnimationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A0A0A),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.2,
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF0A0A0A),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'SECURE ACCESS',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 4,
                  color: Color(0xFF64FFDA),
                  shadows: [
                    Shadow(
                      blurRadius: 10,
                      color: Color(0xFF64FFDA).withOpacity(0.5),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
              FuturisticPasswordField(),
            ],
          ),
        ),
      ),
    );
  }
}

class FuturisticPasswordField extends StatefulWidget {
  @override
  _FuturisticPasswordFieldState createState() => _FuturisticPasswordFieldState();
}

class _FuturisticPasswordFieldState extends State<FuturisticPasswordField>
    with TickerProviderStateMixin {
  bool _isPasswordVisible = false;
  bool _isPressed = false;
  String _password = "MySecurePass123!";
  
  late AnimationController _blinkController;
  late AnimationController _revealController;
  late AnimationController _pulseController;
  late AnimationController _glowController;
  
  late Animation<double> _blinkAnimation;
  late Animation<double> _revealAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    
    // Blink animation
    _blinkController = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    );
    _blinkAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _blinkController, curve: Curves.easeInOut),
    );
    
    // Reveal animation
    _revealController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _revealAnimation = CurvedAnimation(
      parent: _revealController,
      curve: Curves.elasticOut,
    );
    
    // Pulse animation
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    
    // Glow animation
    _glowController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );
    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
    
    // Start continuous animations
    _startContinuousAnimations();
  }

  void _startContinuousAnimations() {
    // Random blinking
    _startRandomBlinking();
    
    // Continuous glow
    _glowController.repeat(reverse: true);
  }

  void _startRandomBlinking() async {
    await Future.delayed(Duration(seconds: 2 + (DateTime.now().millisecond % 3)));
    if (mounted && _isPasswordVisible) { // Blink only when password is visible (eye closed)
      _blinkController.forward().then((_) {
        _blinkController.reverse().then((_) {
          _startRandomBlinking();
        });
      });
    }
  }

  void _togglePasswordVisibility() async {
    setState(() {
      _isPressed = true;
    });
    
    // Haptic feedback
    HapticFeedback.lightImpact();
    
    // Stop blinking and glow when revealing
    _glowController.stop();
    
    // Blink before revealing/hiding
    await _blinkController.forward();
    await _blinkController.reverse();
    
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
      _isPressed = false;
    });
    
    if (_isPasswordVisible) {
      _revealController.forward();
      _pulseController.repeat(reverse: true);
      // Restart blinking when password is visible (eye closed state)
      _startRandomBlinking();
    } else {
      _revealController.reverse();
      _pulseController.stop();
      _pulseController.reset();
      // Stop blinking and restart glow when hiding password (eye open state)
      _glowController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _blinkController.dispose();
    _revealController.dispose();
    _pulseController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      padding: EdgeInsets.all(30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1E1E3E).withOpacity(0.8),
            Color(0xFF2A2A4E).withOpacity(0.6),
          ],
        ),
        border: Border.all(
          color: Color(0xFF64FFDA).withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF64FFDA).withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          // Eye Animation
          GestureDetector(
            onTap: _togglePasswordVisibility,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Color(0xFF64FFDA).withOpacity(0.2),
                    Colors.transparent,
                  ],
                ),
                border: Border.all(
                  color: _isPasswordVisible 
                    ? Color(0xFF64FFDA) 
                    : Color(0xFF64FFDA).withOpacity(0.5),
                  width: 2,
                ),
                boxShadow: _isPasswordVisible ? [
                  BoxShadow(
                    color: Color(0xFF64FFDA).withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ] : [],
              ),
              child: AnimatedBuilder(
                animation: Listenable.merge([
                  _blinkAnimation,
                  _pulseAnimation,
                  _glowAnimation,
                ]),
                builder: (context, child) {
                  return Transform.scale(
                    scale: _isPasswordVisible ? _pulseAnimation.value : 1.0,
                    child: CustomPaint(
                      size: Size(80, 80),
                      painter: EyePainter(
                        isOpen: !_isPasswordVisible, // Reversed: closed when password visible
                        blinkValue: _blinkAnimation.value,
                        glowIntensity: _isPasswordVisible ? 1.0 : _glowAnimation.value,
                        isPressed: _isPressed,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          
          SizedBox(height: 30),
          
          // Password Display
          Container(
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Color(0xFF1A1A2E).withOpacity(0.8),
              border: Border.all(
                color: Color(0xFF64FFDA).withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Center(
              child: AnimatedBuilder(
                animation: _revealAnimation,
                builder: (context, child) {
                  final revealLength = (_password.length * _revealAnimation.value).round().clamp(0, _password.length);
                  return Text(
                    _isPasswordVisible 
                      ? _password.substring(0, revealLength)
                      : '•' * _password.length,
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'monospace',
                      color: _isPasswordVisible 
                        ? Color(0xFF64FFDA)
                        : Color(0xFF64FFDA).withOpacity(0.6),
                      letterSpacing: 2,
                      shadows: _isPasswordVisible ? [
                        Shadow(
                          blurRadius: 8,
                          color: Color(0xFF64FFDA).withOpacity(0.3),
                        ),
                      ] : [],
                    ),
                  );
                },
              ),
            ),
          ),
          
          SizedBox(height: 20),
          
          // Status Text
          AnimatedOpacity(
            opacity: _isPasswordVisible ? 1.0 : 0.6,
            duration: Duration(milliseconds: 300),
            child: Text(
              _isPasswordVisible ? 'PASSWORD REVEALED' : 'TAP EYE TO REVEAL',
              style: TextStyle(
                fontSize: 12,
                letterSpacing: 2,
                color: Color(0xFF64FFDA),
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EyePainter extends CustomPainter {
  final bool isOpen;
  final double blinkValue;
  final double glowIntensity;
  final bool isPressed;

  EyePainter({
    required this.isOpen,
    required this.blinkValue,
    required this.glowIntensity,
    required this.isPressed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final eyeWidth = size.width * 0.6;
    final eyeHeight = size.height * 0.3;
    
    // Eye glow
    final glowPaint = Paint()
      ..color = Color(0xFF64FFDA).withOpacity(0.1 * glowIntensity)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 10);
    
    canvas.drawOval(
      Rect.fromCenter(
        center: center,
        width: eyeWidth + 10,
        height: eyeHeight + 10,
      ),
      glowPaint,
    );
    
    // Eye outline
    final outlinePaint = Paint()
      ..color = Color(0xFF64FFDA).withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    // Calculate eye opening based on blink and open state
    double currentEyeHeight = eyeHeight;
    if (!isOpen) {
      currentEyeHeight *= blinkValue;
    }
    
    // Draw eye shape
    final eyePath = Path();
    eyePath.addOval(Rect.fromCenter(
      center: center,
      width: eyeWidth,
      height: currentEyeHeight,
    ));
    
    canvas.drawPath(eyePath, outlinePaint);
    
    // Eye fill
    if (currentEyeHeight > 2) {
      final fillPaint = Paint()
        ..color = Color(0xFF1A1A2E).withOpacity(0.8);
      canvas.drawPath(eyePath, fillPaint);
    }
    
    // Iris and pupil (only when eye is sufficiently open)
    if (currentEyeHeight > eyeHeight * 0.3) {
      // Iris
      final irisPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            Color(0xFF64FFDA).withOpacity(0.8),
            Color(0xFF1DE9B6).withOpacity(0.6),
            Color(0xFF64FFDA).withOpacity(0.4),
          ],
        ).createShader(Rect.fromCircle(center: center, radius: 12));
      
      canvas.drawCircle(center, 12, irisPaint);
      
      // Pupil
      final pupilPaint = Paint()
        ..color = Color(0xFF0A0A0A);
      canvas.drawCircle(center, 6, pupilPaint);
      
      // Eye reflection
      final reflectionPaint = Paint()
        ..color = Color(0xFF64FFDA).withOpacity(0.6);
      canvas.drawCircle(
        center.translate(-3, -3),
        2,
        reflectionPaint,
      );
    }
    
    // Eyelashes
    if (currentEyeHeight < eyeHeight * 0.8) {
      final lashPaint = Paint()
        ..color = Color(0xFF64FFDA).withOpacity(0.6)
        ..strokeWidth = 1
        ..style = PaintingStyle.stroke;
      
      for (int i = 0; i < 5; i++) {
        final x = center.dx - eyeWidth/2 + (eyeWidth/4) * i;
        canvas.drawLine(
          Offset(x, center.dy - currentEyeHeight/2),
          Offset(x, center.dy - currentEyeHeight/2 - 5),
          lashPaint,
        );
      }
    }
    
    // Press effect
    if (isPressed) {
      final pressPaint = Paint()
        ..color = Color(0xFF64FFDA).withOpacity(0.2);
      canvas.drawCircle(center, size.width/2, pressPaint);
    }
  }

  @override
  bool shouldRepaint(EyePainter oldDelegate) {
    return oldDelegate.isOpen != isOpen ||
           oldDelegate.blinkValue != blinkValue ||
           oldDelegate.glowIntensity != glowIntensity ||
           oldDelegate.isPressed != isPressed;
  }
}