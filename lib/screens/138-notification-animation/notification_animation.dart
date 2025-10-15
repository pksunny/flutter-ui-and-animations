import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Demo screen showcasing the animated notification bell
class NotificationAnimation extends StatefulWidget {
  const NotificationAnimation({Key? key}) : super(key: key);

  @override
  State<NotificationAnimation> createState() => _NotificationAnimationState();
}

class _NotificationAnimationState extends State<NotificationAnimation> {
  final GlobalKey<AnimatedNotificationBellState> _bellKey = GlobalKey();
  int _notificationCount = 0;

  void _triggerNotification() {
    setState(() {
      _notificationCount++;
    });
    _bellKey.currentState?.shake();
  }

  void _clearNotifications() {
    setState(() {
      _notificationCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF0A0E21),
              const Color(0xFF1D1E33),
              const Color(0xFF0A0E21).withOpacity(0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar with Bell
              _buildAppBar(),

              const Spacer(),

              // Main Content
              _buildMainContent(),

              const Spacer(),

              // Control Buttons
              _buildControlButtons(),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo/Title
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.purple.withOpacity(0.2),
                  Colors.blue.withOpacity(0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: const Text(
              'BellShake',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
          ),

          // Notification Bell
          AnimatedNotificationBell(
            key: _bellKey,
            notificationCount: _notificationCount,
            bellSize: 32,
            bellColor: Colors.white,
            badgeColor: const Color(0xFFFF4757),
            glowColor: Colors.purpleAccent,
            onTap: _notificationCount > 0 ? _clearNotifications : null,
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Animated Icon
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 1200),
          curve: Curves.elasticOut,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.purple.withOpacity(0.3),
                      Colors.blue.withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purpleAccent.withOpacity(0.3),
                      blurRadius: 60,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.notifications_active_rounded,
                  size: 100,
                  color: Colors.white70,
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 40),

        // Title
        ShaderMask(
          shaderCallback:
              (bounds) => LinearGradient(
                colors: [
                  Colors.purple.shade300,
                  Colors.blue.shade300,
                  Colors.cyan.shade300,
                ],
              ).createShader(bounds),
          child: const Text(
            'Notification Bell Shake',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        const SizedBox(height: 16),

        // Subtitle
        Text(
          'Tap the button to trigger a shake animation\nwith physics-based motion',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withOpacity(0.6),
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 30),

        // Notification Counter
        if (_notificationCount > 0)
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 400),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.purple.withOpacity(0.3),
                        Colors.blue.withOpacity(0.3),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '$_notificationCount ${_notificationCount == 1 ? "Notification" : "Notifications"}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildControlButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        children: [
          Expanded(
            child: _buildButton(
              label: 'Send Notification',
              gradient: LinearGradient(
                colors: [Colors.purple.shade600, Colors.blue.shade600],
              ),
              icon: Icons.notification_add_rounded,
              onTap: _triggerNotification,
            ),
          ),
          if (_notificationCount > 0) ...[
            const SizedBox(width: 16),
            Expanded(
              child: _buildButton(
                label: 'Clear',
                gradient: LinearGradient(
                  colors: [
                    Colors.red.shade600.withOpacity(0.8),
                    Colors.orange.shade600.withOpacity(0.8),
                  ],
                ),
                icon: Icons.clear_rounded,
                onTap: _clearNotifications,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required Gradient gradient,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: gradient.colors.first.withOpacity(0.4),
                blurRadius: 20,
                spreadRadius: 1,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 12),
              Icon(icon, color: Colors.white, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
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

/// 🔔 Animated Notification Bell Widget
/// A highly customizable, reusable notification bell with physics-based shake animation
class AnimatedNotificationBell extends StatefulWidget {
  /// Size of the bell icon
  final double bellSize;

  /// Color of the bell icon
  final Color bellColor;

  /// Number of notifications to display (0 to hide badge)
  final int notificationCount;

  /// Background color of the notification badge
  final Color badgeColor;

  /// Text color of the notification count
  final Color badgeTextColor;

  /// Glow color when bell shakes
  final Color glowColor;

  /// Duration of the shake animation
  final Duration shakeDuration;

  /// Intensity of the shake (rotation angle in radians)
  final double shakeIntensity;

  /// Number of oscillations during shake
  final int shakeOscillations;

  /// Callback when bell is tapped
  final VoidCallback? onTap;

  /// Enable/disable glow effect
  final bool enableGlow;

  /// Enable/disable pulse effect on badge
  final bool enableBadgePulse;

  const AnimatedNotificationBell({
    Key? key,
    this.bellSize = 28.0,
    this.bellColor = Colors.white,
    this.notificationCount = 0,
    this.badgeColor = Colors.red,
    this.badgeTextColor = Colors.white,
    this.glowColor = Colors.blue,
    this.shakeDuration = const Duration(milliseconds: 800),
    this.shakeIntensity = 0.15,
    this.shakeOscillations = 3,
    this.onTap,
    this.enableGlow = true,
    this.enableBadgePulse = true,
  }) : super(key: key);

  @override
  State<AnimatedNotificationBell> createState() =>
      AnimatedNotificationBellState();
}

class AnimatedNotificationBellState extends State<AnimatedNotificationBell>
    with TickerProviderStateMixin {
  late AnimationController _shakeController;
  late AnimationController _glowController;
  late AnimationController _pulseController;

  late Animation<double> _shakeAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    // Shake Animation Controller
    _shakeController = AnimationController(
      vsync: this,
      duration: widget.shakeDuration,
    );

    // Physics-based shake animation with damping
    _shakeAnimation = TweenSequence<double>([
      for (int i = 0; i < widget.shakeOscillations; i++) ...[
        TweenSequenceItem(
          tween: Tween<double>(
            begin: 0.0,
            end: widget.shakeIntensity * math.pow(0.7, i),
          ).chain(CurveTween(curve: Curves.easeOut)),
          weight: 1,
        ),
        TweenSequenceItem(
          tween: Tween<double>(
            begin: widget.shakeIntensity * math.pow(0.7, i),
            end: -widget.shakeIntensity * math.pow(0.7, i),
          ).chain(CurveTween(curve: Curves.easeInOut)),
          weight: 1,
        ),
        TweenSequenceItem(
          tween: Tween<double>(
            begin: -widget.shakeIntensity * math.pow(0.7, i),
            end: 0.0,
          ).chain(CurveTween(curve: Curves.easeIn)),
          weight: 1,
        ),
      ],
    ]).animate(_shakeController);

    // Glow Animation Controller
    _glowController = AnimationController(
      vsync: this,
      duration: widget.shakeDuration,
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    // Badge Pulse Animation Controller
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (widget.enableBadgePulse && widget.notificationCount > 0) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(AnimatedNotificationBell oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Restart pulse animation if notification count changed
    if (widget.notificationCount != oldWidget.notificationCount) {
      if (widget.enableBadgePulse && widget.notificationCount > 0) {
        _pulseController.repeat(reverse: true);
      } else {
        _pulseController.stop();
        _pulseController.value = 0;
      }
    }
  }

  /// Trigger the shake animation (can be called from parent widget)
  void shake() {
    _shakeController.forward(from: 0.0);
    if (widget.enableGlow) {
      _glowController.forward(from: 0.0).then((_) {
        _glowController.reverse();
      });
    }
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _glowController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _shakeController,
          _glowController,
          _pulseController,
        ]),
        builder: (context, child) {
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.1),
              boxShadow:
                  widget.enableGlow
                      ? [
                        BoxShadow(
                          color: widget.glowColor.withOpacity(
                            _glowAnimation.value * 0.6,
                          ),
                          blurRadius: 20 * _glowAnimation.value,
                          spreadRadius: 5 * _glowAnimation.value,
                        ),
                      ]
                      : null,
            ),
            child: Transform.rotate(
              angle: _shakeAnimation.value,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Bell Icon
                  Icon(
                    Icons.notifications_rounded,
                    size: widget.bellSize,
                    color: widget.bellColor,
                  ),

                  // Notification Badge
                  if (widget.notificationCount > 0)
                    Positioned(
                      right: -6,
                      top: -6,
                      child: Transform.scale(
                        scale: _pulseAnimation.value,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: widget.badgeColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: widget.badgeColor.withOpacity(0.5),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 20,
                            minHeight: 20,
                          ),
                          child: Center(
                            child: Text(
                              widget.notificationCount > 99
                                  ? '99+'
                                  : widget.notificationCount.toString(),
                              style: TextStyle(
                                color: widget.badgeTextColor,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
