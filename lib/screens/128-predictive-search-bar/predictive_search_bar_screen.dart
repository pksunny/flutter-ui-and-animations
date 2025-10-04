import 'package:flutter/material.dart';
import 'dart:math' as math;

class PredictiveSearchBarScreen extends StatelessWidget {
  const PredictiveSearchBarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample database for demonstration
    final List<String> sampleDatabase = [
      'Apple',
      'Application',
      'Banana',
      'Beautiful',
      'California',
      'Celebration',
      'Developer',
      'Development',
      'Elephant',
      'Engineering',
      'Flutter',
      'Framework',
      'Google',
      'Gorgeous',
      'Hamburg',
      'Hamburger',
      'Innovation',
      'Intelligence',
      'JavaScript',
      'Journey',
      'Keyboard',
      'Knowledge',
      'Laboratory',
      'Learning',
      'Mountain',
      'Magnificent',
      'Navigation',
      'Network',
      'Opportunity',
      'Organization',
      'Programming',
      'Professional',
      'Quality',
      'Question',
      'Restaurant',
      'Revolution',
      'Smartphone',
      'Software',
      'Technology',
      'Telescope',
      'Universe',
      'Understanding',
      'Velocity',
      'Visualization',
      'Wonderful',
      'Workspace',
      'Xylophone',
      'Yesterday',
      'Zephyr',
      'Zoology',
    ];

    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A0E21),
              Color(0xFF1A1F3A),
              Color(0xFF0F1729),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
              const SizedBox(height: 40),
              // Animated Header
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 800),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Opacity(
                      opacity: value.clamp(0.0, 1.0),
                      child: child,
                    ),
                  );
                },
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Colors.purple.withOpacity(0.3),
                            Colors.blue.withOpacity(0.3),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.purple.withOpacity(0.3),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.search_rounded,
                        size: 48,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Magical Search',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'AI-Powered Predictive Typing',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.6),
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              // The Magical Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: MagicalPredictiveSearchBar(
                  database: sampleDatabase,
                  onSearch: (query) {
                    print('Searching for: $query');
                  },
                  onSuggestionSelected: (suggestion) {
                    print('Selected suggestion: $suggestion');
                  },
                ),
              ),
              const SizedBox(height: 30),
              // Info Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _InfoCard(),
              ),
              const SizedBox(height: 40),
            ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.withOpacity(0.1),
            Colors.blue.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.purple.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.tips_and_updates_rounded,
                color: Colors.amber.shade300,
                size: 24,
              ),
              const SizedBox(width: 10),
              const Text(
                'Try These:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          _SuggestionChip(text: 'Aple (Apple)'),
          const SizedBox(height: 8),
          _SuggestionChip(text: 'Fluter (Flutter)'),
          const SizedBox(height: 8),
          _SuggestionChip(text: 'Developmnt (Development)'),
        ],
      ),
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  final String text;

  const _SuggestionChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.auto_fix_high_rounded,
            size: 16,
            color: Colors.purple.shade300,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

/// 🎨 MAGICAL PREDICTIVE SEARCH BAR
/// Ultra-stylish, customizable, production-ready widget
class MagicalPredictiveSearchBar extends StatefulWidget {
  /// Database of valid search terms
  final List<String> database;

  /// Callback when search is performed
  final Function(String query)? onSearch;

  /// Callback when suggestion is selected
  final Function(String suggestion)? onSuggestionSelected;

  /// Primary accent color
  final Color primaryColor;

  /// Secondary accent color
  final Color secondaryColor;

  /// Maximum suggestions to show
  final int maxSuggestions;

  /// Fuzzy match threshold (0.0 - 1.0, lower = more lenient)
  final double fuzzyThreshold;

  /// Enable animations
  final bool enableAnimations;

  /// Search bar height
  final double height;

  /// Border radius
  final double borderRadius;

  const MagicalPredictiveSearchBar({
    Key? key,
    required this.database,
    this.onSearch,
    this.onSuggestionSelected,
    this.primaryColor = const Color(0xFF9C27B0),
    this.secondaryColor = const Color(0xFF2196F3),
    this.maxSuggestions = 3,
    this.fuzzyThreshold = 0.4,
    this.enableAnimations = true,
    this.height = 60,
    this.borderRadius = 30,
  }) : super(key: key);

