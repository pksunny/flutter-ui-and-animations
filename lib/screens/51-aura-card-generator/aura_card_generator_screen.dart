import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui';

class AuraCardGeneratorScreen extends StatefulWidget {
  @override
  _AuraCardGeneratorScreenState createState() => _AuraCardGeneratorScreenState();
}

class _AuraCardGeneratorScreenState extends State<AuraCardGeneratorScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late AnimationController _particleController;
  late AnimationController _gradientController;
  late AnimationController _tiltController;
  
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _particleAnimation;
  late Animation<double> _gradientAnimation;
  
  bool _isCardTapped = false;
  double _tiltX = 0.0;
  double _tiltY = 0.0;
  
  List<Color> _currentAuraColors = [
    Color(0xFF6366F1),
    Color(0xFF8B5CF6),
    Color(0xFFEC4899),
  ];
  
  final List<List<Color>> _auraPresets = [
    [Color(0xFF6366F1), Color(0xFF8B5CF6), Color(0xFFEC4899)], // Mystic Purple
    [Color(0xFF06B6D4), Color(0xFF3B82F6), Color(0xFF8B5CF6)], // Ocean Blue
    [Color(0xFFEF4444), Color(0xFFF59E0B), Color(0xFFEAB308)], // Fire Orange
    [Color(0xFF10B981), Color(0xFF06B6D4), Color(0xFF3B82F6)], // Forest Green
    [Color(0xFFEC4899), Color(0xFFF472B6), Color(0xFFFBBF24)], // Rose Gold
    [Color(0xFF8B5CF6), Color(0xFFEC4899), Color(0xFF06B6D4)], // Galaxy
  ];
  
  String _currentAuraName = "Mystic Aura";
  final List<String> _auraNames = [
    "Mystic Aura",
    "Ocean Dreams",
    "Phoenix Fire",
    "Forest Whisper",
    "Rose Quartz",
    "Galaxy Storm",
  ];

  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    
    _rotationController = AnimationController(
      duration: Duration(seconds: 8),
      vsync: this,
    );
    
    _particleController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );
    
    _gradientController = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    );
    
    _tiltController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    
    _rotationAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );
    
    _particleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _particleController, curve: Curves.easeInOut),
    );
    
    _gradientAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _gradientController, curve: Curves.easeInOut),
    );
    
    _startAnimations();
  }
  
  void _startAnimations() {
    _pulseController.repeat(reverse: true);
    _rotationController.repeat();
    _particleController.repeat();
    _gradientController.repeat(reverse: true);
  }
  
  void _onCardTap() {
    setState(() {
      _isCardTapped = !_isCardTapped;
    });
    
    if (_isCardTapped) {
      _tiltController.forward();
    } else {
      _tiltController.reverse();
    }
  }
  
  void _generateNewAura() {
    final random = math.Random();
    final index = random.nextInt(_auraPresets.length);
    
    setState(() {
      _currentAuraColors = _auraPresets[index];
      _currentAuraName = _auraNames[index];
    });
    
    // Trigger explosion effect
    _particleController.reset();
    _particleController.forward();
  }
  
  void _onPanUpdate(DragUpdateDetails details) {
    final size = MediaQuery.of(context).size;
    setState(() {
      _tiltX = (details.globalPosition.dy - size.height / 2) / size.height * 0.3;
      _tiltY = (details.globalPosition.dx - size.width / 2) / size.width * 0.3;
    });
  }
  
  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _tiltX = 0.0;
      _tiltY = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A0A0A),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
              Color(0xFF0A0A0A),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: _currentAuraColors,
                      ).createShader(bounds),
                      child: Text(
                        'AURA GENERATOR',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 3,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Discover Your Mystic Energy',
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 16,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Main Card Area
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onTap: _onCardTap,
                    onPanUpdate: _onPanUpdate,
                    onPanEnd: _onPanEnd,
                    child: AnimatedBuilder(
                      animation: Listenable.merge([
                        _pulseAnimation,
                        _rotationAnimation,
                        _particleAnimation,
                        _gradientAnimation,
                      ]),
                      builder: (context, child) {
                        return Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateX(_tiltX)
                            ..rotateY(_tiltY),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Outer Glow Rings
                              for (int i = 0; i < 3; i++)
                                AnimatedContainer(
                                  duration: Duration(milliseconds: 300),
                                  width: 300 + (i * 60) * _pulseAnimation.value,
                                  height: 300 + (i * 60) * _pulseAnimation.value,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: _currentAuraColors[i % _currentAuraColors.length]
                                          .withOpacity(0.3 - i * 0.1),
                                      width: 2,
                                    ),
                                  ),
                                ),
                              
                              // Particle System
                              ...List.generate(12, (index) {
                                final angle = (index * 30.0) * math.pi / 180;
                                final radius = 150 + math.sin(_particleAnimation.value * math.pi * 2) * 50;
                                final x = math.cos(angle + _rotationAnimation.value) * radius;
                                final y = math.sin(angle + _rotationAnimation.value) * radius;
                                
                                return Transform.translate(
                                  offset: Offset(x, y),
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _currentAuraColors[index % _currentAuraColors.length]
                                          .withOpacity(0.8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: _currentAuraColors[index % _currentAuraColors.length]
                                              .withOpacity(0.6),
                                          blurRadius: 10,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                              
                              // Main Aura Card
                              Container(
                                width: 280,
                                height: 400,
                                child: Stack(
                                  children: [
                                    // Background Gradient
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(24),
                                        gradient: SweepGradient(
                                          center: Alignment.center,
                                          startAngle: _gradientAnimation.value * 2 * math.pi,
                                          endAngle: (_gradientAnimation.value + 1) * 2 * math.pi,
                                          colors: [
                                            ..._currentAuraColors,
                                            ..._currentAuraColors.reversed,
                                          ],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: _currentAuraColors[0].withOpacity(0.5),
                                            blurRadius: 30,
                                            spreadRadius: 5,
                                          ),
                                        ],
                                      ),
                                    ),
                                    
                                    // Glass Effect
                                    Container(
                                      margin: EdgeInsets.all(2),
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(22),
                                        color: Colors.black.withOpacity(0.3),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(22),
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                  Colors.white.withOpacity(0.1),
                                                  Colors.white.withOpacity(0.05),
                                                ],
                                              ),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(24),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  // Aura Symbol
                                                  Transform.rotate(
                                                    angle: _rotationAnimation.value,
                                                    child: Container(
                                                      width: 80,
                                                      height: 80,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        gradient: RadialGradient(
                                                          colors: _currentAuraColors,
                                                        ),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: _currentAuraColors[0].withOpacity(0.6),
                                                            blurRadius: 20,
                                                            spreadRadius: 2,
                                                          ),
                                                        ],
                                                      ),
                                                      child: Center(
                                                        child: Icon(
                                                          Icons.auto_awesome,
                                                          color: Colors.white,
                                                          size: 40,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  
                                                  SizedBox(height: 32),
                                                  
                                                  // Aura Name
                                                  ShaderMask(
                                                    shaderCallback: (bounds) => LinearGradient(
                                                      colors: _currentAuraColors,
                                                    ).createShader(bounds),
                                                    child: Text(
                                                      _currentAuraName,
                                                      style: TextStyle(
                                                        fontSize: 24,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white,
                                                        letterSpacing: 1,
                                                      ),
                                                    ),
                                                  ),
                                                  
                                                  SizedBox(height: 16),
                                                  
                                                  // Energy Level
                                                  Text(
                                                    'ENERGY LEVEL',
                                                    style: TextStyle(
                                                      color: Colors.white60,
                                                      fontSize: 12,
                                                      letterSpacing: 2,
                                                    ),
                                                  ),
                                                  
                                                  SizedBox(height: 8),
                                                  
                                                  // Energy Bar
                                                  Container(
                                                    width: 150,
                                                    height: 8,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(4),
                                                      color: Colors.white.withOpacity(0.2),
                                                    ),
                                                    child: FractionallySizedBox(
                                                      alignment: Alignment.centerLeft,
                                                      widthFactor: _pulseAnimation.value * 0.8,
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(4),
                                                          gradient: LinearGradient(
                                                            colors: _currentAuraColors,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              
              // Generate Button
              Padding(
                padding: EdgeInsets.all(32),
                child: GestureDetector(
                  onTap: _generateNewAura,
                  child: AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 1.0 + (_pulseAnimation.value - 1.0) * 0.1,
                        child: Container(
                          width: double.infinity,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: LinearGradient(
                              colors: _currentAuraColors,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: _currentAuraColors[0].withOpacity(0.4),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              'GENERATE NEW AURA',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    _particleController.dispose();
    _gradientController.dispose();
    _tiltController.dispose();
    super.dispose();
  }
}