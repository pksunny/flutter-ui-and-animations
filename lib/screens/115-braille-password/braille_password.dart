import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;


class BraillePassword extends StatefulWidget {
  @override
  _BraillePasswordState createState() => _BraillePasswordState();
}

class _BraillePasswordState extends State<BraillePassword> {
  final TextEditingController _controller = TextEditingController();
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A0A0A),
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [Colors.cyan, Colors.purple, Colors.pink],
                  ).createShader(bounds),
                  child: Text(
                    'Braille Password',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Enter your secure password',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 60),
                
                // Animated Braille Password Widget
                AnimatedBraillePassword(
                  controller: _controller,
                  maxLength: 12,
                  onChanged: (value) {
                    print('Password: $value');
                  },
                  onSubmitted: (value) {
                    print('Submitted: $value');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Password entered: ${value.length} characters'),
                        backgroundColor: Colors.cyan,
                      ),
                    );
                  },
                  // Customization options
                  dotSize: 12.0,
                  dotSpacing: 16.0,
                  animationDuration: Duration(milliseconds: 800),
                  primaryColor: Colors.cyan,
                  secondaryColor: Colors.purple,
                  backgroundColor: Colors.white.withOpacity(0.1),
                ),
                
                SizedBox(height: 40),
                
                // Toggle visibility button
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isVisible = !_isVisible;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.cyan.withOpacity(0.5)),
                      gradient: LinearGradient(
                        colors: [
                          Colors.cyan.withOpacity(0.1),
                          Colors.purple.withOpacity(0.1),
                        ],
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _isVisible ? Icons.visibility_off : Icons.visibility,
                          color: Colors.cyan,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          _isVisible ? 'Hide' : 'Show',
                          style: TextStyle(color: Colors.cyan),
                        ),
                      ],
                    ),
                  ),
                ),
                
                if (_isVisible) ...[
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.black.withOpacity(0.3),
                      border: Border.all(color: Colors.cyan.withOpacity(0.3)),
                    ),
                    child: Text(
                      'Password: ${_controller.text}',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

/// Animated Braille Password Widget
/// A highly customizable, production-ready password input widget
/// that displays dots in a fluid, animated Braille-like pattern
class AnimatedBraillePassword extends StatefulWidget {
  /// Controller for the password input
  final TextEditingController? controller;
  
  /// Maximum number of characters allowed
  final int maxLength;
  
  /// Callback when password changes
  final ValueChanged<String>? onChanged;
  
  /// Callback when password is submitted
  final ValueChanged<String>? onSubmitted;
  
  /// Size of each Braille dot
  final double dotSize;
  
  /// Spacing between dots
  final double dotSpacing;
  
  /// Animation duration for morphing effects
  final Duration animationDuration;
  
  /// Primary color for active dots
  final Color primaryColor;
  
  /// Secondary color for gradient effects
  final Color secondaryColor;
  
  /// Background color of the input field
  final Color backgroundColor;
  
  /// Border radius of the input container
  final double borderRadius;
  
  /// Whether to show floating label
  final bool showLabel;
  
  /// Label text
  final String labelText;
  
  /// Whether to enable haptic feedback
  final bool enableHapticFeedback;

  const AnimatedBraillePassword({
    Key? key,
    this.controller,
    this.maxLength = 8,
    this.onChanged,
    this.onSubmitted,
    this.dotSize = 10.0,
    this.dotSpacing = 14.0,
    this.animationDuration = const Duration(milliseconds: 600),
    this.primaryColor = Colors.cyan,
    this.secondaryColor = Colors.purple,
    this.backgroundColor = const Color(0xFF1A1A2E),
    this.borderRadius = 16.0,
    this.showLabel = false,
    this.labelText = 'Password',
    this.enableHapticFeedback = true,
  }) : super(key: key);

  @override
  _AnimatedBraillePasswordState createState() => _AnimatedBraillePasswordState();
}

class _AnimatedBraillePasswordState extends State<AnimatedBraillePassword>
    with TickerProviderStateMixin {
  
  late TextEditingController _controller;
  late AnimationController _pulseController;
  late AnimationController _morphController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _morphAnimation;
  late FocusNode _textFieldFocusNode;
  
  String _password = '';
  bool _isFocused = false;
  List<AnimationController> _dotControllers = [];
  List<Animation<double>> _dotAnimations = [];

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _textFieldFocusNode = FocusNode();
    
    // Listen to focus changes
    _textFieldFocusNode.addListener(() {
      setState(() {
        _isFocused = _textFieldFocusNode.hasFocus;
      });
    });
    
    // Initialize animation controllers
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _morphController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _morphAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _morphController,
      curve: Curves.elasticOut,
    ));
    
    // Initialize dot animations
    _initializeDotAnimations();
    
    // Start pulse animation
    _pulseController.repeat(reverse: true);
    
    _controller.addListener(_onPasswordChanged);
  }

  void _initializeDotAnimations() {
    for (int i = 0; i < widget.maxLength; i++) {
      final controller = AnimationController(
        duration: Duration(milliseconds: 300 + (i * 50)),
        vsync: this,
      );
      
      final animation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.elasticOut,
      ));
      
      _dotControllers.add(controller);
      _dotAnimations.add(animation);
    }
  }

  void _onPasswordChanged() {
    final newPassword = _controller.text;
    if (newPassword != _password) {
      setState(() {
        _password = newPassword;
      });
      
      // Trigger haptic feedback
      if (widget.enableHapticFeedback) {
        HapticFeedback.lightImpact();
      }
      
      // Animate new dots
      if (newPassword.length > _password.length) {
        final index = newPassword.length - 1;
        if (index < _dotControllers.length) {
          _dotControllers[index].forward();
        }
      }
      
      // Animate morphing effect
      _morphController.forward().then((_) {
        _morphController.reverse();
      });
      
      widget.onChanged?.call(newPassword);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final availableWidth = screenWidth - 64; // Account for padding
    final maxDotWidth = (availableWidth - 40) / widget.maxLength; // Container padding
    final actualDotSpacing = math.min(widget.dotSpacing, maxDotWidth * 0.5);
    final actualDotSize = math.min(widget.dotSize, maxDotWidth * 0.6);

    return GestureDetector(
      onTap: () {
        // Show keyboard properly
        FocusScope.of(context).requestFocus(_textFieldFocusNode);
      },
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(
            color: _isFocused 
                ? widget.primaryColor.withOpacity(0.8)
                : widget.primaryColor.withOpacity(0.3),
            width: 2,
          ),
          boxShadow: [
            if (_isFocused)
              BoxShadow(
                color: widget.primaryColor.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 2,
              ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.showLabel) ...[
              Text(
                widget.labelText,
                style: TextStyle(
                  color: widget.primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 16),
            ],
            
            // Braille Dots Display with responsive sizing
            Container(
              height: 60,
              width: double.infinity,
              child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(widget.maxLength, (index) {
                      return AnimatedBuilder(
                        animation: Listenable.merge([
                          _pulseAnimation,
                          _morphAnimation,
                          if (index < _dotAnimations.length) _dotAnimations[index],
                        ]),
                        builder: (context, child) {
                          final isActive = index < _password.length;
                          final dotScale = isActive 
                              ? _dotAnimations[index].value
                              : 0.3;
                          
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: actualDotSpacing / 2),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Outer glow effect
                                if (isActive)
                                  AnimatedBuilder(
                                    animation: _pulseAnimation,
                                    builder: (context, child) {
                                      return Container(
                                        width: actualDotSize * 2.5 * _pulseAnimation.value,
                                        height: actualDotSize * 2.5 * _pulseAnimation.value,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: RadialGradient(
                                            colors: [
                                              widget.primaryColor.withOpacity(0.3),
                                              Colors.transparent,
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                
                                // Main dot with morphing effect
                                Transform.scale(
                                  scale: dotScale * (1 + _morphAnimation.value * 0.3),
                                  child: Container(
                                    width: actualDotSize,
                                    height: actualDotSize,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: isActive
                                            ? [
                                                widget.primaryColor,
                                                widget.secondaryColor,
                                              ]
                                            : [
                                                Colors.grey.withOpacity(0.3),
                                                Colors.grey.withOpacity(0.1),
                                              ],
                                      ),
                                      boxShadow: isActive
                                          ? [
                                              BoxShadow(
                                                color: widget.primaryColor.withOpacity(0.6),
                                                blurRadius: 8,
                                                spreadRadius: 1,
                                              ),
                                            ]
                                          : null,
                                    ),
                                  ),
                                ),
                                
                                // Fluid pattern overlay
                                if (isActive)
                                  AnimatedBuilder(
                                    animation: _morphAnimation,
                                    builder: (context, child) {
                                      return CustomPaint(
                                        size: Size(actualDotSize * 3, actualDotSize * 3),
                                        painter: FluidPatternPainter(
                                          progress: _morphAnimation.value,
                                          color: widget.primaryColor.withOpacity(0.4),
                                          dotIndex: index,
                                        ),
                                      );
                                    },
                                  ),
                              ],
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ),
              ),
            ),
            
            SizedBox(height: 20),
            
            // Visible TextField for proper input handling
            TextField(
              controller: _controller,
              focusNode: _textFieldFocusNode,
              obscureText: true,
              maxLength: widget.maxLength,
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done,
              onSubmitted: widget.onSubmitted,
              onChanged: (value) {
                // Additional safety check
                if (value.length <= widget.maxLength) {
                  _onPasswordChanged();
                } else {
                  // Truncate if somehow exceeds max length
                  _controller.text = value.substring(0, widget.maxLength);
                  _controller.selection = TextSelection.fromPosition(
                    TextPosition(offset: widget.maxLength),
                  );
                }
              },
              style: TextStyle(
                color: Colors.transparent,
                fontSize: 16,
              ),
              cursorColor: Colors.transparent,
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                counterText: '',
                hintText: '',
              ),
            ),
            
            // Interactive hint
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _isFocused ? Icons.keyboard : Icons.touch_app,
                    color: widget.primaryColor.withOpacity(0.7),
                    size: 16,
                  ),
                  SizedBox(width: 8),
                  Text(
                    _isFocused ? 'Enter your password' : 'Tap to enter password',
                    style: TextStyle(
                      color: widget.primaryColor.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            
            // Password strength indicator
            if (_password.isNotEmpty)
              Container(
                margin: EdgeInsets.only(top: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: _password.length / widget.maxLength,
                        backgroundColor: Colors.grey.withOpacity(0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getStrengthColor(),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      '${_password.length}/${widget.maxLength}',
                      style: TextStyle(
                        color: _getStrengthColor(),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getStrengthColor() {
    final ratio = _password.length / widget.maxLength;
    if (ratio < 0.3) return Colors.red;
    if (ratio < 0.6) return Colors.orange;
    if (ratio < 0.8) return Colors.yellow;
    return Colors.green;
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _morphController.dispose();
    _textFieldFocusNode.dispose();
    for (final controller in _dotControllers) {
      controller.dispose();
    }
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }
}

/// Custom painter for fluid pattern effects
class FluidPatternPainter extends CustomPainter {
  final double progress;
  final Color color;
  final int dotIndex;

  FluidPatternPainter({
    required this.progress,
    required this.color,
    required this.dotIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 3;

    // Create fluid ripple effect
    for (int i = 0; i < 3; i++) {
      final rippleProgress = (progress - (i * 0.2)).clamp(0.0, 1.0);
      final radius = maxRadius * rippleProgress;
      final opacity = (1 - rippleProgress) * 0.8;
      
      paint.color = color.withOpacity(opacity);
      canvas.drawCircle(center, radius, paint);
    }

    // Create connecting lines between dots (fluid pattern)
    if (progress > 0.5) {
      final lineProgress = (progress - 0.5) * 2;
      paint.color = color.withOpacity(lineProgress * 0.6);
      
      // Draw sine wave pattern
      final path = Path();
      final amplitude = 8 * lineProgress;
      final frequency = 2 + dotIndex;
      
      path.moveTo(0, size.height / 2);
      
      for (double x = 0; x <= size.width; x += 2) {
        final y = size.height / 2 + 
                  amplitude * math.sin((x / size.width) * frequency * 2 * math.pi);
        path.lineTo(x, y);
      }
      
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(FluidPatternPainter oldDelegate) {
    return oldDelegate.progress != progress ||
           oldDelegate.color != color ||
           oldDelegate.dotIndex != dotIndex;
  }
}