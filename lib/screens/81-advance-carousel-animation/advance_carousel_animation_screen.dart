import 'package:flutter/material.dart';
import 'dart:math' as math;

class AdvanceCarouselAnimationScreen extends StatefulWidget {
  @override
  _AdvanceCarouselAnimationScreenState createState() => _AdvanceCarouselAnimationScreenState();
}

class _AdvanceCarouselAnimationScreenState extends State<AdvanceCarouselAnimationScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late AnimationController _backgroundController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _backgroundAnimation;
  
  int _currentIndex = 0;
  double _currentPage = 0;

  final List<CarouselItem> _items = [
    CarouselItem(
      title: "Cosmic Journey",
      subtitle: "Explore the Universe",
      description: "Embark on an incredible journey through space and time, discovering the mysteries of the cosmos.",
      color: Color(0xFF6B73FF),
      gradientColors: [Color(0xFF9796F0), Color(0xFFFBC7D4)],
      icon: Icons.rocket_launch,
    ),
    CarouselItem(
      title: "Ocean Depths",
      subtitle: "Dive Deep",
      description: "Discover the hidden treasures and mysterious creatures living in the deepest parts of our oceans.",
      color: Color(0xFF4ECDC4),
      gradientColors: [Color(0xFF44A08D), Color(0xFF093637)],
      icon: Icons.waves,
    ),
    CarouselItem(
      title: "Mountain Peak",
      subtitle: "Reach New Heights",
      description: "Challenge yourself to climb the highest peaks and witness breathtaking views from the summit.",
      color: Color(0xFFFF6B6B),
      gradientColors: [Color(0xFFFF9A8B), Color(0xFFA8E6CF)],
      icon: Icons.landscape,
    ),
    CarouselItem(
      title: "Digital Future",
      subtitle: "Innovation Awaits",
      description: "Step into tomorrow with cutting-edge technology that will reshape how we live and work.",
      color: Color(0xFF4ECDC4),
      gradientColors: [Color(0xFF667EEA), Color(0xFF764BA2)],
      icon: Icons.auto_awesome,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8);
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _backgroundController = AnimationController(
      duration: Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _backgroundAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      _backgroundController,
    );

    _animationController.forward();

    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
              Color(0xFF0F3460),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Animated Background
            AnimatedBuilder(
              animation: _backgroundAnimation,
              builder: (context, child) {
                return CustomPaint(
                  painter: BackgroundPainter(_backgroundAnimation.value),
                  size: Size.infinite,
                );
              },
            ),
            
            SafeArea(
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Discover",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                              ),
                            ),
                            child: Icon(
                              Icons.menu,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Carousel
                  Expanded(
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: PageView.builder(
                          controller: _pageController,
                          onPageChanged: _onPageChanged,
                          itemCount: _items.length,
                          itemBuilder: (context, index) {
                            final item = _items[index];
                            final isActive = index == _currentIndex;
                            final offset = (_currentPage - index).abs();
                            final scale = math.max(0.8, 1 - offset * 0.2);
                            final opacity = math.max(0.5, 1 - offset * 0.5);

                            return AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.001)
                                ..rotateY(offset * 0.3)
                                ..scale(scale),
                              child: Opacity(
                                opacity: opacity,
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 20,
                                  ),
                                  child: CarouselCard(
                                    item: item,
                                    isActive: isActive,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  // Dots Indicator
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _items.length,
                          (index) => AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            width: index == _currentIndex ? 32 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: index == _currentIndex
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Bottom Action
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            // Add your action here
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Color(0xFF1A1A2E),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            "Get Started",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
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
      ),
    );
  }
}

class CarouselCard extends StatefulWidget {
  final CarouselItem item;
  final bool isActive;

  const CarouselCard({
    Key? key,
    required this.item,
    required this.isActive,
  }) : super(key: key);

  @override
  _CarouselCardState createState() => _CarouselCardState();
}

class _CarouselCardState extends State<CarouselCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _hoverAnimation;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _hoverAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
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
    return GestureDetector(
      onTapDown: (_) => _hoverController.forward(),
      onTapUp: (_) => _hoverController.reverse(),
      onTapCancel: () => _hoverController.reverse(),
      child: ScaleTransition(
        scale: _hoverAnimation,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: widget.item.gradientColors,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.item.color.withOpacity(0.3),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Background Pattern
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: CustomPaint(
                    painter: PatternPainter(widget.item.color),
                  ),
                ),
              ),

              // Content
              Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                      child: Icon(
                        widget.item.icon,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),

                    Spacer(),

                    // Text Content
                    Text(
                      widget.item.subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.item.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      widget.item.description,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              // Floating Action Button
              Positioned(
                bottom: 24,
                right: 24,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: widget.item.color,
                    size: 24,
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

class CarouselItem {
  final String title;
  final String subtitle;
  final String description;
  final Color color;
  final List<Color> gradientColors;
  final IconData icon;

  CarouselItem({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.color,
    required this.gradientColors,
    required this.icon,
  });
}

class BackgroundPainter extends CustomPainter {
  final double animationValue;

  BackgroundPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    // Animated circles
    for (int i = 0; i < 5; i++) {
      final offset = Offset(
        size.width * 0.2 * (i + 1) + 50 * math.sin(animationValue + i),
        size.height * 0.2 * (i + 1) + 30 * math.cos(animationValue + i * 2),
      );
      
      paint.color = Colors.white.withOpacity(0.05);
      canvas.drawCircle(offset, 40 + 20 * math.sin(animationValue + i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class PatternPainter extends CustomPainter {
  final Color color;

  PatternPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw geometric pattern
    for (int i = 0; i < 10; i++) {
      final rect = Rect.fromCenter(
        center: Offset(size.width * 0.8, size.height * 0.2),
        width: 20.0 * (i + 1),
        height: 20.0 * (i + 1),
      );
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}