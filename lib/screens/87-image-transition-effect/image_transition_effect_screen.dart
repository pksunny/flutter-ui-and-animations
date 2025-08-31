import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math' as math;

class ImageTransitionEffectScreen extends StatefulWidget {
  @override
  _ImageTransitionEffectScreenState createState() => _ImageTransitionEffectScreenState();
}

class _ImageTransitionEffectScreenState extends State<ImageTransitionEffectScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _backgroundController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _backgroundAnimation;
  
  int _currentIndex = 0;
  int _transitionType = 0;
  
  final List<String> _imageUrls = [
    'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&h=600&fit=crop',
    'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=800&h=600&fit=crop',
    'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800&h=600&fit=crop',
    'https://images.unsplash.com/photo-1500622944204-b135684e99fd?w=800&h=600&fit=crop',
    'https://images.unsplash.com/photo-1519904981063-b0cf448d479e?w=800&h=600&fit=crop',
  ];
  
  final List<String> _transitionNames = [
    'Fade & Scale',
    'Slide & Rotate',
    'Flip 3D',
    'Zoom Blur',
    'Liquid Morph'
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    
    _backgroundController = AnimationController(
      duration: Duration(seconds: 20),
      vsync: this,
    )..repeat();
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    
    _rotationAnimation = Tween<double>(begin: -0.1, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    
    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      _backgroundController,
    );
    
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  void _nextImage() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _imageUrls.length;
    });
    _controller.reset();
    _controller.forward();
  }

  void _previousImage() {
    setState(() {
      _currentIndex = _currentIndex == 0 ? _imageUrls.length - 1 : _currentIndex - 1;
    });
    _controller.reset();
    _controller.forward();
  }

  void _changeTransitionType() {
    setState(() {
      _transitionType = (_transitionType + 1) % _transitionNames.length;
    });
    _controller.reset();
    _controller.forward();
  }

  Widget _buildTransitionWidget() {
    switch (_transitionType) {
      case 0: // Fade & Scale
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Opacity(
                opacity: _fadeAnimation.value,
                child: child,
              ),
            );
          },
          child: _buildImageContainer(),
        );
      
      case 1: // Slide & Rotate
        return SlideTransition(
          position: _slideAnimation,
          child: AnimatedBuilder(
            animation: _rotationAnimation,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotationAnimation.value,
                child: child,
              );
            },
            child: _buildImageContainer(),
          ),
        );
      
      case 2: // Flip 3D
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final angle = _controller.value * math.pi;
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(angle),
              child: angle >= math.pi / 2
                  ? Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..rotateY(math.pi),
                      child: child,
                    )
                  : _buildImageContainer(),
            );
          },
          child: _buildImageContainer(),
        );
      
      case 3: // Zoom Blur
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final blur = (1.0 - _controller.value) * 10.0;
            return Transform.scale(
              scale: 1.0 + (1.0 - _controller.value) * 0.3,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                    child: child,
                  ),
                ),
              ),
            );
          },
          child: _buildImageContainer(),
        );
      
      case 4: // Liquid Morph
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20 + _controller.value * 10),
              ),
              child: ClipPath(
                clipper: LiquidClipper(_controller.value),
                child: Transform.scale(
                  scale: 0.9 + _controller.value * 0.1,
                  child: child,
                ),
              ),
            );
          },
          child: _buildImageContainer(),
        );
      
      default:
        return _buildImageContainer();
    }
  }

  Widget _buildImageContainer() {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(
          _imageUrls[_currentIndex],
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              height: 300,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.grey[300]!, Colors.grey[100]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                  strokeWidth: 3,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  HSLColor.fromAHSL(1.0, _backgroundAnimation.value * 360, 0.6, 0.9).toColor(),
                  HSLColor.fromAHSL(1.0, (_backgroundAnimation.value * 360 + 60) % 360, 0.4, 0.95).toColor(),
                ],
                stops: [0.0, 1.0],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Amazing',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Image Transitions',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withOpacity(0.3)),
                          ),
                          child: Text(
                            '${_currentIndex + 1}/${_imageUrls.length}',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 40),
                    
                    // Main Image Area
                    Expanded(
                      child: Center(
                        child: _buildTransitionWidget(),
                      ),
                    ),
                    
                    SizedBox(height: 40),
                    
                    // Transition Type Button
                    Center(
                      child: GestureDetector(
                        onTap: _changeTransitionType,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.auto_fix_high, color: Colors.blue[600]),
                              SizedBox(width: 8),
                              Text(
                                _transitionNames[_transitionType],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 20),
                    
                    // Control Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildControlButton(
                          icon: Icons.arrow_back_ios_new,
                          onTap: _previousImage,
                        ),
                        _buildControlButton(
                          icon: Icons.play_arrow,
                          onTap: () {
                            _controller.reset();
                            _controller.forward();
                          },
                          isPrimary: true,
                        ),
                        _buildControlButton(
                          icon: Icons.arrow_forward_ios,
                          onTap: _nextImage,
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: isPrimary ? Colors.white : Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: isPrimary ? Colors.blue[600] : Colors.grey[600],
          size: 24,
        ),
      ),
    );
  }
}

class LiquidClipper extends CustomClipper<Path> {
  final double progress;

  LiquidClipper(this.progress);

  @override
  Path getClip(Size size) {
    final path = Path();
    final width = size.width;
    final height = size.height;
    
    final waveHeight = 20 * (1 - progress);
    final waveFreq = 2 * math.pi * progress;
    
    path.moveTo(0, waveHeight * math.sin(waveFreq));
    
    for (double x = 0; x <= width; x++) {
      final y = waveHeight * math.sin(waveFreq + x * 0.01);
      path.lineTo(x, y);
    }
    
    path.lineTo(width, height + waveHeight * math.sin(waveFreq + width * 0.01));
    path.lineTo(width, height);
    path.lineTo(0, height);
    path.close();
    
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}