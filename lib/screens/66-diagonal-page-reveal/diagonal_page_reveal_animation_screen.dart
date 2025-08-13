import 'package:flutter/material.dart';
import 'dart:math' as math;

class DiagonalPageRevealAnimationScreen extends StatelessWidget {
  const DiagonalPageRevealAnimationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diagonal Page Reveal',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const DiagonalPageView(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DiagonalPageView extends StatefulWidget {
  const DiagonalPageView({Key? key}) : super(key: key);

  @override
  State<DiagonalPageView> createState() => _DiagonalPageViewState();
}

class _DiagonalPageViewState extends State<DiagonalPageView>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late Animation<double> _animation;
  
  int _currentPage = 0;
  double _pageOffset = 0;
  bool _isAnimating = false;

  final List<PageData> _pages = [
    PageData(
      title: "COSMIC DREAMS",
      subtitle: "Explore the infinite",
      color: const Color(0xFF6C5CE7),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
      ),
      icon: Icons.auto_awesome,
    ),
    PageData(
      title: "NEON NIGHTS",
      subtitle: "Feel the electric pulse",
      color: const Color(0xFF00CEC9),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF00CEC9), Color(0xFF55EFC4)],
      ),
      icon: Icons.electric_bolt,
    ),
    PageData(
      title: "FIRE SOUL",
      subtitle: "Ignite your passion",
      color: const Color(0xFFE17055),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFE17055), Color(0xFFFFAB91)],
      ),
      icon: Icons.local_fire_department,
    ),
    PageData(
      title: "ARCTIC FLOW",
      subtitle: "Embrace the cool",
      color: const Color(0xFF0984E3),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF0984E3), Color(0xFF74B9FF)],
      ),
      icon: Icons.ac_unit,
    ),
    PageData(
      title: "GOLDEN HOUR",
      subtitle: "Capture the moment",
      color: const Color(0xFFFDAE5B),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFDAE5B), Color(0xFFFFD93D)],
      ),
      icon: Icons.wb_sunny,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    );
    
    _pageController.addListener(() {
      setState(() {
        _pageOffset = _pageController.page ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_isAnimating || _currentPage >= _pages.length - 1) return;
    
    _isAnimating = true;
    _animationController.reset();
    _animationController.forward().then((_) {
      setState(() {
        _currentPage++;
        _isAnimating = false;
      });
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  void _previousPage() {
    if (_isAnimating || _currentPage <= 0) return;
    
    _isAnimating = true;
    _animationController.reset();
    _animationController.forward().then((_) {
      setState(() {
        _currentPage--;
        _isAnimating = false;
      });
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background pages
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return _buildPage(index);
            },
          ),
          
          // Diagonal reveal overlay
          if (_isAnimating)
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return CustomPaint(
                  painter: DiagonalRevealPainter(
                    progress: _animation.value,
                    screenSize: MediaQuery.of(context).size,
                    fromColor: _pages[_currentPage].color,
                    toColor: _currentPage < _pages.length - 1 
                        ? _pages[_currentPage + 1].color 
                        : _pages[_currentPage].color,
                  ),
                  size: Size.infinite,
                );
              },
            ),
          
          // Navigation controls
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: _buildNavigationControls(),
          ),
          
          // Page indicator
          Positioned(
            top: 60,
            right: 30,
            child: _buildPageIndicator(),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(int index) {
    final page = _pages[index];
    final offset = _pageOffset - index;
    final scale = 1.0 - (offset.abs() * 0.1).clamp(0.0, 1.0);
    final opacity = 1.0 - (offset.abs() * 0.5).clamp(0.0, 1.0);
    
    return Transform.scale(
      scale: scale,
      child: Opacity(
        opacity: opacity,
        child: Container(
          decoration: BoxDecoration(
            gradient: page.gradient,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Animated background particles
              ...List.generate(20, (i) => _buildParticle(i, page.color)),
              
              // Main content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Icon with glow effect
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.3),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Icon(
                        page.icon,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Title with typing animation
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 500),
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 4,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(2, 2),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(page.title, textAlign: TextAlign.center,)),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Subtitle
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 700),
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white.withOpacity(0.9),
                        letterSpacing: 2,
                      ),
                      child: Text(page.subtitle),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParticle(int index, Color baseColor) {
    final random = math.Random(index);
    final size = 2.0 + random.nextDouble() * 4;
    final left = random.nextDouble() * 400;
    final top = random.nextDouble() * 800;
    
    return Positioned(
      left: left,
      top: top,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: Duration(milliseconds: 2000 + random.nextInt(2000)),
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(0, -value * 20),
            child: Opacity(
              opacity: (1 - value) * 0.7,
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.6),
                  boxShadow: [
                    BoxShadow(
                      color: baseColor.withOpacity(0.5),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNavigationControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildNavButton(
          icon: Icons.arrow_back_ios,
          onTap: _previousPage,
          enabled: _currentPage > 0,
        ),
        _buildNavButton(
          icon: Icons.arrow_forward_ios,
          onTap: _nextPage,
          enabled: _currentPage < _pages.length - 1,
        ),
      ],
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool enabled,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: enabled 
              ? Colors.white.withOpacity(0.2) 
              : Colors.white.withOpacity(0.1),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 2,
          ),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Icon(
          icon,
          color: enabled 
              ? Colors.white 
              : Colors.white.withOpacity(0.5),
          size: 24,
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Column(
      children: List.generate(_pages.length, (index) {
        final isActive = index == _currentPage;
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          width: 4,
          height: isActive ? 24 : 12,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: isActive 
                ? Colors.white 
                : Colors.white.withOpacity(0.4),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.6),
                      blurRadius: 8,
                    ),
                  ]
                : null,
          ),
        );
      }),
    );
  }
}

class DiagonalRevealPainter extends CustomPainter {
  final double progress;
  final Size screenSize;
  final Color fromColor;
  final Color toColor;

  DiagonalRevealPainter({
    required this.progress,
    required this.screenSize,
    required this.fromColor,
    required this.toColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [fromColor, toColor],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final diagonal = math.sqrt(size.width * size.width + size.height * size.height);
    final animatedDiagonal = diagonal * progress;

    final path = Path();
    
    // Create diagonal reveal effect
    if (progress < 0.5) {
      // Reveal from top-left corner
      final revealSize = animatedDiagonal * 2;
      path.moveTo(0, 0);
      path.lineTo(revealSize, 0);
      path.lineTo(0, revealSize);
      path.close();
    } else {
      // Complete reveal with smooth transition
      final revealProgress = (progress - 0.5) * 2;
      path.moveTo(0, 0);
      path.lineTo(size.width * revealProgress, 0);
      path.lineTo(size.width, size.height * revealProgress);
      path.lineTo(0, size.height);
      path.close();
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class PageData {
  final String title;
  final String subtitle;
  final Color color;
  final LinearGradient gradient;
  final IconData icon;

  const PageData({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.gradient,
    required this.icon,
  });
}