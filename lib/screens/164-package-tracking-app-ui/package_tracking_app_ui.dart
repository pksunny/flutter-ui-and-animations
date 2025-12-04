import 'package:flutter/material.dart';
import 'dart:math' as math;

class PackageTrackingScreen extends StatelessWidget {
  const PackageTrackingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                // Header Section
                _buildHeader(),
                const SizedBox(height: 30),

                // Package Info Card
                _buildPackageInfoCard(),
                const SizedBox(height: 30),

                // Tracking Timeline Widget
                AnimatedPackageTracker(
                  trackingSteps: [
                    TrackingStep(
                      title: 'Order Placed',
                      subtitle: 'Your order has been confirmed',
                      time: '10:30 AM',
                      date: 'Nov 28, 2024',
                      icon: Icons.shopping_bag_outlined,
                    ),
                    TrackingStep(
                      title: 'Processing',
                      subtitle: 'Package is being prepared',
                      time: '2:15 PM',
                      date: 'Nov 28, 2024',
                      icon: Icons.inventory_2_outlined,
                    ),
                    TrackingStep(
                      title: 'Shipped',
                      subtitle: 'Package picked up by courier',
                      time: '8:45 AM',
                      date: 'Nov 29, 2024',
                      icon: Icons.local_shipping_outlined,
                    ),
                    TrackingStep(
                      title: 'Out for Delivery',
                      subtitle: 'On the way to your location',
                      time: '9:20 AM',
                      date: 'Nov 30, 2024',
                      icon: Icons.delivery_dining_outlined,
                    ),
                    TrackingStep(
                      title: 'Delivered',
                      subtitle: 'Package delivered successfully',
                      time: '-- --',
                      date: 'Expected Dec 1',
                      icon: Icons.check_circle_outline,
                    ),
                  ],
                  currentStep: 3, // 0-indexed, so step 4 is active
                  primaryColor: const Color(0xFF6C5CE7),
                  accentColor: const Color(0xFFFF6B9D),
                  completedColor: const Color(0xFF00D9A3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Track Package',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.grey[900],
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Real-time delivery status',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            Icons.notifications_outlined,
            color: Colors.grey[700],
            size: 28,
          ),
        ),
      ],
    );
  }

  Widget _buildPackageInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C5CE7), Color(0xFF8B7FF4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C5CE7).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tracking Number',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'In Transit',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'TRK9847562301',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  Icons.location_on_outlined,
                  'From',
                  'New York, USA',
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withOpacity(0.3),
              ),
              Expanded(
                child: _buildInfoItem(
                  Icons.flag_outlined,
                  'To',
                  'Los Angeles, USA',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white70, size: 16),
              const SizedBox(width: 5),
              Text(
                label,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// TRACKING STEP DATA MODEL
// ============================================================================

class TrackingStep {
  final String title;
  final String subtitle;
  final String time;
  final String date;
  final IconData icon;

  TrackingStep({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.date,
    required this.icon,
  });
}

// ============================================================================
// ANIMATED PACKAGE TRACKER WIDGET (Reusable & Customizable)
// ============================================================================

class AnimatedPackageTracker extends StatefulWidget {
  /// List of tracking steps to display
  final List<TrackingStep> trackingSteps;

  /// Current active step (0-indexed)
  final int currentStep;

  /// Primary theme color
  final Color primaryColor;

  /// Accent color for highlights
  final Color accentColor;

  /// Color for completed steps
  final Color completedColor;

  /// Animation duration for transitions
  final Duration animationDuration;

  /// Enable delivery van animation
  final bool showDeliveryVan;

  const AnimatedPackageTracker({
    Key? key,
    required this.trackingSteps,
    required this.currentStep,
    this.primaryColor = const Color(0xFF6C5CE7),
    this.accentColor = const Color(0xFFFF6B9D),
    this.completedColor = const Color(0xFF00D9A3),
    this.animationDuration = const Duration(milliseconds: 1500),
    this.showDeliveryVan = true,
  }) : super(key: key);

  @override
  State<AnimatedPackageTracker> createState() => _AnimatedPackageTrackerState();
}

class _AnimatedPackageTrackerState extends State<AnimatedPackageTracker>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _glowController;
  late AnimationController _vanController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    // Progress line animation controller
    _progressController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    // Glow pulse animation for active step
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    // Delivery van movement animation
    _vanController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    // Calculate progress based on current step
    final targetProgress =
        widget.currentStep / (widget.trackingSteps.length - 1);
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: targetProgress.clamp(0.0, 1.0),
    ).animate(
      CurvedAnimation(
        parent: _progressController,
        curve: Curves.easeInOutCubic,
      ),
    );

    // Start animation
    _progressController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    _glowController.dispose();
    _vanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Delivery Timeline',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[900],
            ),
          ),
          const SizedBox(height: 30),

          // Timeline with animated progress
          ...List.generate(widget.trackingSteps.length, (index) {
            return _buildTimelineItem(
              widget.trackingSteps[index],
              index,
              isLast: index == widget.trackingSteps.length - 1,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
    TrackingStep step,
    int index, {
    bool isLast = false,
  }) {
    final isCompleted = index <= widget.currentStep;
    final isActive = index == widget.currentStep;
    final isFuture = index > widget.currentStep;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator column
          Column(
            children: [
              // Animated Icon Circle
              AnimatedBuilder(
                animation: _glowController,
                builder: (context, child) {
                  return Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient:
                          isCompleted
                              ? LinearGradient(
                                colors:
                                    isActive
                                        ? [
                                          widget.primaryColor,
                                          widget.accentColor,
                                        ]
                                        : [
                                          widget.completedColor,
                                          widget.completedColor,
                                        ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                              : null,
                      color: isFuture ? Colors.grey[200] : null,
                      boxShadow:
                          isActive
                              ? [
                                BoxShadow(
                                  color: widget.primaryColor.withOpacity(
                                    0.3 + (_glowController.value * 0.3),
                                  ),
                                  blurRadius: 15 + (_glowController.value * 10),
                                  spreadRadius: 2 + (_glowController.value * 2),
                                ),
                              ]
                              : isCompleted
                              ? [
                                BoxShadow(
                                  color: widget.completedColor.withOpacity(0.3),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                ),
                              ]
                              : null,
                    ),
                    child: Icon(
                      step.icon,
                      color: isCompleted ? Colors.white : Colors.grey[400],
                      size: 28,
                    ),
                  );
                },
              ),

              // Connecting line with animation
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: AnimatedBuilder(
                      animation: _progressAnimation,
                      builder: (context, child) {
                        final lineProgress = ((widget.currentStep - index) /
                                1.0)
                            .clamp(0.0, 1.0);
                        return CustomPaint(
                          painter: _TimelineLinePainter(
                            progress: lineProgress,
                            completedColor: widget.completedColor,
                            incompleteColor: Colors.grey[200]!,
                          ),
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(width: 20),

          // Content Column
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: AnimatedBuilder(
                animation: _glowController,
                builder: (context, child) {
                  return TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 500),
                    tween: Tween(begin: 0.0, end: 1.0),
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 20 * (1 - value)),
                          child: child,
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color:
                            isActive
                                ? widget.primaryColor.withOpacity(0.05)
                                : Colors.grey[50],
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color:
                              isActive
                                  ? widget.primaryColor.withOpacity(
                                    0.2 + (_glowController.value * 0.1),
                                  )
                                  : Colors.transparent,
                          width: 2,
                        ),
                        boxShadow:
                            isActive
                                ? [
                                  BoxShadow(
                                    color: widget.primaryColor.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                                : null,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  step.title,
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        isCompleted
                                            ? Colors.grey[900]
                                            : Colors.grey[500],
                                  ),
                                ),
                              ),
                              if (isActive && widget.showDeliveryVan)
                                AnimatedBuilder(
                                  animation: _vanController,
                                  builder: (context, child) {
                                    return Transform.translate(
                                      offset: Offset(
                                        _vanController.value * 10,
                                        0,
                                      ),
                                      child: Icon(
                                        Icons.local_shipping,
                                        color: widget.accentColor,
                                        size: 24,
                                      ),
                                    );
                                  },
                                ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            step.subtitle,
                            style: TextStyle(
                              fontSize: 14,
                              color:
                                  isCompleted
                                      ? Colors.grey[600]
                                      : Colors.grey[400],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 14,
                                color: Colors.grey[500],
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '${step.time} • ${step.date}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// CUSTOM PAINTER FOR ANIMATED TIMELINE LINE
// ============================================================================

class _TimelineLinePainter extends CustomPainter {
  final double progress;
  final Color completedColor;
  final Color incompleteColor;

  _TimelineLinePainter({
    required this.progress,
    required this.completedColor,
    required this.incompleteColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final incompletePaint =
        Paint()
          ..color = incompleteColor
          ..strokeWidth = 3
          ..style = PaintingStyle.stroke;

    final completePaint =
        Paint()
          ..shader = LinearGradient(
            colors: [completedColor, completedColor.withOpacity(0.7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
          ..strokeWidth = 3
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    // Draw incomplete line
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      incompletePaint,
    );

    // Draw completed line with progress
    if (progress > 0) {
      canvas.drawLine(
        Offset(size.width / 2, 0),
        Offset(size.width / 2, size.height * progress),
        completePaint,
      );
    }
  }

  @override
  bool shouldRepaint(_TimelineLinePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
