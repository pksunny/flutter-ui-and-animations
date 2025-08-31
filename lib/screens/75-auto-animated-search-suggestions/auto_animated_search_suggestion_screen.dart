// ignore_for_file: prefer_final_fields

import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math' as math;

class AutoAnimatedSearchSuggestionScreen extends StatefulWidget {
  @override
  _AutoAnimatedSearchSuggestionScreenState createState() =>
      _AutoAnimatedSearchSuggestionScreenState();
}

class _AutoAnimatedSearchSuggestionScreenState
    extends State<AutoAnimatedSearchSuggestionScreen>
    with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  late AnimationController _animationController;
  late AnimationController _suggestionController;
  late AnimationController _pulseController;
  late AnimationController _floatingController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _suggestionAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _floatingAnimation;

  List<String> _allSuggestions = [
    'Flutter Development',
    'Dart Programming',
    'Mobile App Design',
    'UI/UX Animation',
    'Firebase Integration',
    'State Management',
    'Custom Widgets',
    'Material Design',
    'iOS Development',
    'Cross Platform',
    'Performance Optimization',
    'Responsive Design',
    'API Integration',
    'Database Design',
    'User Experience',
    'Modern Architecture',
    'Clean Code',
    'Testing Strategies',
  ];

  List<String> _filteredSuggestions = [];
  bool _showSuggestions = false;
  String _selectedSuggestion = '';

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _suggestionController = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _floatingController = AnimationController(
      duration: Duration(milliseconds: 3000),
      vsync: this,
    )..repeat();

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _suggestionAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _suggestionController, curve: Curves.easeOutBack),
    );

    _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _floatingAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.linear),
    );

    _controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);

    _animationController.forward();
  }

  void _onTextChanged() {
    final query = _controller.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredSuggestions = [];
        _showSuggestions = false;
        _suggestionController.reverse();
      } else {
        _filteredSuggestions =
            _allSuggestions
                .where((suggestion) => suggestion.toLowerCase().contains(query))
                .take(5)
                .toList();
        _showSuggestions = _filteredSuggestions.isNotEmpty;
        if (_showSuggestions) {
          _suggestionController.forward();
        } else {
          _suggestionController.reverse();
        }
      }
    });
  }

  void _onFocusChanged() {
    if (_focusNode.hasFocus && _controller.text.isNotEmpty) {
      _onTextChanged();
    } else if (!_focusNode.hasFocus) {
      Future.delayed(Duration(milliseconds: 200), () {
        setState(() {
          _showSuggestions = false;
        });
        _suggestionController.reverse();
      });
    }
  }

  void _selectSuggestion(String suggestion) {
    setState(() {
      _controller.text = suggestion;
      _selectedSuggestion = suggestion;
      _showSuggestions = false;
    });
    _suggestionController.reverse();
    _focusNode.unfocus();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _suggestionController.dispose();
    _pulseController.dispose();
    _floatingController.dispose();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF667eea), Color(0xFF764ba2), Color(0xFFf093fb)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Floating particles
              ...List.generate(20, (index) => _buildFloatingParticle(index)),

              // Main content
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      SizedBox(height: 100),

                      // Title
                      AnimatedBuilder(
                        animation: _scaleAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _scaleAnimation.value,
                            child: Text(
                              'Smart Search',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.2,
                              ),
                            ),
                          );
                        },
                      ),

                      SizedBox(height: 12),

                      Text(
                        'Discover amazing possibilities',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                          fontWeight: FontWeight.w300,
                        ),
                      ),

                      SizedBox(height: 60),

                      // Search Field with suggestions
                      AnimatedBuilder(
                        animation: _scaleAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _scaleAnimation.value,
                            child: _buildSearchField(),
                          );
                        },
                      ),

                      // Selected suggestion display
                      if (_selectedSuggestion.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: _buildSelectedCard(),
                        ),

                      SizedBox(height: 40), // Bottom spacing
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingParticle(int index) {
    return AnimatedBuilder(
      animation: _floatingAnimation,
      builder: (context, child) {
        final offset = Offset(
          100 + (index * 15) + 50 * math.sin(_floatingAnimation.value + index),
          200 +
              (index * 25) +
              30 * math.cos(_floatingAnimation.value + index * 0.5),
        );

        return Positioned(
          left: offset.dx,
          top: offset.dy,
          child: Container(
            width: 4 + (index % 3) * 2,
            height: 4 + (index % 3) * 2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.3),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchField() {
    return Column(
      children: [
        // Main search container
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 0,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                child: AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color:
                              _focusNode.hasFocus
                                  ? Colors.white.withOpacity(0.6)
                                  : Colors.white.withOpacity(
                                    0.2 + 0.1 * _pulseAnimation.value,
                                  ),
                          width: 1.5,
                        ),
                      ),
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search for anything...',
                          hintStyle: TextStyle(
                            color: Colors.white60,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: Colors.white70,
                            size: 24,
                          ),
                          suffixIcon:
                              _controller.text.isNotEmpty
                                  ? GestureDetector(
                                    onTap: () {
                                      _controller.clear();
                                      _onTextChanged();
                                    },
                                    child: Icon(
                                      Icons.clear_rounded,
                                      color: Colors.white70,
                                      size: 24,
                                    ),
                                  )
                                  : null,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),

        // Suggestions dropdown
        AnimatedBuilder(
          animation: _suggestionAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _suggestionAnimation.value,
              alignment: Alignment.topCenter,
              child: Opacity(
                opacity: _suggestionAnimation.value.clamp(0.0, 1.0),
                child:
                    _showSuggestions
                        ? _buildSuggestionsList()
                        : SizedBox.shrink(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSuggestionsList() {
    return Container(
      margin: EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 0,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.15),
                width: 1,
              ),
            ),
            child: Column(
              children:
                  _filteredSuggestions.asMap().entries.map((entry) {
                    int index = entry.key;
                    String suggestion = entry.value;

                    return TweenAnimationBuilder(
                      duration: Duration(milliseconds: 200 + (index * 50)),
                      tween: Tween<double>(begin: 0, end: 1),
                      builder: (context, double value, child) {
                        return Transform.translate(
                          offset: Offset(0, 20 * (1 - value)),
                          child: Opacity(
                            opacity: value.clamp(0.0, 1.0),
                            child: _buildSuggestionItem(suggestion, index),
                          ),
                        );
                      },
                    );
                  }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestionItem(String suggestion, int index) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _selectSuggestion(suggestion),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            border:
                index < _filteredSuggestions.length - 1
                    ? Border(
                      bottom: BorderSide(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                    )
                    : null,
          ),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  suggestion,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_outward_rounded,
                color: Colors.white.withOpacity(0.5),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedCard() {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 600),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 0,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.check_circle_outline_rounded,
                        color: Colors.white,
                        size: 48,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Selected',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        _selectedSuggestion,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
