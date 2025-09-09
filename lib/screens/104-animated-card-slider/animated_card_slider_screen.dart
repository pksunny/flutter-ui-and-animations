import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedCardSliderScreen extends StatefulWidget {
  @override
  _AnimatedCardSliderScreenState createState() => _AnimatedCardSliderScreenState();
}

class _AnimatedCardSliderScreenState extends State<AnimatedCardSliderScreen>
    with TickerProviderStateMixin {
  int selectedStyle = 0;
  late AnimationController _backgroundController;
  late Animation<double> _backgroundAnimation;

  final List<String> styleNames = [
    'Glassmorphism',
    'Neon Glow',
    'Floating Cards',
    '3D Perspective',
    'Liquid Motion'
  ];

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      duration: Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _backgroundAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(_backgroundController);
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    super.dispose();
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
              Color(0xFF1a1a2e),
              Color(0xFF16213e),
              Color(0xFF0f3460),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Animated background particles
            AnimatedBuilder(
              animation: _backgroundAnimation,
              builder: (context, child) {
                return CustomPaint(
                  painter: ParticlesPainter(_backgroundAnimation.value),
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
                    child: Column(
                      children: [
                        Text(
                          'Amazing Card Slider',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Choose your favorite style',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Style selector
                  Container(
                    height: 50,
                    margin: EdgeInsets.symmetric(vertical: 20),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: styleNames.length,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      itemBuilder: (context, index) {
                        bool isSelected = selectedStyle == index;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedStyle = index;
                            });
                          },
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            margin: EdgeInsets.only(right: 15),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? LinearGradient(
                                      colors: [
                                        Colors.cyanAccent,
                                        Colors.blueAccent
                                      ],
                                    )
                                  : null,
                              color: isSelected ? null : Colors.white12,
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.transparent
                                    : Colors.white30,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              styleNames[index],
                              style: TextStyle(
                                color: isSelected ? Colors.black : Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Card slider based on selected style
                  Expanded(
                    child: _buildCardSlider(selectedStyle),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardSlider(int style) {
    switch (style) {
      case 0:
        return GlassmorphismSlider();
      case 1:
        return NeonGlowSlider();
      case 2:
        return FloatingCardsSlider();
      case 3:
        return PerspectiveSlider();
      case 4:
        return LiquidMotionSlider();
      default:
        return GlassmorphismSlider();
    }
  }
}

// Style 1: Glassmorphism Slider
class GlassmorphismSlider extends StatefulWidget {
  @override
  _GlassmorphismSliderState createState() => _GlassmorphismSliderState();
}

class _GlassmorphismSliderState extends State<GlassmorphismSlider> {
  PageController _pageController = PageController(viewportFraction: 0.8);
  int currentPage = 0;

  final List<Map<String, dynamic>> cards = [
    {
      'title': 'Aurora Dreams',
      'subtitle': 'Ethereal Beauty',
      'color': LinearGradient(
        colors: [Colors.purple.withOpacity(0.3), Colors.pink.withOpacity(0.3)],
      ),
      'icon': Icons.auto_awesome,
    },
    {
      'title': 'Ocean Waves',
      'subtitle': 'Calm & Serene',
      'color': LinearGradient(
        colors: [Colors.blue.withOpacity(0.3), Colors.cyan.withOpacity(0.3)],
      ),
      'icon': Icons.waves,
    },
    {
      'title': 'Golden Hour',
      'subtitle': 'Warm Embrace',
      'color': LinearGradient(
        colors: [Colors.orange.withOpacity(0.3), Colors.yellow.withOpacity(0.3)],
      ),
      'icon': Icons.wb_sunny,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (index) {
        setState(() {
          currentPage = index;
        });
      },
      itemCount: cards.length,
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: _pageController,
          builder: (context, child) {
            double value = 1.0;
            if (_pageController.position.haveDimensions) {
              value = _pageController.page! - index;
              value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
            }
            
            return Transform.scale(
              scale: Curves.easeOut.transform(value),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 40),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: cards[index]['color'],
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1.5,
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Glassmorphism effect
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        ),
                        // Content
                        Padding(
                          padding: EdgeInsets.all(30),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  cards[index]['icon'],
                                  size: 80,
                                  color: Colors.white,
                                ),
                                SizedBox(height: 30),
                                Text(
                                  cards[index]['title'],
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  cards[index]['subtitle'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
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
      },
    );
  }
}

// Style 2: Neon Glow Slider
class NeonGlowSlider extends StatefulWidget {
  @override
  _NeonGlowSliderState createState() => _NeonGlowSliderState();
}

class _NeonGlowSliderState extends State<NeonGlowSlider>
    with TickerProviderStateMixin {
  PageController _pageController = PageController(viewportFraction: 0.85);
  late AnimationController _glowController;

  final List<Map<String, dynamic>> cards = [
    {
      'title': 'Cyber Punk',
      'subtitle': 'Future Awaits',
      'color': Colors.cyanAccent,
      'shadowColor': Colors.cyanAccent,
      'icon': Icons.flash_on,
    },
    {
      'title': 'Electric Dream',
      'subtitle': 'Digital Paradise',
      'color': Colors.pinkAccent,
      'shadowColor': Colors.pinkAccent,
      'icon': Icons.electric_bolt,
    },
    {
      'title': 'Neon Lights',
      'subtitle': 'City Nights',
      'color': Colors.greenAccent,
      'shadowColor': Colors.greenAccent,
      'icon': Icons.lightbulb,
    },
  ];

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemCount: cards.length,
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: _glowController,
          builder: (context, child) {
            return Container(
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: cards[index]['shadowColor'].withOpacity(
                        0.3 + 0.2 * _glowController.value),
                    blurRadius: 20 + 10 * _glowController.value,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF1a1a1a),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: cards[index]['color'],
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        cards[index]['icon'],
                        size: 100,
                        color: cards[index]['color'],
                      ),
                      SizedBox(height: 30),
                      Text(
                        cards[index]['title'],
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: cards[index]['color'],
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        cards[index]['subtitle'],
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// Style 3: Floating Cards Slider
class FloatingCardsSlider extends StatefulWidget {
  @override
  _FloatingCardsSliderState createState() => _FloatingCardsSliderState();
}

class _FloatingCardsSliderState extends State<FloatingCardsSlider>
    with TickerProviderStateMixin {
  late AnimationController _floatingController;
  PageController _pageController = PageController(viewportFraction: 0.7);

  final List<Map<String, dynamic>> cards = [
    {
      'title': 'Floating Dreams',
      'subtitle': 'Weightless Wonder',
      'gradient': LinearGradient(
        colors: [Color(0xFF667eea), Color(0xFF764ba2)],
      ),
      'icon': Icons.cloud,
    },
    {
      'title': 'Sky High',
      'subtitle': 'Above the Clouds',
      'gradient': LinearGradient(
        colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
      ),
      'icon': Icons.flight_takeoff,
    },
    {
      'title': 'Zero Gravity',
      'subtitle': 'Space Exploration',
      'gradient': LinearGradient(
        colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
      ),
      'icon': Icons.rocket_launch,
    },
  ];

  @override
  void initState() {
    super.initState();
    _floatingController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemCount: cards.length,
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: _floatingController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(
                0,
                10 * math.sin(_floatingController.value * 2 * math.pi + index),
              ),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 25,
                      offset: Offset(0, 15),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(35),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: cards[index]['gradient'],
                      borderRadius: BorderRadius.circular(35),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          cards[index]['icon'],
                          size: 90,
                          color: Colors.white,
                        ),
                        SizedBox(height: 30),
                        Text(
                          cards[index]['title'],
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          cards[index]['subtitle'],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.8),
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
      },
    );
  }
}

// Style 4: 3D Perspective Slider
class PerspectiveSlider extends StatefulWidget {
  @override
  _PerspectiveSliderState createState() => _PerspectiveSliderState();
}

class _PerspectiveSliderState extends State<PerspectiveSlider> {
  PageController _pageController = PageController(viewportFraction: 0.8);
  double currentPageValue = 0.0;

  final List<Map<String, dynamic>> cards = [
    {
      'title': '3D Vision',
      'subtitle': 'Dimensional Reality',
      'color': Color(0xFF6c5ce7),
      'icon': Icons.view_in_ar,
    },
    {
      'title': 'Perspective',
      'subtitle': 'New Angles',
      'color': Color(0xFFfd79a8),
      'icon': Icons.threed_rotation,
    },
    {
      'title': 'Depth Field',
      'subtitle': 'Immersive Experience',
      'color': Color(0xFF00cec9),
      'icon': Icons.threed_rotation,
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        currentPageValue = _pageController.page!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemCount: cards.length,
      itemBuilder: (context, index) {
        double distortionValue = 1.0;
        if (currentPageValue > index - 1 && currentPageValue < index + 1) {
          double currentDistortion = (currentPageValue - index).abs();
          distortionValue = 1.0 - currentDistortion;
        }

        return Transform(
          alignment: FractionalOffset.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(currentPageValue - index),
          child: Container(
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: cards[index]['color'].withOpacity(0.4),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      cards[index]['color'],
                      cards[index]['color'].withOpacity(0.7),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      cards[index]['icon'],
                      size: 100,
                      color: Colors.white,
                    ),
                    SizedBox(height: 30),
                    Text(
                      cards[index]['title'],
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      cards[index]['subtitle'],
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white.withOpacity(0.8),
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

// Style 5: Liquid Motion Slider
class LiquidMotionSlider extends StatefulWidget {
  @override
  _LiquidMotionSliderState createState() => _LiquidMotionSliderState();
}

class _LiquidMotionSliderState extends State<LiquidMotionSlider>
    with TickerProviderStateMixin {
  late AnimationController _liquidController;
  PageController _pageController = PageController(viewportFraction: 0.8);

  final List<Map<String, dynamic>> cards = [
    {
      'title': 'Liquid Flow',
      'subtitle': 'Smooth Transitions',
      'colors': [Color(0xFFff9a9e), Color(0xFFfecfef), Color(0xFFfecfef)],
      'icon': Icons.water_drop,
    },
    {
      'title': 'Wave Motion',
      'subtitle': 'Fluid Dynamics',
      'colors': [Color(0xFFa8edea), Color(0xFFfed6e3), Color(0xFFa8edea)],
      'icon': Icons.waves,
    },
    {
      'title': 'Morphing',
      'subtitle': 'Shape Shifting',
      'colors': [Color(0xFFd299c2), Color(0xFFfef9d7), Color(0xFFd299c2)],
      'icon': Icons.transform,
    },
  ];

  @override
  void initState() {
    super.initState();
    _liquidController = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _liquidController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemCount: cards.length,
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: _liquidController,
          builder: (context, child) {
            return Container(
              margin: EdgeInsets.all(15),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: CustomPaint(
                  painter: LiquidPainter(
                    _liquidController.value,
                    cards[index]['colors'],
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          cards[index]['icon'],
                          size: 90,
                          color: Colors.white,
                        ),
                        SizedBox(height: 30),
                        Text(
                          cards[index]['title'],
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          cards[index]['subtitle'],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.9),
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
      },
    );
  }
}

// Custom Painters
class ParticlesPainter extends CustomPainter {
  final double animationValue;

  ParticlesPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 1;

    for (int i = 0; i < 50; i++) {
      double x = (i * 37) % size.width;
      double y = (i * 23 + animationValue * 50) % size.height;
      canvas.drawCircle(Offset(x, y), 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class LiquidPainter extends CustomPainter {
  final double animationValue;
  final List<Color> colors;

  LiquidPainter(this.animationValue, this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    final path = Path();
    
    // Create liquid wave effect
    for (int i = 0; i < colors.length; i++) {
      paint.color = colors[i].withOpacity(0.8);
      
      path.reset();
      path.moveTo(0, size.height * 0.3 + i * 50);
      
      for (double x = 0; x <= size.width; x += 10) {
        double y = size.height * 0.3 + 
                  i * 50 + 
                  30 * math.sin((x / 50) + animationValue * 2 * math.pi + i);
        path.lineTo(x, y);
      }
      
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();
      
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}