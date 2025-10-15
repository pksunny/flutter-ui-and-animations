import 'package:flutter/material.dart';

/// Demo screen showcasing the AnimatedTabView widget
class TabSwitchAnimation extends StatelessWidget {
  const TabSwitchAnimation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF667eea), Color(0xFF764ba2), Color(0xFFf093fb)],
          ),
        ),
        child: SafeArea(
          child: AnimatedTabView(
            tabs: const [
              TabItem(icon: Icons.home_rounded, label: 'Home'),
              TabItem(icon: Icons.explore_rounded, label: 'Explore'),
              TabItem(icon: Icons.favorite_rounded, label: 'Favorites'),
              TabItem(icon: Icons.person_rounded, label: 'Profile'),
            ],
            tabContents: [
              _buildHomeContent(),
              _buildExploreContent(),
              _buildFavoritesContent(),
              _buildProfileContent(),
            ],
            // Customization options
            tabBarBackgroundColor: Colors.white.withOpacity(0.15),
            selectedTabColor: Colors.white,
            unselectedTabColor: Colors.white.withOpacity(0.5),
            indicatorColor: Colors.white,
            tabBarHeight: 70,
            tabBarMargin: const EdgeInsets.all(20),
            tabBarBorderRadius: 35,
            contentAnimationDuration: const Duration(milliseconds: 600),
            contentAnimationCurve: Curves.easeInOutCubic,
            slideDistance: 100,
          ),
        ),
      ),
    );
  }

  // Demo content builders
  static Widget _buildHomeContent() {
    return _ContentCard(
      title: 'Welcome Home',
      icon: Icons.home_rounded,
      gradient: const LinearGradient(
        colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
      ),
      items: const [
        'Dashboard Overview',
        'Recent Activities',
        'Quick Actions',
        'Analytics Summary',
      ],
    );
  }

  static Widget _buildExploreContent() {
    return _ContentCard(
      title: 'Explore World',
      icon: Icons.explore_rounded,
      gradient: const LinearGradient(
        colors: [Color(0xFF43e97b), Color(0xFF38f9d7)],
      ),
      items: const [
        'Trending Topics',
        'New Discoveries',
        'Popular Content',
        'Recommended for You',
      ],
    );
  }

  static Widget _buildFavoritesContent() {
    return _ContentCard(
      title: 'Your Favorites',
      icon: Icons.favorite_rounded,
      gradient: const LinearGradient(
        colors: [Color(0xFFfa709a), Color(0xFFfee140)],
      ),
      items: const ['Saved Items', 'Liked Content', 'Bookmarks', 'Collections'],
    );
  }

  static Widget _buildProfileContent() {
    return _ContentCard(
      title: 'Your Profile',
      icon: Icons.person_rounded,
      gradient: const LinearGradient(
        colors: [Color(0xFF30cfd0), Color(0xFF330867)],
      ),
      items: const [
        'Account Settings',
        'Preferences',
        'Privacy & Security',
        'Help & Support',
      ],
    );
  }
}

/// Demo content card widget
class _ContentCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Gradient gradient;
  final List<String> items;

  const _ContentCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.gradient,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon and title
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(icon, color: Colors.white, size: 32),
                ),
                const SizedBox(width: 15),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          // Content items
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          gradient: gradient,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          items[index],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2d3436),
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                        color: Colors.grey.shade400,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Data model for tab items
class TabItem {
  final IconData icon;
  final String label;

  const TabItem({required this.icon, required this.label});
}

/// Main AnimatedTabView widget with smooth slide + fade transitions
///
/// This widget creates a beautiful tab-based navigation system with:
/// - Smooth sliding animations when switching tabs
/// - Fade in/out effects for content transitions
/// - Highly customizable appearance
/// - Production-ready and reusable
class AnimatedTabView extends StatefulWidget {
  /// List of tab items to display in the tab bar
  final List<TabItem> tabs;

  /// List of widgets to display for each tab (must match tabs length)
  final List<Widget> tabContents;

  /// Background color of the tab bar
  final Color tabBarBackgroundColor;

  /// Color of the selected tab
  final Color selectedTabColor;

  /// Color of unselected tabs
  final Color unselectedTabColor;

  /// Color of the selection indicator
  final Color indicatorColor;

  /// Height of the tab bar
  final double tabBarHeight;

  /// Margin around the tab bar
  final EdgeInsets tabBarMargin;

  /// Border radius of the tab bar
  final double tabBarBorderRadius;

  /// Duration of content animations
  final Duration contentAnimationDuration;

  /// Curve for content animations
  final Curve contentAnimationCurve;

  /// Distance the content slides during transition (in pixels)
  final double slideDistance;

  /// Initial selected tab index
  final int initialTabIndex;

  /// Callback when tab is changed
  final ValueChanged<int>? onTabChanged;

  const AnimatedTabView({
    Key? key,
    required this.tabs,
    required this.tabContents,
    this.tabBarBackgroundColor = Colors.white,
    this.selectedTabColor = Colors.black,
    this.unselectedTabColor = Colors.grey,
    this.indicatorColor = Colors.blue,
    this.tabBarHeight = 70,
    this.tabBarMargin = const EdgeInsets.all(20),
    this.tabBarBorderRadius = 35,
    this.contentAnimationDuration = const Duration(milliseconds: 500),
    this.contentAnimationCurve = Curves.easeInOutCubic,
    this.slideDistance = 80,
    this.initialTabIndex = 0,
    this.onTabChanged,
  }) : assert(
         tabs.length == tabContents.length,
         'tabs and tabContents must have the same length',
       ),
       assert(tabs.length > 0, 'At least one tab is required'),
       assert(
         initialTabIndex >= 0 && initialTabIndex < tabs.length,
         'initialTabIndex must be within tabs range',
       ),
       super(key: key);

