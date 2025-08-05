import 'package:flutter/material.dart';
import 'dart:math' as math;

class ScrollAnimationScreen extends StatefulWidget {
  @override
  _ScrollAnimationScreenState createState() =>
      _ScrollAnimationScreenState();
}

class _ScrollAnimationScreenState
    extends State<ScrollAnimationScreen>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _backgroundController;
  late Animation<double> _backgroundAnimation;
  
  List<GlobalKey> itemKeys = [];
  List<bool> itemsVisible = [];
  List<AnimationController> itemControllers = [];
  List<Animation<double>> slideAnimations = [];
  List<Animation<double>> fadeAnimations = [];
  List<Animation<double>> scaleAnimations = [];

  final List<ItemData> items = [
    ItemData("Neural Networks", "Advanced AI processing capabilities", Icons.psychology, Colors.cyan),
    ItemData("Quantum Computing", "Next-gen computational power", Icons.memory, Colors.purple),
    ItemData("Holographic UI", "3D interactive interfaces", Icons.view_in_ar, Colors.pink),
    ItemData("Biometric Security", "Advanced authentication systems", Icons.fingerprint, Colors.green),
    ItemData("Nano Technology", "Microscopic engineering marvels", Icons.science, Colors.orange),
    ItemData("Space Exploration", "Journey beyond our planet", Icons.rocket_launch, Colors.blue),
    ItemData("Time Manipulation", "Temporal control systems", Icons.access_time, Colors.amber),
    ItemData("Energy Fusion", "Unlimited power generation", Icons.flash_on, Colors.red),
    ItemData("Consciousness Transfer", "Digital immortality concepts", Icons.cloud_upload, Colors.indigo),
    ItemData("Reality Synthesis", "Virtual world creation", Icons.blur_on, Colors.teal),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    
    _backgroundController = AnimationController(
      duration: Duration(seconds: 10),
      vsync: this,
    )..repeat();
    
    _backgroundAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(_backgroundController);

    // Initialize animation controllers for each item
    for (int i = 0; i < items.length; i++) {
      itemKeys.add(GlobalKey());
      itemsVisible.add(false);
      
      final controller = AnimationController(
        duration: Duration(milliseconds: 800),
        vsync: this,
      );
      itemControllers.add(controller);
      
      slideAnimations.add(Tween<double>(
        begin: 100,
        end: 0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.elasticOut,
      )));
      
      fadeAnimations.add(Tween<double>(
        begin: 0,
        end: 1,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      )));
      
      scaleAnimations.add(Tween<double>(
        begin: 0.8,
        end: 1,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.elasticOut,
      )));
    }
  }

  void _onScroll() {
    for (int i = 0; i < itemKeys.length; i++) {
      if (itemKeys[i].currentContext != null) {
        final RenderBox renderBox =
            itemKeys[i].currentContext!.findRenderObject() as RenderBox;
        final position = renderBox.localToGlobal(Offset.zero);
        final screenHeight = MediaQuery.of(context).size.height;
        
        // Trigger animation when item is 80% visible
        if (position.dy < screenHeight * 0.8 && !itemsVisible[i]) {
          setState(() {
            itemsVisible[i] = true;
          });
          // Staggered animation delay
          Future.delayed(Duration(milliseconds: i * 100), () {
            if (mounted) {
              itemControllers[i].forward();
            }
          });
        }
        // Reset animation when scrolling back up
        else if (position.dy > screenHeight && itemsVisible[i]) {
          setState(() {
            itemsVisible[i] = false;
          });
          itemControllers[i].reset();
        }
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _backgroundController.dispose();
    for (var controller in itemControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated background
          AnimatedBuilder(
            animation: _backgroundAnimation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(
                      math.sin(_backgroundAnimation.value) * 0.5,
                      math.cos(_backgroundAnimation.value) * 0.3,
                    ),
                    radius: 1.5,
                    colors: [
                      Color(0xFF0A0A0A),
                      Color(0xFF1A1A2E),
                      Color(0xFF16213E),
                      Color(0xFF0F0F23),
                    ],
                    stops: [0.0, 0.3, 0.7, 1.0],
                  ),
                ),
                child: CustomPaint(
                  painter: ParticlesPainter(_backgroundAnimation.value),
                  size: Size.infinite,
                ),
              );
            },
          ),
          
          // Main content
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [Colors.cyan, Colors.purple, Colors.pink],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds),
                          child: Text(
                            'FUTURE TECH',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 4,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Scroll to explore the impossible',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                            letterSpacing: 2,
                          ),
                        ),
                        SizedBox(height: 40),
                        AnimatedBuilder(
                          animation: _backgroundAnimation,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(0, math.sin(_backgroundAnimation.value * 2) * 10),
                              child: Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.white54,
                                size: 40,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Animated list items
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return AnimatedBuilder(
                      animation: Listenable.merge([
                        slideAnimations[index],
                        fadeAnimations[index],
                        scaleAnimations[index],
                      ]),
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(slideAnimations[index].value, 0),
                          child: Transform.scale(
                            scale: scaleAnimations[index].value,
                            child: Opacity(
                              opacity: fadeAnimations[index].value,
                              child: Container(
                                key: itemKeys[index],
                                margin: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 15,
                                ),
                                child: FuturisticCard(
                                  item: items[index],
                                  index: index,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  childCount: items.length,
                ),
              ),
              
              // Footer
              SliverToBoxAdapter(
                child: Container(
                  height: 200,
                  child: Center(
                    child: Text(
                      'The future is now',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white30,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FuturisticCard extends StatefulWidget {
  final ItemData item;
  final int index;

  const FuturisticCard({Key? key, required this.item, required this.index})
      : super(key: key);

  @override
  _FuturisticCardState createState() => _FuturisticCardState();
}

class _FuturisticCardState extends State<FuturisticCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _hoverAnimation;
  bool isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _hoverAnimation = Tween<double>(begin: 1, end: 1.05).animate(
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
      animation: _hoverAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _hoverAnimation.value,
          child: GestureDetector(
            onTapDown: (_) {
              _hoverController.forward();
            },
            onTapUp: (_) {
              _hoverController.reverse();
            },
            onTapCancel: () {
              _hoverController.reverse();
            },
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    widget.item.color.withOpacity(0.1),
                    widget.item.color.withOpacity(0.05),
                    Colors.transparent,
                  ],
                ),
                border: Border.all(
                  color: widget.item.color.withOpacity(0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.item.color.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    // Animated background pattern
                    Positioned.fill(
                      child: CustomPaint(
                        painter: CardPatternPainter(
                          widget.item.color,
                          widget.index.toDouble(),
                        ),
                      ),
                    ),
                    
                    // Content
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        children: [
                          // Icon
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  widget.item.color.withOpacity(0.3),
                                  widget.item.color.withOpacity(0.1),
                                ],
                              ),
                              border: Border.all(
                                color: widget.item.color.withOpacity(0.5),
                              ),
                            ),
                            child: Icon(
                              widget.item.icon,
                              color: widget.item.color,
                              size: 30,
                            ),
                          ),
                          
                          SizedBox(width: 20),
                          
                          // Text content
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  widget.item.title,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 1,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  widget.item.description,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // Arrow
                          Icon(
                            Icons.arrow_forward_ios,
                            color: widget.item.color.withOpacity(0.7),
                            size: 20,
                          ),
                        ],
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

class ParticlesPainter extends CustomPainter {
  final double animationValue;

  ParticlesPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 1;

    // Draw animated particles
    for (int i = 0; i < 50; i++) {
      final x = (size.width * (i * 0.02)) +
          math.sin(animationValue + i * 0.5) * 100;
      final y = (size.height * (i * 0.02)) +
          math.cos(animationValue + i * 0.3) * 50;
      
      if (x >= 0 && x <= size.width && y >= 0 && y <= size.height) {
        canvas.drawCircle(
          Offset(x, y),
          1 + math.sin(animationValue + i) * 0.5,
          paint,
        );
      }
    }

    // Draw connecting lines
    paint.strokeWidth = 0.5;
    for (int i = 0; i < 20; i++) {
      final x1 = size.width * (i * 0.05) +
          math.sin(animationValue + i * 0.7) * 80;
      final y1 = size.height * (i * 0.05) +
          math.cos(animationValue + i * 0.4) * 60;
      final x2 = size.width * ((i + 1) * 0.05) +
          math.sin(animationValue + (i + 1) * 0.7) * 80;
      final y2 = size.height * ((i + 1) * 0.05) +
          math.cos(animationValue + (i + 1) * 0.4) * 60;
      
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class CardPatternPainter extends CustomPainter {
  final Color color;
  final double index;

  CardPatternPainter(this.color, this.index);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.05)
      ..strokeWidth = 1;

    // Draw geometric pattern
    final centerX = size.width * 0.8;
    final centerY = size.height * 0.5;
    final radius = 30.0;

    for (int i = 0; i < 6; i++) {
      final angle = (i * math.pi / 3) + (index * 0.2);
      final x = centerX + math.cos(angle) * radius;
      final y = centerY + math.sin(angle) * radius;
      
      canvas.drawLine(
        Offset(centerX, centerY),
        Offset(x, y),
        paint,
      );
      
      canvas.drawCircle(Offset(x, y), 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ItemData {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  ItemData(this.title, this.description, this.icon, this.color);
}
