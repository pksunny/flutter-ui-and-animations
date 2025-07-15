import 'package:flutter/material.dart';
import 'dart:math' as math;

class BreathingCardsScreen extends StatefulWidget {
  @override
  _BreathingCardsScreenState createState() => _BreathingCardsScreenState();
}

class _BreathingCardsScreenState extends State<BreathingCardsScreen>
    with TickerProviderStateMixin {
  late AnimationController _breathingController;
  late AnimationController _pulseController;
  late AnimationController _shimmerController;
  late AnimationController _particleController;
  
  late Animation<double> _breathingAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _shimmerAnimation;
  late Animation<double> _particleAnimation;

  final List<CardData> cards = [
    CardData(
      title: "Mindful Breathing",
      subtitle: "Find your center",
      quote: "Breathe in peace, breathe out stress",
      gradient: [Color(0xFF00D4FF), Color(0xFF5A67D8)],
      icon: Icons.self_improvement,
    ),
    CardData(
      title: "Inner Balance",
      subtitle: "Harmony within",
      quote: "Balance is not something you find, it's something you create",
      gradient: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
      icon: Icons.balance,
    ),
    CardData(
      title: "Digital Zen",
      subtitle: "Modern meditation",
      quote: "In stillness, find your strength",
      gradient: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
      icon: Icons.spa,
    ),
    CardData(
      title: "Cosmic Flow",
      subtitle: "Universal rhythm",
      quote: "You are the universe experiencing itself",
      gradient: [Color(0xFF667EEA), Color(0xFF764BA2)],
      icon: Icons.blur_circular,
    ),
  ];

  @override
  void initState() {
    super.initState();
    
    _breathingController = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    
    _shimmerController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );
    
    _particleController = AnimationController(
      duration: Duration(seconds: 8),
      vsync: this,
    );
    
    _breathingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _breathingController,
      curve: Curves.easeInOut,
    ));
    
    _pulseAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _shimmerAnimation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOut,
    ));
    
    _particleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _particleController,
      curve: Curves.linear,
    ));
    
    // Start animations
    _breathingController.repeat(reverse: true);
    _pulseController.repeat(reverse: true);
    _shimmerController.repeat();
    _particleController.repeat();
  }

  @override
  void dispose() {
    _breathingController.dispose();
    _pulseController.dispose();
    _shimmerController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated background
          AnimatedBuilder(
            animation: _particleAnimation,
            builder: (context, child) {
              return CustomPaint(
                painter: ParticleBackgroundPainter(_particleAnimation.value),
                size: Size.infinite,
              );
            },
          ),
          
          // Main content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Container(
                    margin: EdgeInsets.only(bottom: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [Color(0xFF00D4FF), Color(0xFF5A67D8)],
                          ).createShader(bounds),
                          child: Text(
                            'Breathing Cards',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Living interfaces that breathe with you',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Cards grid
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.8,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                      ),
                      itemCount: cards.length,
                      itemBuilder: (context, index) {
                        return BreathingCard(
                          cardData: cards[index],
                          breathingAnimation: _breathingAnimation,
                          pulseAnimation: _pulseAnimation,
                          shimmerAnimation: _shimmerAnimation,
                          delay: index * 0.5,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BreathingCard extends StatefulWidget {
  final CardData cardData;
  final Animation<double> breathingAnimation;
  final Animation<double> pulseAnimation;
  final Animation<double> shimmerAnimation;
  final double delay;

  const BreathingCard({
    Key? key,
    required this.cardData,
    required this.breathingAnimation,
    required this.pulseAnimation,
    required this.shimmerAnimation,
    required this.delay,
  }) : super(key: key);

  @override
  _BreathingCardState createState() => _BreathingCardState();
}

class _BreathingCardState extends State<BreathingCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _hoverAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _hoverAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        widget.breathingAnimation,
        widget.pulseAnimation,
        widget.shimmerAnimation,
        _hoverAnimation,
      ]),
      builder: (context, child) {
        // Calculate breathing effect
        double breathingValue = math.sin(
          (widget.breathingAnimation.value + widget.delay) * math.pi * 2
        ) * 0.03 + 1.0;
        
        // Calculate pulse effect
        double pulseValue = widget.pulseAnimation.value;
        
        // Combine effects
        double totalScale = breathingValue * pulseValue;
        
        // Hover effect
        double hoverScale = 1.0 + (_hoverAnimation.value * 0.05);
        double hoverElevation = _hoverAnimation.value * 20;
        
        return MouseRegion(
          onEnter: (_) {
            setState(() => _isHovered = true);
            _hoverController.forward();
          },
          onExit: (_) {
            setState(() => _isHovered = false);
            _hoverController.reverse();
          },
          child: Transform.scale(
            scale: totalScale * hoverScale,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: widget.cardData.gradient[0].withOpacity(0.3),
                    blurRadius: 20 + hoverElevation,
                    spreadRadius: 2,
                    offset: Offset(0, 10 + hoverElevation / 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Stack(
                  children: [
                    // Base gradient
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: widget.cardData.gradient,
                        ),
                      ),
                    ),
                    
                    // Shimmer effect
                    Positioned.fill(
                      child: CustomPaint(
                        painter: ShimmerPainter(
                          progress: widget.shimmerAnimation.value,
                          isHovered: _isHovered,
                        ),
                      ),
                    ),
                    
                    // Breathing glow overlay
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            center: Alignment.center,
                            radius: 1.5,
                            colors: [
                              Colors.white.withOpacity(
                                0.1 + (breathingValue - 1.0) * 0.5
                              ),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    // Content
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Icon
                          Transform.scale(
                            scale: 0.95 + (breathingValue - 1.0) * 0.5,
                            child: Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Icon(
                                widget.cardData.icon,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                          
                          Spacer(),
                          
                          // Title
                          Text(
                            widget.cardData.title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          
                          SizedBox(height: 4),
                          
                          // Subtitle
                          Text(
                            widget.cardData.subtitle,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                          
                          SizedBox(height: 12),
                          
                          // Quote
                          Text(
                            widget.cardData.quote,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white.withOpacity(0.9),
                              fontStyle: FontStyle.italic,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    
                    // Breathing border
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: Colors.white.withOpacity(
                              0.1 + (breathingValue - 1.0) * 0.3
                            ),
                            width: 1 + (breathingValue - 1.0) * 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ShimmerPainter extends CustomPainter {
  final double progress;
  final bool isHovered;

  ShimmerPainter({required this.progress, required this.isHovered});

  @override
  void paint(Canvas canvas, Size size) {
    if (!isHovered) return;
    
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.transparent,
          Colors.white.withOpacity(0.1),
          Colors.white.withOpacity(0.3),
          Colors.white.withOpacity(0.1),
          Colors.transparent,
        ],
        stops: [0.0, 0.3, 0.5, 0.7, 1.0],
      ).createShader(Rect.fromLTWH(
        size.width * (progress - 0.5),
        0,
        size.width,
        size.height,
      ));

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ParticleBackgroundPainter extends CustomPainter {
  final double progress;

  ParticleBackgroundPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 50; i++) {
      double x = (size.width * (i % 7) / 7) + 
                 (math.sin(progress * math.pi * 2 + i) * 30);
      double y = (size.height * (i % 8) / 8) + 
                 (math.cos(progress * math.pi * 2 + i) * 20);
      
      double radius = 1 + math.sin(progress * math.pi * 4 + i) * 1;
      
      canvas.drawCircle(
        Offset(x, y),
        radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class CardData {
  final String title;
  final String subtitle;
  final String quote;
  final List<Color> gradient;
  final IconData icon;

  CardData({
    required this.title,
    required this.subtitle,
    required this.quote,
    required this.gradient,
    required this.icon,
  });
}