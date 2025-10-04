import 'dart:async';
import 'package:flutter/material.dart';

class AutoSaveIndicatorScreen extends StatefulWidget {
  const AutoSaveIndicatorScreen({Key? key}) : super(key: key);

  @override
  State<AutoSaveIndicatorScreen> createState() =>
      _AutoSaveIndicatorScreenState();
}

class _AutoSaveIndicatorScreenState extends State<AutoSaveIndicatorScreen> {
  final TextEditingController _controller = TextEditingController();
  final SmartAutoSaveController _saveController = SmartAutoSaveController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    _saveController.triggerSave();
  }

  @override
  void dispose() {
    _controller.dispose();
    _saveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0A0E21),
                  Color(0xFF1A1F3A),
                  Color(0xFF2D1B69),
                ],
              ),
            ),
          ),

          // Floating particles effect
          ...List.generate(20, (index) => _FloatingParticle(index: index)),

          // Main Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),

                  // Header
                  _buildHeader(),

                  const SizedBox(height: 48),

                  // Editor Card
                  _buildEditorCard(),

                  const SizedBox(height: 24),

                  // Info Card
                  _buildInfoCard(),
                ],
              ),
            ),
          ),

          // Smart Auto Save Indicator
          SmartAutoSaveIndicator(
            controller: _saveController,
            position: AutoSavePosition.topRight,
            savingText: 'Saving...',
            savedText: 'All changes saved',
            style: AutoSaveStyle.glassmorphic,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFF5A52D5)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6C63FF).withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.auto_awesome,
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
                    'Smart Auto Save',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Text(
                    'Real-time saving indicator',
                    style: TextStyle(fontSize: 14, color: Color(0xFF8F8E94)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEditorCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1C1F2E).withOpacity(0.6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6C63FF).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFF6C63FF).withOpacity(0.3),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.edit_note_rounded,
                          size: 16,
                          color: Color(0xFF6C63FF),
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Document Editor',
                          style: TextStyle(
                            color: Color(0xFF6C63FF),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _controller,
                maxLines: 12,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.6,
                ),
                decoration: InputDecoration(
                  hintText:
                      'Start typing... your changes will be saved automatically',
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.3),
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF6C63FF).withOpacity(0.15),
            const Color(0xFF5A52D5).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF6C63FF).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF6C63FF).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.info_outline,
              color: Color(0xFF6C63FF),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              'Watch the top-right corner! Type to see the magic ✨',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// SMART AUTO SAVE INDICATOR - MAIN COMPONENT
// ============================================================================

/// Position options for the auto-save indicator
enum AutoSavePosition { topLeft, topRight, bottomLeft, bottomRight }

/// Style variants for the indicator
enum AutoSaveStyle { glassmorphic, solid, minimal, gradient }

/// Controller to manage auto-save state with debouncing
class SmartAutoSaveController extends ChangeNotifier {
  Timer? _debounceTimer;
  Timer? _hideTimer;
  bool _isSaving = false;
  bool _isVisible = false;

  final Duration debounceDuration;
  final Duration displayDuration;

  SmartAutoSaveController({
    this.debounceDuration = const Duration(milliseconds: 800),
    this.displayDuration = const Duration(seconds: 2),
  });

  bool get isSaving => _isSaving;
  bool get isVisible => _isVisible;

