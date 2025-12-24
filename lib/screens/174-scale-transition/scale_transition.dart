import 'package:flutter/material.dart';

/// 🏠 Main Screen with Card Grid
class SmoothScaleTransitionScreen extends StatefulWidget {
  const SmoothScaleTransitionScreen({super.key});

  @override
  State<SmoothScaleTransitionScreen> createState() =>
      _SmoothScaleTransitionScreenState();
}

class _SmoothScaleTransitionScreenState
    extends State<SmoothScaleTransitionScreen> {
  int? _activeCardId;

  // 📊 Card data model list
  final List<CardData> _cardDataList = [
    CardData(
      id: 1,
      icon: Icons.camera_alt_rounded,
      title: 'Photography',
      subtitle: 'Capture moments',
      gradientColors: [Color(0xFFC084FC), Color(0xFFF0ABFC)],
      detail: 'Professional camera with AI enhancement',
    ),
    CardData(
      id: 2,
      icon: Icons.favorite_rounded,
      title: 'Health',
      subtitle: 'Stay fit',
      gradientColors: [Color(0xFFFB7185), Color(0xFFFB923C)],
      detail: 'Track your wellness journey daily',
    ),
    CardData(
      id: 3,
      icon: Icons.star_rounded,
      title: 'Premium',
      subtitle: 'Go exclusive',
      gradientColors: [Color(0xFFFBBF24), Color(0xFFFDE047)],
      detail: 'Unlock all premium features now',
    ),
    CardData(
      id: 4,
      icon: Icons.bolt_rounded,
      title: 'Energy',
      subtitle: 'Boost power',
      gradientColors: [Color(0xFF22D3EE), Color(0xFF3B82F6)],
      detail: 'Supercharge your productivity',
    ),
    CardData(
      id: 5,
      icon: Icons.emoji_events_rounded,
      title: 'Achievement',
      subtitle: 'Win rewards',
      gradientColors: [Color(0xFF34D399), Color(0xFF14B8A6)],
      detail: 'Earn badges and unlock achievements',
    ),
    CardData(
      id: 6,
      icon: Icons.card_giftcard_rounded,
      title: 'Rewards',
      subtitle: 'Get prizes',
      gradientColors: [Color(0xFF8B5CF6), Color(0xFFA78BFA)],
      detail: 'Redeem points for amazing gifts',
    ),
  ];

  void _toggleCard(int id) {
    setState(() {
      _activeCardId = _activeCardId == id ? null : id;
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
            colors: [Color(0xFFF8FAFC), Color(0xFFDCEEFF), Color(0xFFF3E8FF)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 📌 Header Section
                _buildHeader(),
                SizedBox(height: 32),

                // 🎴 Cards Grid
                _buildCardsGrid(),

                SizedBox(height: 32),

                // 💡 Info Card
                _buildInfoCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 📌 Header with title and description
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShaderMask(
          shaderCallback:
              (bounds) => LinearGradient(
                colors: [Color(0xFF9333EA), Color(0xFFDB2777)],
              ).createShader(bounds),
          child: Text(
            'Smooth Scale Transition',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Tap any card to see the magical scale animation with detail reveal',
          style: TextStyle(fontSize: 16, color: Colors.grey[700], height: 1.5),
        ),
      ],
    );
  }

  /// 🎴 Cards Grid Layout
  Widget _buildCardsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive grid: 1 column on small, 2 on medium, 3 on large screens
        int crossAxisCount =
            constraints.maxWidth > 900
                ? 3
                : constraints.maxWidth > 600
                ? 2
                : 1;

        return GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            childAspectRatio: 1.5,
          ),
          itemCount: _cardDataList.length,
          itemBuilder: (context, index) {
            final cardData = _cardDataList[index];
            final isActive = _activeCardId == cardData.id;

            return AnimatedScaleCard(
              cardData: cardData,
              isActive: isActive,
              onTap: () => _toggleCard(cardData.id),
            );
          },
        );
      },
    );
  }

  /// 💡 Info Card at bottom
  Widget _buildInfoCard() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🎯 Flutter Implementation Features',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 16),
          _buildFeatureSection('✨ Animation Details', [
            'Smooth scale transition with custom curves',
            'Fade-in detail text with staggered delay',
            'Icon rotation and scale on tap',
            'Ripple effect overlay animation',
            'Glow shadow effect on active state',
          ], Colors.purple[600]!),
          SizedBox(height: 16),
          _buildFeatureSection('🎨 Design Elements', [
            'Gradient backgrounds with custom colors',
            'Glassmorphism icon containers',
            'Decorative background circles',
            'Active state indicators',
            'Responsive grid layout',
          ], Colors.pink[600]!),
        ],
      ),
    );
  }

  Widget _buildFeatureSection(
    String title,
    List<String> features,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        SizedBox(height: 8),
        ...features.map(
          (feature) => Padding(
            padding: EdgeInsets.only(bottom: 4),
            child: Text(
              '• $feature',
              style: TextStyle(fontSize: 13, color: Colors.grey[700]),
            ),
          ),
        ),
      ],
    );
  }
}

