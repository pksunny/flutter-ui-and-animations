import 'package:flutter/material.dart';
import 'dart:math' as math;

class FingerprintPulse extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A0A0A),
      body: Center(
        child: FingerprintPulseUnlock(
          onUnlockSuccess: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('🎉 Unlocked Successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          },
          onUnlockFailed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('❌ Authentication Failed'),
                backgroundColor: Colors.red,
              ),
            );
          },
        ),
      ),
    );
  }
}

/// A stunning fingerprint unlock widget with pulse animations and glowing effects
/// 
/// Features:
/// - Beautiful glowing fingerprint icon with pulse animation
/// - Customizable colors, sizes, and animation durations
/// - Success/failure states with different visual feedback
/// - Ripple pulse effects on touch
/// - Smooth transitions and micro-interactions
/// - Production-ready and highly reusable
class FingerprintPulseUnlock extends StatefulWidget {
  /// Callback when unlock is successful
  final VoidCallback? onUnlockSuccess;
  
  /// Callback when unlock fails
  final VoidCallback? onUnlockFailed;
  
  /// Size of the fingerprint button
  final double size;
  
  /// Primary glow color
  final Color primaryColor;
  
  /// Secondary glow color
  final Color secondaryColor;
  
  /// Error color for failed attempts
  final Color errorColor;
  
  /// Success color for successful unlock
  final Color successColor;
  
  /// Background color of the widget
  final Color backgroundColor;
  
  /// Duration of pulse animation
  final Duration pulseDuration;
  
  /// Duration of ripple animation
  final Duration rippleDuration;
  
  /// Maximum number of pulse rings
  final int maxPulseRings;
  
  /// Simulate authentication (for demo purposes)
  final bool simulateAuthentication;
  
  /// Success rate for simulated authentication (0.0 to 1.0)
  final double successRate;

  const FingerprintPulseUnlock({
    Key? key,
    this.onUnlockSuccess,
    this.onUnlockFailed,
    this.size = 200.0,
    this.primaryColor = const Color(0xFF00E5FF),
    this.secondaryColor = const Color(0xFF1DE9B6),
    this.errorColor = const Color(0xFFFF5252),
    this.successColor = const Color(0xFF4CAF50),
    this.backgroundColor = const Color(0xFF0A0A0A),
    this.pulseDuration = const Duration(milliseconds: 2000),
    this.rippleDuration = const Duration(milliseconds: 1500),
    this.maxPulseRings = 4,
    this.simulateAuthentication = true,
    this.successRate = 0.7,
  }) : super(key: key);

  @override
  _FingerprintPulseUnlockState createState() => _FingerprintPulseUnlockState();
}