  @override
  State<AnimatedTabView> createState() => _AnimatedTabViewState();
}

class _AnimatedTabViewState extends State<AnimatedTabView>
    with TickerProviderStateMixin {
  late int _currentIndex;
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  // Direction of the slide animation
  int _slideDirection = 1; // 1 for right, -1 for left

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTabIndex;

    // Initialize slide animation controller
    _slideController = AnimationController(
      vsync: this,
      duration: widget.contentAnimationDuration,
    );

    // Initialize fade animation controller
    _fadeController = AnimationController(
      vsync: this,
      duration: widget.contentAnimationDuration,
    );

    // Setup animations
    _setupAnimations();

    // Start with full opacity and no slide
    _fadeController.value = 1.0;
  }

  /// Setup slide and fade animations
  void _setupAnimations() {
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(_slideDirection * widget.slideDistance / 100, 0),
    ).animate(
      CurvedAnimation(
        parent: _slideController,
        curve: widget.contentAnimationCurve,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: widget.contentAnimationCurve,
      ),
    );
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  /// Handle tab selection with smooth animations
  void _onTabSelected(int index) {
    if (index == _currentIndex) return;

    // Determine slide direction
    _slideDirection = index > _currentIndex ? 1 : -1;

    // Update animations
    _setupAnimations();

    // Animate out current content
    _slideController.forward(from: 0.0);
    _fadeController.forward(from: 0.0);

    // Wait for animation to complete, then switch content
    Future.delayed(widget.contentAnimationDuration ~/ 2, () {
      if (mounted) {
        setState(() {
          _currentIndex = index;
        });

        // Animate in new content
        _slideDirection = -_slideDirection; // Reverse for entry
        _setupAnimations();
        _slideController.reverse(from: 1.0);
        _fadeController.reverse(from: 1.0);

        // Notify callback
        widget.onTabChanged?.call(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Content area with animations
        Expanded(
          child: AnimatedBuilder(
            animation: Listenable.merge([_slideController, _fadeController]),
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(position: _slideAnimation, child: child),
              );
            },
            child: widget.tabContents[_currentIndex],
          ),
        ),

        // Tab bar
        Container(
          margin: widget.tabBarMargin,
          height: widget.tabBarHeight,
          decoration: BoxDecoration(
            color: widget.tabBarBackgroundColor,
            borderRadius: BorderRadius.circular(widget.tabBarBorderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Animated indicator
              _AnimatedIndicator(
                currentIndex: _currentIndex,
                itemCount: widget.tabs.length,
                color: widget.indicatorColor,
                animationDuration: widget.contentAnimationDuration,
                animationCurve: widget.contentAnimationCurve,
              ),

              // Tab buttons
              Row(
                children: List.generate(
                  widget.tabs.length,
                  (index) => _TabButton(
                    tab: widget.tabs[index],
                    isSelected: _currentIndex == index,
                    onTap: () => _onTabSelected(index),
                    selectedColor: widget.selectedTabColor,
                    unselectedColor: widget.unselectedTabColor,
                    animationDuration: widget.contentAnimationDuration,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Animated indicator that slides between tabs
class _AnimatedIndicator extends StatelessWidget {
  final int currentIndex;
  final int itemCount;
  final Color color;
  final Duration animationDuration;
  final Curve animationCurve;

  const _AnimatedIndicator({
    Key? key,
    required this.currentIndex,
    required this.itemCount,
    required this.color,
    required this.animationDuration,
    required this.animationCurve,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedAlign(
      duration: animationDuration,
      curve: animationCurve,
      alignment: Alignment(-1 + (2 * currentIndex / (itemCount - 1)), 0),
      child: FractionallySizedBox(
        widthFactor: 1 / itemCount,
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
    );
  }
}

/// Individual tab button with animations
class _TabButton extends StatelessWidget {
  final TabItem tab;
  final bool isSelected;
  final VoidCallback onTap;
  final Color selectedColor;
  final Color unselectedColor;
  final Duration animationDuration;

  const _TabButton({
    Key? key,
    required this.tab,
    required this.isSelected,
    required this.onTap,
    required this.selectedColor,
    required this.unselectedColor,
    required this.animationDuration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(25),
        child: AnimatedContainer(
          duration: animationDuration,
          curve: Curves.easeInOutCubic,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with scale animation
              AnimatedScale(
                scale: isSelected ? 1.1 : 1.0,
                duration: animationDuration,
                curve: Curves.easeInOutCubic,
                child: Icon(
                  tab.icon,
                  color: isSelected ? selectedColor : unselectedColor,
                  size: 26,
                ),
              ),
              const SizedBox(height: 4),

              // Label with fade and scale
              AnimatedDefaultTextStyle(
                duration: animationDuration,
                curve: Curves.easeInOutCubic,
                style: TextStyle(
                  fontSize: isSelected ? 12 : 10,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? selectedColor : unselectedColor,
                ),
                child: Text(
                  tab.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
