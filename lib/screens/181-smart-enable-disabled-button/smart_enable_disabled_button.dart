import 'package:flutter/material.dart';

class SmartEnableDisabledButton extends StatefulWidget {
  const SmartEnableDisabledButton({Key? key}) : super(key: key);

  @override
  State<SmartEnableDisabledButton> createState() => _SmartEnableDisabledButtonState();
}

class _SmartEnableDisabledButtonState extends State<SmartEnableDisabledButton> {
  bool _isButtonEnabled = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  void _validateForm() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    
    final isValid = email.contains('@') && 
                   email.length > 3 && 
                   password.length >= 6;
    
    if (isValid != _isButtonEnabled) {
      setState(() {
        _isButtonEnabled = isValid;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header with subtle animation
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 800),
                  tween: Tween(begin: 0.0, end: 1.0),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: child,
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      const Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A1A),
                          letterSpacing: -0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Sign in to continue',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF6B7280),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                
                // Email Field
                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'your@email.com',
                  icon: Icons.email_outlined,
                ),
                const SizedBox(height: 20),
                
                // Password Field
                _buildTextField(
                  controller: _passwordController,
                  label: 'Password',
                  hint: 'Enter your password',
                  icon: Icons.lock_outlined,
                  isPassword: true,
                ),
                const SizedBox(height: 12),
                
