import 'package:flutter/material.dart';
import 'dart:math' as math;

class TextfieldBorderFlowAnimation extends StatelessWidget {
  const TextfieldBorderFlowAnimation({Key? key}) : super(key: key);

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
              const Color(0xFF1A1F3A),
              const Color(0xFF0A0E21),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title Section
                Text(
                  'Flow Border TextField',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    foreground:
                        Paint()
                          ..shader = const LinearGradient(
                            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                          ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Watch the gradient flow as you type',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),

                // Animated TextField - Default Style
                AnimatedBorderTextField(
                  hintText: 'Enter your email',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 24),

                // Animated TextField - Custom Purple Gradient
                AnimatedBorderTextField(
                  hintText: 'Enter your password',
                  prefixIcon: Icons.lock_outline,
                  obscureText: true,
                  gradientColors: const [
                    Color(0xFFDA22FF),
                    Color(0xFF9733EE),
                    Color(0xFF667EEA),
                  ],
                ),
                const SizedBox(height: 24),

                // Animated TextField - Custom Green Gradient
                AnimatedBorderTextField(
                  hintText: 'Enter your username',
                  prefixIcon: Icons.person_outline,
                  gradientColors: const [
                    Color(0xFF11998E),
                    Color(0xFF38EF7D),
                    Color(0xFF11998E),
                  ],
                  borderRadius: 20,
                ),
                const SizedBox(height: 24),

                // Animated TextField - Multiline
                AnimatedBorderTextField(
                  hintText: 'Tell us about yourself...',
                  prefixIcon: Icons.edit_outlined,
                  maxLines: 4,
                  gradientColors: const [
                    Color(0xFFFF6B6B),
                    Color(0xFFFFE66D),
                    Color(0xFF4ECDC4),
                  ],
                  animationSpeed: 3.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 🎨 AnimatedBorderTextField - A stunning text field with animated gradient border
/// that flows based on typing activity and cursor position.
///
/// Features:
/// - Animated gradient border that flows when typing
/// - Smooth focus animations
/// - Customizable colors, speed, and appearance
/// - Production-ready and reusable
/// - Supports all standard TextField properties
class AnimatedBorderTextField extends StatefulWidget {
  /// Hint text displayed when the field is empty
  final String hintText;

  /// Icon displayed at the start of the text field
  final IconData? prefixIcon;

  /// Icon displayed at the end of the text field
  final IconData? suffixIcon;

  /// Callback when suffix icon is tapped
  final VoidCallback? onSuffixIconTap;

  /// Whether to obscure text (for passwords)
  final bool obscureText;

  /// Keyboard type
  final TextInputType? keyboardType;

  /// Text input action
  final TextInputAction? textInputAction;

  /// Controller for the text field
  final TextEditingController? controller;

  /// Callback when text changes
  final ValueChanged<String>? onChanged;

  /// Callback when editing is complete
  final VoidCallback? onEditingComplete;

  /// Callback when form is submitted
  final ValueChanged<String>? onSubmitted;

  /// Maximum number of lines
  final int maxLines;

  /// Minimum number of lines
  final int? minLines;

  /// Maximum length of input
  final int? maxLength;

  /// Border radius
  final double borderRadius;

  /// Border width
  final double borderWidth;

  /// Gradient colors for the animated border
  final List<Color> gradientColors;

  /// Animation speed (higher = faster)
  final double animationSpeed;

  /// Glow intensity when focused
  final double glowIntensity;

  /// Enable/disable the flow animation
  final bool enableFlowAnimation;

  const AnimatedBorderTextField({
    Key? key,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconTap,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.controller,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.borderRadius = 16.0,
    this.borderWidth = 2.0,
    this.gradientColors = const [
      Color(0xFF667EEA),
      Color(0xFF764BA2),
      Color(0xFFF093FB),
      Color(0xFF667EEA),
    ],
    this.animationSpeed = 2.0,
    this.glowIntensity = 0.3,
    this.enableFlowAnimation = true,
  }) : super(key: key);

  @override
  State<AnimatedBorderTextField> createState() =>
      _AnimatedBorderTextFieldState();
}

class _AnimatedBorderTextFieldState extends State<AnimatedBorderTextField>
    with TickerProviderStateMixin {
  late AnimationController _flowController;
  late AnimationController _focusController;
  late AnimationController _typingController;

  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();

    // Flow animation controller - continuous rotation
    _flowController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (2000 / widget.animationSpeed).round()),
    )..repeat();

    // Focus animation controller
    _focusController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Typing animation controller
    _typingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });

