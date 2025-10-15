import 'package:flutter/material.dart';
import 'dart:math' as math;

/// 🎯 Demo screen showcasing the magical collapsing AppBar
class CollapseTransition extends StatelessWidget {
  const CollapseTransition({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MagicalCollapsingAppBar(
      // 🎨 Expanded state configuration
      expandedHeight: 320.0,
      expandedTitle: 'Discover\nAmazing Places',
      expandedTitleStyle: const TextStyle(
        fontSize: 42,
        fontWeight: FontWeight.w900,
        height: 1.2,
        letterSpacing: -1,
        color: Colors.white,
      ),
      
      // 🎭 Collapsed state configuration
      collapsedTitle: 'Amazing Places',
      collapsedTitleStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      
      // 🖼️ Image configuration
      heroImage: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800',
      heroImageFit: BoxFit.cover,
      
      // 🎨 Color & style configuration
      backgroundColor: Colors.deepPurple,
      gradientColors: [
        Colors.deepPurple.shade900.withOpacity(0.9),
        Colors.purple.shade600.withOpacity(0.7),
        Colors.transparent,
      ],
      
      // ⚙️ Behavior configuration
      pinned: true,
      floating: false,
      snap: false,
      
      // ✨ Animation configuration
      collapseTransitionDuration: const Duration(milliseconds: 300),
      imageScaleFactor: 0.95,
      titleFadeInPoint: 0.3,
      
      // 🎯 Actions
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.favorite_border, color: Colors.white),
          onPressed: () {},
        ),
      ],
      
      // 📱 Leading widget
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.white),
        onPressed: () {},
      ),
      
      // 📜 Body content - use slivers for proper scrolling
      bodyBuilder: (context) => _buildDemoContent(),
    );
  }

  List<Widget> _buildDemoContent() {
    return List.generate(20, (index) {
      return SliverToBoxAdapter(
        child: Container(
          margin: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.primaries[index % Colors.primaries.length],
                        Colors.primaries[index % Colors.primaries.length].shade700,
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Opacity(
                          opacity: 0.3,
                          child: Image.network(
                            'https://images.unsplash.com/photo-${1506905925346 + index}?w=400',
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const SizedBox(),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '⭐ ${(4.0 + (index % 10) / 10).toStringAsFixed(1)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Amazing Place ${index + 1}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Discover the beauty and wonder of this incredible destination.',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

/// 🌟 MAGICAL COLLAPSING APP BAR
/// A highly customizable, beautiful, and production-ready collapsing AppBar
/// with smooth animations and stunning visual effects.
class MagicalCollapsingAppBar extends StatefulWidget {
  // 📏 Layout Configuration
  final double expandedHeight;
  final double collapsedHeight;
  
  // 📝 Title Configuration
  final String expandedTitle;
  final String collapsedTitle;
  final TextStyle? expandedTitleStyle;
  final TextStyle? collapsedTitleStyle;
  
  // 🖼️ Image Configuration
  final String? heroImage;
  final BoxFit heroImageFit;
  final double imageScaleFactor;
  
  // 🎨 Visual Configuration
  final Color? backgroundColor;
  final List<Color>? gradientColors;
  final bool showGradientOverlay;
  
  // ⚙️ Behavior Configuration
  final bool pinned;
  final bool floating;
  final bool snap;
  
  // ✨ Animation Configuration
  final Duration collapseTransitionDuration;
  final Curve collapseTransitionCurve;
  final double titleFadeInPoint;
  
  // 🎯 Widgets
  final Widget? leading;
  final List<Widget>? actions;
  final List<Widget> Function(BuildContext)? bodyBuilder;
  
  const MagicalCollapsingAppBar({
    Key? key,
    this.expandedHeight = 300.0,
    this.collapsedHeight = 56.0,
    required this.expandedTitle,
    required this.collapsedTitle,
    this.expandedTitleStyle,
    this.collapsedTitleStyle,
    this.heroImage,
    this.heroImageFit = BoxFit.cover,
    this.imageScaleFactor = 0.9,
    this.backgroundColor,
    this.gradientColors,
    this.showGradientOverlay = true,
    this.pinned = true,
    this.floating = false,
    this.snap = false,
    this.collapseTransitionDuration = const Duration(milliseconds: 300),
    this.collapseTransitionCurve = Curves.easeInOut,
    this.titleFadeInPoint = 0.3,
    this.leading,
    this.actions,
    this.bodyBuilder,
  }) : super(key: key);

  @override
  State<MagicalCollapsingAppBar> createState() => _MagicalCollapsingAppBarState();
}

class _MagicalCollapsingAppBarState extends State<MagicalCollapsingAppBar>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _animationController;
  
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.collapseTransitionDuration,
    );
    
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    final maxScroll = widget.expandedHeight - widget.collapsedHeight;
    final progress = (offset / maxScroll).clamp(0.0, 1.0);
    
    _animationController.value = progress;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: widget.expandedHeight,
            collapsedHeight: widget.collapsedHeight,
            pinned: widget.pinned,
            floating: widget.floating,
            snap: widget.snap,
            backgroundColor: widget.backgroundColor ?? Colors.deepPurple,
            elevation: 0,
            leading: widget.leading,
            actions: widget.actions,
            flexibleSpace: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return _MagicalFlexibleSpace(
                  controller: _animationController,
                  expandedHeight: widget.expandedHeight,
                  collapsedHeight: widget.collapsedHeight,
                  expandedTitle: widget.expandedTitle,
                  collapsedTitle: widget.collapsedTitle,
                  expandedTitleStyle: widget.expandedTitleStyle,
                  collapsedTitleStyle: widget.collapsedTitleStyle,
                  heroImage: widget.heroImage,
                  heroImageFit: widget.heroImageFit,
                  imageScaleFactor: widget.imageScaleFactor,
                  gradientColors: widget.gradientColors,
                  showGradientOverlay: widget.showGradientOverlay,
                  titleFadeInPoint: widget.titleFadeInPoint,
                );
              },
            ),
          ),
          // Add padding at the top of content
          SliverPadding(
            padding: const EdgeInsets.only(top: 20),
          ),
          // Body content as slivers
          if (widget.bodyBuilder != null)
            ...widget.bodyBuilder!(context),
          // Add padding at the bottom
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 20),
          ),
        ],
      ),
    );
  }
}

