import 'package:flutter/material.dart';
import 'dart:math' as math;

/// 🎯 CORE MORPHING UI WIDGET
/// Ultra-stylish, AI-powered morphing interface that adapts to user selections
/// Fully customizable and reusable across different apps
class AIMorphingUI extends StatefulWidget {
  const AIMorphingUI({Key? key}) : super(key: key);

  @override
  State<AIMorphingUI> createState() => _AIMorphingUIState();
}

class _AIMorphingUIState extends State<AIMorphingUI>
    with TickerProviderStateMixin {
  late AnimationController _morphController;
  late AnimationController _pulseController;
  late AnimationController _floatController;

  String _activeThemeId = 'books';
  late Map<String, MorphingTheme> _themes;

  @override
  void initState() {
    super.initState();
    
    // Initialize themes
    _themes = {
      'books': MorphingTheme(
        id: 'books',
        name: 'Library',
        icon: Icons.menu_book_rounded,
        emoji: '📚',
        gradientColors: const [Color(0xFFFFF8E1), Color(0xFFFFE0B2)],
        accentGradient: const [Color(0xFFFFB300), Color(0xFFFF6F00)],
        cardColors: const [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
        textColor: const Color(0xFF5D4037),
        accentTextColor: const Color(0xFFE65100),
        shadowColor: const Color(0xFFFFB300).withOpacity(0.3),
      ),
      'music': MorphingTheme(
        id: 'music',
        name: 'Harmony',
        icon: Icons.music_note_rounded,
        emoji: '🎵',
        gradientColors: const [Color(0xFFE1F5FE), Color(0xFFB3E5FC)],
        accentGradient: const [Color(0xFF29B6F6), Color(0xFF0277BD)],
        cardColors: const [Color(0xFFE1F5FE), Color(0xFF81D4FA)],
        textColor: const Color(0xFF01579B),
        accentTextColor: const Color(0xFF0277BD),
        shadowColor: const Color(0xFF29B6F6).withOpacity(0.3),
      ),
      'art': MorphingTheme(
        id: 'art',
        name: 'Gallery',
        icon: Icons.palette_rounded,
        emoji: '🎨',
        gradientColors: const [Color(0xFFF3E5F5), Color(0xFFE1BEE7)],
        accentGradient: const [Color(0xFFAB47BC), Color(0xFF6A1B9A)],
        cardColors: const [Color(0xFFF3E5F5), Color(0xFFCE93D8)],
        textColor: const Color(0xFF4A148C),
        accentTextColor: const Color(0xFF6A1B9A),
        shadowColor: const Color(0xFFAB47BC).withOpacity(0.3),
      ),
      'coffee': MorphingTheme(
        id: 'coffee',
        name: 'Café',
        icon: Icons.coffee_rounded,
        emoji: '☕',
        gradientColors: const [Color(0xFFEFEBE9), Color(0xFFD7CCC8)],
        accentGradient: const [Color(0xFF8D6E63), Color(0xFF5D4037)],
        cardColors: const [Color(0xFFEFEBE9), Color(0xFFBCAAA4)],
        textColor: const Color(0xFF3E2723),
        accentTextColor: const Color(0xFF5D4037),
        shadowColor: const Color(0xFF8D6E63).withOpacity(0.3),
      ),
      'nature': MorphingTheme(
        id: 'nature',
        name: 'Outdoors',
        icon: Icons.terrain_rounded,
        emoji: '🏔️',
        gradientColors: const [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
        accentGradient: const [Color(0xFF66BB6A), Color(0xFF2E7D32)],
        cardColors: const [Color(0xFFE8F5E9), Color(0xFFA5D6A7)],
        textColor: const Color(0xFF1B5E20),
        accentTextColor: const Color(0xFF2E7D32),
        shadowColor: const Color(0xFF66BB6A).withOpacity(0.3),
      ),
      'wellness': MorphingTheme(
        id: 'wellness',
        name: 'Wellness',
        icon: Icons.favorite_rounded,
        emoji: '💖',
        gradientColors: const [Color(0xFFFCE4EC), Color(0xFFF8BBD0)],
        accentGradient: const [Color(0xFFEC407A), Color(0xFFC2185B)],
        cardColors: const [Color(0xFFFCE4EC), Color(0xFFF48FB1)],
        textColor: const Color(0xFF880E4F),
        accentTextColor: const Color(0xFFC2185B),
        shadowColor: const Color(0xFFEC407A).withOpacity(0.3),
      ),
    };
    
    // Main morphing animation controller
    _morphController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Pulse animation for active elements
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    // Floating animation for cards
    _floatController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _morphController.dispose();
    _pulseController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  /// Trigger morphing animation when theme changes
  void _changeTheme(String themeId) {
    if (_activeThemeId == themeId) return;
    
    setState(() {
      _activeThemeId = themeId;
    });
    
    _morphController.forward(from: 0.0);
  }

  MorphingTheme get _activeTheme => _themes[_activeThemeId]!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _morphController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: _activeTheme.gradientColors,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildThemeSelector(),
                  const SizedBox(height: 32),
                  Expanded(child: _buildContentArea()),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// 🎨 HEADER WITH MORPHING TITLE
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        children: [
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 600),
            tween: Tween(begin: 0, end: 1),
            builder: (context, value, child) {
              return Transform.rotate(
                angle: value * math.pi * 2,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _activeTheme.accentGradient,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: _activeTheme.shadowColor,
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Icon(
                    _activeTheme.icon,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: _activeTheme.textColor,
                    letterSpacing: -0.5,
                  ),
                  child: Text(_activeTheme.name),
                ),
                const SizedBox(height: 4),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 400),
                  style: TextStyle(
                    fontSize: 14,
                    color: _activeTheme.textColor.withOpacity(0.6),
                    fontWeight: FontWeight.w500,
                  ),
                  child: const Text('AI-Powered Experience'),
                ),
              ],
            ),
          ),
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.0 + (_pulseController.value * 0.1),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: _activeTheme.accentTextColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _activeTheme.accentTextColor.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        color: _activeTheme.accentTextColor,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'AI',
                        style: TextStyle(
                          color: _activeTheme.accentTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// 🎯 THEME SELECTOR WITH MORPHING BUTTONS
  Widget _buildThemeSelector() {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _themes.length,
        itemBuilder: (context, index) {
          final theme = _themes.values.elementAt(index);
          final isActive = theme.id == _activeThemeId;
          
          return _MorphingThemeCard(
            theme: theme,
            isActive: isActive,
            onTap: () => _changeTheme(theme.id),
            pulseAnimation: _pulseController,
          );
        },
      ),
    );
  }

  /// 📱 CONTENT AREA WITH MORPHING CARDS
  Widget _buildContentArea() {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Featured for You'),
              const SizedBox(height: 16),
              _buildFeatureCard(0),
              const SizedBox(height: 20),
              _buildSectionTitle('Recommended'),
              const SizedBox(height: 16),
              _buildFeatureCard(1),
              const SizedBox(height: 20),
              _buildFeatureCard(2),
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 400),
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: _activeTheme.textColor,
      ),
      child: Text(title),
    );
  }

  Widget _buildFeatureCard(int index) {
    final floatOffset = math.sin(_floatController.value * math.pi * 2 + index) * 8;
    
    return Transform.translate(
      offset: Offset(0, floatOffset),
      child: TweenAnimationBuilder<double>(
        duration: Duration(milliseconds: 600 + (index * 100)),
        tween: Tween(begin: 0, end: 1),
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 30 * (1 - value)),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: _activeTheme.cardColors,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: _activeTheme.shadowColor,
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _activeTheme.emoji,
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _activeTheme.accentTextColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'NEW',
                            style: TextStyle(
                              color: _activeTheme.accentTextColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _getCardTitle(index),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: _activeTheme.textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getCardDescription(index),
                      style: TextStyle(
                        fontSize: 14,
                        color: _activeTheme.textColor.withOpacity(0.7),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: _activeTheme.accentGradient,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: _activeTheme.shadowColor,
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'Explore Now',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
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
    );
  }

  String _getCardTitle(int index) {
    final titles = {
      'books': ['Classic Literature', 'Best Sellers 2024', 'Poetry Collection'],
      'music': ['Jazz Essentials', 'Electronic Vibes', 'Acoustic Sessions'],
      'art': ['Modern Masters', 'Digital Art Trends', 'Renaissance Revival'],
      'coffee': ['Artisan Blends', 'Morning Rituals', 'World Tour'],
      'nature': ['Mountain Trails', 'Forest Therapy', 'Ocean Escapes'],
      'wellness': ['Mindful Living', 'Yoga Journey', 'Inner Peace'],
    };
    return titles[_activeThemeId]![index % 3];
  }

  String _getCardDescription(int index) {
    final descriptions = {
      'books': [
        'Discover timeless stories that shaped literature',
        'Explore the most captivating reads of the year',
        'Journey through verses of beauty and emotion'
      ],
      'music': [
        'Smooth rhythms and soulful melodies',
        'Pulse-pounding beats and synthesized dreams',
        'Intimate performances and raw emotion'
      ],
      'art': [
        'Explore revolutionary artistic movements',
        'Witness the fusion of technology and creativity',
        'Rediscover classical beauty in modern context'
      ],
      'coffee': [
        'Handcrafted beans from around the globe',
        'Perfect brews to start your day right',
        'Experience coffee cultures worldwide'
      ],
      'nature': [
        'Breathtaking peaks and scenic adventures',
        'Reconnect with nature and find tranquility',
        'Dive into coastal wonders and marine life'
      ],
      'wellness': [
        'Transform your daily routine with mindfulness',
        'Find balance through movement and breath',
        'Cultivate harmony between body and spirit'
      ],
    };
    return descriptions[_activeThemeId]![index % 3];
  }
}

/// 🎨 MORPHING THEME CARD WIDGET
class _MorphingThemeCard extends StatelessWidget {
  final MorphingTheme theme;
  final bool isActive;
  final VoidCallback onTap;
  final Animation<double> pulseAnimation;

  const _MorphingThemeCard({
    required this.theme,
    required this.isActive,
    required this.onTap,
    required this.pulseAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulseAnimation,
      builder: (context, child) {
        final scale = isActive ? 1.0 + (pulseAnimation.value * 0.05) : 1.0;
        
        return Padding(
          padding: const EdgeInsets.only(right: 16),
          child: GestureDetector(
            onTap: onTap,
            child: Transform.scale(
              scale: scale,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                width: 100,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: isActive
                      ? LinearGradient(colors: theme.accentGradient)
                      : LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.8),
                            Colors.white.withOpacity(0.6),
                          ],
                        ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: isActive
                          ? theme.shadowColor
                          : Colors.black.withOpacity(0.05),
                      blurRadius: isActive ? 20 : 10,
                      offset: Offset(0, isActive ? 10 : 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      theme.icon,
                      color: isActive ? Colors.white : theme.textColor,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      theme.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isActive ? Colors.white : theme.textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// 📦 MORPHING THEME DATA MODEL
class MorphingTheme {
  final String id;
  final String name;
  final IconData icon;
  final String emoji;
  final List<Color> gradientColors;
  final List<Color> accentGradient;
  final List<Color> cardColors;
  final Color textColor;
  final Color accentTextColor;
  final Color shadowColor;

  MorphingTheme({
    required this.id,
    required this.name,
    required this.icon,
    required this.emoji,
    required this.gradientColors,
    required this.accentGradient,
    required this.cardColors,
    required this.textColor,
    required this.accentTextColor,
    required this.shadowColor,
  });
}