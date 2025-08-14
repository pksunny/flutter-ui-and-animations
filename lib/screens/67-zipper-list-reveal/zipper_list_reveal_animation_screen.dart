import 'package:flutter/material.dart';

class ZipperListRevealAnimationScreen extends StatefulWidget {
  @override
  _ZipperListRevealAnimationScreenState createState() => _ZipperListRevealAnimationScreenState();
}

class _ZipperListRevealAnimationScreenState extends State<ZipperListRevealAnimationScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _pulseController;
  late Animation<double> _zipperAnimation;
  late Animation<double> _pulseAnimation;
  
  List<AnimationController> _itemControllers = [];
  List<Animation<double>> _itemAnimations = [];
  List<Animation<Offset>> _slideAnimations = [];
  List<Animation<double>> _scaleAnimations = [];
  
  final List<ZipperItem> _items = [
    ZipperItem(
      icon: Icons.rocket_launch,
      title: "Futuristic Designs",
      subtitle: "Cutting-edge UI patterns", 
      color: Color(0xFF00D4FF),
    ),
    ZipperItem(
      icon: Icons.auto_awesome,
      title: "Smooth Animations",
      subtitle: "Silky 60fps transitions",
      color: Color(0xFF9D4EDD),
    ),
    ZipperItem(
      icon: Icons.psychology,
      title: "Smart Interactions",
      subtitle: "Intuitive user experience",
      color: Color(0xFF06FFA5),
    ),
    ZipperItem(
      icon: Icons.speed,
      title: "Performance First",
      subtitle: "Optimized for all devices",
      color: Color(0xFFFFD60A),
    ),
    ZipperItem(
      icon: Icons.palette,
      title: "Beautiful Gradients",
      subtitle: "Eye-catching visual effects",
      color: Color(0xFFFF006E),
    ),
    ZipperItem(
      icon: Icons.bolt,
      title: "Lightning Fast",
      subtitle: "Instant response time",
      color: Color(0xFF8338EC),
    ),
  ];

  @override
  void initState() {
    super.initState();
    
    _mainController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    _zipperAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: Curves.easeInOutCubic,
    ));
    
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _initializeItemAnimations();
    
    // Start animation after a brief delay
    Future.delayed(Duration(milliseconds: 500), () {
      _startZipperAnimation();
    });
  }

  void _initializeItemAnimations() {
    for (int i = 0; i < _items.length; i++) {
      final controller = AnimationController(
        duration: Duration(milliseconds: 800),
        vsync: this,
      );
      
      final animation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.elasticOut,
      ));
      
      final slideAnimation = Tween<Offset>(
        begin: Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutBack,
      ));
      
      final scaleAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.elasticOut,
      ));
      
      _itemControllers.add(controller);
      _itemAnimations.add(animation);
      _slideAnimations.add(slideAnimation);
      _scaleAnimations.add(scaleAnimation);
    }
  }

  void _startZipperAnimation() {
    _mainController.forward();
    
    for (int i = 0; i < _itemControllers.length; i++) {
      Future.delayed(Duration(milliseconds: 200 * i + 400), () {
        if (mounted) {
          _itemControllers[i].forward();
        }
      });
    }
  }

  void _resetAnimation() {
    _mainController.reset();
    for (var controller in _itemControllers) {
      controller.reset();
    }
    Future.delayed(Duration(milliseconds: 300), () {
      _startZipperAnimation();
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _pulseController.dispose();
    for (var controller in _itemControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.5,
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF0F0F23),
              Color(0xFF0A0A0A),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: _buildZipperList(),
              ),
              _buildResetButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(24.0),
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value.clamp(0.5, 1.5),
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFF00D4FF), Color(0xFF9D4EDD)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF00D4FF).withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.list_alt_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 24),
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [Color(0xFF00D4FF), Color(0xFF9D4EDD)],
            ).createShader(bounds),
            child: Text(
              'ZIPPER LIST REVEAL',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Premium animated list experience',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.7),
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZipperList() {
    return AnimatedBuilder(
      animation: _zipperAnimation,
      builder: (context, child) {
        return CustomPaint(
          painter: ZipperPainter(_zipperAnimation.value),
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20),
            itemCount: _items.length,
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: _itemAnimations[index],
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimations[index].value.clamp(0.0, 2.0),
                    child: SlideTransition(
                      position: _slideAnimations[index],
                      child: Opacity(
                        opacity: _itemAnimations[index].value.clamp(0.0, 1.0),
                        child: _buildListItem(_items[index], index),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildListItem(ZipperItem item, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                item.color.withOpacity(0.1),
                item.color.withOpacity(0.05),
              ],
            ),
            border: Border.all(
              color: item.color.withOpacity(0.3),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {},
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: item.color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: item.color.withOpacity(0.3),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        item.icon,
                        color: item.color,
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            item.subtitle,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: item.color.withOpacity(0.7),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResetButton() {
    return Padding(
      padding: EdgeInsets.all(24),
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF00D4FF), Color(0xFF9D4EDD)],
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF00D4FF).withOpacity(0.3),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(28),
            onTap: _resetAnimation,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.replay_rounded, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'REPLAY ANIMATION',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ZipperItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  ZipperItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });
}

class ZipperPainter extends CustomPainter {
  final double progress;

  ZipperPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..shader = LinearGradient(
        colors: [
          Color(0xFF00D4FF).withOpacity(progress * 0.5),
          Color(0xFF9D4EDD).withOpacity(progress * 0.5),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final centerX = size.width / 2;
    final zipperHeight = size.height * progress;

    // Draw zipper line
    canvas.drawLine(
      Offset(centerX, 0),
      Offset(centerX, zipperHeight),
      paint,
    );

    // Draw zipper teeth
    final toothSpacing = 30.0;
    final toothCount = (zipperHeight / toothSpacing).floor();

    for (int i = 0; i <= toothCount; i++) {
      final y = i * toothSpacing;
      if (y <= zipperHeight) {
        // Left teeth
        canvas.drawLine(
          Offset(centerX - 10, y),
          Offset(centerX, y),
          paint,
        );
        // Right teeth
        canvas.drawLine(
          Offset(centerX, y),
          Offset(centerX + 10, y),
          paint,
        );
      }
    }

    // Draw zipper slider
    if (progress > 0) {
      final sliderPaint = Paint()
        ..color = Color(0xFF00D4FF)
        ..style = PaintingStyle.fill;

      final sliderY = zipperHeight;
      final sliderRect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(centerX, sliderY),
          width: 30,
          height: 20,
        ),
        Radius.circular(10),
      );

      canvas.drawRRect(sliderRect, sliderPaint);
    }
  }

  @override
  bool shouldRepaint(ZipperPainter oldDelegate) =>
      oldDelegate.progress != progress;
}