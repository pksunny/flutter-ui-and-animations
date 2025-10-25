import 'package:flutter/material.dart';
import 'dart:math' as math;
/// Demo page showcasing the Floating Reward Badge system
class RewardBadge extends StatefulWidget {
  const RewardBadge({Key? key}) : super(key: key);

  @override
  State<RewardBadge> createState() =>
      _RewardBadgeState();
}

class _RewardBadgeState extends State<RewardBadge> {
  final GlobalKey<FloatingRewardBadgeOverlayState> _overlayKey = GlobalKey();
  int _points = 0;
  int _achievements = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FloatingRewardBadgeOverlay(
        key: _overlayKey,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.deepPurple.shade900,
                Colors.black,
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Header
                _buildHeader(),
                
                const SizedBox(height: 40),

                // Stats Dashboard
                _buildStatsCard(),

                const Spacer(),

                // Action Buttons
                _buildActionButtons(),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Text(
            '🏆 Reward System',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
              color: Colors.white
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap buttons to earn rewards!',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.amber.withOpacity(0.2),
              Colors.orange.withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.amber.withOpacity(0.3),
            width: 2,
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
              icon: Icons.star,
              label: 'Points',
              value: _points.toString(),
              color: Colors.amber,
            ),
            Container(
              width: 2,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.amber.withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            _buildStatItem(
              icon: Icons.emoji_events,
              label: 'Achievements',
              value: _achievements.toString(),
              color: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.withOpacity(0.3),
                color.withOpacity(0.1),
              ],
            ),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 32),
        ),
        const SizedBox(height: 12),
        Text(
          value,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade400,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          _buildActionButton(
            label: '⭐ Earn 10 Points',
            gradient: [Colors.amber.shade700, Colors.amber.shade500],
            onTap: () => _earnPoints(10),
          ),
          const SizedBox(height: 16),
          _buildActionButton(
            label: '💎 Earn 25 Points',
            gradient: [Colors.cyan.shade700, Colors.cyan.shade500],
            onTap: () => _earnPoints(25),
          ),
          const SizedBox(height: 16),
          _buildActionButton(
            label: '🏆 Unlock Achievement',
            gradient: [Colors.purple.shade700, Colors.purple.shade500],
            onTap: _unlockAchievement,
          ),
          const SizedBox(height: 16),
          _buildActionButton(
            label: '🎁 Special Reward',
            gradient: [Colors.pink.shade700, Colors.pink.shade500],
            onTap: _specialReward,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradient),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }

  void _earnPoints(int points) {
    setState(() {
      _points += points;
    });

    _overlayKey.currentState?.showRewardBadge(
      RewardBadgeConfig(
        icon: Icons.star,
        label: '+$points',
        mainColor: Colors.amber,
        accentColor: Colors.orange,
        size: RewardBadgeSize.medium,
      ),
    );
  }

  void _unlockAchievement() {
    setState(() {
      _achievements++;
    });

    _overlayKey.currentState?.showRewardBadge(
      RewardBadgeConfig(
        icon: Icons.emoji_events,
        label: 'Achievement!',
        mainColor: Colors.purple,
        accentColor: Colors.purpleAccent,
        size: RewardBadgeSize.large,
        sparkleCount: 12,
      ),
    );
  }

  void _specialReward() {
    setState(() {
      _points += 50;
    });

    _overlayKey.currentState?.showRewardBadge(
      RewardBadgeConfig(
        icon: Icons.card_giftcard,
        label: '🎉 BONUS +50',
        mainColor: Colors.pink,
        accentColor: Colors.pinkAccent,
        size: RewardBadgeSize.large,
        sparkleCount: 20,
      ),
    );
  }
}

/// ==================== Floating Reward Badge System ====================

/// Configuration for the reward badge appearance and behavior
class RewardBadgeConfig {
  final IconData icon;
  final String label;
  final Color mainColor;
  final Color accentColor;
  final RewardBadgeSize size;
  final int sparkleCount;
  final Duration animationDuration;
  final Duration displayDuration;

  const RewardBadgeConfig({
    required this.icon,
    required this.label,
    this.mainColor = Colors.amber,
    this.accentColor = Colors.orange,
    this.size = RewardBadgeSize.medium,
    this.sparkleCount = 8,
    this.animationDuration = const Duration(milliseconds: 1500),
    this.displayDuration = const Duration(milliseconds: 2000),
  });
}

/// Enum for badge size presets
enum RewardBadgeSize {
  small(60.0),
  medium(80.0),
  large(100.0);

  final double value;
  const RewardBadgeSize(this.value);
}

/// Overlay widget that manages and displays floating reward badges
class FloatingRewardBadgeOverlay extends StatefulWidget {
  final Widget child;