/// 🎭 MAGICAL FLEXIBLE SPACE
/// The core component that handles all the magic animations and transitions
class _MagicalFlexibleSpace extends StatelessWidget {
  final AnimationController controller;
  final double expandedHeight;
  final double collapsedHeight;
  final String expandedTitle;
  final String collapsedTitle;
  final TextStyle? expandedTitleStyle;
  final TextStyle? collapsedTitleStyle;
  final String? heroImage;
  final BoxFit heroImageFit;
  final double imageScaleFactor;
  final List<Color>? gradientColors;
  final bool showGradientOverlay;
  final double titleFadeInPoint;

  const _MagicalFlexibleSpace({
    Key? key,
    required this.controller,
    required this.expandedHeight,
    required this.collapsedHeight,
    required this.expandedTitle,
    required this.collapsedTitle,
    this.expandedTitleStyle,
    this.collapsedTitleStyle,
    this.heroImage,
    required this.heroImageFit,
    required this.imageScaleFactor,
    this.gradientColors,
    required this.showGradientOverlay,
    required this.titleFadeInPoint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = controller.value;
    
    // 🎨 Calculate animations
    final imageScale = Tween<double>(begin: 1.0, end: imageScaleFactor)
        .transform(progress);
    final imageOpacity = Tween<double>(begin: 1.0, end: 0.0)
        .transform(math.min(progress * 2, 1.0));
    
    final expandedOpacity = Tween<double>(begin: 1.0, end: 0.0)
        .transform(math.min(progress * 1.5, 1.0));
    
    final collapsedOpacity = progress > titleFadeInPoint
        ? Tween<double>(begin: 0.0, end: 1.0)
            .transform((progress - titleFadeInPoint) / (1.0 - titleFadeInPoint))
        : 0.0;
    
    return LayoutBuilder(
      builder: (context, constraints) {
        final currentHeight = constraints.maxHeight;
        final percent = (currentHeight - collapsedHeight) /
            (expandedHeight - collapsedHeight);
        
        return Stack(
          fit: StackFit.expand,
          children: [
            // 🖼️ Hero Image with Scale Animation
            if (heroImage != null)
              Positioned.fill(
                child: Transform.scale(
                  scale: imageScale,
                  child: Opacity(
                    opacity: imageOpacity,
                    child: Image.network(
                      heroImage!,
                      fit: heroImageFit,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.deepPurple.shade400,
                                Colors.purple.shade600,
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            
            // 🌈 Gradient Overlay
            if (showGradientOverlay)
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: gradientColors ??
                          [
                            Colors.black.withOpacity(0.7),
                            Colors.black.withOpacity(0.4),
                            Colors.transparent,
                          ],
                    ),
                  ),
                ),
              ),
            
            // ✨ Expanded Title
            Positioned(
              left: 24,
              right: 24,
              bottom: 40,
              child: Opacity(
                opacity: expandedOpacity,
                child: Transform.translate(
                  offset: Offset(0, progress * 20),
                  child: Text(
                    expandedTitle,
                    style: expandedTitleStyle ??
                        const TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.w900,
                          height: 1.2,
                          letterSpacing: -1,
                          color: Colors.white,
                        ),
                  ),
                ),
              ),
            ),
            
            // 🎯 Collapsed Title (in AppBar center)
            if (progress > titleFadeInPoint)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Container(
                    height: collapsedHeight,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 60),
                    child: Opacity(
                      opacity: collapsedOpacity,
                      child: Transform.scale(
                        scale: 0.9 + (collapsedOpacity * 0.1),
                        child: Text(
                          collapsedTitle,
                          style: collapsedTitleStyle ??
                              const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            
            // 💫 Decorative Elements (Shimmer effect on scroll)
            if (progress < 0.5)
              Positioned(
                top: 60 + (progress * 100),
                right: 20 - (progress * 40),
                child: Opacity(
                  opacity: 1.0 - (progress * 2),
                  child: Transform.rotate(
                    angle: progress * math.pi * 2,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}