  /// Trigger save with debouncing
  void triggerSave() {
    _debounceTimer?.cancel();
    _hideTimer?.cancel();

    _isSaving = true;
    _isVisible = true;
    notifyListeners();

    _debounceTimer = Timer(debounceDuration, () {
      _isSaving = false;
      notifyListeners();

      _hideTimer = Timer(displayDuration, () {
        _isVisible = false;
        notifyListeners();
      });
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _hideTimer?.cancel();
    super.dispose();
  }
}

/// The main Smart Auto Save Indicator widget
class SmartAutoSaveIndicator extends StatelessWidget {
  final SmartAutoSaveController controller;
  final AutoSavePosition position;
  final AutoSaveStyle style;
  final String savingText;
  final String savedText;
  final Duration animationDuration;
  final Color? primaryColor;
  final Color? backgroundColor;
  final double? fontSize;
  final EdgeInsets? margin;

  const SmartAutoSaveIndicator({
    Key? key,
    required this.controller,
    this.position = AutoSavePosition.topRight,
    this.style = AutoSaveStyle.glassmorphic,
    this.savingText = 'Saving...',
    this.savedText = 'Saved',
    this.animationDuration = const Duration(milliseconds: 400),
    this.primaryColor,
    this.backgroundColor,
    this.fontSize,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return AnimatedPositioned(
          duration: animationDuration,
          curve: Curves.easeOutCubic,
          top: _getTop(),
          right: _getRight(),
          bottom: _getBottom(),
          left: _getLeft(),
          child: AnimatedOpacity(
            opacity: controller.isVisible ? 1.0 : 0.0,
            duration: animationDuration,
            curve: Curves.easeInOut,
            child: AnimatedScale(
              scale: controller.isVisible ? 1.0 : 0.8,
              duration: animationDuration,
              curve: Curves.easeOutBack,
              child: Padding(
                padding: EdgeInsets.only(top: 40),
                child: _buildIndicator(context),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIndicator(BuildContext context) {
    switch (style) {
      case AutoSaveStyle.glassmorphic:
        return _GlassmorphicIndicator(
          isSaving: controller.isSaving,
          savingText: savingText,
          savedText: savedText,
          primaryColor: primaryColor,
          fontSize: fontSize,
        );
      case AutoSaveStyle.solid:
        return _SolidIndicator(
          isSaving: controller.isSaving,
          savingText: savingText,
          savedText: savedText,
          primaryColor: primaryColor,
          backgroundColor: backgroundColor,
          fontSize: fontSize,
        );
      case AutoSaveStyle.minimal:
        return _MinimalIndicator(
          isSaving: controller.isSaving,
          savingText: savingText,
          savedText: savedText,
          primaryColor: primaryColor,
          fontSize: fontSize,
        );
      case AutoSaveStyle.gradient:
        return _GradientIndicator(
          isSaving: controller.isSaving,
          savingText: savingText,
          savedText: savedText,
          primaryColor: primaryColor,
          fontSize: fontSize,
        );
    }
  }

  double? _getTop() {
    final m = margin ?? const EdgeInsets.all(24);
    switch (position) {
      case AutoSavePosition.topLeft:
      case AutoSavePosition.topRight:
        return m.top;
      default:
        return null;
    }
  }

  double? _getRight() {
    final m = margin ?? const EdgeInsets.all(24);
    switch (position) {
      case AutoSavePosition.topRight:
      case AutoSavePosition.bottomRight:
        return m.right;
      default:
        return null;
    }
  }

  double? _getBottom() {
    final m = margin ?? const EdgeInsets.all(24);
    switch (position) {
      case AutoSavePosition.bottomLeft:
      case AutoSavePosition.bottomRight:
        return m.bottom;
      default:
        return null;
    }
  }

  double? _getLeft() {
    final m = margin ?? const EdgeInsets.all(24);
    switch (position) {
      case AutoSavePosition.topLeft:
      case AutoSavePosition.bottomLeft:
        return m.left;
      default:
        return null;
    }
  }
}

// ============================================================================
// INDICATOR STYLE IMPLEMENTATIONS
// ============================================================================

/// Glassmorphic style indicator
class _GlassmorphicIndicator extends StatelessWidget {
  final bool isSaving;
  final String savingText;
  final String savedText;
  final Color? primaryColor;
  final double? fontSize;

  const _GlassmorphicIndicator({
    required this.isSaving,
    required this.savingText,
    required this.savedText,
    this.primaryColor,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final color = primaryColor ?? const Color(0xFF6C63FF);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isSaving)
            _LoadingSpinner(color: color)
          else
            Icon(Icons.check_circle_rounded, color: color, size: 20),
          const SizedBox(width: 10),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: Text(
              isSaving ? savingText : savedText,
              key: ValueKey(isSaving),
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize ?? 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Solid style indicator
class _SolidIndicator extends StatelessWidget {
  final bool isSaving;
  final String savingText;
  final String savedText;
  final Color? primaryColor;
  final Color? backgroundColor;
  final double? fontSize;

  const _SolidIndicator({
    required this.isSaving,
    required this.savingText,
    required this.savedText,
    this.primaryColor,
    this.backgroundColor,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final color = primaryColor ?? const Color(0xFF6C63FF);
    final bgColor = backgroundColor ?? color.withOpacity(0.15);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isSaving)
            _LoadingSpinner(color: color)
          else
            Icon(Icons.check_circle_rounded, color: color, size: 20),
          const SizedBox(width: 10),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              isSaving ? savingText : savedText,
              key: ValueKey(isSaving),
              style: TextStyle(
                color: color,
                fontSize: fontSize ?? 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Minimal style indicator
class _MinimalIndicator extends StatelessWidget {
  final bool isSaving;
  final String savingText;
  final String savedText;
  final Color? primaryColor;
  final double? fontSize;

  const _MinimalIndicator({
    required this.isSaving,
    required this.savingText,
    required this.savedText,
    this.primaryColor,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final color = primaryColor ?? const Color(0xFF6C63FF);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isSaving)
            _LoadingSpinner(color: color, size: 16)
          else
            Icon(Icons.check_circle_rounded, color: color, size: 16),
          const SizedBox(width: 8),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              isSaving ? savingText : savedText,
              key: ValueKey(isSaving),
              style: TextStyle(
                color: Colors.white70,
                fontSize: fontSize ?? 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Gradient style indicator
class _GradientIndicator extends StatelessWidget {
  final bool isSaving;
  final String savingText;
  final String savedText;
  final Color? primaryColor;
  final double? fontSize;

  const _GradientIndicator({
    required this.isSaving,
    required this.savingText,
    required this.savedText,
    this.primaryColor,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final color = primaryColor ?? const Color(0xFF6C63FF);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.8), color.withOpacity(0.6)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isSaving)
            _LoadingSpinner(color: Colors.white)
          else
            const Icon(
              Icons.check_circle_rounded,
              color: Colors.white,
              size: 20,
            ),
          const SizedBox(width: 10),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              isSaving ? savingText : savedText,
              key: ValueKey(isSaving),
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize ?? 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// HELPER WIDGETS
// ============================================================================

/// Custom loading spinner widget
class _LoadingSpinner extends StatefulWidget {
  final Color color;
  final double size;

  const _LoadingSpinner({required this.color, this.size = 20});

  @override
  State<_LoadingSpinner> createState() => _LoadingSpinnerState();
}

class _LoadingSpinnerState extends State<_LoadingSpinner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: Icon(Icons.sync_rounded, color: widget.color, size: widget.size),
    );
  }
}

/// Floating particle for background effect
class _FloatingParticle extends StatefulWidget {
  final int index;

  const _FloatingParticle({required this.index});

  @override
  State<_FloatingParticle> createState() => _FloatingParticleState();
}

class _FloatingParticleState extends State<_FloatingParticle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late double _startX;
  late double _startY;
  late double _size;

  @override
  void initState() {
    super.initState();
    _startX = (widget.index * 50) % 400;
    _startY = (widget.index * 80) % 800;
    _size = 2 + (widget.index % 3);

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10 + (widget.index % 5)),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0,
      end: 100,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          left: _startX + _animation.value,
          top: _startY + (_animation.value * 0.5),
          child: Container(
            width: _size,
            height: _size,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6C63FF).withOpacity(0.2),
                  blurRadius: 10,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
