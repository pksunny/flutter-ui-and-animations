import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Main Interactive Onboarding Story Widget
/// Fully customizable with story scenes, colors, and animations
class InteractiveOnboardingStory extends StatefulWidget {
  final List<OnboardingScene> scenes;
  final VoidCallback? onComplete;
  final Duration transitionDuration;
  final Curve transitionCurve;

  const InteractiveOnboardingStory({
    Key? key,
    List<OnboardingScene>? scenes,
    this.onComplete,
    this.transitionDuration = const Duration(milliseconds: 600),
    this.transitionCurve = Curves.easeInOutCubic,
  })  : scenes = scenes ?? _defaultScenes,
        super(key: key);

  static const List<OnboardingScene> _defaultScenes = [
    OnboardingScene(
      title: 'Welcome to the Future',
      description: 'Experience a new dimension of digital interaction',
      icon: Icons.rocket_launch_rounded,
      primaryColor: Color(0xFF6C5CE7),
      secondaryColor: Color(0xFFA29BFE),
      accentColor: Color(0xFFDFE6E9),
    ),
    OnboardingScene(
      title: 'Seamless Journey',
      description: 'Navigate through your goals with effortless precision',
      icon: Icons.explore_rounded,
      primaryColor: Color(0xFFFF6B6B),
      secondaryColor: Color(0xFFFFE66D),
      accentColor: Color(0xFFFEF5E7),
    ),
    OnboardingScene(
      title: 'Infinite Possibilities',
      description: 'Unlock limitless potential with intelligent features',
      icon: Icons.auto_awesome_rounded,
      primaryColor: Color(0xFF00D2D3),
      secondaryColor: Color(0xFF4ECDC4),
      accentColor: Color(0xFFE8F8F7),
    ),
    OnboardingScene(
      title: 'Begin Your Story',
      description: 'Transform your vision into reality, one step at a time',
      icon: Icons.celebration_rounded,
      primaryColor: Color(0xFFFF9FF3),
      secondaryColor: Color(0xFFFECA57),
      accentColor: Color(0xFFFFF5F9),
    ),
  ];

  @override
  State<InteractiveOnboardingStory> createState() =>
      _InteractiveOnboardingStoryState();
}

