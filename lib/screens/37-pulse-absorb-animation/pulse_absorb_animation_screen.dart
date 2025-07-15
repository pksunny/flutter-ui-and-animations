import 'package:flutter/material.dart';

class PulseAbsorbAnimationScreen extends StatefulWidget {
  @override
  _PulseAbsorbAnimationScreenState createState() => _PulseAbsorbAnimationScreenState();
}

class _PulseAbsorbAnimationScreenState extends State<PulseAbsorbAnimationScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _absorptionController;
  late AnimationController _scaleController;
  late AnimationController _forwardController;
  
  late Animation<double> _pulseAnimation;
  late Animation<double> _absorptionAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _forwardAnimation;
  late Animation<double> _opacityAnimation;
  
  bool _isAnimating = false;
  bool _showNextContent = false;
  
  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    
    _absorptionController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    );
    
    _forwardController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeOutQuart,
    ));
    
    _absorptionAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _absorptionController,
      curve: Curves.easeInQuart,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInBack,
    ));
    
    _forwardAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _forwardController,
      curve: Curves.elasticOut,
    ));
    
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _forwardController,
      curve: Interval(0.3, 1.0, curve: Curves.easeOut),
    ));
  }
  
  @override
  void dispose() {
    _pulseController.dispose();
    _absorptionController.dispose();
    _scaleController.dispose();
    _forwardController.dispose();
    super.dispose();
  }
  
  Future<void> _triggerPulseAbsorb() async {
    if (_isAnimating) return;
    
    setState(() {
      _isAnimating = true;
      _showNextContent = false;
    });
    
    // Step 1: Pulse wave
    await _pulseController.forward();
    
    // Step 2: Absorption effect
    _absorptionController.forward();
    await _scaleController.forward();
    
    // Step 3: Show next content
    setState(() {
      _showNextContent = true;
    });
    
    // Step 4: Forward animation
    await _forwardController.forward();
    
    // Reset after delay
    await Future.delayed(Duration(milliseconds: 1500));
    _resetAnimation();
  }
  
  void _resetAnimation() {
    _pulseController.reset();
    _absorptionController.reset();
    _scaleController.reset();
    _forwardController.reset();
    
    setState(() {
      _isAnimating = false;
      _showNextContent = false;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1a1a2e),
                  Color(0xFF16213e),
                  Color(0xFF0f3460),
                ],
              ),
            ),
          ),
          
          // Main content or next content
          if (!_showNextContent)
            AnimatedBuilder(
              animation: Listenable.merge([
                _pulseAnimation,
                _absorptionAnimation,
                _scaleAnimation,
              ]),
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: CustomPaint(
                    painter: PulseAbsorptionPainter(
                      pulseProgress: _pulseAnimation.value,
                      absorptionProgress: _absorptionAnimation.value,
                      buttonCenter: Offset(
                        MediaQuery.of(context).size.width * 0.5,
                        MediaQuery.of(context).size.height * 0.7,
                      ),
                    ),
                    child: _buildMainContent(),
                  ),
                );
              },
            ),
          
          // Next content
          if (_showNextContent)
            AnimatedBuilder(
              animation: _forwardAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _forwardAnimation.value,
                  child: Opacity(
                    opacity: _opacityAnimation.value,
                    child: _buildNextContent(),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
  
  Widget _buildMainContent() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.touch_app,
                    size: 60,
                    color: Colors.white,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Pulse Absorb',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Experience the future of UI interactions',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.8),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 60),
            
            // Feature cards
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFeatureCard(Icons.waves, 'Pulse Wave'),
                _buildFeatureCard(Icons.blur_circular, 'Absorption'),
                _buildFeatureCard(Icons.rocket_launch, 'Forward'),
              ],
            ),
            
            SizedBox(height: 80),
            
            // Pulse Absorb Button
            Container(
              width: 200,
              height: 60,
              child: ElevatedButton(
                onPressed: _isAnimating ? null : _triggerPulseAbsorb,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF00d4ff),
                  foregroundColor: Colors.white,
                  elevation: 8,
                  shadowColor: Color(0xFF00d4ff).withOpacity(0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isAnimating) ...[
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 2,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text('Processing...', style: TextStyle(fontSize: 16)),
                    ] else ...[
                      Icon(Icons.touch_app, size: 24),
                      SizedBox(width: 10),
                      Text('Submit', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFeatureCard(IconData icon, String label) {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Color(0xFF00d4ff), size: 30),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildNextContent() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Success animation
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.green,
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.check_circle,
                  size: 80,
                  color: Colors.green,
                ),
              ),
              
              SizedBox(height: 40),
              
              Text(
                'Action Complete!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.0,
                ),
              ),
              
              SizedBox(height: 20),
              
              Text(
                'The pulse absorption effect has successfully\ntransitioned to the next state.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.8),
                ),
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: 60),
              
              // Try again button
              Container(
                width: 180,
                height: 50,
                child: ElevatedButton(
                  onPressed: _resetAnimation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.1),
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                      side: BorderSide(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.refresh, size: 20),
                      SizedBox(width: 8),
                      Text('Try Again', style: TextStyle(fontSize: 16)),
                    ],
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

