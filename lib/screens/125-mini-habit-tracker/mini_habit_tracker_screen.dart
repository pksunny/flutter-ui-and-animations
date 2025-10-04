import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Main screen demonstrating the Habit Tracker Bubble UI
class MiniHabitTrackerScreen extends StatefulWidget {
  const MiniHabitTrackerScreen({Key? key}) : super(key: key);

  @override
  State<MiniHabitTrackerScreen> createState() => _MiniHabitTrackerScreenState();
}

class _MiniHabitTrackerScreenState extends State<MiniHabitTrackerScreen> {
  // Sample habit data
  final List<HabitData> habits = [
    HabitData(
      id: '1',
      name: 'Morning Yoga',
      emoji: '🧘',
      color: const Color(0xFF6C5CE7),
      completedDays: 5,
      totalDays: 7,
    ),
    HabitData(
      id: '2',
      name: 'Read 30min',
      emoji: '📚',
      color: const Color(0xFFFF6B9D),
      completedDays: 3,
      totalDays: 7,
    ),
    HabitData(
      id: '3',
      name: 'Drink Water',
      emoji: '💧',
      color: const Color(0xFF00D9FF),
      completedDays: 7,
      totalDays: 7,
    ),
    HabitData(
      id: '4',
      name: 'Meditation',
      emoji: '🧠',
      color: const Color(0xFFFD79A8),
      completedDays: 4,
      totalDays: 7,
    ),
    HabitData(
      id: '5',
      name: 'Exercise',
      emoji: '💪',
      color: const Color(0xFFFDCB6E),
      completedDays: 6,
      totalDays: 7,
    ),
    HabitData(
      id: '6',
      name: 'Journal',
      emoji: '📝',
      color: const Color(0xFF00B894),
      completedDays: 2,
      totalDays: 7,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildHeader(),
            Expanded(
              child: HabitBubbleGrid(
                habits: habits,
                onHabitTap: (habit) {
                  setState(() {
                    // Toggle completion
                    if (habit.completedDays < habit.totalDays) {
                      habit.completedDays++;
                    } else {
                      habit.completedDays = 0;
                    }
                  });
                },
                onHabitLongPress: (habit) {
                  _showHabitDetails(context, habit);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Your Habits',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap bubbles to complete daily goals',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black45,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  void _showHabitDetails(BuildContext context, HabitData habit) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => HabitDetailSheet(habit: habit),
    );
  }
}

/// Customizable Habit Bubble Grid Widget
/// This is the main reusable component
class HabitBubbleGrid extends StatelessWidget {
  final List<HabitData> habits;
  final Function(HabitData)? onHabitTap;
  final Function(HabitData)? onHabitLongPress;
  final EdgeInsets padding;
  final double spacing;

  const HabitBubbleGrid({
    Key? key,
    required this.habits,
    this.onHabitTap,
    this.onHabitLongPress,
    this.padding = const EdgeInsets.all(20),
    this.spacing = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: padding,
      child: Wrap(
        spacing: spacing,
        runSpacing: spacing,
        children: habits
            .map((habit) => HabitBubble(
                  habit: habit,
                  onTap: () => onHabitTap?.call(habit),
                  onLongPress: () => onHabitLongPress?.call(habit),
                ))
            .toList(),
      ),
    );
  }
}

/// Individual Habit Bubble Widget
/// Highly customizable and reusable
class HabitBubble extends StatefulWidget {
  final HabitData habit;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double size;
  final Duration animationDuration;

  const HabitBubble({
    Key? key,
    required this.habit,
    this.onTap,
    this.onLongPress,
    this.size = 110,
    this.animationDuration = const Duration(milliseconds: 600),
  }) : super(key: key);

  @override
  State<HabitBubble> createState() => _HabitBubbleState();
}

class _HabitBubbleState extends State<HabitBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward().then((_) => _controller.reverse());
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final progress = widget.habit.completedDays / widget.habit.totalDays;
    final isCompleted = progress >= 1.0;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: _handleTap,
      onLongPress: widget.onLongPress,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _isPressed ? 0.95 : _scaleAnimation.value,
            child: Transform.rotate(
              angle: _rotationAnimation.value,
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: widget.habit.color.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Background circle
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.05),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                          width: 2,
                        ),
                      ),
                    ),
                    // Animated fill
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOutCubic,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            widget.habit.color,
                            widget.habit.color.withOpacity(0.6),
                          ],
                          stops: [
                            0.0,
                            progress.clamp(0.0, 1.0),
                          ],
                        ),
                      ),
                    ),
                    // Shimmer effect when completed
                    if (isCompleted)
                      _ShimmerEffect(
                        color: Colors.white.withOpacity(0.3),
                      ),
                    // Content
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.habit.emoji,
                            style: const TextStyle(fontSize: 32),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.habit.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${widget.habit.completedDays}/${widget.habit.totalDays}',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Completion checkmark
                    if (isCompleted)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: _CompletionBadge(),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Shimmer effect for completed habits
class _ShimmerEffect extends StatefulWidget {
  final Color color;

  const _ShimmerEffect({required this.color});

  @override
  State<_ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<_ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: SweepGradient(
              colors: [
                Colors.transparent,
                widget.color,
                Colors.transparent,
              ],
              stops: const [0.0, 0.5, 1.0],
              transform: GradientRotation(_controller.value * 2 * math.pi),
            ),
          ),
        );
      },
    );
  }
}

/// Completion badge with animation
class _CompletionBadge extends StatefulWidget {
  @override
  State<_CompletionBadge> createState() => _CompletionBadgeState();
}

class _CompletionBadgeState extends State<_CompletionBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(
          Icons.check,
          size: 12,
          color: Color(0xFF0A0E27),
        ),
      ),
    );
  }
}

/// Bottom sheet for habit details
class HabitDetailSheet extends StatelessWidget {
  final HabitData habit;

  const HabitDetailSheet({Key? key, required this.habit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = habit.completedDays / habit.totalDays;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F3A),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '${habit.emoji} ${habit.name}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Progress',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '${(progress * 100).toStringAsFixed(0)}%',
                      style: TextStyle(
                        color: habit.color,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.white.withOpacity(0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(habit.color),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatItem(
                      label: 'Completed',
                      value: '${habit.completedDays}',
                      color: habit.color,
                    ),
                    _StatItem(
                      label: 'Remaining',
                      value: '${habit.totalDays - habit.completedDays}',
                      color: Colors.white70,
                    ),
                    _StatItem(
                      label: 'Total',
                      value: '${habit.totalDays}',
                      color: Colors.white70,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white54,
          ),
        ),
      ],
    );
  }
}

/// Data model for a habit
/// Fully customizable and extensible
class HabitData {
  final String id;
  final String name;
  final String emoji;
  final Color color;
  int completedDays;
  final int totalDays;

  HabitData({
    required this.id,
    required this.name,
    required this.emoji,
    required this.color,
    this.completedDays = 0,
    this.totalDays = 7,
  });

  double get progress => completedDays / totalDays;
  bool get isCompleted => completedDays >= totalDays;

  // Factory constructor for easy customization
  factory HabitData.create({
    required String id,
    required String name,
    String emoji = '✅',
    Color? color,
    int completedDays = 0,
    int totalDays = 7,
  }) {
    return HabitData(
      id: id,
      name: name,
      emoji: emoji,
      color: color ?? Colors.blue,
      completedDays: completedDays,
      totalDays: totalDays,
    );
  }
}