class _FingerprintPulseUnlockState extends State<FingerprintPulseUnlock>
    with TickerProviderStateMixin {
  
  late AnimationController _pulseController;
  late AnimationController _rippleController;
  late AnimationController _scanController;
  late AnimationController _resultController;
  
  late Animation<double> _pulseAnimation;
  late Animation<double> _rippleAnimation;
  late Animation<double> _scanAnimation;
  late Animation<double> _resultAnimation;
  
  UnlockState _state = UnlockState.idle;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    // Pulse animation (continuous)
    _pulseController = AnimationController(
      duration: widget.pulseDuration,
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseController.repeat();

    // Ripple animation (on press)
    _rippleController = AnimationController(
      duration: widget.rippleDuration,
      vsync: this,
    );
    _rippleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rippleController, curve: Curves.easeOut),
    );

    // Scan animation (authentication process)
    _scanController = AnimationController(
      duration: Duration(milliseconds: 2500),
      vsync: this,
    );
    _scanAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scanController, curve: Curves.easeInOut),
    );

    // Result animation (success/failure)
    _resultController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _resultAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _resultController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rippleController.dispose();
    _scanController.dispose();
    _resultController.dispose();
    super.dispose();
  }

  void _handlePress() async {
    if (_state != UnlockState.idle) return;

    setState(() {
      _isPressed = true;
      _state = UnlockState.scanning;
    });

    // Start ripple and scan animations
    _rippleController.forward(from: 0);
    _scanController.forward(from: 0);

    // Simulate authentication process
    await Future.delayed(Duration(milliseconds: 2000));

    // Determine result (for demo purposes)
    bool success = widget.simulateAuthentication 
        ? math.Random().nextDouble() < widget.successRate
        : true;

    setState(() {
      _state = success ? UnlockState.success : UnlockState.error;
    });

    _resultController.forward(from: 0);

    // Trigger callbacks
    if (success) {
      widget.onUnlockSuccess?.call();
    } else {
      widget.onUnlockFailed?.call();
    }

    // Reset after showing result
    await Future.delayed(Duration(milliseconds: 1500));
    _resetState();
  }

  void _resetState() {
    setState(() {
      _state = UnlockState.idle;
      _isPressed = false;
    });
    _scanController.reset();
    _resultController.reset();
  }

  Color get _currentColor {
    switch (_state) {
      case UnlockState.success:
        return widget.successColor;
      case UnlockState.error:
        return widget.errorColor;
      case UnlockState.scanning:
        return widget.primaryColor;
      default:
        return widget.primaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size * 2,
      height: widget.size * 2,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background pulse rings
          ...List.generate(widget.maxPulseRings, (index) {
            return _buildPulseRing(index);
          }),
          
          // Ripple effect on press
          if (_isPressed) _buildRippleEffect(),
          
          // Main fingerprint button
          _buildFingerprintButton(),
          
          // Scanning line effect
          if (_state == UnlockState.scanning) _buildScanningEffect(),
          
          // Result indicator
          if (_state == UnlockState.success || _state == UnlockState.error)
            _buildResultIndicator(),
        ],
      ),
    );
  }

  Widget _buildPulseRing(int ringIndex) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        double delay = ringIndex * 0.2;
        double progress = (_pulseAnimation.value + delay) % 1.0;
        double opacity = (1.0 - progress) * 0.3;
        double scale = 0.5 + (progress * 1.5);

        return Transform.scale(
          scale: scale,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: _currentColor.withOpacity(opacity),
                width: 2.0,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRippleEffect() {
    return AnimatedBuilder(
      animation: _rippleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + (_rippleAnimation.value * 2.0),
          child: Container(
            width: widget.size * 0.8,
            height: widget.size * 0.8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentColor.withOpacity(0.3 * (1.0 - _rippleAnimation.value)),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFingerprintButton() {
    return GestureDetector(
      onTap: _handlePress,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: widget.size * 0.6,
        height: widget.size * 0.6,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              _currentColor.withOpacity(0.8),
              _currentColor.withOpacity(0.3),
              _currentColor.withOpacity(0.1),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: _currentColor.withOpacity(0.5),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Container(
          margin: EdgeInsets.all(20),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withOpacity(0.7),
            border: Border.all(
              color: _currentColor.withOpacity(0.8),
              width: 2,
            ),
          ),
          child: Icon(
            _getStateIcon(),
            size: widget.size * 0.2,
            color: _currentColor,
          ),
        ),
      ),
    );
  }

  Widget _buildScanningEffect() {
    return AnimatedBuilder(
      animation: _scanAnimation,
      builder: (context, child) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(widget.size * 0.3),
          child: Container(
            width: widget.size * 0.6,
            height: widget.size * 0.6,
            child: Stack(
              children: [
                Positioned(
                  top: widget.size * 0.6 * _scanAnimation.value - 5,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 10,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.transparent,
                          _currentColor.withOpacity(0.8),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildResultIndicator() {
    return AnimatedBuilder(
      animation: _resultAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _resultAnimation.value,
          child: Container(
            width: widget.size * 0.3,
            height: widget.size * 0.3,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentColor.withOpacity(0.9),
              boxShadow: [
                BoxShadow(
                  color: _currentColor.withOpacity(0.6),
                  blurRadius: 15,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: Icon(
              _state == UnlockState.success ? Icons.check : Icons.close,
              size: widget.size * 0.15,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  IconData _getStateIcon() {
    switch (_state) {
      case UnlockState.scanning:
        return Icons.fingerprint;
      case UnlockState.success:
        return Icons.check;
      case UnlockState.error:
        return Icons.error_outline;
      default:
        return Icons.fingerprint;
    }
  }
}

/// Enum to represent different unlock states
enum UnlockState {
  idle,
  scanning,
  success,
  error,
}