class PulseAbsorptionPainter extends CustomPainter {
  final double pulseProgress;
  final double absorptionProgress;
  final Offset buttonCenter;
  
  PulseAbsorptionPainter({
    required this.pulseProgress,
    required this.absorptionProgress,
    required this.buttonCenter,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    
    // Draw pulse waves
    if (pulseProgress > 0) {
      for (int i = 0; i < 3; i++) {
        final waveRadius = (pulseProgress * 300) + (i * 50);
        final opacity = (1.0 - pulseProgress) * (1.0 - (i * 0.3));
        
        if (opacity > 0) {
          paint.color = Color(0xFF00d4ff).withOpacity(opacity * 0.6);
          canvas.drawCircle(buttonCenter, waveRadius, paint);
        }
      }
    }
    
    // Draw absorption effect
    if (absorptionProgress > 0) {
      final maxDistance = (size.width + size.height) * 0.7;
      final currentDistance = maxDistance * (1.0 - absorptionProgress);
      
      // Create absorption gradient
      final gradient = RadialGradient(
        center: Alignment.center,
        radius: 1.0,
        colors: [
          Color(0xFF00d4ff).withOpacity(0.1),
          Color(0xFF00d4ff).withOpacity(0.05),
          Colors.transparent,
        ],
        stops: [0.0, 0.5, 1.0],
      );
      
      final gradientPaint = Paint()
        ..shader = gradient.createShader(
          Rect.fromCircle(
            center: buttonCenter,
            radius: currentDistance,
          ),
        );
      
      canvas.drawCircle(buttonCenter, currentDistance, gradientPaint);
      
      // Draw absorption lines
      for (int i = 0; i < 12; i++) {
        final angle = (i * 30) * (3.14159 / 180);
        final startX = buttonCenter.dx + (currentDistance * 0.8) * cos(angle);
        final startY = buttonCenter.dy + (currentDistance * 0.8) * sin(angle);
        final endX = buttonCenter.dx + (currentDistance * 0.2) * cos(angle);
        final endY = buttonCenter.dy + (currentDistance * 0.2) * sin(angle);
        
        paint.color = Color(0xFF00d4ff).withOpacity(absorptionProgress * 0.8);
        paint.strokeWidth = 1.5;
        canvas.drawLine(
          Offset(startX, startY),
          Offset(endX, endY),
          paint,
        );
      }
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Helper function for cos (since dart:math might not be available)
double cos(double radians) {
  // Simple approximation using Taylor series
  double result = 1.0;
  double term = 1.0;
  for (int i = 1; i <= 10; i++) {
    term *= -radians * radians / ((2 * i - 1) * (2 * i));
    result += term;
  }
  return result;
}

// Helper function for sin
double sin(double radians) {
  // Simple approximation using Taylor series
  double result = radians;
  double term = radians;
  for (int i = 1; i <= 10; i++) {
    term *= -radians * radians / ((2 * i) * (2 * i + 1));
    result += term;
  }
  return result;
}