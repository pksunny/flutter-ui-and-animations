import 'package:flutter/material.dart';
import 'dart:math' as math;

class GlowingSearchbarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Beautiful Search',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 40),
              GlowingSearchbar(),
            ],
          ),
        ),
      ),
    );
  }
}

class GlowingSearchbar extends StatefulWidget {
  @override
  _GlowingSearchbarState createState() => _GlowingSearchbarState();
}

class _GlowingSearchbarState extends State<GlowingSearchbar>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late AnimationController _borderController;
  late Animation<double> _glowAnimation;
  late Animation<double> _borderAnimation;
  
  TextEditingController _textController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    
    _glowController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
    
    _borderController = AnimationController(
      duration: Duration(milliseconds: 3000),
      vsync: this,
    );
    
    _glowAnimation = Tween<double>(
      begin: 0.4,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));
    
    _borderAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _borderController,
      curve: Curves.linear,
    ));
    
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
        if (_isFocused) {
          _borderController.repeat();
        } else {
          _borderController.stop();
        }
      });
    });
    
    _textController.addListener(() {
      setState(() {
        _hasText = _textController.text.isNotEmpty;
        if (_hasText && !_borderController.isAnimating) {
          _borderController.repeat();
        } else if (!_hasText && !_isFocused) {
          _borderController.stop();
        }
      });
    });
  }

  @override
  void dispose() {
    _glowController.dispose();
    _borderController.dispose();
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_glowAnimation, _borderAnimation]),
      builder: (context, child) {
        return Container(
          height: 56,
          child: Stack(
            children: [
              // Main Container
              Container(
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF1E1E1E),
                      Color(0xFF2A2A2A),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: _isFocused || _hasText
                        ? Colors.transparent
                        : Colors.grey.withOpacity(0.3),
                    width: 1,
                  ),
                  boxShadow: [
                    if (_isFocused || _hasText)
                      BoxShadow(
                        color: Color(0xFF6366F1).withOpacity(0.3 * _glowAnimation.value),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Search Icon
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 16),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        child: Icon(
                          Icons.search_rounded,
                          color: _isFocused || _hasText 
                              ? Color(0xFF6366F1) 
                              : Colors.grey[400],
                          size: 22,
                        ),
                      ),
                    ),
                    
                    // Text Field
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        focusNode: _focusNode,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 16),
                        ),
                        cursorColor: Color(0xFF6366F1),
                        cursorWidth: 2,
                      ),
                    ),
                    
                    // Clear Button
                    if (_hasText)
                      Padding(
                        padding: EdgeInsets.only(right: 16),
                        child: GestureDetector(
                          onTap: () {
                            _textController.clear();
                          },
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.grey[700],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    
                    // Action Button
                    Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: _isFocused || _hasText
                                ? [Color(0xFF6366F1), Color(0xFF8B5CF6)]
                                : [Colors.grey[600]!, Colors.grey[700]!],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            if (_isFocused || _hasText)
                              BoxShadow(
                                color: Color(0xFF6366F1).withOpacity(0.4),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                          ],
                        ),
                        child: Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Moving Border Overlay
              if (_isFocused || _hasText)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      gradient: SweepGradient(
                        colors: [
                          Colors.transparent,
                          Color(0xFF6366F1).withOpacity(0.8),
                          Colors.transparent,
                          Color(0xFF8B5CF6).withOpacity(0.6),
                          Colors.transparent,
                          Color(0xFF06B6D4).withOpacity(0.4),
                          Colors.transparent,
                        ],
                        stops: [0.0, 0.15, 0.3, 0.5, 0.65, 0.8, 1.0],
                        transform: GradientRotation(_borderAnimation.value * 2 * math.pi),
                      ),
                    ),
                    child: Container(
                      margin: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(26),
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}