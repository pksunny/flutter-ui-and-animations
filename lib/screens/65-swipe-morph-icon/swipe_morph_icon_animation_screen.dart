import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

class SwipeMorphIconAnimationScreen extends StatefulWidget {
  const SwipeMorphIconAnimationScreen({Key? key}) : super(key: key);

  @override
  State<SwipeMorphIconAnimationScreen> createState() => _SwipeMorphIconAnimationScreenState();
}

class _SwipeMorphIconAnimationScreenState extends State<SwipeMorphIconAnimationScreen>
    with TickerProviderStateMixin {
  late AnimationController _morphController;
  late AnimationController _glowController;
  late AnimationController _rotationController;
  late Animation<double> _morphAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _rotationAnimation;

  int _currentIconIndex = 0;
  double _swipeProgress = 0.0;
  bool _isAnimating = false;

  final List<IconMorphData> _icons = [
    IconMorphData(Icons.lock, Colors.red, "Locked"),
    IconMorphData(Icons.lock_open, Colors.green, "Unlocked"),
    IconMorphData(Icons.favorite_border, Colors.pink, "Like"),
    IconMorphData(Icons.favorite, Colors.red, "Loved"),
    IconMorphData(Icons.visibility_off, Colors.grey, "Hidden"),
    IconMorphData(Icons.visibility, Colors.blue, "Visible"),
    IconMorphData(Icons.star_border, Colors.amber, "Unstarred"),
    IconMorphData(Icons.star, Colors.orange, "Starred"),
  ];

  @override
  void initState() {
    super.initState();
    
    _morphController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _morphAnimation = CurvedAnimation(
      parent: _morphController,
      curve: Curves.elasticOut,
    );
    
    _glowAnimation = CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    );
    
    _rotationAnimation = CurvedAnimation(
      parent: _rotationController,
      curve: Curves.easeOutBack,
    );

    // Start the ambient glow animation
    _glowController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _morphController.dispose();
    _glowController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_isAnimating) return;

    setState(() {
      _swipeProgress += details.delta.dx / 200;
      _swipeProgress = _swipeProgress.clamp(-1.0, 1.0);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (_isAnimating) return;

    if (_swipeProgress.abs() > 0.3) {
      _performMorph(_swipeProgress > 0);
    } else {
      _resetSwipe();
    }
  }

  void _performMorph(bool forward) async {
    setState(() {
      _isAnimating = true;
    });

    // Haptic feedback
    HapticFeedback.mediumImpact();

    // Update icon index
    if (forward) {
      _currentIconIndex = (_currentIconIndex + 1) % _icons.length;
    } else {
      _currentIconIndex = (_currentIconIndex - 1 + _icons.length) % _icons.length;
    }

    // Start animations
    _morphController.forward();
    _rotationController.forward();

    await Future.delayed(const Duration(milliseconds: 800));
    
    _morphController.reset();
    _rotationController.reset();
    
    setState(() {
      _swipeProgress = 0.0;
      _isAnimating = false;
    });
  }

  void _resetSwipe() {
    setState(() {
      _swipeProgress = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title
            AnimatedBuilder(
              animation: _glowAnimation,
              builder: (context, child) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 60),
                  child: Text(
                    "SWIPE TO MORPH",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w300,
                      color: Colors.white.withOpacity(0.7 + _glowAnimation.value * 0.3),
                      letterSpacing: 4,
                    ),
                  ),
                );
              },
            ),
            
            // Main Icon Container
            GestureDetector(
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,
              child: AnimatedBuilder(
                animation: Listenable.merge([
                  _morphAnimation,
                  _glowAnimation,
                  _rotationAnimation,
                ]),
                builder: (context, child) {
                  final currentIcon = _icons[_currentIconIndex];
                  final nextIndex = (_currentIconIndex + 1) % _icons.length;
                  final prevIndex = (_currentIconIndex - 1 + _icons.length) % _icons.length;
                  
                  return Transform.translate(
                    offset: Offset(_swipeProgress * 30, 0),
                    child: Transform.rotate(
                      angle: _rotationAnimation.value * math.pi * 0.5,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              currentIcon.color.withOpacity(0.3),
                              currentIcon.color.withOpacity(0.1),
                              Colors.transparent,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: currentIcon.color.withOpacity(0.3 + _glowAnimation.value * 0.4),
                              blurRadius: 40 + _glowAnimation.value * 20,
                              spreadRadius: 5,
                            ),
                            BoxShadow(
                              color: Colors.white.withOpacity(0.1),
                              blurRadius: 20,
                              spreadRadius: -5,
                              offset: const Offset(0, -10),
                            ),
                          ],
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withOpacity(0.2),
                                Colors.white.withOpacity(0.05),
                              ],
                            ),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 400),
                              transitionBuilder: (child, animation) {
                                return ScaleTransition(
                                  scale: animation,
                                  child: RotationTransition(
                                    turns: animation,
                                    child: child,
                                  ),
                                );
                              },
                              child: Icon(
                                currentIcon.icon,
                                key: ValueKey(_currentIconIndex),
                                size: 80,
                                color: currentIcon.color.withOpacity(0.9),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 60),
            
            // Status Text
            AnimatedBuilder(
              animation: _morphAnimation,
              builder: (context, child) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    _icons[_currentIconIndex].label,
                    key: ValueKey(_currentIconIndex),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: _icons[_currentIconIndex].color.withOpacity(0.8),
                      letterSpacing: 2,
                    ),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 40),
            
            // Swipe Indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedOpacity(
                  opacity: _swipeProgress < -0.1 ? 1.0 : 0.3,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white54,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 20),
                Container(
                  width: 100,
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: Colors.white.withOpacity(0.1),
                  ),
                  child: Stack(
                    children: [
                      AnimatedAlign(
                        alignment: Alignment(_swipeProgress, 0),
                        duration: const Duration(milliseconds: 100),
                        child: Container(
                          width: 20,
                          height: 4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: _icons[_currentIconIndex].color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                AnimatedOpacity(
                  opacity: _swipeProgress > 0.1 ? 1.0 : 0.3,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white54,
                    size: 20,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 60),
            
            // Icon Preview Strip
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _icons.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final isSelected = index == _currentIconIndex;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected 
                          ? _icons[index].color.withOpacity(0.2)
                          : Colors.white.withOpacity(0.05),
                      border: Border.all(
                        color: isSelected
                            ? _icons[index].color.withOpacity(0.5)
                            : Colors.white.withOpacity(0.1),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Icon(
                      _icons[index].icon,
                      size: isSelected ? 24 : 20,
                      color: isSelected 
                          ? _icons[index].color
                          : Colors.white.withOpacity(0.4),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IconMorphData {
  final IconData icon;
  final Color color;
  final String label;

  IconMorphData(this.icon, this.color, this.label);
}