/// 🎴 Animated Scale Card Widget (Reusable)
class AnimatedScaleCard extends StatefulWidget {
  final CardData cardData;
  final bool isActive;
  final VoidCallback onTap;

  const AnimatedScaleCard({
    super.key,
    required this.cardData,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<AnimatedScaleCard> createState() => _AnimatedScaleCardState();
}

class _AnimatedScaleCardState extends State<AnimatedScaleCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _detailOpacityAnimation;
  late Animation<double> _detailSlideAnimation;
  late Animation<double> _rippleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    // Custom curve for elastic effect
    final elasticCurve = Curves.easeOutBack;

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _controller, curve: elasticCurve));

    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.087).animate(
      // 0.087 radians ≈ 5 degrees
      CurvedAnimation(parent: _controller, curve: elasticCurve),
    );

    _detailOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    _detailSlideAnimation = Tween<double>(begin: -10.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.3, 1.0, curve: elasticCurve),
      ),
    );

    _rippleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void didUpdateWidget(AnimatedScaleCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Stack(
              children: [
                // Glow effect (background)
                if (widget.isActive)
                  Positioned.fill(
                    child: Container(
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: widget.cardData.gradientColors,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: widget.cardData.gradientColors[0]
                                .withOpacity(0.6),
                            blurRadius: 40,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                    ),
                  ),

                // Main Card
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: widget.cardData.gradientColors,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Background decorations
                      _buildBackgroundDecorations(),

                      // Ripple overlay
                      if (widget.isActive) _buildRippleOverlay(),

                      // Content
                      Padding(
                        padding: EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Icon
                            _buildIcon(),
                            Spacer(),

                            // Title & Subtitle
                            _buildTitleSection(),

                            // Detail section (animated)
                            _buildDetailSection(),
                          ],
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
    );
  }

  /// 🎨 Background decorative circles
  Widget _buildBackgroundDecorations() {
    return Stack(
      children: [
        Positioned(
          top: -50,
          right: -50,
          child: Container(
            width: 128,
            height: 128,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.1),
            ),
          ),
        ),
        Positioned(
          bottom: -40,
          left: -40,
          child: Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.1),
            ),
          ),
        ),
      ],
    );
  }

  /// ✨ Ripple overlay effect
  Widget _buildRippleOverlay() {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _rippleAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _rippleAnimation.value,
            child: Transform.scale(
              scale: _rippleAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.0,
                    colors: [Colors.white.withOpacity(0.2), Colors.transparent],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// 🎭 Icon with rotation and scale
  Widget _buildIcon() {
    return Transform.rotate(
      angle: _rotationAnimation.value,
      child: Transform.scale(
        scale: 1.0 + (_scaleAnimation.value - 1.0) * 1.2,
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Icon(widget.cardData.icon, size: 32, color: Colors.grey[800]),
        ),
      ),
    );
  }

  /// 📝 Title and subtitle section
  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.cardData.title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.3),
                offset: Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
        ),
        SizedBox(height: 4),
        Text(
          widget.cardData.subtitle,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
      ],
    );
  }

  /// 📋 Detail section with fade-in animation
  Widget _buildDetailSection() {
    return AnimatedBuilder(
      animation: _detailOpacityAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _detailOpacityAnimation.value,
          child: Transform.translate(
            offset: Offset(0, _detailSlideAnimation.value),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.2),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  widget.cardData.detail,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.95),
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    _buildPulsingDot(),
                    SizedBox(width: 8),
                    Text(
                      'ACTIVE',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withOpacity(0.8),
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// ⚪ Pulsing dot indicator
  Widget _buildPulsingDot() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: 0.5 + (value * 0.5),
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        );
      },
      onEnd: () {
        if (mounted) setState(() {});
      },
    );
  }
}

/// 📊 Card Data Model
class CardData {
  final int id;
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> gradientColors;
  final String detail;

  CardData({
    required this.id,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradientColors,
    required this.detail,
  });
}
