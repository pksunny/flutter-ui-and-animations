import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SlideToConfirmActionBar extends StatefulWidget {
  final String text;
  final String confirmText;
  final VoidCallback? onConfirm;
  final Color backgroundColor;
  final Color thumbColor;
  final Color textColor;
  final Color confirmColor;
  final double height;
  final double borderRadius;
  final IconData icon;
  final Duration animationDuration;
  final bool enabled;

  const SlideToConfirmActionBar({
    Key? key,
    this.text = 'Slide to confirm',
    this.confirmText = 'Confirmed!',
    this.onConfirm,
    this.backgroundColor = const Color(0xFF1E1E1E),
    this.thumbColor = Colors.white,
    this.textColor = Colors.white70,
    this.confirmColor = const Color(0xFF4CAF50),
    this.height = 60.0,
    this.borderRadius = 30.0,
    this.icon = Icons.arrow_forward_ios,
    this.animationDuration = const Duration(milliseconds: 300),
    this.enabled = true,
  }) : super(key: key);

  @override
  State<SlideToConfirmActionBar> createState() => _SlideToConfirmActionBarState();
}

class _SlideToConfirmActionBarState extends State<SlideToConfirmActionBar>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _successController;
  late AnimationController _pulseController;
  late AnimationController _shimmerController;
  
  late Animation<double> _slideAnimation;
  late Animation<double> _successAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _shimmerAnimation;
  late Animation<Color?> _colorAnimation;
  
  bool _isSliding = false;
  bool _isConfirmed = false;
  double _dragPosition = 0.0;
  
  @override
  void initState() {
    super.initState();
    
    _slideController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    
    _successController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    ));
    
    _successAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _successController,
      curve: Curves.elasticOut,
    ));
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _shimmerAnimation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOut,
    ));
    
    _colorAnimation = ColorTween(
      begin: widget.backgroundColor,
      end: widget.confirmColor,
    ).animate(CurvedAnimation(
      parent: _successController,
      curve: Curves.easeInOut,
    ));
    
    // Start pulse animation
    _pulseController.repeat(reverse: true);
    _shimmerController.repeat();
  }
  
  @override
  void dispose() {
    _slideController.dispose();
    _successController.dispose();
    _pulseController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }
  
  void _onPanStart(DragStartDetails details) {
    if (!widget.enabled || _isConfirmed) return;
    
    setState(() {
      _isSliding = true;
    });
    
    HapticFeedback.lightImpact();
  }
  
  void _onPanUpdate(DragUpdateDetails details) {
    if (!widget.enabled || _isConfirmed) return;
    
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final double maxDrag = renderBox.size.width - widget.height;
    
    setState(() {
      _dragPosition = (details.localPosition.dx - widget.height / 2)
          .clamp(0.0, maxDrag);
    });
  }
  
  void _onPanEnd(DragEndDetails details) {
    if (!widget.enabled || _isConfirmed) return;
    
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final double maxDrag = renderBox.size.width - widget.height;
    
    if (_dragPosition >= maxDrag * 0.8) {
      // Confirm action
      _confirmAction();
    } else {
      // Reset position
      _resetPosition();
    }
  }
  
  void _confirmAction() async {
    setState(() {
      _isConfirmed = true;
      _isSliding = false;
    });
    
    HapticFeedback.mediumImpact();
    
    await _slideController.forward();
    await _successController.forward();
    
    widget.onConfirm?.call();
    
    // Reset after delay
    await Future.delayed(const Duration(milliseconds: 1500));
    _resetToInitial();
  }
  
  void _resetPosition() {
    setState(() {
      _isSliding = false;
      _dragPosition = 0.0;
    });
  }
  
  void _resetToInitial() {
    setState(() {
      _isConfirmed = false;
      _isSliding = false;
      _dragPosition = 0.0;
    });
    
    _slideController.reset();
    _successController.reset();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: AnimatedBuilder(
            animation: Listenable.merge([
              _slideAnimation,
              _successAnimation,
              _pulseAnimation,
              _shimmerAnimation,
              _colorAnimation,
            ]),
            builder: (context, child) {
              final double rawProgress = _isSliding 
                  ? _dragPosition / (MediaQuery.of(context).size.width - widget.height)
                  : _slideAnimation.value;
              final double progress = rawProgress.clamp(0.0, 1.0);
              
              return Transform.scale(
                scale: _isSliding ? _pulseAnimation.value : 1.0,
                child: Container(
                  height: widget.height,
                  decoration: BoxDecoration(
                    color: _colorAnimation.value,
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Shimmer effect
                      if (!_isConfirmed)
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(widget.borderRadius),
                            child: CustomPaint(
                              painter: ShimmerPainter(
                                progress: _shimmerAnimation.value,
                                color: Colors.white.withOpacity(0.1),
                              ),
                            ),
                          ),
                        ),
                      
                      // Progress indicator
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(widget.borderRadius),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.transparent,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              widget.confirmColor.withOpacity(0.3),
                            ),
                          ),
                        ),
                      ),
                      
                      // Text
                      Center(
                        child: AnimatedOpacity(
                          opacity: _isConfirmed ? 0.0 : 1.0,
                          duration: const Duration(milliseconds: 200),
                          child: Text(
                            widget.text,
                            style: TextStyle(
                              color: widget.textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                      
                      // Success text
                      if (_isConfirmed)
                        Center(
                          child: AnimatedOpacity(
                            opacity: _successAnimation.value.clamp(0.0, 1.0),
                            duration: const Duration(milliseconds: 200),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  widget.confirmText,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      
                      // Draggable thumb
                      Positioned(
                        left: _isConfirmed
                            ? (MediaQuery.of(context).size.width - widget.height) * _slideAnimation.value
                            : _dragPosition,
                        top: 0,
                        child: GestureDetector(
                          onPanStart: _onPanStart,
                          onPanUpdate: _onPanUpdate,
                          onPanEnd: _onPanEnd,
                          child: Container(
                            height: widget.height,
                            width: widget.height,
                            decoration: BoxDecoration(
                              color: _isConfirmed ? widget.confirmColor : widget.thumbColor,
                              borderRadius: BorderRadius.circular(widget.borderRadius),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Center(
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                child: _isConfirmed
                                    ? Transform.scale(
                                        scale: _successAnimation.value,
                                        child: const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 24,
                                          key: ValueKey('check'),
                                        ),
                                      )
                                    : Icon(
                                        widget.icon,
                                        color: widget.backgroundColor,
                                        size: 20,
                                        key: const ValueKey('arrow'),
                                      ),
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
        ),
      ),
    );
  }
}

class ShimmerPainter extends CustomPainter {
  final double progress;
  final Color color;

  ShimmerPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          color,
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(Rect.fromLTWH(
        size.width * progress - size.width * 0.5,
        0,
        size.width,
        size.height,
      ));

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Example usage
class SlideToConfirmDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Slide to Confirm Examples',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              
              // Default style
              SlideToConfirmActionBar(
                text: 'Slide to unlock',
                onConfirm: () => print('Unlocked!'),
              ),
              
              const SizedBox(height: 24),
              
              // Custom style
              SlideToConfirmActionBar(
                text: 'Slide to delete',
                confirmText: 'Deleted!',
                backgroundColor: const Color(0xFF2A2A2A),
                thumbColor: const Color(0xFFFF4444),
                confirmColor: const Color(0xFFFF4444),
                textColor: Colors.white,
                icon: Icons.delete,
                onConfirm: () => print('Deleted!'),
              ),
              
              const SizedBox(height: 24),
              
              // Another custom style
              SlideToConfirmActionBar(
                text: 'Slide to pay',
                confirmText: 'Payment sent!',
                backgroundColor: const Color(0xFF1A1A2E),
                thumbColor: const Color(0xFF00D4FF),
                confirmColor: const Color(0xFF00D4FF),
                textColor: const Color(0xFF00D4FF),
                icon: Icons.payment,
                height: 56,
                borderRadius: 28,
                onConfirm: () => print('Payment sent!'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}