import 'package:flutter/material.dart';

class CardExpansionAnimationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topRight,
            radius: 1.5,
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF0A0A0F),
              Color(0xFF000000),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Futuristic Cards',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    SizedBox(height: 20),
                    FuturisticCard(
                      title: 'Neural Networks',
                      subtitle: 'AI & Machine Learning',
                      icon: Icons.psychology,
                      gradient: [Color(0xFF6C63FF), Color(0xFF3F51B5)],
                      content: CardContent(
                        title: 'Advanced Neural Networks',
                        description: 'Explore the depths of artificial intelligence with cutting-edge neural network architectures. Discover how deep learning transforms data into insights.',
                        stats: ['98.7% Accuracy', '2.3ms Response', '10M+ Parameters'],
                        features: ['Real-time Processing', 'Adaptive Learning', 'Edge Computing'],
                      ),
                    ),
                    SizedBox(height: 24),
                    FuturisticCard(
                      title: 'Quantum Computing',
                      subtitle: 'Next-Gen Processing',
                      icon: Icons.memory,
                      gradient: [Color(0xFF00BCD4), Color(0xFF009688)],
                      content: CardContent(
                        title: 'Quantum Supremacy',
                        description: 'Harness the power of quantum mechanics for unprecedented computational capabilities. Break through classical computing limitations.',
                        stats: ['1000+ Qubits', '99.9% Fidelity', '10^15 Operations/sec'],
                        features: ['Superposition', 'Entanglement', 'Quantum Algorithms'],
                      ),
                    ),
                    SizedBox(height: 24),
                    FuturisticCard(
                      title: 'Blockchain',
                      subtitle: 'Decentralized Future',
                      icon: Icons.link,
                      gradient: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                      content: CardContent(
                        title: 'Distributed Ledger Technology',
                        description: 'Build trust in a trustless world with immutable blockchain solutions. Revolutionize transactions and data integrity.',
                        stats: ['99.99% Uptime', '50k TPS', '0% Fraud Rate'],
                        features: ['Smart Contracts', 'DeFi Integration', 'Cross-chain'],
                      ),
                    ),
                    SizedBox(height: 24),
                    FuturisticCard(
                      title: 'Space Tech',
                      subtitle: 'Beyond Earth',
                      icon: Icons.rocket_launch,
                      gradient: [Color(0xFF9C27B0), Color(0xFF673AB7)],
                      content: CardContent(
                        title: 'Interplanetary Systems',
                        description: 'Pioneer the next frontier with advanced propulsion systems and life support technologies for deep space exploration.',
                        stats: ['Mars Ready', '99.8% Reliability', '10-year Mission'],
                        features: ['Ion Propulsion', 'Life Support', 'AI Navigation'],
                      ),
                    ),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FuturisticCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient;
  final CardContent content;

  const FuturisticCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.content,
  }) : super(key: key);

  @override
  _FuturisticCardState createState() => _FuturisticCardState();
}

class _FuturisticCardState extends State<FuturisticCard>
    with TickerProviderStateMixin {
  late AnimationController _expansionController;
  late AnimationController _contentController;
  late Animation<double> _expandAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    
    // Main expansion controller with spring physics
    _expansionController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    // Content animation controller for staggered animations
    _contentController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    // Spring-like expansion animation
    _expandAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _expansionController,
      curve: Curves.elasticOut,
    ));

    // Content fade animation
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _contentController,
      curve: Interval(0.3, 1.0, curve: Curves.easeOut),
    ));

    // Content scale animation
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _contentController,
      curve: Interval(0.2, 0.8, curve: Curves.elasticOut),
    ));

    // Content slide animation
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _contentController,
      curve: Interval(0.1, 0.7, curve: Curves.easeOutBack),
    ));
  }

  @override
  void dispose() {
    _expansionController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _expansionController.forward();
        Future.delayed(Duration(milliseconds: 200), () {
          _contentController.forward();
        });
      } else {
        _contentController.reverse();
        Future.delayed(Duration(milliseconds: 200), () {
          _expansionController.reverse();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _expansionController,
      builder: (context, child) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: widget.gradient[0].withOpacity(0.3),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: widget.gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.1),
                      Colors.transparent,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _toggleExpansion,
                      child: Container(
                        padding: EdgeInsets.all(24),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Icon(
                                widget.icon,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.title,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    widget.subtitle,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Transform.rotate(
                              angle: _expandAnimation.value * 3.14159,
                              child: Icon(
                                Icons.expand_more,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizeTransition(
                      sizeFactor: _expandAnimation,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                          border: Border(
                            top: BorderSide(
                              color: Colors.white.withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                        ),
                        child: AnimatedBuilder(
                          animation: _contentController,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _scaleAnimation.value,
                              child: SlideTransition(
                                position: _slideAnimation,
                                child: FadeTransition(
                                  opacity: _fadeAnimation,
                                  child: Padding(
                                    padding: EdgeInsets.all(24),
                                    child: _buildExpandedContent(),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
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

  Widget _buildExpandedContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.content.title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 12),
        Text(
          widget.content.description,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withOpacity(0.9),
            height: 1.5,
          ),
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Performance',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  SizedBox(height: 8),
                  ...widget.content.stats.map((stat) => Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          stat,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  )).toList(),
                ],
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Features',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  SizedBox(height: 8),
                  ...widget.content.features.map((feature) => Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 14,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8),
                        Text(
                          feature,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  )).toList(),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Container(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.2),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              elevation: 0,
            ),
            child: Text(
              'Explore Technology',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CardContent {
  final String title;
  final String description;
  final List<String> stats;
  final List<String> features;

  CardContent({
    required this.title,
    required this.description,
    required this.stats,
    required this.features,
  });
}