import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Demo page showcasing the ambient page transition
class AmbientTransitionDemo extends StatelessWidget {
  const AmbientTransitionDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AmbientPageView(
      pages: [
        _buildPage(
          color: const Color(0xFFF8F9FA),
          accentColor: const Color(0xFF6366F1),
          icon: Icons.home_rounded,
          title: 'Welcome Home',
          subtitle: 'Your personal sanctuary',
          description: 'Experience the magic of ambient transitions',
        ),
        _buildPage(
          color: const Color(0xFFFFFBEB),
          accentColor: const Color(0xFFF59E0B),
          icon: Icons.explore_rounded,
          title: 'Explore More',
          subtitle: 'Discover new horizons',
          description: 'Navigate through content seamlessly',
        ),
        _buildPage(
          color: const Color(0xFFF0FDF4),
          accentColor: const Color(0xFF10B981),
          icon: Icons.favorite_rounded,
          title: 'Your Favorites',
          subtitle: 'Curated just for you',
          description: 'Only shadow direction changes',
        ),
        _buildPage(
          color: const Color(0xFFFCE7F3),
          accentColor: const Color(0xFFEC4899),
          icon: Icons.settings_rounded,
          title: 'Settings',
          subtitle: 'Customize your experience',
          description: 'Feel the magical shadow transitions',
        ),
      ],
    );
  }

  Widget _buildPage({
    required Color color,
    required Color accentColor,
    required IconData icon,
    required String title,
    required String subtitle,
    required String description,
  }) {
    return Container(
      color: color,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Floating icon card
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withOpacity(0.2),
                      blurRadius: 40,
                      offset: const Offset(0, 20),
                    ),
                  ],
                ),
                child: Icon(icon, size: 60, color: accentColor),
              ),
              const SizedBox(height: 48),

              // Title
              Text(
                title,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: accentColor,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Subtitle
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                  letterSpacing: 0.3,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Description
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Main Ambient Page View Widget
///
/// This widget creates magical page transitions where only shadow direction changes
/// giving the illusion of movement without visible animation
class AmbientPageView extends StatefulWidget {
  /// List of pages to display
  final List<Widget> pages;

  /// Duration of the shadow transition
  final Duration transitionDuration;

  /// Maximum shadow offset
  final double maxShadowOffset;

  /// Shadow blur radius
  final double shadowBlur;

  /// Shadow opacity
  final double shadowOpacity;

  /// Enable swipe gestures
  final bool enableSwipe;

  const AmbientPageView({
    Key? key,
    required this.pages,
    this.transitionDuration = const Duration(milliseconds: 600),
    this.maxShadowOffset = 30.0,
    this.shadowBlur = 40.0,
    this.shadowOpacity = 0.15,
    this.enableSwipe = true,
  }) : super(key: key);

  @override
  State<AmbientPageView> createState() => _AmbientPageViewState();
}

class _AmbientPageViewState extends State<AmbientPageView>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _shadowController;

  int _currentPage = 0;
  double _dragProgress = 0.0;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _shadowController = AnimationController(
      vsync: this,
      duration: widget.transitionDuration,
    );

    // Add listener to PageController for smooth shadow transitions
    _pageController.addListener(() {
      if (_pageController.page != null) {
        setState(() {
          _dragProgress = _pageController.page!;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _shadowController.dispose();
    super.dispose();
  }

  /// Calculate shadow offset based on page position
  /// This creates the magical effect where only shadow direction changes
  Offset _calculateShadowOffset() {
    // Get current page position (including fractional part during scroll)
    final currentPosition = _dragProgress;

    // Calculate angle based on page position (360 degrees rotation)
    final angle = (currentPosition / widget.pages.length) * 2 * math.pi;

    // Calculate shadow offset using trigonometry
    final x = math.sin(angle) * widget.maxShadowOffset;
    final y = math.cos(angle) * widget.maxShadowOffset;

    return Offset(x, y);
  }

  /// Handle page change completion
  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
      _isDragging = false;
    });

    // Subtle animation for shadow intensity
    _shadowController.forward(from: 0.0).then((_) {
      _shadowController.reverse();
    });
  }

  /// Navigate to specific page programmatically
  void _navigateToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: widget.transitionDuration,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main page view with ambient shadow effect
          AnimatedBuilder(
            animation: _shadowController,
            builder: (context, child) {
              final shadowOffset = _calculateShadowOffset();

              // Calculate shadow intensity based on animation
              final shadowIntensity = 1.0 + (_shadowController.value * 0.3);

              return Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    // Primary ambient shadow
                    BoxShadow(
                      color: Colors.black.withOpacity(
                        widget.shadowOpacity * shadowIntensity,
                      ),
                      blurRadius: widget.shadowBlur * shadowIntensity,
                      offset: shadowOffset,
                      spreadRadius: 2,
                    ),
                    // Secondary softer shadow for depth
                    BoxShadow(
                      color: Colors.black.withOpacity(
                        widget.shadowOpacity * 0.5 * shadowIntensity,
                      ),
                      blurRadius: widget.shadowBlur * 2,
                      offset: shadowOffset * 0.5,
                    ),
                  ],
                ),
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  physics:
                      widget.enableSwipe
                          ? const BouncingScrollPhysics()
                          : const NeverScrollableScrollPhysics(),
                  itemCount: widget.pages.length,
                  itemBuilder: (context, index) {
                    return widget.pages[index];
                  },
                ),
              );
            },
          ),

          // Page indicators at bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 40,
            child: _buildPageIndicators(),
          ),

          // Navigation dots with tap interaction
          Positioned(
            left: 0,
            right: 0,
            bottom: 100,
            child: _buildNavigationDots(),
          ),
        ],
      ),
    );
  }

  /// Build animated page indicators
  Widget _buildPageIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.pages.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == index ? 32 : 8,
          height: 8,
          decoration: BoxDecoration(
            color:
                _currentPage == index
                    ? Colors.black.withOpacity(0.8)
                    : Colors.black.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  /// Build interactive navigation dots
  Widget _buildNavigationDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.pages.length,
        (index) => GestureDetector(
          onTap: () => _navigateToPage(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutCubic,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color:
                  _currentPage == index
                      ? Colors.white
                      : Colors.white.withOpacity(0.5),
              shape: BoxShape.circle,
              boxShadow:
                  _currentPage == index
                      ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ]
                      : [],
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color:
                      _currentPage == index
                          ? Colors.black
                          : Colors.black.withOpacity(0.4),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom Ambient Page Widget
///
/// Use this widget to create custom pages with specific styling
/// Perfect for building reusable page templates
class AmbientPage extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;
  final bool safeArea;

  const AmbientPage({
    Key? key,
    required this.child,
    this.backgroundColor = Colors.white,
    this.padding = const EdgeInsets.all(24.0),
    this.safeArea = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget content = Padding(padding: padding, child: child);

    if (safeArea) {
      content = SafeArea(child: content);
    }

    return Container(color: backgroundColor, child: content);
  }
}

/// Reusable Card Widget with Ambient Styling
class AmbientCard extends StatelessWidget {
  final Widget child;
  final Color color;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final VoidCallback? onTap;

  const AmbientCard({
    Key? key,
    required this.child,
    this.color = Colors.white,
    this.padding = const EdgeInsets.all(24.0),
    this.borderRadius = 24.0,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
