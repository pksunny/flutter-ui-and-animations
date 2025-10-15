import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Demo page showcasing the StepProgressIndicator widget
class StepProgress extends StatefulWidget {
  const StepProgress({Key? key}) : super(key: key);

  @override
  State<StepProgress> createState() => _StepProgressState();
}

class _StepProgressState extends State<StepProgress> {
  int _currentStep = 0;
  final int _totalSteps = 5;

  final List<StepData> _steps = [
    StepData(
      title: 'Account',
      subtitle: 'Create your profile',
      icon: Icons.person_outline,
    ),
    StepData(
      title: 'Verify',
      subtitle: 'Confirm your identity',
      icon: Icons.verified_user_outlined,
    ),
    StepData(
      title: 'Payment',
      subtitle: 'Add payment method',
      icon: Icons.credit_card_outlined,
    ),
    StepData(
      title: 'Preferences',
      subtitle: 'Set your choices',
      icon: Icons.tune_outlined,
    ),
    StepData(
      title: 'Complete',
      subtitle: 'You\'re all set!',
      icon: Icons.check_circle_outline,
    ),
  ];

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  void _goToStep(int step) {
    if (step >= 0 && step < _totalSteps) {
      setState(() {
        _currentStep = step;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF0A0E21),
              const Color(0xFF1D1E33),
              const Color(0xFF0A0E21),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Title
              const Text(
                'Step Progress Animation',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Next-Generation UI Experience',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white54,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 60),

              // Step Progress Indicator
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: StepProgressIndicator(
                  currentStep: _currentStep,
                  totalSteps: _totalSteps,
                  steps: _steps,
                  onStepTapped: _goToStep,
                  // Customization options
                  activeColor: const Color(0xFF00D9FF),
                  inactiveColor: const Color(0xFF2D3142),
                  completedColor: const Color(0xFF00FFB3),
                  lineHeight: 4,
                  circleSize: 48,
                  animationDuration: const Duration(milliseconds: 600),
                  pulseAnimation: true,
                  glowEffect: true,
                ),
              ),

              const SizedBox(height: 80),

              // Current Step Content Display
              Expanded(child: _buildStepContent()),

              // Navigation Buttons
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    // Previous Button
                    Expanded(
                      child: _AnimatedButton(
                        onPressed: _currentStep > 0 ? _previousStep : null,
                        label: 'Previous',
                        icon: Icons.arrow_back,
                        isPrimary: false,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Next Button
                    Expanded(
                      child: _AnimatedButton(
                        onPressed:
                            _currentStep < _totalSteps - 1 ? _nextStep : null,
                        label:
                            _currentStep == _totalSteps - 1 ? 'Finish' : 'Next',
                        icon:
                            _currentStep == _totalSteps - 1
                                ? Icons.check
                                : Icons.arrow_forward,
                        isPrimary: true,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    final step = _steps[_currentStep];
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 400),
      tween: Tween(begin: 0.0, end: 1.0),
      key: ValueKey(_currentStep),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 30),
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: const Color(0xFF1D1E33).withOpacity(0.5),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color(0xFF00D9FF).withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00D9FF).withOpacity(0.1),
              blurRadius: 30,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(step.icon, size: 80, color: const Color(0xFF00D9FF)),
            const SizedBox(height: 24),
            Text(
              step.title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              step.subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white60,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Step ${_currentStep + 1} of $_totalSteps',
              style: TextStyle(
                fontSize: 14,
                color: const Color(0xFF00D9FF).withOpacity(0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Data model for step information
class StepData {
  final String title;
  final String subtitle;
  final IconData icon;

  StepData({required this.title, required this.subtitle, required this.icon});
}

/// Ultra-stylish Step Progress Indicator Widget
///
/// A highly customizable, animated horizontal progress bar with step indicators.
/// Perfect for onboarding flows, checkout processes, and multi-step forms.
///
/// Features:
/// - Smooth animated transitions between steps
/// - Pulsing animations on active step
/// - Glowing effects for visual appeal
/// - Tap-to-navigate functionality
/// - Fully customizable colors and sizes
/// - Production-ready and reusable
class StepProgressIndicator extends StatefulWidget {
  /// Current active step (0-indexed)
  final int currentStep;

  /// Total number of steps
  final int totalSteps;

  /// List of step data (optional)
  final List<StepData>? steps;

  /// Callback when a step is tapped
  final Function(int)? onStepTapped;

  /// Color for the active step
  final Color activeColor;

  /// Color for inactive/pending steps
  final Color inactiveColor;

  /// Color for completed steps
  final Color completedColor;

  /// Height of the connecting line
  final double lineHeight;

  /// Size of the step circle
  final double circleSize;

  /// Duration of animations
  final Duration animationDuration;

  /// Enable pulse animation on active step
  final bool pulseAnimation;

  /// Enable glow effect
  final bool glowEffect;

  const StepProgressIndicator({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
    this.steps,
    this.onStepTapped,
    this.activeColor = const Color(0xFF00D9FF),
    this.inactiveColor = const Color(0xFF2D3142),
    this.completedColor = const Color(0xFF00FFB3),
    this.lineHeight = 4,
    this.circleSize = 48,
    this.animationDuration = const Duration(milliseconds: 600),
    this.pulseAnimation = true,
    this.glowEffect = true,
  }) : assert(currentStep >= 0 && currentStep < totalSteps),
       assert(totalSteps > 1),
       super(key: key);

  @override
  State<StepProgressIndicator> createState() => _StepProgressIndicatorState();
}

class _StepProgressIndicatorState extends State<StepProgressIndicator>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _pulseController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    // Progress animation controller
    _progressController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    // Pulse animation controller (continuous)
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    if (widget.pulseAnimation) {
      _pulseController.repeat(reverse: true);
    }

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _progressController,
        curve: Curves.easeInOutCubic,
      ),
    );

    _progressController.forward();
  }

  @override
  void didUpdateWidget(StepProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentStep != widget.currentStep) {
      _progressController.reset();
      _progressController.forward();
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final spacing = width / (widget.totalSteps - 1);

        return Column(
          children: [
            SizedBox(
              height: widget.circleSize,
              child: Stack(
                children: [
                  // Background line
                  _buildBackgroundLine(),
                  // Animated progress line
                  _buildProgressLine(spacing),
                  // Step circles
                  ..._buildStepCircles(spacing),
                ],
              ),
            ),
            if (widget.steps != null) ...[
              const SizedBox(height: 16),
              _buildStepLabels(spacing),
            ],
          ],
        );
      },
    );
  }

  Widget _buildBackgroundLine() {
    return Positioned(
      left: widget.circleSize / 2,
      right: widget.circleSize / 2,
      top: widget.circleSize / 2 - widget.lineHeight / 2,
      child: Container(
        height: widget.lineHeight,
        decoration: BoxDecoration(
          color: widget.inactiveColor,
          borderRadius: BorderRadius.circular(widget.lineHeight / 2),
        ),
      ),
    );
  }

  Widget _buildProgressLine(double spacing) {
    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, child) {
        final progress = widget.currentStep / (widget.totalSteps - 1);
        final animatedProgress = progress * _progressAnimation.value;

        return Positioned(
          left: widget.circleSize / 2,
          right: widget.circleSize / 2,
          top: widget.circleSize / 2 - widget.lineHeight / 2,
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: animatedProgress,
            child: Container(
              height: widget.lineHeight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [widget.completedColor, widget.activeColor],
                ),
                borderRadius: BorderRadius.circular(widget.lineHeight / 2),
                boxShadow:
                    widget.glowEffect
                        ? [
                          BoxShadow(
                            color: widget.activeColor.withOpacity(0.5),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ]
                        : null,
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildStepCircles(double spacing) {
    return List.generate(widget.totalSteps, (index) {
      final isCompleted = index < widget.currentStep;
      final isActive = index == widget.currentStep;
      final isPending = index > widget.currentStep;

      return Positioned(
        left: index * spacing,
        child: GestureDetector(
          onTap:
              widget.onStepTapped != null
                  ? () => widget.onStepTapped!(index)
                  : null,
          child: _StepCircle(
            index: index,
            isCompleted: isCompleted,
            isActive: isActive,
            isPending: isPending,
            activeColor: widget.activeColor,
            inactiveColor: widget.inactiveColor,
            completedColor: widget.completedColor,
            circleSize: widget.circleSize,
            pulseController: isActive ? _pulseController : null,
            glowEffect: widget.glowEffect,
            stepData:
                widget.steps != null && index < widget.steps!.length
                    ? widget.steps![index]
                    : null,
          ),
        ),
      );
    });
  }

  Widget _buildStepLabels(double spacing) {
    return SizedBox(
      height: 50,
      child: Stack(
        children: List.generate(widget.totalSteps, (index) {
          if (widget.steps == null || index >= widget.steps!.length) {
            return const SizedBox.shrink();
          }

          final step = widget.steps![index];
          final isActive = index == widget.currentStep;

          return Positioned(
            left: index * spacing - 40,
            width: 120,
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 300),
              tween: Tween(begin: 0.0, end: isActive ? 1.0 : 0.6),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Column(
                    children: [
                      Text(
                        step.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isActive ? 13 : 11,
                          fontWeight:
                              isActive ? FontWeight.w600 : FontWeight.w400,
                          color: isActive ? widget.activeColor : Colors.white60,
                          letterSpacing: 0.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}

/// Individual step circle widget with animations
class _StepCircle extends StatelessWidget {
  final int index;
  final bool isCompleted;
  final bool isActive;
  final bool isPending;
  final Color activeColor;
  final Color inactiveColor;
  final Color completedColor;
  final double circleSize;
  final AnimationController? pulseController;
  final bool glowEffect;
  final StepData? stepData;

  const _StepCircle({
    Key? key,
    required this.index,
    required this.isCompleted,
    required this.isActive,
    required this.isPending,
    required this.activeColor,
    required this.inactiveColor,
    required this.completedColor,
    required this.circleSize,
    this.pulseController,
    required this.glowEffect,
    this.stepData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color circleColor;
    if (isCompleted) {
      circleColor = completedColor;
    } else if (isActive) {
      circleColor = activeColor;
    } else {
      circleColor = inactiveColor;
    }

    Widget child = Container(
      width: circleSize,
      height: circleSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: circleColor,
        border: Border.all(
          color: Colors.white.withOpacity(isActive ? 0.3 : 0.1),
          width: 2,
        ),
        boxShadow:
            glowEffect && (isActive || isCompleted)
                ? [
                  BoxShadow(
                    color: circleColor.withOpacity(0.6),
                    blurRadius: isActive ? 20 : 12,
                    spreadRadius: isActive ? 4 : 2,
                  ),
                ]
                : null,
      ),
      child: Center(child: _buildIcon()),
    );

    // Add pulse animation for active step
    if (isActive && pulseController != null) {
      child = AnimatedBuilder(
        animation: pulseController!,
        builder: (context, childWidget) {
          final scale = 1.0 + (pulseController!.value * 0.1);
          return Transform.scale(scale: scale, child: childWidget);
        },
        child: child,
      );
    }

    // Add bounce animation when step becomes active or completed
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 400),
      tween: Tween(begin: 0.8, end: 1.0),
      curve: Curves.elasticOut,
      builder: (context, scale, childWidget) {
        return Transform.scale(scale: scale, child: childWidget);
      },
      child: child,
    );
  }

  Widget _buildIcon() {
    if (isCompleted) {
      return Icon(
        Icons.check_rounded,
        color: Colors.white,
        size: circleSize * 0.5,
      );
    } else if (isActive && stepData != null) {
      return Icon(stepData!.icon, color: Colors.white, size: circleSize * 0.45);
    } else {
      return Text(
        '${index + 1}',
        style: TextStyle(
          color: Colors.white.withOpacity(isPending ? 0.5 : 1.0),
          fontSize: circleSize * 0.35,
          fontWeight: FontWeight.bold,
        ),
      );
    }
  }
}

/// Animated button widget for navigation
class _AnimatedButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String label;
  final IconData icon;
  final bool isPrimary;

  const _AnimatedButton({
    Key? key,
    required this.onPressed,
    required this.label,
    required this.icon,
    required this.isPrimary,
  }) : super(key: key);

  @override
  State<_AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<_AnimatedButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.onPressed != null;

    return GestureDetector(
      onTapDown: isEnabled ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: isEnabled ? (_) => setState(() => _isPressed = false) : null,
      onTapCancel: isEnabled ? () => setState(() => _isPressed = false) : null,
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        height: 56,
        decoration: BoxDecoration(
          gradient:
              widget.isPrimary
                  ? LinearGradient(
                    colors:
                        isEnabled
                            ? [const Color(0xFF00D9FF), const Color(0xFF00FFB3)]
                            : [
                              const Color(0xFF2D3142),
                              const Color(0xFF2D3142),
                            ],
                  )
                  : null,
          color:
              !widget.isPrimary
                  ? (isEnabled
                      ? const Color(0xFF1D1E33)
                      : const Color(0xFF1D1E33).withOpacity(0.3))
                  : null,
          borderRadius: BorderRadius.circular(16),
          border:
              !widget.isPrimary
                  ? Border.all(
                    color: const Color(
                      0xFF00D9FF,
                    ).withOpacity(isEnabled ? 0.3 : 0.1),
                    width: 1.5,
                  )
                  : null,
          boxShadow:
              isEnabled && widget.isPrimary
                  ? [
                    BoxShadow(
                      color: const Color(0xFF00D9FF).withOpacity(0.3),
                      blurRadius: _isPressed ? 10 : 20,
                      spreadRadius: _isPressed ? 0 : 2,
                    ),
                  ]
                  : null,
        ),
        transform:
            Matrix4.identity()..scale(_isPressed && isEnabled ? 0.95 : 1.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.label == 'Previous')
              Icon(
                widget.icon,
                color: isEnabled ? Colors.white : Colors.white38,
                size: 20,
              ),
            const SizedBox(width: 8),
            Text(
              widget.label,
              style: TextStyle(
                color: isEnabled ? Colors.white : Colors.white38,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 8),
            if (widget.label != 'Previous')
              Icon(
                widget.icon,
                color: isEnabled ? Colors.white : Colors.white38,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
