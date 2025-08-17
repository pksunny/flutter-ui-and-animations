import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedScrollingScreen extends StatefulWidget {
  @override
  _AnimatedScrollingScreenState createState() => _AnimatedScrollingScreenState();
}

class _AnimatedScrollingScreenState extends State<AnimatedScrollingScreen>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  double _scrollOffset = 0;

  final List<ItemData> items = [
    ItemData(
      title: "Quantum Computing",
      subtitle: "The Future of Processing",
      description: "Revolutionizing how we solve complex problems",
      gradient: [Color(0xFF667eea), Color(0xFF764ba2)],
      icon: Icons.computer_rounded,
    ),
    ItemData(
      title: "Neural Networks",
      subtitle: "Artificial Intelligence",
      description: "Mimicking the human brain's neural connections",
      gradient: [Color(0xFFf093fb), Color(0xFFf5576c)],
      icon: Icons.psychology_rounded,
    ),
    ItemData(
      title: "Space Exploration",
      subtitle: "Beyond Our World",
      description: "Discovering the mysteries of the universe",
      gradient: [Color(0xFF4facfe), Color(0xFF00f2fe)],
      icon: Icons.rocket_launch_rounded,
    ),
    ItemData(
      title: "Biotechnology",
      subtitle: "Life Sciences",
      description: "Engineering life for a better tomorrow",
      gradient: [Color(0xFF43e97b), Color(0xFF38f9d7)],
      icon: Icons.biotech_rounded,
    ),
    ItemData(
      title: "Virtual Reality",
      subtitle: "Immersive Experience",
      description: "Creating new dimensions of interaction",
      gradient: [Color(0xFFfa709a), Color(0xFFfee140)],
      icon: Icons.view_in_ar_rounded,
    ),
    ItemData(
      title: "Sustainable Energy",
      subtitle: "Green Technology",
      description: "Powering the future responsibly",
      gradient: [Color(0xFFa8edea), Color(0xFFfed6e3)],
      icon: Icons.solar_power_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          _scrollOffset = _scrollController.offset;
        });
      });

    _fadeController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutQuart,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _fadeController.dispose();
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
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: _buildScrollingContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              "FUTURE",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 8,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Explore Tomorrow's Innovations",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScrollingContent() {
    return CustomScrollView(
      controller: _scrollController,
      physics: BouncingScrollPhysics(),
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index == 0) {
                return _buildParallaxHero();
              }
              
              final itemIndex = index - 1;
              if (itemIndex >= items.length) return null;
              
              return _buildAnimatedItem(items[itemIndex], itemIndex);
            },
            childCount: items.length + 1,
          ),
        ),
      ],
    );
  }

  Widget _buildParallaxHero() {
    final parallaxOffset = _scrollOffset * 0.5;
    
    return Container(
      height: 300,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Transform.translate(
              offset: Offset(0, parallaxOffset),
              child: Container(
                height: 350,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF667eea),
                      Color(0xFF764ba2),
                      Color(0xFF4facfe),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.3),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              left: 30,
              right: 30,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Innovation Awaits",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Scroll to discover the technologies shaping our future",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
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

  Widget _buildAnimatedItem(ItemData item, int index) {
    final itemOffset = (index + 1) * 380.0;
    final scrollProgress = (_scrollOffset - itemOffset + 600) / 600;
    final clampedProgress = scrollProgress.clamp(0.0, 1.0);
    
    final fadeOpacity = Curves.easeOut.transform(clampedProgress);
    final slideOffset = (1 - Curves.easeOutCubic.transform(clampedProgress)) * 100;
    final scale = 0.8 + (0.2 * Curves.easeOutBack.transform(clampedProgress));

    return Transform.translate(
      offset: Offset(0, slideOffset),
      child: Transform.scale(
        scale: scale,
        child: Opacity(
          opacity: fadeOpacity,
          child: Container(
            height: 350,
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              child: Stack(
                children: [
                  _buildGradientCard(item),
                  _buildCardContent(item),
                  _buildFloatingIcon(item),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGradientCard(ItemData item) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: item.gradient,
        ),
        boxShadow: [
          BoxShadow(
            color: item.gradient[0].withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
          BoxShadow(
            color: item.gradient[1].withOpacity(0.2),
            blurRadius: 40,
            offset: Offset(0, 20),
          ),
        ],
      ),
    );
  }

  Widget _buildCardContent(ItemData item) {
    return Padding(
      padding: EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            item.subtitle,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.8),
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 8),
          Text(
            item.title,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          SizedBox(height: 16),
          Container(
            width: 60,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 16),
          Text(
            item.description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingIcon(ItemData item) {
    return Positioned(
      top: 24,
      right: 24,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Icon(
          item.icon,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }
}

class ItemData {
  final String title;
  final String subtitle;
  final String description;
  final List<Color> gradient;
  final IconData icon;

  ItemData({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.gradient,
    required this.icon,
  });
}