  @override
  State<MagicalPredictiveSearchBar> createState() =>
      _MagicalPredictiveSearchBarState();
}

class _MagicalPredictiveSearchBarState
    extends State<MagicalPredictiveSearchBar>
    with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  
  List<String> _suggestions = [];
  bool _showSuggestions = false;
  late AnimationController _pulseController;
  late AnimationController _glowController;
  late AnimationController _suggestionController;

  @override
  void initState() {
    super.initState();
    
    // Pulse animation for search icon
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    // Glow animation for focus state
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Suggestion cards animation
    _suggestionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _pulseController.dispose();
    _glowController.dispose();
    _suggestionController.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    if (_focusNode.hasFocus) {
      _glowController.forward();
    } else {
      _glowController.reverse();
    }
  }

  void _onTextChanged() {
    final query = _controller.text.trim();
    
    if (query.isEmpty) {
      setState(() {
        _showSuggestions = false;
        _suggestions = [];
      });
      _suggestionController.reverse();
      return;
    }

    // Find fuzzy matches
    final matches = _findFuzzyMatches(query);
    
    setState(() {
      _suggestions = matches;
      _showSuggestions = matches.isNotEmpty;
    });

    if (matches.isNotEmpty) {
      _suggestionController.forward();
    } else {
      _suggestionController.reverse();
    }
  }

  List<String> _findFuzzyMatches(String query) {
    final matches = <_Match>[];
    
    for (final term in widget.database) {
      final distance = _levenshteinDistance(
        query.toLowerCase(),
        term.toLowerCase(),
      );
      final maxLen = math.max(query.length, term.length);
      final similarity = 1.0 - (distance / maxLen);
      
      // Check if it's a fuzzy match (not exact)
      if (similarity >= widget.fuzzyThreshold && 
          term.toLowerCase() != query.toLowerCase()) {
        matches.add(_Match(term: term, similarity: similarity));
      }
    }

    // Sort by similarity and take top matches
    matches.sort((a, b) => b.similarity.compareTo(a.similarity));
    return matches
        .take(widget.maxSuggestions)
        .map((m) => m.term)
        .toList();
  }

  int _levenshteinDistance(String s1, String s2) {
    if (s1 == s2) return 0;
    if (s1.isEmpty) return s2.length;
    if (s2.isEmpty) return s1.length;

    List<int> v0 = List<int>.generate(s2.length + 1, (i) => i);
    List<int> v1 = List<int>.filled(s2.length + 1, 0);

    for (int i = 0; i < s1.length; i++) {
      v1[0] = i + 1;
      for (int j = 0; j < s2.length; j++) {
        int cost = (s1[i] == s2[j]) ? 0 : 1;
        v1[j + 1] = math.min(
          v1[j] + 1,
          math.min(v0[j + 1] + 1, v0[j] + cost),
        );
      }
      List<int> temp = v0;
      v0 = v1;
      v1 = temp;
    }

    return v0[s2.length];
  }

  void _selectSuggestion(String suggestion) {
    _controller.text = suggestion;
    setState(() {
      _showSuggestions = false;
      _suggestions = [];
    });
    _suggestionController.reverse();
    widget.onSuggestionSelected?.call(suggestion);
  }

  void _performSearch() {
    final query = _controller.text.trim();
    if (query.isNotEmpty) {
      widget.onSearch?.call(query);
      _focusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchBar(),
        if (_showSuggestions) _buildSuggestions(),
      ],
    );
  }

  Widget _buildSearchBar() {
    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        return Container(
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              colors: [
                widget.primaryColor.withOpacity(0.1),
                widget.secondaryColor.withOpacity(0.1),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: widget.primaryColor.withOpacity(
                  0.3 * _glowController.value,
                ),
                blurRadius: 20 + (10 * _glowController.value),
                spreadRadius: 2 * _glowController.value,
              ),
              BoxShadow(
                color: widget.secondaryColor.withOpacity(
                  0.2 * _glowController.value,
                ),
                blurRadius: 15 + (8 * _glowController.value),
                spreadRadius: 1 * _glowController.value,
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              border: Border.all(
                color: Colors.white.withOpacity(
                  0.1 + (0.2 * _glowController.value),
                ),
                width: 1.5,
              ),
              color: Colors.white.withOpacity(0.05),
            ),
            child: Row(
              children: [
                const SizedBox(width: 20),
                _buildSearchIcon(),
                const SizedBox(width: 15),
                Expanded(child: _buildTextField()),
                if (_controller.text.isNotEmpty) _buildClearButton(),
                const SizedBox(width: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchIcon() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + (0.1 * _pulseController.value),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  widget.primaryColor.withOpacity(
                    0.3 + (0.2 * _pulseController.value),
                  ),
                  widget.secondaryColor.withOpacity(
                    0.3 + (0.2 * _pulseController.value),
                  ),
                ],
              ),
            ),
            child: Icon(
              Icons.search_rounded,
              color: Colors.white.withOpacity(
                0.7 + (0.3 * _pulseController.value),
              ),
              size: 24,
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: 'Search anything...',
        hintStyle: TextStyle(
          color: Colors.white.withOpacity(0.4),
          fontSize: 16,
        ),
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
      ),
      textInputAction: TextInputAction.search,
      onSubmitted: (_) => _performSearch(),
    );
  }

  Widget _buildClearButton() {
    return GestureDetector(
      onTap: () {
        _controller.clear();
        setState(() {
          _showSuggestions = false;
          _suggestions = [];
        });
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.1),
        ),
        child: Icon(
          Icons.close_rounded,
          color: Colors.white.withOpacity(0.6),
          size: 18,
        ),
      ),
    );
  }

  Widget _buildSuggestions() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: AnimatedBuilder(
        animation: _suggestionController,
        builder: (context, child) {
          return Transform.scale(
            scale: 0.95 + (0.05 * _suggestionController.value),
            child: Opacity(
              opacity: _suggestionController.value,
              child: child,
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                widget.primaryColor.withOpacity(0.05),
                widget.secondaryColor.withOpacity(0.05),
              ],
            ),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.auto_fix_high_rounded,
                      color: widget.primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Did you mean?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 1,
                color: Colors.white12,
              ),
              ..._suggestions.asMap().entries.map((entry) {
                final index = entry.key;
                final suggestion = entry.value;
                return _SuggestionTile(
                  suggestion: suggestion,
                  index: index,
                  primaryColor: widget.primaryColor,
                  secondaryColor: widget.secondaryColor,
                  onTap: () => _selectSuggestion(suggestion),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SuggestionTile extends StatefulWidget {
  final String suggestion;
  final int index;
  final Color primaryColor;
  final Color secondaryColor;
  final VoidCallback onTap;

  const _SuggestionTile({
    required this.suggestion,
    required this.index,
    required this.primaryColor,
    required this.secondaryColor,
    required this.onTap,
  });

  @override
  State<_SuggestionTile> createState() => _SuggestionTileState();
}

class _SuggestionTileState extends State<_SuggestionTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _hoverController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _hoverController.reverse();
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _hoverController,
          builder: (context, child) {
            return Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white.withOpacity(
                  0.03 + (0.05 * _hoverController.value),
                ),
                border: Border.all(
                  color: widget.primaryColor.withOpacity(
                    0.1 + (0.3 * _hoverController.value),
                  ),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Transform.scale(
                    scale: 1.0 + (0.2 * _hoverController.value),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            widget.primaryColor.withOpacity(0.3),
                            widget.secondaryColor.withOpacity(0.3),
                          ],
                        ),
                      ),
                      child: Icon(
                        Icons.lightbulb_rounded,
                        color: Colors.white.withOpacity(0.8),
                        size: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.suggestion,
                      style: TextStyle(
                        color: Colors.white.withOpacity(
                          0.7 + (0.3 * _hoverController.value),
                        ),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.north_west_rounded,
                    color: widget.primaryColor.withOpacity(
                      0.4 + (0.4 * _hoverController.value),
                    ),
                    size: 18,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Match {
  final String term;
  final double similarity;

  _Match({required this.term, required this.similarity});
}