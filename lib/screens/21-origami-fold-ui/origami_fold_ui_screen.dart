import 'package:flutter/material.dart';

class OrigamiFoldUIScreen extends StatefulWidget {
  const OrigamiFoldUIScreen({Key? key}) : super(key: key);

  @override
  State<OrigamiFoldUIScreen> createState() => _OrigamiFoldUIScreenState();
}

class _OrigamiFoldUIScreenState extends State<OrigamiFoldUIScreen>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;
  late List<Animation<double>> _scaleAnimations;
  late List<Animation<double>> _opacityAnimations;
  
  final List<bool> _isExpanded = [false, false, false, false];
  
  final List<OrigamiSection> _sections = [
    OrigamiSection(
      title: 'Design',
      subtitle: 'Creative Excellence',
      icon: Icons.palette_outlined,
      color: const Color(0xFF6C63FF),
      gradient: const LinearGradient(
        colors: [Color(0xFF6C63FF), Color(0xFF9D50BB)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      content: 'Crafting beautiful and intuitive user experiences through thoughtful design principles and modern aesthetics.',
    ),
    OrigamiSection(
      title: 'Development',
      subtitle: 'Code Perfection',
      icon: Icons.code_outlined,
      color: const Color(0xFF00D4AA),
      gradient: const LinearGradient(
        colors: [Color(0xFF00D4AA), Color(0xFF00B4D8)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      content: 'Building robust applications with clean code architecture and cutting-edge technologies.',
    ),
    OrigamiSection(
      title: 'Innovation',
      subtitle: 'Future Forward',
      icon: Icons.lightbulb_outline,
      color: const Color(0xFFFF6B6B),
      gradient: const LinearGradient(
        colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      content: 'Pushing boundaries with innovative solutions and emerging technologies.',
    ),
    OrigamiSection(
      title: 'Strategy',
      subtitle: 'Smart Solutions',
      icon: Icons.psychology_outlined,
      color: const Color(0xFF4ECDC4),
      gradient: const LinearGradient(
        colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      content: 'Strategic thinking that drives meaningful results and sustainable growth.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      _sections.length,
      (index) => AnimationController(
        duration: Duration(milliseconds: 800 + (index * 100)),
        vsync: this,
      ),
    );
    
    _animations = _controllers.map((controller) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.elasticOut,
      ));
    }).toList();
    
    _scaleAnimations = _controllers.map((controller) {
      return Tween<double>(
        begin: 0.8,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutBack,
      ));
    }).toList();
    
    _opacityAnimations = _controllers.map((controller) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ));
    }).toList();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _toggleFold(int index) {
    setState(() {
      _isExpanded[index] = !_isExpanded[index];
    });
    
    if (_isExpanded[index]) {
      _controllers[index].forward();
    } else {
      _controllers[index].reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF0A0A0F),
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Origami Fold UI',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF6C63FF), Color(0xFF0A0A0F)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.auto_awesome,
                    size: 80,
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: OrigamiFoldCard(
                      section: _sections[index],
                      isExpanded: _isExpanded[index],
                      animation: _animations[index],
                      scaleAnimation: _scaleAnimations[index],
                      opacityAnimation: _opacityAnimations[index],
                      onTap: () => _toggleFold(index),
                    ),
                  );
                },
                childCount: _sections.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrigamiFoldCard extends StatelessWidget {
  final OrigamiSection section;
  final bool isExpanded;
  final Animation<double> animation;
  final Animation<double> scaleAnimation;
  final Animation<double> opacityAnimation;
  final VoidCallback onTap;

  const OrigamiFoldCard({
    Key? key,
    required this.section,
    required this.isExpanded,
    required this.animation,
    required this.scaleAnimation,
    required this.opacityAnimation,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 - (animation.value * 0.02),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: section.color.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: section.gradient,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        // Header Section
                        Container(
                          padding: const EdgeInsets.all(25),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Icon(
                                  section.icon,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      section.title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      section.subtitle,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              AnimatedRotation(
                                turns: isExpanded ? 0.5 : 0,
                                duration: const Duration(milliseconds: 300),
                                child: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Expandable Content
                        AnimatedBuilder(
                          animation: scaleAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: scaleAnimation.value,
                              child: Opacity(
                                opacity: opacityAnimation.value,
                                child: Container(
                                  height: animation.value * 120,
                                  margin: const EdgeInsets.only(
                                    left: 25,
                                    right: 25,
                                    bottom: 25,
                                  ),
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: SingleChildScrollView(
                                    child: Text(
                                      section.content,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.9),
                                        fontSize: 16,
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
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

class OrigamiSection {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final LinearGradient gradient;
  final String content;

  OrigamiSection({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.gradient,
    required this.content,
  });
}