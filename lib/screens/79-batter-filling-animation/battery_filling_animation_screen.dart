import 'package:flutter/material.dart';
import 'dart:math' as math;

class BatteryFillingAnimationScreen extends StatefulWidget {
  @override
  _BatteryFillingAnimationScreenState createState() => _BatteryFillingAnimationScreenState();
}

class _BatteryFillingAnimationScreenState extends State<BatteryFillingAnimationScreen>
    with TickerProviderStateMixin {
  late AnimationController _batteryController;
  late AnimationController _waveController;
  late AnimationController _particleController;
  late Animation<double> _batteryAnimation;
  late Animation<double> _waveAnimation;
  late Animation<double> _particleAnimation;
  
  int selectedBattery = 0;
  double batteryLevel = 0.0;

  @override
  void initState() {
    super.initState();
    
    _batteryController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );
    
    _waveController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    
    _particleController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    
    _batteryAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _batteryController, curve: Curves.easeInOut)
    );
    
    _waveAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.linear)
    );
    
    _particleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _particleController, curve: Curves.easeOut)
    );
    
    _waveController.repeat();
    _particleController.repeat();
  }

  @override
  void dispose() {
    _batteryController.dispose();
    _waveController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  void _chargeBattery() {
    setState(() {
      batteryLevel = 1.0;
    });
    _batteryController.forward();
  }

  void _resetBattery() {
    setState(() {
      batteryLevel = 0.0;
    });
    _batteryController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
              Color(0xFF0F0F23),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: _buildBatteryDisplay(),
              ),
              _buildControls(),
              _buildBatterySelector(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'Battery Animations',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 10),
          AnimatedBuilder(
            animation: _batteryAnimation,
            builder: (context, child) {
              return Text(
                '${(_batteryAnimation.value * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: _getBatteryColor(_batteryAnimation.value),
                  letterSpacing: 2,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBatteryDisplay() {
    return Center(
      child: Container(
        width: 300,
        height: 400,
        child: AnimatedBuilder(
          animation: Listenable.merge([_batteryAnimation, _waveAnimation, _particleAnimation]),
          builder: (context, child) {
            switch (selectedBattery) {
              case 0:
                return _buildClassicBattery();
              case 1:
                return _buildLiquidBattery();
              case 2:
                return _buildNeonBattery();
              case 3:
                return _buildParticleBattery();
              default:
                return _buildClassicBattery();
            }
          },
        ),
      ),
    );
  }

  Widget _buildClassicBattery() {
    return CustomPaint(
      size: Size(300, 400),
      painter: ClassicBatteryPainter(
        progress: _batteryAnimation.value,
        color: _getBatteryColor(_batteryAnimation.value),
      ),
    );
  }

  Widget _buildLiquidBattery() {
    return CustomPaint(
      size: Size(300, 400),
      painter: LiquidBatteryPainter(
        progress: _batteryAnimation.value,
        wavePhase: _waveAnimation.value,
        color: _getBatteryColor(_batteryAnimation.value),
      ),
    );
  }

  Widget _buildNeonBattery() {
    return CustomPaint(
      size: Size(300, 400),
      painter: NeonBatteryPainter(
        progress: _batteryAnimation.value,
        glowPhase: _waveAnimation.value,
        color: _getBatteryColor(_batteryAnimation.value),
      ),
    );
  }

  Widget _buildParticleBattery() {
    return CustomPaint(
      size: Size(300, 400),
      painter: ParticleBatteryPainter(
        progress: _batteryAnimation.value,
        particlePhase: _particleAnimation.value,
        color: _getBatteryColor(_batteryAnimation.value),
      ),
    );
  }

  Widget _buildControls() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildControlButton(
            'Charge',
            Icons.battery_charging_full,
            Colors.green,
            _chargeBattery,
          ),
          _buildControlButton(
            'Reset',
            Icons.refresh,
            Colors.orange,
            _resetBattery,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton(String text, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: color, width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBatterySelector() {
    List<String> batteryTypes = ['Classic', 'Liquid', 'Neon', 'Particle'];
    
    return Container(
      height: 80,
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(batteryTypes.length, (index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedBattery = index;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: selectedBattery == index 
                    ? Colors.cyan.withOpacity(0.3) 
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: selectedBattery == index ? Colors.cyan : Colors.grey.withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: Text(
                batteryTypes[index],
                style: TextStyle(
                  color: selectedBattery == index ? Colors.cyan : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Color _getBatteryColor(double progress) {
    if (progress < 0.2) return Colors.red;
    if (progress < 0.5) return Colors.orange;
    if (progress < 0.8) return Colors.yellow;
    return Colors.green;
  }
}

class ClassicBatteryPainter extends CustomPainter {
  final double progress;
  final Color color;

  ClassicBatteryPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.stroke..strokeWidth = 4;
    final fillPaint = Paint()..style = PaintingStyle.fill;

    // Battery outline
    final batteryRect = Rect.fromLTWH(50, 50, 200, 300);
    final tipRect = Rect.fromLTWH(120, 20, 60, 30);

    // Draw battery outline
    paint.color = Colors.white.withOpacity(0.8);
    canvas.drawRRect(RRect.fromRectAndRadius(batteryRect, Radius.circular(20)), paint);
    canvas.drawRRect(RRect.fromRectAndRadius(tipRect, Radius.circular(10)), paint);

    // Draw fill
    final fillHeight = (batteryRect.height - 20) * progress;
    final fillRect = Rect.fromLTWH(
      batteryRect.left + 10,
      batteryRect.bottom - 10 - fillHeight,
      batteryRect.width - 20,
      fillHeight,
    );

    fillPaint.shader = LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: [color, color.withOpacity(0.6)],
    ).createShader(fillRect);

    canvas.drawRRect(RRect.fromRectAndRadius(fillRect, Radius.circular(15)), fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class LiquidBatteryPainter extends CustomPainter {
  final double progress;
  final double wavePhase;
  final Color color;

  LiquidBatteryPainter({
    required this.progress,
    required this.wavePhase,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.stroke..strokeWidth = 4;
    final fillPaint = Paint()..style = PaintingStyle.fill;

    // Battery outline
    final batteryRect = Rect.fromLTWH(50, 50, 200, 300);
    final tipRect = Rect.fromLTWH(120, 20, 60, 30);

    // Draw battery outline
    paint.color = Colors.white.withOpacity(0.8);
    canvas.drawRRect(RRect.fromRectAndRadius(batteryRect, Radius.circular(20)), paint);
    canvas.drawRRect(RRect.fromRectAndRadius(tipRect, Radius.circular(10)), paint);

    // Create liquid wave path
    final path = Path();
    final waveHeight = 20.0;
    final fillLevel = batteryRect.bottom - 10 - (batteryRect.height - 20) * progress;

    path.moveTo(batteryRect.left + 10, batteryRect.bottom - 10);
    path.lineTo(batteryRect.left + 10, fillLevel + waveHeight);

    // Create wave effect
    for (double x = batteryRect.left + 10; x <= batteryRect.right - 10; x += 5) {
      final normalizedX = (x - batteryRect.left - 10) / (batteryRect.width - 20);
      final waveY = fillLevel + math.sin(normalizedX * 4 * math.pi + wavePhase) * waveHeight;
      path.lineTo(x, waveY);
    }

    path.lineTo(batteryRect.right - 10, fillLevel + waveHeight);
    path.lineTo(batteryRect.right - 10, batteryRect.bottom - 10);
    path.close();

    // Apply gradient
    fillPaint.shader = LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: [color, color.withOpacity(0.4)],
    ).createShader(batteryRect);

    canvas.drawPath(path, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class NeonBatteryPainter extends CustomPainter {
  final double progress;
  final double glowPhase;
  final Color color;

  NeonBatteryPainter({
    required this.progress,
    required this.glowPhase,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.stroke..strokeWidth = 4;
    final glowPaint = Paint()..style = PaintingStyle.stroke..strokeWidth = 8;
    final fillPaint = Paint()..style = PaintingStyle.fill;

    // Battery outline
    final batteryRect = Rect.fromLTWH(50, 50, 200, 300);
    final tipRect = Rect.fromLTWH(120, 20, 60, 30);

    // Draw glow effect
    final glowIntensity = (math.sin(glowPhase) + 1) / 2;
    glowPaint.color = color.withOpacity(0.3 * glowIntensity);
    glowPaint.maskFilter = MaskFilter.blur(BlurStyle.outer, 10);
    canvas.drawRRect(RRect.fromRectAndRadius(batteryRect, Radius.circular(20)), glowPaint);

    // Draw battery outline
    paint.color = color.withOpacity(0.8 + 0.2 * glowIntensity);
    canvas.drawRRect(RRect.fromRectAndRadius(batteryRect, Radius.circular(20)), paint);
    canvas.drawRRect(RRect.fromRectAndRadius(tipRect, Radius.circular(10)), paint);

    // Draw neon fill
    final fillHeight = (batteryRect.height - 20) * progress;
    final fillRect = Rect.fromLTWH(
      batteryRect.left + 10,
      batteryRect.bottom - 10 - fillHeight,
      batteryRect.width - 20,
      fillHeight,
    );

    fillPaint.color = color.withOpacity(0.6 + 0.2 * glowIntensity);
    fillPaint.maskFilter = MaskFilter.blur(BlurStyle.normal, 2);
    canvas.drawRRect(RRect.fromRectAndRadius(fillRect, Radius.circular(15)), fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ParticleBatteryPainter extends CustomPainter {
  final double progress;
  final double particlePhase;
  final Color color;

  ParticleBatteryPainter({
    required this.progress,
    required this.particlePhase,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.stroke..strokeWidth = 4;
    final particlePaint = Paint()..style = PaintingStyle.fill;

    // Battery outline
    final batteryRect = Rect.fromLTWH(50, 50, 200, 300);
    final tipRect = Rect.fromLTWH(120, 20, 60, 30);

    // Draw battery outline
    paint.color = Colors.white.withOpacity(0.8);
    canvas.drawRRect(RRect.fromRectAndRadius(batteryRect, Radius.circular(20)), paint);
    canvas.drawRRect(RRect.fromRectAndRadius(tipRect, Radius.circular(10)), paint);

    // Draw particles
    final fillHeight = (batteryRect.height - 20) * progress;
    final particleCount = 50;
    
    for (int i = 0; i < particleCount; i++) {
      final normalizedI = i / particleCount;
      final particleY = batteryRect.bottom - 10 - fillHeight * (normalizedI + particlePhase) % 1;
      
      if (particleY <= batteryRect.bottom - 10 && particleY >= batteryRect.top + 10) {
        final particleX = batteryRect.left + 20 + 
            (batteryRect.width - 40) * (0.5 + 0.3 * math.sin(normalizedI * 4 * math.pi));
        
        final opacity = 1.0 - (particleY - (batteryRect.bottom - 10 - fillHeight)) / fillHeight;
        particlePaint.color = color.withOpacity(opacity.clamp(0.0, 1.0));
        
        canvas.drawCircle(
          Offset(particleX, particleY),
          3 + 2 * math.sin(particlePhase + normalizedI * math.pi),
          particlePaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}