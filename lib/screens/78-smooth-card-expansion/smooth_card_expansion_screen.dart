import 'package:flutter/material.dart';

class SmoothCardExpansionScreen extends StatelessWidget {
  final List<CardData> cards = [
    CardData(
      title: "Artificial Intelligence",
      subtitle: "The Future is Now",
      description: "Discover how AI is revolutionizing industries and transforming the way we work, live, and interact with technology in our daily lives.",
      color: const Color(0xFF6366F1),
      icon: Icons.psychology,
    ),
    CardData(
      title: "Space Exploration",
      subtitle: "Beyond the Stars",
      description: "Journey through the cosmos and explore the latest missions, discoveries, and technological breakthroughs in space exploration.",
      color: const Color(0xFF8B5CF6),
      icon: Icons.rocket_launch,
    ),
    CardData(
      title: "Sustainable Energy",
      subtitle: "Green Tomorrow",
      description: "Learn about renewable energy sources, sustainability practices, and innovative solutions for a cleaner, greener planet.",
      color: const Color(0xFF10B981),
      icon: Icons.eco,
    ),
    CardData(
      title: "Digital Innovation",
      subtitle: "Tech Revolution",
      description: "Explore cutting-edge technologies, digital transformation trends, and innovations that are reshaping our digital landscape.",
      color: const Color(0xFFF59E0B),
      icon: Icons.auto_awesome,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text(
          'Animated Cards',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F172A),
              Color(0xFF1E293B),
              Color(0xFF334155),
            ],
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: cards.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: AnimatedCard(cardData: cards[index]),
            );
          },
        ),
      ),
    );
  }
}

class CardData {
  final String title;
  final String subtitle;
  final String description;
  final Color color;
  final IconData icon;

  CardData({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.color,
    required this.icon,
  });
}

class AnimatedCard extends StatefulWidget {
  final CardData cardData;

  const AnimatedCard({Key? key, required this.cardData}) : super(key: key);

  @override
  _AnimatedCardState createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard>
    with TickerProviderStateMixin {
  late AnimationController _expandController;
  late AnimationController _typewriterController;
  late Animation<double> _expandAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  bool _isExpanded = false;
  String _displayedText = '';
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    
    _expandController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _typewriterController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _expandAnimation = CurvedAnimation(
      parent: _expandController,
      curve: Curves.elasticOut,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _expandController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _expandController,
      curve: Curves.elasticOut,
    ));

    _typewriterController.addListener(_typewriterListener);
  }

  void _typewriterListener() {
    if (_typewriterController.isAnimating) {
      final progress = _typewriterController.value;
      final targetLength = (widget.cardData.description.length * progress).round();
      
      if (targetLength != _currentIndex) {
        setState(() {
          _currentIndex = targetLength;
          _displayedText = widget.cardData.description.substring(0, _currentIndex);
        });
      }
    }
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });

    if (_isExpanded) {
      _expandController.forward();
      Future.delayed(const Duration(milliseconds: 400), () {
        _typewriterController.forward();
      });
    } else {
      _typewriterController.reset();
      _expandController.reverse();
      _displayedText = '';
      _currentIndex = 0;
    }
  }

  @override
  void dispose() {
    _expandController.dispose();
    _typewriterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleExpand,
      child: AnimatedBuilder(
        animation: _expandController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  widget.cardData.color.withOpacity(0.1),
                  widget.cardData.color.withOpacity(0.05),
                ],
              ),
              border: Border.all(
                color: widget.cardData.color.withOpacity(0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.cardData.color.withOpacity(0.2),
                  blurRadius: 20 * (1 + _expandAnimation.value),
                  spreadRadius: 2 * (1 + _expandAnimation.value),
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          widget.cardData.color.withOpacity(0.8),
                          widget.cardData.color.withOpacity(0.6),
                        ],
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            widget.cardData.icon,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.cardData.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.cardData.subtitle,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        AnimatedRotation(
                          turns: _isExpanded ? 0.5 : 0,
                          duration: const Duration(milliseconds: 300),
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Expandable Content Section
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.elasticOut,
                    height: _isExpanded ? 120 : 0,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B).withOpacity(0.5),
                      ),
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 50,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: widget.cardData.color,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Expanded(
                                child: Text(
                                  _displayedText + (_typewriterController.isAnimating ? '|' : ''),
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 16,
                                    height: 1.5,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}