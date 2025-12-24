import 'package:flutter/material.dart';

class SoftCardTap extends StatelessWidget {
  const SoftCardTap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Explore Destinations',
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, color: Color(0xFF1A1A1A)),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.filter_list, color: Color(0xFF1A1A1A)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Animated Cards Grid
          SoftCardGrid(cards: _getDemoCards()),
        ],
      ),
    );
  }

  List<CardData> _getDemoCards() {
    return [
      CardData(
        title: 'Mountain Paradise',
        subtitle: 'Explore the majestic peaks',
        gradientColors: [Color(0xFF4A90E2), Color(0xFF50E3C2)],
        icon: Icons.landscape,
        likes: '2.4k',
        comments: '856',
        imageUrl: '🏔️',
      ),
      CardData(
        title: 'Ocean Waves',
        subtitle: 'Dive into serenity',
        gradientColors: [Color(0xFF7B68EE), Color(0xFFFF69B4)],
        icon: Icons.water,
        likes: '3.1k',
        comments: '1.2k',
        imageUrl: '🌊',
      ),
      CardData(
        title: 'Desert Dreams',
        subtitle: 'Golden sand adventures',
        gradientColors: [Color(0xFFFF6B6B), Color(0xFFFFD93D)],
        icon: Icons.wb_sunny,
        likes: '1.8k',
        comments: '542',
        imageUrl: '🏜️',
      ),
      CardData(
        title: 'Forest Whispers',
        subtitle: 'Nature\'s hidden gems',
        gradientColors: [Color(0xFF2ECC71), Color(0xFF27AE60)],
        icon: Icons.park,
        likes: '2.9k',
        comments: '967',
        imageUrl: '🌲',
      ),
      CardData(
        title: 'City Lights',
        subtitle: 'Urban exploration',
        gradientColors: [Color(0xFF9B59B6), Color(0xFF3498DB)],
        icon: Icons.location_city,
        likes: '4.2k',
        comments: '1.5k',
        imageUrl: '🌆',
      ),
      CardData(
        title: 'Northern Lights',
        subtitle: 'Aurora borealis magic',
        gradientColors: [Color(0xFF1ABC9C), Color(0xFF16A085)],
        icon: Icons.stars,
        likes: '5.6k',
        comments: '2.1k',
        imageUrl: '✨',
      ),
    ];
  }
}

/// Card Data Model
class CardData {
  final String title;
  final String subtitle;
  final List<Color> gradientColors;
  final IconData icon;
  final String likes;
  final String comments;
  final String imageUrl;

  CardData({
    required this.title,
    required this.subtitle,
    required this.gradientColors,
    required this.icon,
    required this.likes,
    required this.comments,
    required this.imageUrl,
  });
}

/// Soft Card Grid Widget - Displays cards in a responsive grid
class SoftCardGrid extends StatelessWidget {
  final List<CardData> cards;
  final int crossAxisCount;
  final double spacing;

  const SoftCardGrid({
    Key? key,
    required this.cards,
    this.crossAxisCount = 2,
    this.spacing = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: 0.65,
      ),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        return SoftHoverCard(
          cardData: cards[index],
          delay: Duration(milliseconds: index * 100),
        );
      },
    );
  }
}

/// Soft Hover Card - Individual card with hover animation
class SoftHoverCard extends StatefulWidget {
  final CardData cardData;
  final Duration delay;
  final Duration animationDuration;
  final double hoverElevation;
  final double normalElevation;
  final double hoverScale;

  const SoftHoverCard({
    Key? key,
    required this.cardData,
    this.delay = Duration.zero,
    this.animationDuration = const Duration(milliseconds: 300),
    this.hoverElevation = 24,
    this.normalElevation = 4,
    this.hoverScale = 1.02,
  }) : super(key: key);

  @override
  State<SoftHoverCard> createState() => _SoftHoverCardState();
}

class _SoftHoverCardState extends State<SoftHoverCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _isVisible = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    // Scale animation (card grows slightly on hover)
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.hoverScale,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    // Elevation animation (shadow expands on hover)
    _elevationAnimation = Tween<double>(
      begin: widget.normalElevation,
      end: widget.hoverElevation,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    // Fade animation for entrance
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // Delayed entrance animation
    Future.delayed(widget.delay, () {
      if (mounted) {
        setState(() => _isVisible = true);
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isHovered = true);
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() => _isHovered = false);
        _controller.reverse();
      }
    });
  }

  void _handleTapCancel() {
    setState(() => _isHovered = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 600),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: GestureDetector(
              onTapDown: _handleTapDown,
              onTapUp: _handleTapUp,
              onTapCancel: _handleTapCancel,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: widget.cardData.gradientColors[0].withOpacity(0.3),
                      blurRadius: _elevationAnimation.value,
                      spreadRadius: _elevationAnimation.value / 4,
                      offset: Offset(0, _elevationAnimation.value / 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: widget.cardData.gradientColors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Background pattern
                        Positioned.fill(
                          child: CustomPaint(
                            painter: CirclePatternPainter(
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                        ),

                        // Card content
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Top row with icon and bookmark
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Icon with animated background
                                  AnimatedContainer(
                                    duration: widget.animationDuration,
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color:
                                          _isHovered
                                              ? Colors.white.withOpacity(0.3)
                                              : Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Icon(
                                      widget.cardData.icon,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                  ),

                                  // Bookmark button with animation
                                  AnimatedRotation(
                                    duration: widget.animationDuration,
                                    turns: _isHovered ? 0.05 : 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        Icons.bookmark_border,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const Spacer(),

                              // Emoji/Image representation
                              Text(
                                widget.cardData.imageUrl,
                                style: const TextStyle(fontSize: 48),
                              ),

                              const SizedBox(height: 12),

                              // Title with animation
                              AnimatedDefaultTextStyle(
                                duration: widget.animationDuration,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: _isHovered ? 20 : 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                                child: Text(widget.cardData.title),
                              ),

                              const SizedBox(height: 4),

                              // Subtitle
                              Text(
                                widget.cardData.subtitle,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Stats row with animated opacity
                              AnimatedOpacity(
                                duration: widget.animationDuration,
                                opacity: _isHovered ? 1.0 : 0.8,
                                child: Row(
                                  children: [
                                    _buildStat(
                                      Icons.favorite_border,
                                      widget.cardData.likes,
                                    ),
                                    const SizedBox(width: 16),
                                    _buildStat(
                                      Icons.chat_bubble_outline,
                                      widget.cardData.comments,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Hover overlay effect
                        if (_isHovered)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.1),
                                    Colors.transparent,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
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
          );
        },
      ),
    );
  }

  Widget _buildStat(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 16),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

/// Custom painter for decorative circle pattern
class CirclePatternPainter extends CustomPainter {
  final Color color;

  CirclePatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    // Draw decorative circles
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.2), 40, paint);

    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.8), 30, paint);

    canvas.drawCircle(Offset(size.width * 0.9, size.height * 0.7), 25, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}