import 'package:flutter/material.dart';

enum ApiState { idle, loading, success, error, warning }

class ApiCallAnimationsScreen extends StatefulWidget {
  @override
  _ApiCallAnimationsScreenState createState() => _ApiCallAnimationsScreenState();
}

class _ApiCallAnimationsScreenState extends State<ApiCallAnimationsScreen>
    with TickerProviderStateMixin {
  ApiState currentState = ApiState.idle;
  late AnimationController _pulseController;
  late AnimationController _scaleController;
  late AnimationController _rotationController;
  late AnimationController _slideController;
  late AnimationController _glowController;

  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _pulseController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _rotationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _glowController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));
    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _scaleController.dispose();
    _rotationController.dispose();
    _slideController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  void _simulateApiCall(ApiState targetState) {
    setState(() {
      currentState = ApiState.loading;
    });
    
    _rotationController.repeat();
    _pulseController.repeat(reverse: true);
    
    Future.delayed(Duration(seconds: 2), () {
      _rotationController.stop();
      _pulseController.stop();
      
      setState(() {
        currentState = targetState;
      });
      
      _scaleController.forward().then((_) {
        _scaleController.reverse();
      });
      _slideController.forward().then((_) {
        _slideController.reverse();
      });
      _glowController.forward().then((_) {
        _glowController.reverse();
      });
    });
  }

  Widget _buildStatusIcon() {
    IconData icon;
    Color color;
    Color glowColor;

    switch (currentState) {
      case ApiState.success:
        icon = Icons.check_circle;
        color = Color(0xFF10B981);
        glowColor = Color(0xFF10B981).withOpacity(0.3);
        break;
      case ApiState.error:
        icon = Icons.error;
        color = Color(0xFFEF4444);
        glowColor = Color(0xFFEF4444).withOpacity(0.3);
        break;
      case ApiState.warning:
        icon = Icons.warning;
        color = Color(0xFFF59E0B);
        glowColor = Color(0xFFF59E0B).withOpacity(0.3);
        break;
      case ApiState.loading:
        icon = Icons.refresh;
        color = Color(0xFF6366F1);
        glowColor = Color(0xFF6366F1).withOpacity(0.3);
        break;
      default:
        icon = Icons.cloud_upload;
        color = Color(0xFF9CA3AF);
        glowColor = Color(0xFF9CA3AF).withOpacity(0.3);
    }

    return AnimatedBuilder(
      animation: Listenable.merge([
        _pulseAnimation,
        _scaleAnimation,
        _rotationAnimation,
        _glowAnimation
      ]),
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: glowColor,
                blurRadius: 30 * _glowAnimation.value,
                spreadRadius: 10 * _glowAnimation.value,
              ),
            ],
          ),
          child: Transform.scale(
            scale: currentState == ApiState.loading 
                ? _pulseAnimation.value 
                : _scaleAnimation.value,
            child: Transform.rotate(
              angle: currentState == ApiState.loading 
                  ? _rotationAnimation.value * 2 * 3.14159 
                  : 0,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      color.withOpacity(0.8),
                      color,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: color.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Icon(
                  icon,
                  size: 50,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusText() {
    String text;
    Color color;

    switch (currentState) {
      case ApiState.success:
        text = "Success!";
        color = Color(0xFF10B981);
        break;
      case ApiState.error:
        text = "Error Occurred";
        color = Color(0xFFEF4444);
        break;
      case ApiState.warning:
        text = "Warning";
        color = Color(0xFFF59E0B);
        break;
      case ApiState.loading:
        text = "Processing...";
        color = Color(0xFF6366F1);
        break;
      default:
        text = "Ready to Connect";
        color = Color(0xFF9CA3AF);
    }

    return SlideTransition(
      position: _slideAnimation,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 300),
        opacity: 1.0,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedButton({
    required String text,
    required Color color,
    required VoidCallback onPressed,
    required IconData icon,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.1),
              color.withOpacity(0.2),
            ],
          ),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(25),
          child: InkWell(
            borderRadius: BorderRadius.circular(25),
            onTap: onPressed,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: color, size: 20),
                  SizedBox(width: 12),
                  Text(
                    text,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.0,
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF0A0A0A),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                // Header
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    "API Call Animation",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..shader = LinearGradient(
                          colors: [
                            Color(0xFF6366F1),
                            Color(0xFF8B5CF6),
                            Color(0xFFEC4899),
                          ],
                        ).createShader(Rect.fromLTWH(0, 0, 300, 70)),
                    ),
                  ),
                ),
                
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Main Status Icon
                        _buildStatusIcon(),
                        
                        SizedBox(height: 40),
                        
                        // Status Text
                        _buildStatusText(),
                        
                        SizedBox(height: 60),
                        
                        // Action Buttons
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 16,
                          runSpacing: 16,
                          children: [
                            _buildAnimatedButton(
                              text: "Success Call",
                              color: Color(0xFF10B981),
                              icon: Icons.check,
                              onPressed: () => _simulateApiCall(ApiState.success),
                            ),
                            _buildAnimatedButton(
                              text: "Error Call",
                              color: Color(0xFFEF4444),
                              icon: Icons.close,
                              onPressed: () => _simulateApiCall(ApiState.error),
                            ),
                            _buildAnimatedButton(
                              text: "Warning Call",
                              color: Color(0xFFF59E0B),
                              icon: Icons.warning_outlined,
                              onPressed: () => _simulateApiCall(ApiState.warning),
                            ),
                          ],
                        ),
                        
                        if (currentState == ApiState.error) ...[
                          SizedBox(height: 30),
                          _buildAnimatedButton(
                            text: "Retry",
                            color: Color(0xFF6366F1),
                            icon: Icons.refresh,
                            onPressed: () => _simulateApiCall(ApiState.success),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                
                // Footer
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: currentState == ApiState.loading 
                              ? Color(0xFF6366F1) 
                              : Color(0xFF4B5563),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        currentState == ApiState.loading 
                            ? "Connecting..." 
                            : "Ready",
                        style: TextStyle(
                          color: Color(0xFF9CA3AF),
                          fontSize: 14,
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
}