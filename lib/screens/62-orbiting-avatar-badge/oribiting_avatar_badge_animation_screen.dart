import 'package:flutter/material.dart';
import 'dart:math' as math;

class OrbitingAvatarBadge extends StatefulWidget {
  final String? imageUrl;
  final double size;
  final String badgeText;
  final Color badgeColor;
  final Color glowColor;
  final double orbitRadius;
  final Duration orbitDuration;
  
  const OrbitingAvatarBadge({
    Key? key,
    this.imageUrl,
    this.size = 120.0,
    this.badgeText = 'ONLINE',
    this.badgeColor = const Color(0xFF00FF88),
    this.glowColor = const Color(0xFF00FF88),
    this.orbitRadius = 60.0,
    this.orbitDuration = const Duration(seconds: 8),
  }) : super(key: key);

  @override
  State<OrbitingAvatarBadge> createState() => _OrbitingAvatarBadgeState();
}

class _OrbitingAvatarBadgeState extends State<OrbitingAvatarBadge>
    with TickerProviderStateMixin {
  late AnimationController _orbitController;
  late AnimationController _pulseController;
  late AnimationController _glowController;
  
  late Animation<double> _orbitAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    
    // Orbit animation
    _orbitController = AnimationController(
      duration: widget.orbitDuration,
      vsync: this,
    );
    _orbitAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _orbitController,
      curve: Curves.linear,
    ));
    
    // Pulse animation for the badge
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    // Glow animation
    _glowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));
    
    // Start all animations
    _orbitController.repeat();
    _pulseController.repeat(reverse: true);
    _glowController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _orbitController.dispose();
    _pulseController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size + (widget.orbitRadius * 2) + 40,
      height: widget.size + (widget.orbitRadius * 2) + 40,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _orbitAnimation,
          _pulseAnimation,
          _glowAnimation,
        ]),
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Outer glow ring
              Container(
                width: widget.size + (widget.orbitRadius * 2) + 20,
                height: widget.size + (widget.orbitRadius * 2) + 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: widget.glowColor.withOpacity(0.1 * _glowAnimation.value),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
              ),
              
              // Profile Avatar with holographic border
              Container(
                width: widget.size + 8,
                height: widget.size + 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      widget.glowColor.withOpacity(0.6),
                      widget.glowColor.withOpacity(0.1),
                      Colors.purple.withOpacity(0.3),
                      widget.glowColor.withOpacity(0.4),
                    ],
                    stops: [0.0, 0.3, 0.7, 1.0],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.glowColor.withOpacity(0.4),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: widget.imageUrl != null
                        ? Image.network(
                            widget.imageUrl!,
                            width: widget.size,
                            height: widget.size,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildDefaultAvatar();
                            },
                          )
                        : _buildDefaultAvatar(),
                  ),
                ),
              ),
              
              // Orbiting Badge
              Transform.translate(
                offset: Offset(
                  widget.orbitRadius * math.cos(_orbitAnimation.value),
                  widget.orbitRadius * math.sin(_orbitAnimation.value),
                ),
                child: Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          widget.badgeColor,
                          widget.badgeColor.withOpacity(0.8),
                          Colors.white.withOpacity(0.9),
                        ],
                        stops: [0.0, 0.6, 1.0],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: widget.badgeColor.withOpacity(0.6),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                        BoxShadow(
                          color: Colors.white.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                      border: Border.all(
                        color: Colors.white.withOpacity(0.6),
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      widget.badgeText,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        shadows: [
                          Shadow(
                            color: Colors.white.withOpacity(0.8),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              
              // Orbit trail particles
              ...List.generate(12, (index) {
                final angle = _orbitAnimation.value + (index * math.pi / 6);
                final opacity = (math.sin(_orbitAnimation.value + index) + 1) / 4;
                return Transform.translate(
                  offset: Offset(
                    (widget.orbitRadius + 10) * math.cos(angle),
                    (widget.orbitRadius + 10) * math.sin(angle),
                  ),
                  child: Container(
                    width: 3,
                    height: 3,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.glowColor.withOpacity(opacity),
                      boxShadow: [
                        BoxShadow(
                          color: widget.glowColor.withOpacity(opacity),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            widget.glowColor.withOpacity(0.3),
            Colors.purple.withOpacity(0.3),
            Colors.blue.withOpacity(0.3),
          ],
        ),
      ),
      child: Icon(
        Icons.person,
        size: widget.size * 0.6,
        color: Colors.white.withOpacity(0.9),
      ),
    );
  }
}

// Demo usage in your app
class OribitingAvatarBadgeAnimationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A0A0F),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           
            // Primary Avatar
            OrbitingAvatarBadge(
              size: 120,
              badgeText: 'ONLINE',
              badgeColor: Color(0xFF00FF88),
              glowColor: Color(0xFF00FF88),
              orbitRadius: 70,
              orbitDuration: Duration(seconds: 8),
            ),
            
            
            // Smaller variants
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OrbitingAvatarBadge(
                  size: 60,
                  badgeText: 'PRO',
                  badgeColor: Color(0xFFFF6B35),
                  glowColor: Color(0xFFFF6B35),
                  orbitRadius: 50,
                  orbitDuration: Duration(seconds: 6),
                ),
                OrbitingAvatarBadge(
                  size: 60,
                  badgeText: 'VIP',
                  badgeColor: Color(0xFF8A2BE2),
                  glowColor: Color(0xFF8A2BE2),
                  orbitRadius: 50,
                  orbitDuration: Duration(seconds: 10),
                ),
               
              ],
            ),
             OrbitingAvatarBadge(
                  size: 80,
                  badgeText: 'LIVE',
                  badgeColor: Color(0xFFFF1493),
                  glowColor: Color(0xFFFF1493),
                  orbitRadius: 50,
                  orbitDuration: Duration(seconds: 4),
                ),
          ],
        ),
      ),
    );
  }
}