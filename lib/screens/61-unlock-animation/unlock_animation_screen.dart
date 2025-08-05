import 'dart:ui';

import 'package:flutter/material.dart';


class UnlockAnimationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F0F23),
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
            ],
          ),
        ),
        child: Center(
          child: FuturisticUnlockButton(),
        ),
      ),
    );
  }
}

class FuturisticUnlockButton extends StatefulWidget {
  @override
  _FuturisticUnlockButtonState createState() => _FuturisticUnlockButtonState();
}

class _FuturisticUnlockButtonState extends State<FuturisticUnlockButton>
    with TickerProviderStateMixin {
  late AnimationController _flipController;
  late AnimationController _glowController;
  late AnimationController _pulseController;
  late AnimationController _rippleController;
  
  late Animation<double> _flipAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rippleAnimation;
  
  bool _isUnlocked = false;
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    
    _flipController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    
    _glowController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _rippleController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _flipAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _flipController,
      curve: Curves.elasticOut,
    ));
    
    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _rippleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rippleController,
      curve: Curves.easeOut,
    ));
    
    _glowController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _flipController.dispose();
    _glowController.dispose();
    _pulseController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  void _handleUnlock() async {
    if (_isAuthenticating) return;
    
    setState(() {
      _isAuthenticating = true;
    });
    
    _pulseController.forward();
    _rippleController.forward();
    
    // Simulate authentication delay
    await Future.delayed(Duration(milliseconds: 1500));
    
    _flipController.forward();
    
    setState(() {
      _isUnlocked = true;
      _isAuthenticating = false;
    });
    
    // Reset after 3 seconds for demo
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        _reset();
      }
    });
  }
  
  void _reset() {
    _flipController.reset();
    _pulseController.reset();
    _rippleController.reset();
    setState(() {
      _isUnlocked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _flipAnimation,
        _glowAnimation,
        _pulseAnimation,
        _rippleAnimation,
      ]),
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Ripple effect
            if (_isAuthenticating)
              Container(
                width: 300 * _rippleAnimation.value,
                height: 300 * _rippleAnimation.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.cyan.withOpacity(0.3 * (1 - _rippleAnimation.value)),
                    width: 2,
                  ),
                ),
              ),
            
            // Outer glow ring
            Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _isUnlocked 
                        ? Colors.green.withOpacity(0.5)
                        : Colors.cyan.withOpacity(0.3 + 0.2 * _glowAnimation.value),
                    blurRadius: 20 + 10 * _glowAnimation.value,
                    spreadRadius: 5,
                  ),
                ],
              ),
            ),
            
            // Main button
            Transform.scale(
              scale: _isAuthenticating ? _pulseAnimation.value : 1.0,
              child: GestureDetector(
                onTap: _handleUnlock,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: _isUnlocked 
                          ? [
                              Color(0xFF00FF88).withOpacity(0.3),
                              Color(0xFF00CC6A).withOpacity(0.5),
                            ]
                          : [
                              Color(0xFF1E3A8A).withOpacity(0.3),
                              Color(0xFF3B82F6).withOpacity(0.5),
                            ],
                    ),
                    border: Border.all(
                      color: _isUnlocked 
                          ? Colors.green.withOpacity(0.6)
                          : Colors.cyan.withOpacity(0.4),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 15,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(75),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.001)
                              ..rotateY(_flipAnimation.value * 3.14159),
                            child: _flipAnimation.value < 0.5
                                ? _buildLockIcon()
                                : Transform(
                                    alignment: Alignment.center,
                                    transform: Matrix4.identity()..rotateY(3.14159),
                                    child: _buildUnlockIcon(),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            // Loading indicator
            if (_isAuthenticating && !_isUnlocked)
              Positioned(
                bottom: -60,
                child: Container(
                  width: 200,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Stack(
                    children: [
                      AnimatedContainer(
                        duration: Duration(milliseconds: 1500),
                        width: 200 * _rippleAnimation.value,
                        height: 4,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.cyan, Colors.blue],
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            
            // Status text
            Positioned(
              bottom: -100,
              child: AnimatedOpacity(
                opacity: _isAuthenticating || _isUnlocked ? 1.0 : 0.0,
                duration: Duration(milliseconds: 300),
                child: Text(
                  _isUnlocked 
                      ? 'UNLOCKED' 
                      : _isAuthenticating 
                          ? 'AUTHENTICATING...' 
                          : '',
                  style: TextStyle(
                    color: _isUnlocked ? Colors.green : Colors.cyan,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
  
  Widget _buildLockIcon() {
    return Icon(
      Icons.lock,
      size: 60,
      color: Colors.white.withOpacity(0.9),
    );
  }
  
  Widget _buildUnlockIcon() {
    return Icon(
      Icons.lock_open,
      size: 60,
      color: Colors.green.withOpacity(0.9),
    );
  }
}