  const FloatingRewardBadgeOverlay({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<FloatingRewardBadgeOverlay> createState() =>
      FloatingRewardBadgeOverlayState();
}

class FloatingRewardBadgeOverlayState
    extends State<FloatingRewardBadgeOverlay> {
  final List<_FloatingBadgeData> _badges = [];

  /// Show a new floating reward badge
  void showRewardBadge(RewardBadgeConfig config) {
    setState(() {
      _badges.add(_FloatingBadgeData(
        config: config,
        id: DateTime.now().millisecondsSinceEpoch,
      ));
    });

    // Auto-remove after display duration
    Future.delayed(config.displayDuration + config.animationDuration, () {
      if (mounted) {
        setState(() {
          _badges.removeWhere((badge) =>
              badge.id ==
              DateTime.now().millisecondsSinceEpoch -
                  config.displayDuration.inMilliseconds -
                  config.animationDuration.inMilliseconds);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        ..._badges.map((badge) => _FloatingRewardBadge(
              config: badge.config,
              onComplete: () {
                setState(() {
                  _badges.remove(badge);
                });
              },
            )),
      ],
    );
  }
}

/// Internal data class for badge tracking
class _FloatingBadgeData {
  final RewardBadgeConfig config;
  final int id;

  _FloatingBadgeData({required this.config, required this.id});
}

/// The actual floating badge widget with animations
class _FloatingRewardBadge extends StatefulWidget {
  final RewardBadgeConfig config;
  final VoidCallback onComplete;

  const _FloatingRewardBadge({
    required this.config,
    required this.onComplete,
  });

  @override
  State<_FloatingRewardBadge> createState() => _FloatingRewardBadgeState();
}

class _FloatingRewardBadgeState extends State<_FloatingRewardBadge>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _sparkleController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _floatAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _rotationAnimation;

  final List<_Sparkle> _sparkles = [];

  @override
  void initState() {
    super.initState();

    // Main animation controller
    _mainController = AnimationController(
      duration: widget.config.animationDuration,
      vsync: this,
    );

    // Sparkle animation controller
    _sparkleController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();

    // Scale animation (pop in effect)
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.3)
            .chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.3, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.0),
        weight: 50,
      ),
    ]).animate(_mainController);

    // Float up animation
    _floatAnimation = Tween<double>(
      begin: 0.0,
      end: -200.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: Curves.easeOut,
    ));

    // Fade out animation
    _fadeAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.0),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0),
        weight: 20,
      ),
    ]).animate(_mainController);

    // Rotation animation
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.1,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: Curves.easeInOut,
    ));

    // Generate sparkles
    _generateSparkles();

    // Start animations
    _mainController.forward().then((_) {
      widget.onComplete();
    });
  }

  void _generateSparkles() {
    final random = math.Random();
    for (int i = 0; i < widget.config.sparkleCount; i++) {
      final angle = (2 * math.pi * i) / widget.config.sparkleCount;
      final distance = 40.0 + random.nextDouble() * 40.0;
      _sparkles.add(_Sparkle(
        angle: angle,
        distance: distance,
        size: 4.0 + random.nextDouble() * 4.0,
        delay: random.nextDouble() * 0.3,
      ));
    }
  }

  @override
  void dispose() {
    _mainController.dispose();
    _sparkleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Positioned(
      left: size.width / 2 - widget.config.size.value / 2,
      top: size.height / 2 - widget.config.size.value / 2,
      child: AnimatedBuilder(
        animation: _mainController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _floatAnimation.value),
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Transform.rotate(
                angle: _rotationAnimation.value,
                child: Opacity(
                  opacity: _fadeAnimation.value,
                  child: _buildBadgeWithSparkles(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBadgeWithSparkles() {
    return SizedBox(
      width: widget.config.size.value * 2,
      height: widget.config.size.value * 2,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Sparkles
          ..._sparkles.map((sparkle) => _buildSparkle(sparkle)),

          // Main badge
          _buildMainBadge(),
        ],
      ),
    );
  }

  Widget _buildSparkle(_Sparkle sparkle) {
    return AnimatedBuilder(
      animation: _sparkleController,
      builder: (context, child) {
        final progress = (_sparkleController.value - sparkle.delay).clamp(0.0, 1.0);
        final x = math.cos(sparkle.angle) * sparkle.distance * progress;
        final y = math.sin(sparkle.angle) * sparkle.distance * progress;
        final opacity = 1.0 - progress;

        return Transform.translate(
          offset: Offset(x, y),
          child: Opacity(
            opacity: opacity,
            child: Container(
              width: sparkle.size,
              height: sparkle.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    widget.config.accentColor,
                    widget.config.mainColor,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.config.mainColor.withOpacity(0.6),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMainBadge() {
    return Container(
      width: widget.config.size.value,
      height: widget.config.size.value,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            widget.config.accentColor,
            widget.config.mainColor,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: widget.config.mainColor.withOpacity(0.6),
            blurRadius: 24,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            widget.config.icon,
            color: Colors.white,
            size: widget.config.size.value * 0.4,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 4,
              ),
            ],
          ),
          if (widget.config.label.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              widget.config.label,
              style: TextStyle(
                color: Colors.white,
                fontSize: widget.config.size.value * 0.15,
                fontWeight: FontWeight.w900,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 4,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// Helper class for sparkle particles
class _Sparkle {
  final double angle;
  final double distance;
  final double size;
  final double delay;

  _Sparkle({
    required this.angle,
    required this.distance,
    required this.size,
    required this.delay,
  });
}