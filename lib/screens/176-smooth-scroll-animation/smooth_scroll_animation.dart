import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Demo page showcasing different scroll animation styles
class SmoothScrollDemo extends StatefulWidget {
  const SmoothScrollDemo({Key? key}) : super(key: key);

  @override
  State<SmoothScrollDemo> createState() => _SmoothScrollDemoState();
}

class _SmoothScrollDemoState extends State<SmoothScrollDemo> {
  int _selectedStyle = 0;

  final List<Map<String, dynamic>> _demoItems = [
    {
      'title': 'Magical Mountains',
      'subtitle': 'Explore breathtaking peaks',
      'color': const Color(0xFF6B46C1),
      'icon': Icons.landscape,
    },
    {
      'title': 'Ocean Dreams',
      'subtitle': 'Dive into crystal waters',
      'color': const Color(0xFF2563EB),
      'icon': Icons.water,
    },
    {
      'title': 'Urban Vibes',
      'subtitle': 'Discover city lights',
      'color': const Color(0xFFEC4899),
      'icon': Icons.location_city,
    },
    {
      'title': 'Forest Escape',
      'subtitle': 'Find peace in nature',
      'color': const Color(0xFF10B981),
      'icon': Icons.forest,
    },
    {
      'title': 'Desert Wonders',
      'subtitle': 'Experience endless sands',
      'color': const Color(0xFFF59E0B),
      'icon': Icons.wb_sunny,
    },
    {
      'title': 'Arctic Adventure',
      'subtitle': 'Journey to the ice',
      'color': const Color(0xFF06B6D4),
      'icon': Icons.ac_unit,
    },
    {
      'title': 'Tropical Paradise',
      'subtitle': 'Relax on sandy beaches',
      'color': const Color(0xFFFB923C),
      'icon': Icons.beach_access,
    },
    {
      'title': 'Starry Nights',
      'subtitle': 'Gaze at the cosmos',
      'color': const Color(0xFF8B5CF6),
      'icon': Icons.nights_stay,
    },
    {
      'title': 'Golden Harvest',
      'subtitle': 'Walk through wheat fields',
      'color': const Color(0xFFEAB308),
      'icon': Icons.grass,
    },
    {
      'title': 'Volcanic Peak',
      'subtitle': 'Feel the earth\'s heat',
      'color': const Color(0xFFEF4444),
      'icon': Icons.volcano,
    },
    {
      'title': 'Mystic Canyon',
      'subtitle': 'Wander deep ravines',
      'color': const Color(0xFF92400E),
      'icon': Icons.terrain,
    },
    {
      'title': 'Midnight Jazz',
      'subtitle': 'Enjoy the city rhythm',
      'color': const Color(0xFF1E293B),
      'icon': Icons.music_note,
    },
    {
      'title': 'Cherry Blossom',
      'subtitle': 'Spring is in the air',
      'color': const Color(0xFFF472B6),
      'icon': Icons.filter_vintage,
    },
    {
      'title': 'Cyber Streets',
      'subtitle': 'Neon-lit future paths',
      'color': const Color(0xFFD946EF),
      'icon': Icons.bolt,
    },
    {
      'title': 'Ancient Ruins',
      'subtitle': 'Uncover hidden history',
      'color': const Color(0xFF78350F),
      'icon': Icons.account_balance,
    },
    {
      'title': 'Deep Space',
      'subtitle': 'Beyond the final frontier',
      'color': const Color(0xFF4338CA),
      'icon': Icons.rocket_launch,
    },
  ];

