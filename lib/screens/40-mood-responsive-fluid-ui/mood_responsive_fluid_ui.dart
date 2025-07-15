import 'package:flutter/material.dart';
import 'dart:math' as math;

enum MoodType {
  happy,
  angry,
  calm,
  excited,
  sad,
  energetic,
}

class MoodData {
  final String name;
  final Color primaryColor;
  final Color secondaryColor;
  final String emoji;
  final String description;

  MoodData({
    required this.name,
    required this.primaryColor,
    required this.secondaryColor,
    required this.emoji,
    required this.description,
  });
}

class MoodResponsiveFluidUi extends StatefulWidget {
  @override
  _MoodResponsiveFluidUiState createState() => _MoodResponsiveFluidUiState();
}

class _MoodResponsiveFluidUiState extends State<MoodResponsiveFluidUi>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rippleController;
  late AnimationController _breatheController;
  late AnimationController _particleController;
  
  MoodType _currentMood = MoodType.happy;
  bool _isTransitioning = false;

  final Map<MoodType, MoodData> _moods = {
    MoodType.happy: MoodData(
      name: 'Happy',
      primaryColor: Color(0xFFFFD700),
      secondaryColor: Color(0xFFFF8C00),
      emoji: '😊',
      description: 'Bright and cheerful energy',
    ),
    MoodType.angry: MoodData(
      name: 'Angry',
      primaryColor: Color(0xFFFF0040),
      secondaryColor: Color(0xFFDC143C),
      emoji: '😠',
      description: 'Intense pulsing energy',
    ),
    MoodType.calm: MoodData(
      name: 'Calm',
      primaryColor: Color(0xFF4169E1),
      secondaryColor: Color(0xFF87CEEB),
      emoji: '😌',
      description: 'Peaceful flowing waves',
    ),
    MoodType.excited: MoodData(
      name: 'Excited',
      primaryColor: Color(0xFFFF1493),
      secondaryColor: Color(0xFF9370DB),
      emoji: '🤩',
      description: 'Electric bursts of joy',
    ),
    MoodType.sad: MoodData(
      name: 'Sad',
      primaryColor: Color(0xFF4682B4),
      secondaryColor: Color(0xFF708090),
      emoji: '😢',
      description: 'Gentle melancholy flow',
    ),
    MoodType.energetic: MoodData(
      name: 'Energetic',
      primaryColor: Color(0xFF00FF7F),
      secondaryColor: Color(0xFF32CD32),
      emoji: '⚡',
      description: 'Dynamic power surge',
    ),
  };

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    _rippleController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
    
    _breatheController = AnimationController(
      duration: Duration(milliseconds: 3000),
      vsync: this,
    )..repeat(reverse: true);
    
    _particleController = AnimationController(
      duration: Duration(milliseconds: 5000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rippleController.dispose();
    _breatheController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  void _changeMood(MoodType newMood) {
    if (_currentMood == newMood) return;
    
    setState(() {
      _isTransitioning = true;
    });
    
    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        _currentMood = newMood;
        _isTransitioning = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final mood = _moods[_currentMood]!;
    
    return Scaffold(
      body: Stack(
        children: [
          // Animated Background
          AnimatedContainer(
            duration: Duration(milliseconds: 800),
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.5,
                colors: [
                  mood.primaryColor.withOpacity(0.3),
                  mood.secondaryColor.withOpacity(0.1),
                  Colors.black,
                ],
              ),
            ),
            child: Container(),
          ),
          
          // Fluid Animation Layer
          ...List.generate(3, (index) => _buildFluidLayer(mood, index)),
          
          // Particle Effects
          _buildParticleEffect(mood),
          
          // Main Content
          SafeArea(
            child: Column(
              children: [
                // Header
                _buildHeader(mood),
                
                // Mood Selector
                Expanded(
                  child: _buildMoodSelector(),
                ),
                
                // Bottom Info
                _buildBottomInfo(mood),
              ],
            ),
          ),
          
          // Transition Overlay
          if (_isTransitioning)
            Container(
              color: Colors.black.withOpacity(0.8),
              child: Center(
                child: AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 1.0 + (_pulseController.value * 0.1),
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: mood.primaryColor.withOpacity(0.8),
                          boxShadow: [
                            BoxShadow(
                              color: mood.primaryColor.withOpacity(0.5),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFluidLayer(MoodData mood, int index) {
    return AnimatedBuilder(
      animation: _currentMood == MoodType.angry ? _pulseController : _rippleController,
      builder: (context, child) {
        return CustomPaint(
          painter: FluidPainter(
            animation: _currentMood == MoodType.angry ? _pulseController : _rippleController,
            color: mood.primaryColor.withOpacity(0.1 - (index * 0.02)),
            moodType: _currentMood,
            layerIndex: index,
          ),
          size: Size.infinite,
        );
      },
    );
  }

  Widget _buildParticleEffect(MoodData mood) {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return CustomPaint(
          painter: ParticlePainter(
            animation: _particleController,
            color: mood.primaryColor,
            moodType: _currentMood,
          ),
          size: Size.infinite,
        );
      },
    );
  }

  Widget _buildHeader(MoodData mood) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _breatheController,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.0 + (_breatheController.value * 0.05),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        mood.primaryColor.withOpacity(0.8),
                        mood.secondaryColor.withOpacity(0.4),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: mood.primaryColor.withOpacity(0.5),
                        blurRadius: 30,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      mood.emoji,
                      style: TextStyle(fontSize: 40),
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 20),
          Text(
            'Currently: ${mood.name}',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: mood.primaryColor,
            ),
          ),
          Text(
            mood.description,
            style: TextStyle(
              fontSize: 16,
              color: mood.primaryColor.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodSelector() {
    return GridView.builder(
      padding: EdgeInsets.all(20),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemCount: _moods.length,
      itemBuilder: (context, index) {
        final moodType = MoodType.values[index];
        final mood = _moods[moodType]!;
        final isSelected = _currentMood == moodType;
        
        return GestureDetector(
          onTap: () => _changeMood(moodType),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: isSelected
                    ? [mood.primaryColor.withOpacity(0.6), mood.secondaryColor.withOpacity(0.3)]
                    : [mood.primaryColor.withOpacity(0.2), mood.secondaryColor.withOpacity(0.1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: isSelected ? mood.primaryColor : Colors.transparent,
                width: 2,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: mood.primaryColor.withOpacity(0.4),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ]
                  : [],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  mood.emoji,
                  style: TextStyle(fontSize: 30),
                ),
                SizedBox(height: 8),
                Text(
                  mood.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? mood.primaryColor : Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomInfo(MoodData mood) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'Tap any mood to transform the experience',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white60,
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 4,
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              gradient: LinearGradient(
                colors: [mood.primaryColor, mood.secondaryColor],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FluidPainter extends CustomPainter {
  final Animation<double> animation;
  final Color color;
  final MoodType moodType;
  final int layerIndex;

  FluidPainter({
    required this.animation,
    required this.color,
    required this.moodType,
    required this.layerIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    switch (moodType) {
      case MoodType.happy:
        _drawHappyRipples(canvas, size, paint);
        break;
      case MoodType.angry:
        _drawAngryPulse(canvas, size, paint);
        break;
      case MoodType.calm:
        _drawCalmWaves(canvas, size, paint);
        break;
      case MoodType.excited:
        _drawExcitedBursts(canvas, size, paint);
        break;
      case MoodType.sad:
        _drawSadDrops(canvas, size, paint);
        break;
      case MoodType.energetic:
        _drawEnergeticLightning(canvas, size, paint);
        break;
    }
  }

  void _drawHappyRipples(Canvas canvas, Size size, Paint paint) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) * animation.value + (layerIndex * 50);
    
    canvas.drawCircle(center, radius, paint);
  }

  void _drawAngryPulse(Canvas canvas, Size size, Paint paint) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = 100 + (layerIndex * 30);
    final pulseRadius = baseRadius * (1 + animation.value * 0.5);
    
    canvas.drawCircle(center, pulseRadius, paint);
  }

  void _drawCalmWaves(Canvas canvas, Size size, Paint paint) {
    final path = Path();
    final waveHeight = 30;
    final waveLength = size.width / 4;
    
    for (double x = 0; x <= size.width; x += 1) {
      final y = size.height / 2 + 
                math.sin((x / waveLength) * 2 * math.pi + animation.value * 2 * math.pi) * waveHeight +
                (layerIndex * 20);
      
      if (x == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    
    canvas.drawPath(path, paint);
  }

  void _drawExcitedBursts(Canvas canvas, Size size, Paint paint) {
    final center = Offset(size.width / 2, size.height / 2);
    final spikes = 8;
    
    for (int i = 0; i < spikes; i++) {
      final angle = (i / spikes) * 2 * math.pi;
      final length = 50 + (animation.value * 100) + (layerIndex * 20);
      
      final start = Offset(
        center.dx + math.cos(angle) * 30,
        center.dy + math.sin(angle) * 30,
      );
      final end = Offset(
        center.dx + math.cos(angle) * length,
        center.dy + math.sin(angle) * length,
      );
      
      canvas.drawLine(start, end, paint..strokeWidth = 3);
    }
  }

  void _drawSadDrops(Canvas canvas, Size size, Paint paint) {
    final dropX = size.width / 2 + (layerIndex * 30);
    final dropY = animation.value * size.height;
    
    canvas.drawCircle(Offset(dropX, dropY), 15, paint);
  }

  void _drawEnergeticLightning(Canvas canvas, Size size, Paint paint) {
    final path = Path();
    final startX = size.width / 4 + (layerIndex * 50);
    final progress = animation.value;
    
    path.moveTo(startX, 0);
    path.lineTo(startX + 20, size.height * 0.3 * progress);
    path.lineTo(startX - 10, size.height * 0.6 * progress);
    path.lineTo(startX + 15, size.height * progress);
    
    canvas.drawPath(path, paint..strokeWidth = 4..style = PaintingStyle.stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ParticlePainter extends CustomPainter {
  final Animation<double> animation;
  final Color color;
  final MoodType moodType;

  ParticlePainter({
    required this.animation,
    required this.color,
    required this.moodType,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    final particleCount = moodType == MoodType.energetic ? 20 : 10;
    final random = math.Random(42);

    for (int i = 0; i < particleCount; i++) {
      final x = random.nextDouble() * size.width;
      final y = (random.nextDouble() * size.height + animation.value * 50) % size.height;
      final radius = random.nextDouble() * 3 + 1;
      
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}