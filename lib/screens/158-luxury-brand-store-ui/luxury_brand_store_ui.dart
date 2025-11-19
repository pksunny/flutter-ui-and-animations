import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Main Screen - Luxury Store Product View
/// Showcases premium product with sophisticated animations
class LuxuryStoreScreen extends StatefulWidget {
  const LuxuryStoreScreen({Key? key}) : super(key: key);

  @override
  State<LuxuryStoreScreen> createState() => _LuxuryStoreScreenState();
}

class _LuxuryStoreScreenState extends State<LuxuryStoreScreen>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _fadeController;
  late AnimationController _buttonController;
  late AnimationController _shimmerController;

  double _scrollOffset = 0.0;
  bool _isAddedToBag = false;

  @override
  void initState() {
    super.initState();

    // Scroll controller for parallax effect
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          _scrollOffset = _scrollController.offset;
        });
      });

    // Fade-in animation controller
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..forward();

    // Button animation controller
    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // Shimmer effect controller
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _fadeController.dispose();
    _buttonController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  void _handleAddToBag() {
    setState(() {
      _isAddedToBag = true;
    });
    _buttonController.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          setState(() {
            _isAddedToBag = false;
          });
          _buttonController.reverse();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Parallax Background with Gradient
          _buildParallaxBackground(size),

          // Main Content
          CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Custom App Bar
              _buildSliverAppBar(),

              // Product Content
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    // Hero Product Image
                    _buildHeroImage(size),

                    // Product Details
                    _buildProductDetails(),

                    // Features Grid
                    _buildFeaturesGrid(),

                    // Specifications
                    _buildSpecifications(),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),

          // Floating Add to Bag Button
          _buildFloatingButton(size),
        ],
      ),
    );
  }

  /// Parallax animated background with luxury gradient
  Widget _buildParallaxBackground(Size size) {
    final parallaxOffset = _scrollOffset * 0.5;

    return Positioned(
      top: -parallaxOffset,
      left: 0,
      right: 0,
      height: size.height * 0.6,
      child: AnimatedBuilder(
        animation: _shimmerController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFFFFBF5),
                  const Color(0xFFFFF8E8),
                  const Color(0xFFFFF5DC).withOpacity(0.8),
                ],
                stops: [
                  0.0,
                  _shimmerController.value,
                  1.0,
                ],
              ),
            ),
            child: CustomPaint(
              painter: LuxuryPatternPainter(
                animation: _shimmerController.value,
              ),
            ),
          );
        },
      ),
    );
  }

  /// Elegant app bar with fade effect
  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 0,
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.white.withOpacity(
        (_scrollOffset / 100).clamp(0.0, 0.98),
      ),
      leading: FadeTransition(
        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _fadeController,
            curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
          ),
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () {},
        ),
      ),
      actions: [
        FadeTransition(
          opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: _fadeController,
              curve: const Interval(0.1, 0.4, curve: Curves.easeOut),
            ),
          ),
          child: IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.black87),
            onPressed: () {},
          ),
        ),
        FadeTransition(
          opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: _fadeController,
              curve: const Interval(0.2, 0.5, curve: Curves.easeOut),
            ),
          ),
          child: IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.black87),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  /// Hero product image with scale animation
  Widget _buildHeroImage(Size size) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _fadeController,
          curve: const Interval(0.2, 0.6, curve: Curves.easeOut),
        ),
      ),
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.8, end: 1.0).animate(
          CurvedAnimation(
            parent: _fadeController,
            curve: const Interval(0.2, 0.6, curve: Curves.easeOutCubic),
          ),
        ),
        child: Container(
          height: size.height * 0.45,
          margin: const EdgeInsets.symmetric(horizontal: 24),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Gold accent circle
              Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFD4AF37).withOpacity(0.1),
                      const Color(0xFFFFD700).withOpacity(0.05),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              // Product placeholder (replace with actual image)
              Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  size: 100,
                  color: Color(0xFFD4AF37),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Product name, price, and description with staggered fade
  Widget _buildProductDetails() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Brand name
          FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: _fadeController,
                curve: const Interval(0.3, 0.6, curve: Curves.easeOut),
              ),
            ),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.3),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: _fadeController,
                  curve: const Interval(0.3, 0.6, curve: Curves.easeOut),
                ),
              ),
              child: Text(
                'MAISON DE LUXE',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                  color: const Color(0xFFD4AF37),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Product name
          FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: _fadeController,
                curve: const Interval(0.4, 0.7, curve: Curves.easeOut),
              ),
            ),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.3),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: _fadeController,
                  curve: const Interval(0.4, 0.7, curve: Curves.easeOut),
                ),
              ),
              child: const Text(
                'Heritage Collection\nSignature Tote',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w300,
                  height: 1.2,
                  color: Colors.black87,
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Price with shimmer effect
          FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: _fadeController,
                curve: const Interval(0.5, 0.8, curve: Curves.easeOut),
              ),
            ),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.3),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: _fadeController,
                  curve: const Interval(0.5, 0.8, curve: Curves.easeOut),
                ),
              ),
              child: ShaderMask(
                shaderCallback: (bounds) {
                  return const LinearGradient(
                    colors: [
                      Color(0xFFD4AF37),
                      Color(0xFFFFD700),
                      Color(0xFFD4AF37),
                    ],
                  ).createShader(bounds);
                },
                child: const Text(
                  '\$2,450',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: -1,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Description
          FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: _fadeController,
                curve: const Interval(0.6, 0.9, curve: Curves.easeOut),
              ),
            ),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.3),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: _fadeController,
                  curve: const Interval(0.6, 0.9, curve: Curves.easeOut),
                ),
              ),
              child: Text(
                'Meticulously crafted from the finest Italian leather, this timeless piece embodies sophistication and elegance. Each bag is handmade by master artisans using techniques passed down through generations.',
                style: TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Features grid with animated cards
  Widget _buildFeaturesGrid() {
    final features = [
      _FeatureData(Icons.verified_outlined, 'Authentic', 'Certified genuine'),
      _FeatureData(Icons.local_shipping_outlined, 'Free Shipping', 'Worldwide'),
      _FeatureData(Icons.workspace_premium_outlined, 'Warranty', '5 years'),
      _FeatureData(Icons.card_giftcard_outlined, 'Gift Ready', 'Luxury box'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.5,
        ),
        itemCount: features.length,
        itemBuilder: (context, index) {
          return FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: _fadeController,
                curve: Interval(
                  0.7 + (index * 0.05),
                  0.95,
                  curve: Curves.easeOut,
                ),
              ),
            ),
            child: _LuxuryFeatureCard(feature: features[index]),
          );
        },
      ),
    );
  }

  /// Specifications section
  Widget _buildSpecifications() {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _fadeController,
          curve: const Interval(0.8, 1.0, curve: Curves.easeOut),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Specifications',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            _SpecRow(label: 'Material', value: 'Italian Calfskin Leather'),
            _SpecRow(label: 'Dimensions', value: '35 × 28 × 15 cm'),
            _SpecRow(label: 'Weight', value: '850g'),
            _SpecRow(label: 'Color', value: 'Midnight Black'),
            _SpecRow(label: 'Hardware', value: '24K Gold Plated'),
          ],
        ),
      ),
    );
  }

  /// Floating "Add to Bag" button with animation
  Widget _buildFloatingButton(Size size) {
    return Positioned(
      left: 24,
      right: 24,
      bottom: 24,
      child: FadeTransition(
        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _fadeController,
            curve: const Interval(0.85, 1.0, curve: Curves.easeOut),
          ),
        ),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: _fadeController,
              curve: const Interval(0.85, 1.0, curve: Curves.easeOutCubic),
            ),
          ),
          child: AnimatedBuilder(
            animation: _buttonController,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.0 - (_buttonController.value * 0.05),
                child: Container(
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _isAddedToBag
                          ? [
                              const Color(0xFF2E7D32),
                              const Color(0xFF43A047),
                            ]
                          : [
                              const Color(0xFF1A1A1A),
                              const Color(0xFF2D2D2D),
                            ],
                    ),
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: (_isAddedToBag
                                ? const Color(0xFF2E7D32)
                                : const Color(0xFF1A1A1A))
                            .withOpacity(0.4),
                        blurRadius: 24,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(32),
                      onTap: _isAddedToBag ? null : _handleAddToBag,
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: _isAddedToBag
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  key: const ValueKey('added'),
                                  children: const [
                                    Icon(
                                      Icons.check_circle_outline,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      'Added to Bag',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  key: const ValueKey('add'),
                                  children: [
                                    ShaderMask(
                                      shaderCallback: (bounds) {
                                        return const LinearGradient(
                                          colors: [
                                            Color(0xFFD4AF37),
                                            Color(0xFFFFD700),
                                          ],
                                        ).createShader(bounds);
                                      },
                                      child: const Icon(
                                        Icons.shopping_bag_outlined,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    const Text(
                                      'Add to Bag',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Custom painter for luxury background pattern
class LuxuryPatternPainter extends CustomPainter {
  final double animation;

  LuxuryPatternPainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD4AF37).withOpacity(0.03)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw elegant diagonal lines
    for (var i = 0; i < 20; i++) {
      final offset = (animation * size.width) + (i * 60);
      canvas.drawLine(
        Offset(offset - size.width, 0),
        Offset(offset, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(LuxuryPatternPainter oldDelegate) =>
      oldDelegate.animation != animation;
}

/// Feature card widget with hover effect
class _LuxuryFeatureCard extends StatefulWidget {
  final _FeatureData feature;

  const _LuxuryFeatureCard({required this.feature});

  @override
  State<_LuxuryFeatureCard> createState() => _LuxuryFeatureCardState();
}

class _LuxuryFeatureCardState extends State<_LuxuryFeatureCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: _isHovered ? const Color(0xFFFFFBF5) : Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered
                ? const Color(0xFFD4AF37).withOpacity(0.3)
                : Colors.grey.withOpacity(0.1),
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              widget.feature.icon,
              color: const Color(0xFFD4AF37),
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              widget.feature.title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            Text(
              widget.feature.subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Specification row widget
class _SpecRow extends StatelessWidget {
  final String label;
  final String value;

  const _SpecRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[600],
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Data class for features
class _FeatureData {
  final IconData icon;
  final String title;
  final String subtitle;

  _FeatureData(this.icon, this.title, this.subtitle);
}