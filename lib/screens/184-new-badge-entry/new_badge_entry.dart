import 'package:flutter/material.dart';

class NewBadgeEntry extends StatefulWidget {
  const NewBadgeEntry({super.key});

  @override
  State<NewBadgeEntry> createState() => _NewBadgeEntryState();
}

class _NewBadgeEntryState extends State<NewBadgeEntry> {
  int _notificationCount = 0;
  int _messageCount = 0;
  int _cartCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'New Badge Soft Entry',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                    color: Color(0xFF1D1D1F),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Ultra-premium badge animations',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF1D1D1F).withOpacity(0.6),
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 60),

                // Icon Buttons Demo
                Wrap(
                  spacing: 32,
                  runSpacing: 32,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildDemoIconButton(
                      icon: Icons.notifications_outlined,
                      label: 'Notifications',
                      count: _notificationCount,
                      onTap: () {
                        setState(() {
                          _notificationCount++;
                        });
                      },
                      badgeColor: const Color(0xFFFF3B30),
                    ),
                    _buildDemoIconButton(
                      icon: Icons.mail_outline,
                      label: 'Messages',
                      count: _messageCount,
                      onTap: () {
                        setState(() {
                          _messageCount++;
                        });
                      },
                      badgeColor: const Color(0xFF007AFF),
                    ),
                    _buildDemoIconButton(
                      icon: Icons.shopping_cart_outlined,
                      label: 'Cart',
                      count: _cartCount,
                      onTap: () {
                        setState(() {
                          _cartCount++;
                        });
                      },
                      badgeColor: const Color(0xFFFF9500),
                    ),
                  ],
                ),

                const SizedBox(height: 60),

                // Reset Button
                _buildResetButton(),

                const SizedBox(height: 40),

                // Feature Cards
                _buildFeatureCards(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDemoIconButton({
    required IconData icon,
    required String label,
    required int count,
    required VoidCallback onTap,
    required Color badgeColor,
  }) {
    return Column(
      children: [
        BadgedIconButton(
          icon: icon,
          badgeCount: count,
          onTap: onTap,
          badgeColor: badgeColor,
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF1D1D1F).withOpacity(0.7),
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }

  Widget _buildResetButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _notificationCount = 0;
          _messageCount = 0;
          _cartCount = 0;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1D1D1F),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1D1D1F).withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Text(
          'Reset All Badges',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: -0.3,
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCards() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: [
        _buildFeatureCard(
          icon: Icons.animation_outlined,
          title: 'Soft Entry',
          description: 'Gentle scale-in animation',
        ),
        _buildFeatureCard(
          icon: Icons.speed_outlined,
          title: 'Performance',
          description: 'Optimized for 60fps',
        ),
        _buildFeatureCard(
          icon: Icons.palette_outlined,
          title: 'Customizable',
          description: 'Flexible color options',
        ),
      ],
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: const Color(0xFF007AFF)),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1D1D1F),
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF1D1D1F).withOpacity(0.6),
              letterSpacing: -0.1,
            ),
          ),
        ],
      ),
    );
  }
}

/// Reusable badged icon button with soft entry animation
class BadgedIconButton extends StatefulWidget {
  final IconData icon;
  final int badgeCount;
  final VoidCallback onTap;
  final Color iconColor;
  final Color badgeColor;
  final Color badgeTextColor;
  final double iconSize;
  final double badgeSize;

  const BadgedIconButton({
    super.key,
    required this.icon,
    required this.badgeCount,
    required this.onTap,
    this.iconColor = const Color(0xFF1D1D1F),
    this.badgeColor = const Color(0xFFFF3B30),
    this.badgeTextColor = Colors.white,
    this.iconSize = 28,
    this.badgeSize = 28,
  });

  @override
  State<BadgedIconButton> createState() => _BadgedIconButtonState();
}

class _BadgedIconButtonState extends State<BadgedIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _badgeController;
  late Animation<double> _badgeScaleAnimation;
  late Animation<double> _badgeOpacityAnimation;

  int _previousCount = 0;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _previousCount = widget.badgeCount;

    // Initialize animation controller with gentle timing
    _badgeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Soft scale animation with elastic curve for premium feel
    _badgeScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _badgeController, curve: Curves.elasticOut),
    );

    // Gentle opacity fade-in
    _badgeOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _badgeController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );
  }

  @override
  void didUpdateWidget(BadgedIconButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Trigger animation when count increases
    if (widget.badgeCount > _previousCount) {
      _badgeController.forward(from: 0.0);
    } else if (widget.badgeCount == 0 && _previousCount > 0) {
      // Reverse animation when count resets to 0
      _badgeController.reverse();
    }

    _previousCount = widget.badgeCount;
  }

  @override
  void dispose() {
    _badgeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        transform: Matrix4.identity()..scale(_isPressed ? 0.92 : 1.0),
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(
                  0xFF000000,
                ).withOpacity(_isPressed ? 0.08 : 0.12),
                blurRadius: _isPressed ? 12 : 24,
                offset: Offset(0, _isPressed ? 4 : 8),
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Icon
              Center(
                child: Icon(
                  widget.icon,
                  size: widget.iconSize,
                  color: widget.iconColor,
                ),
              ),

              // Badge with soft entry animation
              if (widget.badgeCount > 0)
                Positioned(
                  top: -4,
                  right: -4,
                  child: AnimatedBuilder(
                    animation: _badgeController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _badgeScaleAnimation.value,
                        child: Opacity(
                          opacity: _badgeOpacityAnimation.value,
                          child: child,
                        ),
                      );
                    },
                    child: Container(
                      height: widget.badgeSize,
                      width: widget.badgeSize,
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        color: widget.badgeColor,
                        borderRadius: BorderRadius.circular(
                          widget.badgeSize / 2,
                        ),
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: widget.badgeColor.withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          widget.badgeCount > 99
                              ? '99+'
                              : widget.badgeCount.toString(),
                          style: TextStyle(
                            color: widget.badgeTextColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