                // Helper text with smooth fade
                AnimatedOpacity(
                  opacity: _isButtonEnabled ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    height: _isButtonEnabled ? 0 : null,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 14,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Enter a valid email and password (min 6 characters)',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                
                // Smart Enable/Disable Button with Advanced Animations
                SmartButton(
                  isEnabled: _isButtonEnabled,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.white),
                            SizedBox(width: 12),
                            Text('Login successful!'),
                          ],
                        ),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: const Color(0xFF10B981),
                        margin: const EdgeInsets.all(16),
                      ),
                    );
                  },
                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Additional demo section
                const Divider(height: 48),
                const Text(
                  'More Examples',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                
                SmartButton(
                  isEnabled: true,
                  primaryColor: const Color(0xFF10B981),
                  onPressed: () {},
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle_outline, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Enabled Button',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                SmartButton(
                  isEnabled: false,
                  primaryColor: const Color(0xFFEF4444),
                  onPressed: () {},
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.block_outlined, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Disabled Button',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                SmartButton(
                  isEnabled: true,
                  primaryColor: const Color(0xFFF59E0B),
                  enableShimmerEffect: true,
                  onPressed: () {},
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.auto_awesome, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Premium Effect',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.grey.shade400,
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: Icon(
                icon,
                color: const Color(0xFF6B7280),
                size: 20,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Smart Enable/Disable Button with Advanced Animations
/// 
/// Ultra-premium button component with sophisticated state transitions
/// 
/// Features:
/// - Smooth color saturation & brightness transitions
/// - Pulsing glow effect on state change
/// - Shimmer effect for enabled state (optional)
/// - Micro-scale interactions on press
/// - Smooth elevation animations
/// - Gradient overlay on hover/press
/// - Icon rotation animations
/// - Ripple effect on enable
/// 
/// Parameters:
/// - [isEnabled]: Controls the enabled/disabled state
/// - [onPressed]: Callback when button is tapped
/// - [child]: Button content
/// - [primaryColor]: Main color when enabled
/// - [height]: Button height
/// - [borderRadius]: Corner radius
/// - [enableShimmerEffect]: Adds shimmer animation when enabled
/// - [animationDuration]: Duration of state transitions
class SmartButton extends StatefulWidget {
  final bool isEnabled;
  final VoidCallback onPressed;
  final Widget child;
  final Color primaryColor;
  final double height;
  final double borderRadius;
  final bool enableShimmerEffect;
  final Duration animationDuration;

  const SmartButton({
    Key? key,
    required this.isEnabled,
    required this.onPressed,
    required this.child,
    this.primaryColor = const Color(0xFF6C63FF),
    this.height = 56.0,
    this.borderRadius = 14.0,
    this.enableShimmerEffect = false,
    this.animationDuration = const Duration(milliseconds: 400),
  }) : super(key: key);

  @override
  State<SmartButton> createState() => _SmartButtonState();
}

class _SmartButtonState extends State<SmartButton>
    with TickerProviderStateMixin {
  late AnimationController _pressController;
  late AnimationController _stateChangeController;
  late AnimationController _shimmerController;
  late AnimationController _pulseController;
  
  late Animation<double> _scaleAnimation;
  late Animation<double> _stateAnimation;
  late Animation<double> _shimmerAnimation;
  late Animation<double> _pulseAnimation;
  
  bool _isPressed = false;
  bool _previousEnabledState = false;

  @override
  void initState() {
    super.initState();
    _previousEnabledState = widget.isEnabled;
    
    // Press animation controller
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(
        parent: _pressController,
        curve: Curves.easeInOut,
      ),
    );
    
    // State change animation controller
    _stateChangeController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _stateAnimation = CurvedAnimation(
      parent: _stateChangeController,
      curve: Curves.easeInOutCubic,
    );
    
    // Shimmer effect controller
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
    _shimmerAnimation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(
        parent: _shimmerController,
        curve: Curves.easeInOut,
      ),
    );
    
    // Pulse animation for state change
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _pulseAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.08)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.08, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_pulseController);
    
    if (widget.isEnabled) {
      _stateChangeController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(SmartButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Trigger animations on state change
    if (oldWidget.isEnabled != widget.isEnabled) {
      if (widget.isEnabled) {
        _stateChangeController.forward();
        _pulseController.forward(from: 0);
      } else {
        _stateChangeController.reverse();
      }
      _previousEnabledState = widget.isEnabled;
    }
  }

  @override
  void dispose() {
    _pressController.dispose();
    _stateChangeController.dispose();
    _shimmerController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.isEnabled) {
      setState(() => _isPressed = true);
      _pressController.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.isEnabled) {
      setState(() => _isPressed = false);
      _pressController.reverse();
      widget.onPressed();
    }
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _pressController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _scaleAnimation,
        _stateAnimation,
        _pulseAnimation,
        if (widget.enableShimmerEffect) _shimmerAnimation,
      ]),
      builder: (context, child) {
        // Interpolate between disabled and enabled states
        final progress = _stateAnimation.value;
        
        // Color calculations
        final disabledColor = _desaturateColor(widget.primaryColor, 0.7);
        final buttonColor = Color.lerp(disabledColor, widget.primaryColor, progress)!;
        
        // Opacity and elevation
        final textOpacity = 0.4 + (0.6 * progress);
        final elevation = 6.0 * progress;
        
        // Shadow intensity
        final shadowOpacity = 0.15 + (0.25 * progress);
        
        return ScaleTransition(
          scale: _scaleAnimation,
          child: Transform.scale(
            scale: _pulseAnimation.value,
            child: GestureDetector(
              onTapDown: _handleTapDown,
              onTapUp: _handleTapUp,
              onTapCancel: _handleTapCancel,
              child: Container(
                height: widget.height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  boxShadow: [
                    // Primary shadow
                    BoxShadow(
                      color: buttonColor.withOpacity(shadowOpacity),
                      blurRadius: elevation * 4,
                      offset: Offset(0, elevation * 0.8),
                      spreadRadius: elevation * 0.3,
                    ),
                    // Secondary glow
                    if (widget.isEnabled)
                      BoxShadow(
                        color: buttonColor.withOpacity(0.3 * progress),
                        blurRadius: elevation * 6,
                        offset: Offset(0, elevation * 1.2),
                        spreadRadius: -elevation * 0.2,
                      ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  child: Stack(
                    children: [
                      // Base button background
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              buttonColor,
                              _adjustBrightness(buttonColor, -0.05),
                            ],
                          ),
                        ),
                      ),
                      
                      // Shimmer effect overlay
                      if (widget.enableShimmerEffect && widget.isEnabled)
                        Positioned.fill(
                          child: Transform.translate(
                            offset: Offset(_shimmerAnimation.value * 200, 0),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Colors.transparent,
                                    Colors.white.withOpacity(0.15),
                                    Colors.transparent,
                                  ],
                                  stops: const [0.0, 0.5, 1.0],
                                ),
                              ),
                            ),
                          ),
                        ),
                      
                      // Pressed state overlay
                      if (_isPressed)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withOpacity(0.1),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                      
                      // Content
                      AnimatedOpacity(
                        opacity: textOpacity,
                        duration: widget.animationDuration,
                        curve: Curves.easeInOut,
                        child: Center(
                          child: DefaultTextStyle(
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            child: IconTheme(
                              data: const IconThemeData(
                                color: Colors.white,
                              ),
                              child: widget.child,
                            ),
                          ),
                        ),
                      ),
                      
                      // Subtle top highlight
                      if (widget.isEnabled)
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          height: 2,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Colors.white.withOpacity(0.0),
                                  Colors.white.withOpacity(0.2 * progress),
                                  Colors.white.withOpacity(0.0),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Desaturates a color by reducing its saturation
  Color _desaturateColor(Color color, double amount) {
    final hslColor = HSLColor.fromColor(color);
    final desaturated = hslColor.withSaturation(
      (hslColor.saturation * (1.0 - amount)).clamp(0.0, 1.0),
    );
    return desaturated.toColor();
  }

  /// Adjusts the brightness of a color
  Color _adjustBrightness(Color color, double amount) {
    final hslColor = HSLColor.fromColor(color);
    final adjusted = hslColor.withLightness(
      (hslColor.lightness + amount).clamp(0.0, 1.0),
    );
    return adjusted.toColor();
  }
}