  final List<String> _styleNames = [
    'Scale & Fade',
    'Rotation',
    'Slide',
    'Parallax',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildStyleSelector(),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(
                      scale: Tween<double>(
                        begin: 0.95,
                        end: 1.0,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: _buildScrollList(key: ValueKey(_selectedStyle)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Beautiful header with gradient
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade400, Colors.purple.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.animation,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Smooth Scroll',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Magical animations',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Style selector chips
  Widget _buildStyleSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _styleNames.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedStyle == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedStyle = index;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                gradient:
                    isSelected
                        ? LinearGradient(
                          colors: [
                            Colors.blue.shade400,
                            Colors.purple.shade400,
                          ],
                        )
                        : null,
                color: isSelected ? null : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(25),
                boxShadow:
                    isSelected
                        ? [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                        : [],
              ),
              child: Center(
                child: Text(
                  _styleNames[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey.shade700,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Build the scrollable list with animations
  Widget _buildScrollList({Key? key}) {
    return SmoothScrollAnimatedList(
      key: key,
      itemCount: _demoItems.length,
      animationStyle: ScrollAnimationStyle.values[_selectedStyle],
      itemBuilder: (context, index, animation) {
        final item = _demoItems[index];
        return _buildListItem(
          title: item['title'],
          subtitle: item['subtitle'],
          color: item['color'],
          icon: item['icon'],
          animation: animation,
        );
      },
    );
  }

  /// Beautiful list item design
  Widget _buildListItem({
    required String title,
    required String subtitle,
    required Color color,
    required IconData icon,
    required double animation,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2 * animation),
            blurRadius: 20 * animation,
            offset: Offset(0, 10 * animation),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.1), Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color.withOpacity(0.7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, color: color, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Animation styles enum
enum ScrollAnimationStyle { scaleFade, rotation, slide, parallax }

/// Main reusable widget for smooth scroll animations
class SmoothScrollAnimatedList extends StatefulWidget {
  /// Number of items in the list
  final int itemCount;

  /// Builder function for each item
  final Widget Function(BuildContext context, int index, double animation)
  itemBuilder;

  /// Animation style to apply
  final ScrollAnimationStyle animationStyle;

  /// Animation duration
  final Duration animationDuration;

  /// Scroll physics
  final ScrollPhysics? physics;

  /// Padding around the list
  final EdgeInsetsGeometry? padding;

  const SmoothScrollAnimatedList({
    Key? key,
    required this.itemCount,
    required this.itemBuilder,
    this.animationStyle = ScrollAnimationStyle.scaleFade,
    this.animationDuration = const Duration(milliseconds: 600),
    this.physics,
    this.padding,
  }) : super(key: key);

  @override
  State<SmoothScrollAnimatedList> createState() =>
      _SmoothScrollAnimatedListState();
}

class _SmoothScrollAnimatedListState extends State<SmoothScrollAnimatedList> {
  late ScrollController _scrollController;
  final Map<int, double> _itemAnimations = {};

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_updateAnimations);

    // Initialize animations
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateAnimations();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Update animation values based on scroll position
  void _updateAnimations() {
    if (!mounted) return;

    final viewportHeight = _scrollController.position.viewportDimension;
    final scrollOffset = _scrollController.offset;

    setState(() {
      for (int i = 0; i < widget.itemCount; i++) {
        // Estimate item position (assuming ~100px per item)
        final itemOffset = i * 100.0;
        final itemPosition = itemOffset - scrollOffset;

        // Calculate visibility (0.0 to 1.0)
        double visibility = 0.0;

        if (itemPosition < -100) {
          // Item is above viewport
          visibility = 0.0;
        } else if (itemPosition > viewportHeight) {
          // Item is below viewport
          visibility = 0.0;
        } else {
          // Item is in viewport
          final centerOffset = (viewportHeight / 2) - itemPosition;
          visibility = (1.0 - (centerOffset.abs() / (viewportHeight / 2)))
              .clamp(0.0, 1.0);
        }

        _itemAnimations[i] = visibility;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      physics: widget.physics ?? const BouncingScrollPhysics(),
      padding: widget.padding ?? const EdgeInsets.symmetric(vertical: 16),
      itemCount: widget.itemCount,
      itemBuilder: (context, index) {
        final animation = _itemAnimations[index] ?? 0.0;
        return _buildAnimatedItem(index, animation);
      },
    );
  }

  /// Build animated item based on style
  Widget _buildAnimatedItem(int index, double animation) {
    final child = widget.itemBuilder(context, index, animation);

    switch (widget.animationStyle) {
      case ScrollAnimationStyle.scaleFade:
        return _buildScaleFadeAnimation(child, animation);
      case ScrollAnimationStyle.rotation:
        return _buildRotationAnimation(child, animation);
      case ScrollAnimationStyle.slide:
        return _buildSlideAnimation(child, animation);
      case ScrollAnimationStyle.parallax:
        return _buildParallaxAnimation(child, animation, index);
    }
  }

  /// Scale and fade animation
  Widget _buildScaleFadeAnimation(Widget child, double animation) {
    final scale = 0.8 + (animation * 0.2);
    return Transform.scale(
      scale: scale,
      child: Opacity(opacity: animation, child: child),
    );
  }

  /// Rotation animation
  Widget _buildRotationAnimation(Widget child, double animation) {
    final rotation = (1 - animation) * 0.1;
    return Transform(
      transform:
          Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(rotation),
      alignment: Alignment.center,
      child: Opacity(opacity: animation, child: child),
    );
  }

  /// Slide animation
  Widget _buildSlideAnimation(Widget child, double animation) {
    final offset = (1 - animation) * 100;
    return Transform.translate(
      offset: Offset(offset, 0),
      child: Opacity(opacity: animation, child: child),
    );
  }

  /// Parallax animation
  Widget _buildParallaxAnimation(Widget child, double animation, int index) {
    final offset = (1 - animation) * 50 * (index.isEven ? 1 : -1);
    final scale = 0.9 + (animation * 0.1);
    return Transform.translate(
      offset: Offset(offset, 0),
      child: Transform.scale(
        scale: scale,
        child: Opacity(opacity: animation, child: child),
      ),
    );
  }
}
