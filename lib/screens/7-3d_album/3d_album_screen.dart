// pubspec.yaml dependencies:
/*
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2
  vector_math: ^2.1.4
  glassmorphism: ^3.0.0
  animated_text_kit: ^4.2.2
  flutter_staggered_animations: ^1.1.1
  shimmer: ^3.0.0
  blur: ^3.1.0
*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math_64.dart' as math;
import 'dart:math' as math_core;
import 'dart:ui';

// SPLASH SCREEN WITH FUTURISTIC LOADING ANIMATION
class SplashScreen3D extends StatefulWidget {
  const SplashScreen3D({Key? key}) : super(key: key);

  @override
  State<SplashScreen3D> createState() => _SplashScreen3DState();
}

class _SplashScreen3DState extends State<SplashScreen3D>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _particleController;
  late Animation<double> _logoScale;
  late Animation<double> _logoRotation;
  late Animation<double> _glowIntensity;

  @override
  void initState() {
    super.initState();
    
    _logoController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    
    _particleController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _logoRotation = Tween<double>(begin: 0.0, end: 2 * math_core.pi).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );

    _glowIntensity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );

    _startAnimation();
  }

  void _startAnimation() async {
    await _logoController.forward();
    await Future.delayed(const Duration(seconds: 1));
    
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, _) => const AlbumHomePage(),
          transitionDuration: const Duration(milliseconds: 1000),
          transitionsBuilder: (context, animation, _, child) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.3),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                )),
                child: child,
              ),
            );
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.0,
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
              Color(0xFF0F0F23),
              Color(0xFF000000),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Animated particles background
            AnimatedBuilder(
              animation: _particleController,
              builder: (context, child) {
                return CustomPaint(
                  painter: ParticlesPainter(_particleController.value),
                  size: Size.infinite,
                );
              },
            ),
            
            // Main logo
            Center(
              child: AnimatedBuilder(
                animation: _logoController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _logoScale.value,
                    child: Transform.rotate(
                      angle: _logoRotation.value,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Color(0xFF00D4FF).withOpacity(_glowIntensity.value),
                              Color(0xFF7B2CBF).withOpacity(_glowIntensity.value),
                              Colors.transparent,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF00D4FF).withOpacity(_glowIntensity.value * 0.8),
                              blurRadius: 30,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.album,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            
            // Loading text
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _logoController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _logoController.value,
                    child: const Column(
                      children: [
                        Text(
                          '3D ALBUMS',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 3,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        LoadingDots(),
                      ],
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

// LOADING DOTS ANIMATION
class LoadingDots extends StatefulWidget {
  const LoadingDots({Key? key}) : super(key: key);

  @override
  State<LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<LoadingDots>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(3, (index) {
      return AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      );
    });

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();

    _startAnimation();
  }

  void _startAnimation() async {
    while (mounted) {
      for (int i = 0; i < _controllers.length; i++) {
        await Future.delayed(const Duration(milliseconds: 200));
        if (mounted) {
          _controllers[i].forward().then((_) {
            if (mounted) _controllers[i].reverse();
          });
        }
      }
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF00D4FF).withOpacity(_animations[index].value),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF00D4FF).withOpacity(_animations[index].value * 0.8),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}

// PARTICLES PAINTER FOR BACKGROUND EFFECT
class ParticlesPainter extends CustomPainter {
  final double animationValue;
  final List<Particle> particles = [];

  ParticlesPainter(this.animationValue) {
    if (particles.isEmpty) {
      for (int i = 0; i < 50; i++) {
        particles.add(Particle());
      }
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00D4FF).withOpacity(0.3)
      ..style = PaintingStyle.fill;

    for (var particle in particles) {
      final x = particle.x * size.width + 
                math_core.sin(animationValue * 2 * math_core.pi * particle.speed) * 50;
      final y = particle.y * size.height + 
                math_core.cos(animationValue * 2 * math_core.pi * particle.speed) * 30;
      
      canvas.drawCircle(
        Offset(x, y),
        particle.radius * (0.5 + 0.5 * math_core.sin(animationValue * 4 * math_core.pi)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class Particle {
  final double x = math_core.Random().nextDouble();
  final double y = math_core.Random().nextDouble();
  final double radius = math_core.Random().nextDouble() * 3 + 1;
  final double speed = math_core.Random().nextDouble() * 0.5 + 0.2;
}

// MAIN ALBUM HOME PAGE
class AlbumHomePage extends StatefulWidget {
  const AlbumHomePage({Key? key}) : super(key: key);

  @override
  State<AlbumHomePage> createState() => _AlbumHomePageState();
}

class _AlbumHomePageState extends State<AlbumHomePage>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _backgroundController;
  late AnimationController _headerController;
  double _currentPage = 0.0;
  bool _musicEnabled = true;

  final List<Album> albums = [
    Album(
      title: "Neon Dreams",
      artist: "Cyber Flux",
      color: const Color(0xFF00D4FF),
      gradientColors: [const Color(0xFF00D4FF), const Color(0xFF7B2CBF)],
    ),
    Album(
      title: "Digital Horizons", 
      artist: "Synth Wave",
      color: const Color(0xFFFF006E),
      gradientColors: [const Color(0xFFFF006E), const Color(0xFF8338EC)],
    ),
    Album(
      title: "Quantum Beats",
      artist: "Future Bass",
      color: const Color(0xFF06FFA5),
      gradientColors: [const Color(0xFF06FFA5), const Color(0xFF4ECDC4)],
    ),
    Album(
      title: "Holographic",
      artist: "Virtual Reality",
      color: const Color(0xFFFFBE0B),
      gradientColors: [const Color(0xFFFFBE0B), const Color(0xFFFB5607)],
    ),
    Album(
      title: "Space Odyssey",
      artist: "Cosmic Sounds",
      color: const Color(0xFF8B5CF6),
      gradientColors: [const Color(0xFF8B5CF6), const Color(0xFFA855F7)],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8);
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page ?? 0;
      });
    });

    _backgroundController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _headerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _backgroundController.dispose();
    _headerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF0F0F23),
              const Color(0xFF1A1A2E),
              albums[_currentPage.round().clamp(0, albums.length - 1)]
                  .gradientColors[0]
                  .withOpacity(0.1),
              const Color(0xFF000000),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Animated background pattern
            AnimatedBuilder(
              animation: _backgroundController,
              builder: (context, child) {
                return CustomPaint(
                  painter: HolographicBackgroundPainter(_backgroundController.value),
                  size: Size.infinite,
                );
              },
            ),

            // Glassmorphism blur overlay
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
              child: Container(
                color: Colors.black.withOpacity(0.1),
              ),
            ),

            SafeArea(
              child: Column(
                children: [
                  // Header with futuristic design
                  _buildHeader(),
                  
                  const SizedBox(height: 40),
                  
                  // 3D Album cards
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: albums.length,
                      itemBuilder: (context, index) {
                        return _build3DAlbumCard(index);
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Bottom controls
                  _buildBottomControls(),
                  
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return AnimatedBuilder(
      animation: _headerController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -50 * (1 - _headerController.value)),
          child: Opacity(
            opacity: _headerController.value,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [
                            const Color(0xFF00D4FF),
                            const Color(0xFF7B2CBF),
                          ],
                        ).createShader(bounds),
                        child: const Text(
                          'ALBUMS',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      const Text(
                        'Experience the Future of Music',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      setState(() {
                        _musicEnabled = !_musicEnabled;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Color(0xFF00D4FF).withOpacity(0.3),
                            Colors.transparent,
                          ],
                        ),
                        border: Border.all(
                          color: const Color(0xFF00D4FF).withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        _musicEnabled ? Icons.music_note : Icons.music_off,
                        color: const Color(0xFF00D4FF),
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _build3DAlbumCard(int index) {
    final album = albums[index];
    final difference = index - _currentPage;
    final isActive = difference.abs() < 0.5;
    
    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, child) {
        // 3D transformation calculations
        final rotationY = difference * 0.4;
        final scale = 1.0 - (difference.abs() * 0.3).clamp(0.0, 1.0);
        final opacity = (1.0 - difference.abs()).clamp(0.0, 1.0);
        
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001) // Perspective
            ..rotateY(rotationY)
            ..scale(scale),
          child: Opacity(
            opacity: opacity,
            child: GestureDetector(
              onTap: () => _openAlbumDetail(album),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Album3DCard(
                  album: album,
                  isActive: isActive,
                  animationValue: _backgroundController.value,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(albums.length, (index) {
          final isActive = index == _currentPage.round();
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: isActive ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: isActive 
                ? albums[index].color
                : Colors.white.withOpacity(0.3),
              boxShadow: isActive ? [
                BoxShadow(
                  color: albums[index].color.withOpacity(0.6),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ] : null,
            ),
          );
        }),
      ),
    );
  }

  void _openAlbumDetail(Album album) {
    HapticFeedback.mediumImpact();
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, _) => AlbumDetailPage(album: album),
        transitionDuration: const Duration(milliseconds: 800),
        transitionsBuilder: (context, animation, _, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          );
        },
      ),
    );
  }
}

// 3D ALBUM CARD WIDGET
class Album3DCard extends StatefulWidget {
  final Album album;
  final bool isActive;
  final double animationValue;

  const Album3DCard({
    Key? key,
    required this.album,
    required this.isActive,
    required this.animationValue,
  }) : super(key: key);

  @override
  State<Album3DCard> createState() => _Album3DCardState();
}

class _Album3DCardState extends State<Album3DCard>
    with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _hoverAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _hoverAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isHovered = true);
        _hoverController.forward();
        HapticFeedback.lightImpact();
      },
      onTapUp: (_) {
        setState(() => _isHovered = false);
        _hoverController.reverse();
      },
      onTapCancel: () {
        setState(() => _isHovered = false);
        _hoverController.reverse();
      },
      child: AnimatedBuilder(
        animation: _hoverAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _hoverAnimation.value,
            child: Container(
              height: 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    widget.album.gradientColors[0].withOpacity(0.8),
                    widget.album.gradientColors[1].withOpacity(0.6),
                    Colors.black.withOpacity(0.9),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.album.color.withOpacity(0.3),
                    blurRadius: widget.isActive ? 30 : 20,
                    spreadRadius: widget.isActive ? 5 : 0,
                    offset: const Offset(0, 10),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 20,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Stack(
                      children: [
                        // Holographic effect overlay
                        CustomPaint(
                          painter: HolographicEffectPainter(
                            widget.animationValue,
                            widget.album.color,
                          ),
                          size: Size.infinite,
                        ),
                        
                        // Content
                        Padding(
                          padding: const EdgeInsets.all(53),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Album art placeholder with glow
                              Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: RadialGradient(
                                    center: Alignment.topLeft,
                                    radius: 1.5,
                                    colors: [
                                      widget.album.color.withOpacity(0.8),
                                      widget.album.gradientColors[1].withOpacity(0.6),
                                      Colors.black.withOpacity(0.9),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: widget.album.color.withOpacity(0.6),
                                      blurRadius: 20,
                                      spreadRadius: 0,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.album,
                                  size: 80,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                              
                              const SizedBox(height: 30),
                              
                              // Album title
                               Text(
                                widget.album.title,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              
                              const SizedBox(height: 8),
                              
                              // Artist name
                              Text(
                                widget.album.artist,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white.withOpacity(0.7),
                                  letterSpacing: 0.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              
                              const SizedBox(height: 20),
                              
                              // Play button
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      widget.album.color,
                                      widget.album.color.withOpacity(0.8),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: widget.album.color.withOpacity(0.5),
                                      blurRadius: 15,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                  size: 30,
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
            ),
          );
        },
      ),
    );
  }
}

// HOLOGRAPHIC BACKGROUND PAINTER
class HolographicBackgroundPainter extends CustomPainter {
  final double animationValue;

  HolographicBackgroundPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw animated grid lines
    final spacing = 50.0;
    final offset = animationValue * spacing;

    // Vertical lines
    for (double x = -spacing + (offset % spacing); x < size.width + spacing; x += spacing) {
      paint.color = const Color(0xFF00D4FF).withOpacity(0.1);
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Horizontal lines
    for (double y = -spacing + (offset % spacing); y < size.height + spacing; y += spacing) {
      paint.color = const Color(0xFF7B2CBF).withOpacity(0.1);
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }

    // Draw flowing waves
    final path = Path();
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = const Color(0xFF00D4FF).withOpacity(0.2);

    for (int i = 0; i < 5; i++) {
      path.reset();
      final waveOffset = animationValue * 2 * math_core.pi + i * math_core.pi / 2;
      
      for (double x = 0; x <= size.width; x += 5) {
        final y = size.height / 2 + 
                  math_core.sin((x / 100) + waveOffset) * (30 + i * 10) +
                  math_core.sin((x / 50) + waveOffset * 2) * 15;
        
        if (x == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// HOLOGRAPHIC EFFECT PAINTER FOR CARDS
class HolographicEffectPainter extends CustomPainter {
  final double animationValue;
  final Color primaryColor;

  HolographicEffectPainter(this.animationValue, this.primaryColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.overlay;

    // Create shifting holographic bands
    for (int i = 0; i < 3; i++) {
      final bandHeight = size.height / 8;
      final yOffset = (animationValue + i * 0.3) * size.height * 2;
      final currentY = (yOffset % (size.height + bandHeight)) - bandHeight;

      final gradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          primaryColor.withOpacity(0.1),
          primaryColor.withOpacity(0.2),
          primaryColor.withOpacity(0.1),
          Colors.transparent,
        ],
      );

      final rect = Rect.fromLTWH(0, currentY, size.width, bandHeight);
      paint.shader = gradient.createShader(rect);
      canvas.drawRect(rect, paint);
    }

    // Add scanline effect
    paint
      ..shader = null
      ..color = Colors.white.withOpacity(0.03)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    for (double y = 0; y < size.height; y += 4) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ALBUM DETAIL PAGE
class AlbumDetailPage extends StatefulWidget {
  final Album album;

  const AlbumDetailPage({Key? key, required this.album}) : super(key: key);

  @override
  State<AlbumDetailPage> createState() => _AlbumDetailPageState();
}

class _AlbumDetailPageState extends State<AlbumDetailPage>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _rotationController;
  late AnimationController _particleController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  final List<String> tracks = [
    "Neon Pulse",
    "Digital Rain",
    "Cyber Dreams",
    "Virtual Reality",
    "Quantum Leap",
    "Electric Soul",
    "Future Vibes",
    "Holographic Love",
  ];

  @override
  void initState() {
    super.initState();
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _rotationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _particleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _slideAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeInOut),
    );

    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _rotationController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.5,
            colors: [
              widget.album.gradientColors[0].withOpacity(0.3),
              widget.album.gradientColors[1].withOpacity(0.2),
              const Color(0xFF0A0A0A),
              Colors.black,
            ],
          ),
        ),
        child: Stack(
          children: [
            // Animated background
            AnimatedBuilder(
              animation: _particleController,
              builder: (context, child) {
                return CustomPaint(
                  painter: DetailBackgroundPainter(
                    _particleController.value,
                    widget.album.color,
                  ),
                  size: Size.infinite,
                );
              },
            ),

            // Main content
            AnimatedBuilder(
              animation: _slideController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, MediaQuery.of(context).size.height * _slideAnimation.value),
                  child: Opacity(
                    opacity: _fadeAnimation.value,
                    child: SafeArea(
                      child: Column(
                        children: [
                          // Header
                          _buildHeader(),
                          
                          // Album art and info
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  const SizedBox(height: 40),
                                  _buildAlbumArt(),
                                  const SizedBox(height: 40),
                                  _buildAlbumInfo(),
                                  const SizedBox(height: 40),
                                  _buildTrackList(),
                                  const SizedBox(height: 40),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withOpacity(0.3),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withOpacity(0.3),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: const Icon(
              Icons.favorite_border,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withOpacity(0.3),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: const Icon(
              Icons.share,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlbumArt() {
    return AnimatedBuilder(
      animation: _rotationController,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotationController.value * 2 * math_core.pi,
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                center: Alignment.topLeft,
                radius: 1.2,
                colors: [
                  widget.album.gradientColors[0],
                  widget.album.gradientColors[1],
                  Colors.black.withOpacity(0.8),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.album.color.withOpacity(0.6),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.8),
                  blurRadius: 30,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Inner circle with album icon
                Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.3),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.album,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                ),
                
                // Holographic overlay
                CustomPaint(
                  painter: CircularHolographicPainter(
                    _rotationController.value,
                    widget.album.color,
                  ),
                  size: const Size(280, 280),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAlbumInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          Text(
            widget.album.title,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            widget.album.artist,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white.withOpacity(0.7),
              letterSpacing: 1,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildInfoChip("8 Tracks"),
              const SizedBox(width: 16),
              _buildInfoChip("42 min"),
              const SizedBox(width: 16),
              _buildInfoChip("2024"),
            ],
          ),
          const SizedBox(height: 32),
          // Play button
          GestureDetector(
            onTap: () => HapticFeedback.mediumImpact(),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: widget.album.gradientColors,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.album.color.withOpacity(0.8),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.black.withOpacity(0.3),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white.withOpacity(0.8),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTrackList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Tracks",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 20),
          ...tracks.asMap().entries.map((entry) {
            final index = entry.key;
            final track = entry.value;
            
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.black.withOpacity(0.2),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          widget.album.color.withOpacity(0.6),
                          widget.album.color.withOpacity(0.3),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "${index + 1}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          track,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          widget.album.artist,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "${3 + (index % 3)}:${20 + (index * 7) % 40}",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.play_arrow,
                    color: widget.album.color,
                    size: 24,
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// DETAIL BACKGROUND PAINTER
class DetailBackgroundPainter extends CustomPainter {
  final double animationValue;
  final Color primaryColor;

  DetailBackgroundPainter(this.animationValue, this.primaryColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    // Draw floating orbs
    for (int i = 0; i < 8; i++) {
      final x = (size.width * 0.2) + 
                (i * size.width * 0.15) + 
                math_core.sin(animationValue * 2 * math_core.pi + i) * 30;
      final y = (size.height * 0.1) + 
                (i * size.height * 0.1) + 
                math_core.cos(animationValue * 2 * math_core.pi + i * 0.7) * 40;
      
      final gradient = RadialGradient(
        colors: [
          primaryColor.withOpacity(0.3),
          primaryColor.withOpacity(0.1),
          Colors.transparent,
        ],
      );
      
      paint.shader = gradient.createShader(
        Rect.fromCircle(center: Offset(x, y), radius: 20 + i * 3),
      );
      
      canvas.drawCircle(Offset(x, y), 20 + i * 3, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// CIRCULAR HOLOGRAPHIC PAINTER
class CircularHolographicPainter extends CustomPainter {
  final double animationValue;
  final Color primaryColor;

  CircularHolographicPainter(this.animationValue, this.primaryColor);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..blendMode = BlendMode.overlay;

    // Draw rotating rings
    for (int i = 0; i < 5; i++) {
      final ringRadius = radius * 0.3 + i * 20;
      final rotationOffset = animationValue * 2 * math_core.pi + i * math_core.pi / 3;
      
      paint.color = primaryColor.withOpacity(0.3 - i * 0.05);
      
      final path = Path();
      for (double angle = 0; angle < 2 * math_core.pi; angle += 0.1) {
        final x = center.dx + math_core.cos(angle + rotationOffset) * ringRadius;
        final y = center.dy + math_core.sin(angle + rotationOffset) * ringRadius;
        
        if (angle == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ALBUM DATA MODEL
class Album {
  final String title;
  final String artist;
  final Color color;
  final List<Color> gradientColors;

  Album({
    required this.title,
    required this.artist,
    required this.color,
    required this.gradientColors,
  });
}