import 'package:flutter/material.dart';

class LiquidSwitchToggleScreen extends StatefulWidget {
  @override
  _LiquidSwitchToggleScreenState createState() => _LiquidSwitchToggleScreenState();
}

class _LiquidSwitchToggleScreenState extends State<LiquidSwitchToggleScreen> {
  bool _isEnabled = false;
  bool _isDarkMode = true;
  bool _notifications = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkMode ? Color(0xFF0A0A0A) : Color(0xFFF8F9FA),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _isDarkMode 
              ? [Color(0xFF0A0A0A), Color(0xFF1A1A1A)]
              : [Color(0xFFF8F9FA), Color(0xFFE9ECEF)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Liquid Switch Toggle',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: _isDarkMode ? Colors.white : Color(0xFF1A1A1A),
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Smooth & Fluid Animations',
                  style: TextStyle(
                    fontSize: 16,
                    color: _isDarkMode ? Colors.white54 : Color(0xFF6C757D),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 60),
                
                // Main Feature Switch
                _buildSwitchCard(
                  'Enable Feature',
                  'Turn on to activate the main functionality',
                  _isEnabled,
                  (value) => setState(() => _isEnabled = value),
                  Colors.blue,
                ),
                
                SizedBox(height: 24),
                
                // Dark Mode Switch
                _buildSwitchCard(
                  'Dark Mode',
                  'Switch between light and dark themes',
                  _isDarkMode,
                  (value) => setState(() => _isDarkMode = value),
                  Colors.purple,
                ),
                
                SizedBox(height: 24),
                
                // Notifications Switch
                _buildSwitchCard(
                  'Notifications',
                  'Receive push notifications and alerts',
                  _notifications,
                  (value) => setState(() => _notifications = value),
                  Colors.green,
                ),
                
                SizedBox(height: 60),
                
                // Standalone switches showcase
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    LiquidSwitch(
                      value: _isEnabled,
                      onChanged: (value) => setState(() => _isEnabled = value),
                      activeColor: Colors.blue,
                      size: 60,
                    ),
                    LiquidSwitch(
                      value: _isDarkMode,
                      onChanged: (value) => setState(() => _isDarkMode = value),
                      activeColor: Colors.purple,
                      size: 50,
                    ),
                    LiquidSwitch(
                      value: _notifications,
                      onChanged: (value) => setState(() => _notifications = value),
                      activeColor: Colors.green,
                      size: 40,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchCard(String title, String subtitle, bool value, ValueChanged<bool> onChanged, Color activeColor) {
    return Container(
      width: 320,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _isDarkMode ? Color(0xFF1C1C1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _isDarkMode ? Colors.black26 : Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: _isDarkMode ? Colors.white : Color(0xFF1A1A1A),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: _isDarkMode ? Colors.white54 : Color(0xFF6C757D),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 16),
          LiquidSwitch(
            value: value,
            onChanged: onChanged,
            activeColor: activeColor,
          ),
        ],
      ),
    );
  }
}

class LiquidSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  final double size;

  const LiquidSwitch({
    Key? key,
    required this.value,
    required this.onChanged,
    this.activeColor = Colors.blue,
    this.size = 56,
  }) : super(key: key);

  @override
  _LiquidSwitchState createState() => _LiquidSwitchState();
}

class _LiquidSwitchState extends State<LiquidSwitch>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _bounceController;
  late Animation<double> _animation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _bounceController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    
    _bounceAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.elasticOut,
    ));

    if (widget.value) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(LiquidSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      if (widget.value) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
      _bounceController.forward().then((_) {
        _bounceController.reverse();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onChanged(!widget.value),
      child: AnimatedBuilder(
        animation: Listenable.merge([_animation, _bounceAnimation]),
        builder: (context, child) {
          return Transform.scale(
            scale: _bounceAnimation.value,
            child: Container(
              width: widget.size,
              height: widget.size * 0.57,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.size * 0.3),
                boxShadow: [
                  BoxShadow(
                    color: widget.value 
                        ? widget.activeColor.withOpacity(0.3)
                        : Colors.black.withOpacity(0.1),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Background
                  Container(
                    decoration: BoxDecoration(
                      color: widget.value 
                          ? widget.activeColor
                          : Color(0xFF39404A),
                      borderRadius: BorderRadius.circular(widget.size * 0.3),
                    ),
                  ),
                  
                  // Liquid blob
                  CustomPaint(
                    painter: LiquidBlobPainter(
                      animation: _animation,
                      activeColor: widget.activeColor,
                      isActive: widget.value,
                    ),
                    size: Size(widget.size, widget.size * 0.57),
                  ),
                  
                  // Thumb
                  Positioned(
                    left: _animation.value * (widget.size - widget.size * 0.57) + 2,
                    top: 2,
                    child: Container(
                      width: widget.size * 0.57 - 4,
                      height: widget.size * 0.57 - 4,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
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

class LiquidBlobPainter extends CustomPainter {
  final Animation<double> animation;
  final Color activeColor;
  final bool isActive;

  LiquidBlobPainter({
    required this.animation,
    required this.activeColor,
    required this.isActive,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isActive ? activeColor : Color(0xFF39404A)
      ..style = PaintingStyle.fill;

    final path = Path();
    final progress = animation.value;
    
    // Create liquid blob effect
    final centerY = size.height / 2;
    final radius = size.height / 2;
    
    // Left side
    path.moveTo(0, centerY - radius);
    path.quadraticBezierTo(
      radius * 0.3,
      centerY - radius * (1 + 0.2 * progress),
      radius,
      centerY,
    );
    path.quadraticBezierTo(
      radius * 0.3,
      centerY + radius * (1 + 0.2 * progress),
      0,
      centerY + radius,
    );
    
    // Bottom
    path.lineTo(size.width, centerY + radius);
    
    // Right side
    path.quadraticBezierTo(
      size.width - radius * 0.3,
      centerY + radius * (1 + 0.2 * (1 - progress)),
      size.width - radius,
      centerY,
    );
    path.quadraticBezierTo(
      size.width - radius * 0.3,
      centerY - radius * (1 + 0.2 * (1 - progress)),
      size.width,
      centerY - radius,
    );
    
    // Top
    path.lineTo(0, centerY - radius);
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}