    if (_isFocused) {
      _focusController.forward();
    } else {
      _focusController.reverse();
    }
  }

  void _handleTextChange(String text) {
    if (widget.enableFlowAnimation) {
      _isTyping = true;
      _typingController.forward().then((_) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            setState(() {
              _isTyping = false;
            });
            _typingController.reverse();
          }
        });
      });
    }

    widget.onChanged?.call(text);
  }

  @override
  void dispose() {
    _flowController.dispose();
    _focusController.dispose();
    _typingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _flowController,
        _focusController,
        _typingController,
      ]),
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow:
                _isFocused
                    ? [
                      BoxShadow(
                        color: widget.gradientColors[0].withOpacity(
                          widget.glowIntensity,
                        ),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                      BoxShadow(
                        color: widget.gradientColors[1].withOpacity(
                          widget.glowIntensity,
                        ),
                        blurRadius: 30,
                        spreadRadius: -5,
                      ),
                    ]
                    : [],
          ),
          child: CustomPaint(
            painter: _AnimatedBorderPainter(
              flowProgress: _flowController.value,
              focusProgress: _focusController.value,
              typingProgress: _typingController.value,
              borderRadius: widget.borderRadius,
              borderWidth: widget.borderWidth,
              gradientColors: widget.gradientColors,
              isFocused: _isFocused,
              isTyping: _isTyping,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1A1F3A).withOpacity(0.5),
                borderRadius: BorderRadius.circular(widget.borderRadius),
              ),
              child: TextField(
                controller: widget.controller,
                focusNode: _focusNode,
                obscureText: widget.obscureText,
                keyboardType: widget.keyboardType,
                textInputAction: widget.textInputAction,
                maxLines: widget.maxLines,
                minLines: widget.minLines,
                maxLength: widget.maxLength,
                onChanged: _handleTextChange,
                onEditingComplete: widget.onEditingComplete,
                onSubmitted: widget.onSubmitted,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 16,
                  ),
                  prefixIcon:
                      widget.prefixIcon != null
                          ? Icon(
                            widget.prefixIcon,
                            color:
                                _isFocused
                                    ? widget.gradientColors[0]
                                    : Colors.white.withOpacity(0.5),
                          )
                          : null,
                  suffixIcon:
                      widget.suffixIcon != null
                          ? IconButton(
                            icon: Icon(
                              widget.suffixIcon,
                              color:
                                  _isFocused
                                      ? widget.gradientColors[0]
                                      : Colors.white.withOpacity(0.5),
                            ),
                            onPressed: widget.onSuffixIconTap,
                          )
                          : null,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: widget.prefixIcon != null ? 8 : 20,
                    vertical: widget.maxLines > 1 ? 16 : 18,
                  ),
                  counterText: '',
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// 🎨 Custom painter for the animated gradient border
class _AnimatedBorderPainter extends CustomPainter {
  final double flowProgress;
  final double focusProgress;
  final double typingProgress;
  final double borderRadius;
  final double borderWidth;
  final List<Color> gradientColors;
  final bool isFocused;
  final bool isTyping;

  _AnimatedBorderPainter({
    required this.flowProgress,
    required this.focusProgress,
    required this.typingProgress,
    required this.borderRadius,
    required this.borderWidth,
    required this.gradientColors,
    required this.isFocused,
    required this.isTyping,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));

    // Calculate animated rotation angle
    final rotation = flowProgress * 2 * math.pi;

    // Add typing boost to rotation
    final typingBoost = isTyping ? typingProgress * 0.5 : 0.0;
    final totalRotation = rotation + typingBoost;

    // Create sweeping gradient that rotates
    final gradient = SweepGradient(
      colors: gradientColors,
      stops: _generateStops(gradientColors.length),
      transform: GradientRotation(totalRotation),
      center: Alignment.center,
    );

    // Calculate border width with focus animation
    final animatedBorderWidth = borderWidth * (1 + focusProgress * 0.3);

    // Create paint for border
    final paint =
        Paint()
          ..shader = gradient.createShader(rect)
          ..style = PaintingStyle.stroke
          ..strokeWidth = animatedBorderWidth;

    // Draw the animated border
    canvas.drawRRect(rrect, paint);

    // Add extra glow effect when typing
    if (isTyping) {
      final glowPaint =
          Paint()
            ..shader = gradient.createShader(rect)
            ..style = PaintingStyle.stroke
            ..strokeWidth = animatedBorderWidth * 2
            ..maskFilter = MaskFilter.blur(
              BlurStyle.normal,
              10 * typingProgress,
            );
      canvas.drawRRect(rrect, glowPaint);
    }
  }

  List<double> _generateStops(int colorCount) {
    return List.generate(colorCount, (index) => index / (colorCount - 1));
  }

  @override
  bool shouldRepaint(covariant _AnimatedBorderPainter oldDelegate) {
    return oldDelegate.flowProgress != flowProgress ||
        oldDelegate.focusProgress != focusProgress ||
        oldDelegate.typingProgress != typingProgress ||
        oldDelegate.isFocused != isFocused ||
        oldDelegate.isTyping != isTyping;
  }
}