class _InteractiveOnboardingStoryState
    extends State<InteractiveOnboardingStory> {
  late PageController _pageController;
  double _currentPage = 0.0;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page ?? 0.0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Animated Background with Parallax
          _buildParallaxBackground(),

          // Main Content with PageView
          PageView.builder(
            controller: _pageController,
            itemCount: widget.scenes.length,
            physics: const BouncingScrollPhysics(),
            onPageChanged: (index) {
              setState(() {
                _isAnimating = true;
              });
              Future.delayed(widget.transitionDuration, () {
                if (mounted) {
                  setState(() {
                    _isAnimating = false;
                  });
                }
              });
            },
            itemBuilder: (context, index) {
              return _buildScenePage(index, size);
            },
          ),

          // Progress Indicator
          Positioned(
            top: MediaQuery.of(context).padding.top + 20,
            left: 0,
            right: 0,
            child: _buildProgressIndicator(),
          ),

          // Bottom Navigation
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: _buildBottomNavigation(),
          ),
        ],
      ),
    );
  }

  /// Parallax Background with Gradient and Animated Orbs
  Widget _buildParallaxBackground() {
    final currentScene = widget.scenes[_currentPage.floor()];
    final nextScene = _currentPage.floor() + 1 < widget.scenes.length
        ? widget.scenes[_currentPage.floor() + 1]
        : currentScene;

    final progress = _currentPage - _currentPage.floor();

    return AnimatedContainer(
      duration: widget.transitionDuration,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.lerp(
                currentScene.accentColor, nextScene.accentColor, progress)!,
            Color.lerp(currentScene.secondaryColor.withOpacity(0.3),
                nextScene.secondaryColor.withOpacity(0.3), progress)!,
            Colors.white,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Animated Floating Orbs
          ...List.generate(5, (index) {
            return _buildFloatingOrb(
              index: index,
              color: Color.lerp(currentScene.primaryColor.withOpacity(0.1),
                  nextScene.primaryColor.withOpacity(0.1), progress)!,
            );
          }),
        ],
      ),
    );
  }

  /// Individual Scene Page with Parallax Effect
  Widget _buildScenePage(int index, Size size) {
    final scene = widget.scenes[index];
    final parallaxOffset = (_currentPage - index) * 200;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 100),

          // Animated Icon with 3D Transform
          Transform.translate(
            offset: Offset(parallaxOffset * 0.3, 0),
            child: _buildAnimatedIcon(scene, index),
          ),

          const SizedBox(height: 60),

          // Title with Fade and Slide Animation
          Transform.translate(
            offset: Offset(parallaxOffset * 0.5, 0),
            child: Opacity(
              opacity: (1 - (_currentPage - index).abs()).clamp(0.0, 1.0),
              child: Text(
                scene.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                  color: scene.primaryColor,
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Description with Fade Animation
          Transform.translate(
            offset: Offset(parallaxOffset * 0.7, 0),
            child: Opacity(
              opacity: (1 - (_currentPage - index).abs() * 1.5).clamp(0.0, 1.0),
              child: Text(
                scene.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                  height: 1.6,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),

          const Spacer(),
        ],
      ),
    );
  }

  /// Animated Icon with 3D Transform and Glow Effect
  Widget _buildAnimatedIcon(OnboardingScene scene, int index) {
    final scale = (1 - (_currentPage - index).abs() * 0.3).clamp(0.7, 1.0);
    final rotation = (_currentPage - index) * 0.2;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1200),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: scale * (0.8 + value * 0.2),
          child: Transform.rotate(
            angle: rotation,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    scene.primaryColor.withOpacity(0.2),
                    scene.secondaryColor.withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: scene.primaryColor.withOpacity(0.3),
                    blurRadius: 60,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: scene.primaryColor.withOpacity(0.2),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Icon(
                    scene.icon,
                    size: 70,
                    color: scene.primaryColor,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Floating Orb with Animation
  Widget _buildFloatingOrb({required int index, required Color color}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 3000 + index * 500),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        final offset = math.sin(value * math.pi * 2 + index) * 30;
        return Positioned(
          top: 100.0 + index * 100 + offset,
          left: 50.0 + index * 60 + offset * 2,
          child: Container(
            width: 80 + index * 20.0,
            height: 80 + index * 20.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 40,
                  spreadRadius: 5,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Progress Indicator with Animated Dots
  Widget _buildProgressIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.scenes.length, (index) {
        final isActive = index == _currentPage.round();
        final distance = (index - _currentPage).abs();
        final scale = (1 - distance * 0.3).clamp(0.7, 1.0);

        return AnimatedContainer(
          duration: widget.transitionDuration,
          curve: widget.transitionCurve,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 32 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: isActive
                ? widget.scenes[index].primaryColor
                : widget.scenes[index].primaryColor.withOpacity(0.3),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: widget.scenes[index].primaryColor.withOpacity(0.4),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
        );
      }),
    );
  }

  /// Bottom Navigation with Skip and Next Buttons
  Widget _buildBottomNavigation() {
    final isLastPage = _currentPage.round() == widget.scenes.length - 1;
    final currentScene = widget.scenes[_currentPage.round()];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Skip Button
          if (!isLastPage)
            TextButton(
              onPressed: () {
                _pageController.animateToPage(
                  widget.scenes.length - 1,
                  duration: widget.transitionDuration,
                  curve: widget.transitionCurve,
                );
              },
              child: Text(
                'Skip',
                style: TextStyle(
                  fontSize: 16,
                  color: currentScene.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          else
            const SizedBox(width: 60),

          // Next/Get Started Button
          GestureDetector(
            onTap: () {
              if (isLastPage) {
                widget.onComplete?.call();
              } else {
                _pageController.nextPage(
                  duration: widget.transitionDuration,
                  curve: widget.transitionCurve,
                );
              }
            },
            child: AnimatedContainer(
              duration: widget.transitionDuration,
              curve: widget.transitionCurve,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                  colors: [
                    currentScene.primaryColor,
                    currentScene.secondaryColor,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: currentScene.primaryColor.withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isLastPage ? 'Get Started' : 'Next',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Model Class for Onboarding Scene
/// Fully customizable for different stories and themes
class OnboardingScene {
  final String title;
  final String description;
  final IconData icon;
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;

  const OnboardingScene({
    required this.title,
    required this.description,
    required this.icon,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
  });
}