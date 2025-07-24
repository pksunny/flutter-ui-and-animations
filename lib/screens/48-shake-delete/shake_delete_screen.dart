import 'package:flutter/material.dart';
import 'dart:math' as math;

class ShakeDeleteScreen extends StatefulWidget {
  @override
  _ShakeDeleteScreenState createState() => _ShakeDeleteScreenState();
}

class _ShakeDeleteScreenState extends State<ShakeDeleteScreen> {
  List<CardData> cards = [
    CardData(
      id: 1,
      title: "Neural Network",
      subtitle: "Advanced AI Processing",
      icon: Icons.psychology,
      color: Colors.cyan,
    ),
    CardData(
      id: 2,
      title: "Quantum Core",
      subtitle: "Next-Gen Computing",
      icon: Icons.scatter_plot,
      color: Colors.purple,
    ),
    CardData(
      id: 3,
      title: "Plasma Drive",
      subtitle: "Fusion Energy System",
      icon: Icons.flash_on,
      color: Colors.orange,
    ),
    CardData(
      id: 4,
      title: "Holographic UI",
      subtitle: "3D Interface Technology",
      icon: Icons.view_in_ar,
      color: Colors.green,
    ),
  ];

  void deleteCard(int id) {
    setState(() {
      cards.removeWhere((card) => card.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A0A0F),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topRight,
            radius: 2.0,
            colors: [Color(0xFF1A1A2E).withOpacity(0.8), Color(0xFF0A0A0F)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 40),
              Text(
                'FUTURISTIC CARDS',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 4,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),

              SizedBox(height: 40),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  itemCount: cards.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: ShakeToDeleteCard(
                        key: ValueKey(cards[index].id),
                        cardData: cards[index],
                        onDelete: () => deleteCard(cards[index].id),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardData {
  final int id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  CardData({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}

class ShakeToDeleteCard extends StatefulWidget {
  final CardData cardData;
  final VoidCallback onDelete;

  const ShakeToDeleteCard({
    Key? key,
    required this.cardData,
    required this.onDelete,
  }) : super(key: key);

  @override
  _ShakeToDeleteCardState createState() => _ShakeToDeleteCardState();
}

class _ShakeToDeleteCardState extends State<ShakeToDeleteCard>
    with TickerProviderStateMixin {
  late AnimationController _shakeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late AnimationController _glowController;

  late Animation<double> _shakeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();

    _shakeController = AnimationController(
      duration: Duration(milliseconds: 400), // shorter = more snappy
      vsync: this,
    );

    _slideController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _glowController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(-1.5, 0),
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeInBack),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _slideController,
        curve: Interval(0.6, 1.0, curve: Curves.easeIn),
      ),
    );

    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  void _startDeleteAnimation() async {
    if (_isDeleting) return;

    setState(() {
      _isDeleting = true;
    });

    // Start shake animation
    await _shakeController.forward();

    // Start slide and scale animation
    await _slideController.forward();

    // Call delete callback
    widget.onDelete();
  }

  double _getShakeOffset() {
    const shakeCount = 8; // increased from 4
    const maxOffset = 16.0; // increased from 8.0

    double progress = _shakeAnimation.value;
    double shakeOffset =
        math.sin(progress * math.pi * shakeCount) * maxOffset * (1 - progress);

    return shakeOffset;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _shakeAnimation,
        _slideAnimation,
        _scaleAnimation,
        _glowAnimation,
      ]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_getShakeOffset(), 0),
          child: SlideTransition(
            position: _slideAnimation,
            child: Transform.scale(
              scale: _scaleAnimation.value == 0 ? _scaleAnimation.value : 1.0,
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: widget.cardData.color.withOpacity(
                        0.3 * _glowAnimation.value,
                      ),
                      blurRadius: 20,
                      spreadRadius: 2,
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
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.1),
                          Colors.white.withOpacity(0.05),
                        ],
                      ),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  widget.cardData.color.withOpacity(0.8),
                                  widget.cardData.color.withOpacity(0.4),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: widget.cardData.color.withOpacity(0.4),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Icon(
                              widget.cardData.icon,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  widget.cardData.title,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  widget.cardData.subtitle,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: _startDeleteAnimation,
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red.withOpacity(0.1),
                                border: Border.all(
                                  color: Colors.red.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Icon(
                                Icons.delete_outline,
                                color: Colors.red.withOpacity(0.8),
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
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
