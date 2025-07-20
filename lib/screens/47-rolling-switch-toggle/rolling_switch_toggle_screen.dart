import 'package:flutter/material.dart';
import 'dart:math' as math;


class RollingSwitchToggleScreen extends StatefulWidget {
  @override
  _RollingSwitchToggleScreenState createState() => _RollingSwitchToggleScreenState();
}

class _RollingSwitchToggleScreenState extends State<RollingSwitchToggleScreen> {
  bool toggle1 = false;
  bool toggle2 = true;
  bool toggle3 = false;

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Rolling Ball Toggles',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.cyanAccent.withOpacity(0.5),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 60),
              
              // Neon Blue Toggle
              Column(
                children: [
                  Text(
                    'Neon Pulse',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  RollingToggle(
                    value: toggle1,
                    onChanged: (val) => setState(() => toggle1 = val),
                    activeColor: Color(0xFF00F5FF),
                    inactiveColor: Color(0xFF2A2A3E),
                    ballColor: Colors.white,
                  ),
                ],
              ),
              
              SizedBox(height: 40),
              
              // Purple Gradient Toggle
              Column(
                children: [
                  Text(
                    'Cosmic Energy',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  RollingToggle(
                    value: toggle2,
                    onChanged: (val) => setState(() => toggle2 = val),
                    activeColor: Color(0xFF8A2BE2),
                    inactiveColor: Color(0xFF2A2A3E),
                    ballColor: Color(0xFFFFD700),
                  ),
                ],
              ),
              
              SizedBox(height: 40),
              
              // Green Matrix Toggle
              Column(
                children: [
                  Text(
                    'Matrix Mode',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  RollingToggle(
                    value: toggle3,
                    onChanged: (val) => setState(() => toggle3 = val),
                    activeColor: Color(0xFF00FF41),
                    inactiveColor: Color(0xFF2A2A3E),
                    ballColor: Color(0xFF000000),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RollingToggle extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  final Color inactiveColor;
  final Color ballColor;
  final double width;
  final double height;

  const RollingToggle({
    Key? key,
    required this.value,
    required this.onChanged,
    this.activeColor = const Color(0xFF00F5FF),
    this.inactiveColor = const Color(0xFF2A2A3E),
    this.ballColor = Colors.white,
    this.width = 80,
    this.height = 40,
  }) : super(key: key);

  @override
  _RollingToggleState createState() => _RollingToggleState();
}

class _RollingToggleState extends State<RollingToggle>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _glowController;
  late Animation<double> _slideAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: Duration(milliseconds: 900),
      vsync: this,
    );
    
    _glowController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: math.pi,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    if (widget.value) {
      _animationController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(RollingToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      if (widget.value) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onChanged(!widget.value),
      child: AnimatedBuilder(
        animation: Listenable.merge([_animationController, _glowController]),
        builder: (context, child) {
          return Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.height / 2),
              gradient: LinearGradient(
                colors: [
                  Color.lerp(widget.inactiveColor, widget.activeColor, _slideAnimation.value)!,
                  Color.lerp(widget.inactiveColor.withOpacity(0.7), widget.activeColor.withOpacity(0.7), _slideAnimation.value)!,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Color.lerp(widget.inactiveColor, widget.activeColor, _slideAnimation.value)!
                      .withOpacity(_glowAnimation.value * 0.6),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Inner glow effect
                Positioned.fill(
                  child: Container(
                    margin: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(widget.height / 2),
                      gradient: RadialGradient(
                        center: Alignment(-0.5 + _slideAnimation.value, 0),
                        radius: 0.8,
                        colors: [
                          widget.activeColor.withOpacity(_slideAnimation.value * 0.3),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                
                // Rolling ball
                Positioned(
                  left: _slideAnimation.value * (widget.width - widget.height) + 4,
                  top: 4,
                  child: Transform.rotate(
                    angle: _rotationAnimation.value * (widget.value ? 1 : -1),
                    child: Container(
                      width: widget.height - 8,
                      height: widget.height - 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          center: Alignment(-0.3, -0.3),
                          radius: 0.8,
                          colors: [
                            widget.ballColor,
                            widget.ballColor.withOpacity(0.8),
                            widget.ballColor.withOpacity(0.6),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.8),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 4,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.9),
                              widget.ballColor,
                              widget.ballColor.withOpacity(0.7),
                            ],
                          ),
                        ),
                        child: Stack(
                          children: [
                            // Highlight spot
                            Positioned(
                              top: 3,
                              left: 3,
                              child: Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.9),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.6),
                                      blurRadius: 3,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}