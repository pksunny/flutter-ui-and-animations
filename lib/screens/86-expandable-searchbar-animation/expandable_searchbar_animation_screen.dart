import 'package:flutter/material.dart';

class AnimatedExpandableSearchBar extends StatefulWidget {
  final Function(String)? onSubmitted;
  final Function(String)? onChanged;
  final String hintText;
  final Color primaryColor;
  final Color backgroundColor;
  final double height;

  const AnimatedExpandableSearchBar({
    Key? key,
    this.onSubmitted,
    this.onChanged,
    this.hintText = 'Search...',
    this.primaryColor = const Color(0xFF6C5CE7),
    this.backgroundColor = Colors.white,
    this.height = 56.0,
  }) : super(key: key);

  @override
  State<AnimatedExpandableSearchBar> createState() =>
      _AnimatedExpandableSearchBarState();
}

class _AnimatedExpandableSearchBarState
    extends State<AnimatedExpandableSearchBar>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _fadeController;
  late Animation<double> _widthAnimation;
  late Animation<double> _borderRadiusAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _iconRotationAnimation;

  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _widthAnimation = Tween<double>(
      begin: widget.height,
      end: 280.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _borderRadiusAnimation = Tween<double>(
      begin: widget.height / 2,
      end: 28.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _iconRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.5,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _fadeController.dispose();
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    if (_isExpanded) {
      // Collapsing
      _focusNode.unfocus();
      _fadeController.reverse();
      _animationController.reverse();
      _textController.clear();
      setState(() {
        _isExpanded = false;
      });
    } else {
      // Expanding
      setState(() {
        _isExpanded = true;
      });
      _animationController.forward();
      _fadeController.forward();
      Future.delayed(const Duration(milliseconds: 400), () {
        if (_isExpanded) {
          _focusNode.requestFocus();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Container(
            width: _widthAnimation.value,
            height: widget.height,
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(_borderRadiusAnimation.value),
              boxShadow: [
                BoxShadow(
                  color: widget.primaryColor.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                  spreadRadius: _isExpanded ? 2 : 0,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Gradient background overlay
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(_borderRadiusAnimation.value),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        widget.primaryColor.withOpacity(0.05),
                        widget.primaryColor.withOpacity(0.02),
                      ],
                    ),
                  ),
                ),
                
                // Main content
                Row(
                  children: [
                    // Search/Close icon button
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _toggleSearch,
                        borderRadius: BorderRadius.circular(_borderRadiusAnimation.value),
                        child: Container(
                          width: widget.height,
                          height: widget.height,
                          decoration: BoxDecoration(
                            color: widget.primaryColor,
                            borderRadius: BorderRadius.circular(_borderRadiusAnimation.value),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                widget.primaryColor,
                                widget.primaryColor.withOpacity(0.8),
                              ],
                            ),
                          ),
                          child: AnimatedBuilder(
                            animation: _iconRotationAnimation,
                            builder: (context, child) {
                              return RotationTransition(
                                turns: _iconRotationAnimation,
                                child: Icon(
                                  _isExpanded ? Icons.close_rounded : Icons.search_rounded,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    
                    // Text field
                    if (_widthAnimation.value > widget.height + 20)
                      Expanded(
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: TextField(
                              controller: _textController,
                              focusNode: _focusNode,
                              onSubmitted: widget.onSubmitted,
                              onChanged: widget.onChanged,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[800],
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                hintText: widget.hintText,
                                hintStyle: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                              cursorColor: widget.primaryColor,
                              cursorWidth: 2,
                              cursorRadius: const Radius.circular(1),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                
                // Shimmer effect on hover/focus
                if (_isExpanded)
                  Positioned.fill(
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(_borderRadiusAnimation.value),
                            border: Border.all(
                              color: widget.primaryColor.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                        );
                      },
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

// Example usage widget
class ExpandableSearchbarAnimationScreen extends StatefulWidget {
  @override
  _ExpandableSearchbarAnimationScreenState createState() => _ExpandableSearchbarAnimationScreenState();
}

class _ExpandableSearchbarAnimationScreenState extends State<ExpandableSearchbarAnimationScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Animated Search Bar',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.grey[800],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 100),
          
          // Main search bar
          AnimatedExpandableSearchBar(
            hintText: 'Search anything...',
            primaryColor: const Color(0xFF6C5CE7),
            backgroundColor: Colors.white,
            onSubmitted: (query) {
              setState(() {
                _searchQuery = query;
              });
              print('Search submitted: $query');
            },
            onChanged: (query) {
              setState(() {
                _searchQuery = query;
              });
            },
          ),
          
          const SizedBox(height: 40),
          
          // Display current search query
          if (_searchQuery.isNotEmpty)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.search_rounded,
                    size: 32,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Searching for:',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '"$_searchQuery"',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6C5CE7),
                    ),
                  ),
                ],
              ),
            ),
            
          const SizedBox(height: 60),
          
          // Additional search bars with different colors
          const Text(
            'Different Color Variations:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          
          const SizedBox(height: 30),
          
          AnimatedExpandableSearchBar(
            hintText: 'Search products...',
            primaryColor: const Color(0xFFFF6B6B),
            backgroundColor: Colors.white,
            height: 52,
            onSubmitted: (query) => print('Red search: $query'),
          ),
          
          const SizedBox(height: 20),
          
          AnimatedExpandableSearchBar(
            hintText: 'Find locations...',
            primaryColor: const Color(0xFF4ECDC4),
            backgroundColor: Colors.white,
            height: 52,
            onSubmitted: (query) => print('Teal search: $query'),
          ),
          
          const SizedBox(height: 20),
          
          AnimatedExpandableSearchBar(
            hintText: 'Discover music...',
            primaryColor: const Color(0xFFFFBE0B),
            backgroundColor: Colors.white,
            height: 52,
            onSubmitted: (query) => print('Yellow search: $query'),
          ),
        ],
      ),
    );
  }
}