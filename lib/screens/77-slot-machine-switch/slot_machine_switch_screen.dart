import 'package:flutter/material.dart';
import 'dart:math' as math;

class SlotMachineSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final double width;
  final double height;
  final Duration animationDuration;
  final List<String> symbols;
  final Color activeColor;
  final Color inactiveColor;

  const SlotMachineSwitch({
    Key? key,
    required this.value,
    this.onChanged,
    this.width = 120,
    this.height = 60,
    this.animationDuration = const Duration(milliseconds: 800),
    this.symbols = const ['🎰', '💎', '🍀', '⭐', '🎯', '🔥'],
    this.activeColor = const Color(0xFF6C63FF),
    this.inactiveColor = const Color(0xFF9E9E9E),
  }) : super(key: key);

  @override
  State<SlotMachineSwitch> createState() => _SlotMachineSwitchState();
}

class _SlotMachineSwitchState extends State<SlotMachineSwitch>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _spinController;
  late AnimationController _glowController;
  late AnimationController _scaleController;
  
  late Animation<double> _slideAnimation;
  late Animation<double> _spinAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _scaleAnimation;
  
  bool _isSpinning = false;
  String _currentSymbol = '🎰';
  
  @override
  void initState() {
    super.initState();
    
    _slideController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    
    _slideAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.elasticOut),
    );
    
    _spinAnimation = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(parent: _spinController, curve: Curves.easeOut),
    );
    
    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );
    
    if (widget.value) {
      _slideController.value = 1;
      _currentSymbol = widget.symbols[1];
    }
    
    _glowController.repeat(reverse: true);
    
    _spinAnimation.addListener(() {
      if (_isSpinning) {
        final symbolIndex = (_spinAnimation.value * 4).floor() % widget.symbols.length;
        if (_currentSymbol != widget.symbols[symbolIndex]) {
          setState(() {
            _currentSymbol = widget.symbols[symbolIndex];
          });
        }
      }
    });
  }
  
  @override
  void didUpdateWidget(SlotMachineSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _animateSwitch();
    }
  }
  
  void _animateSwitch() async {
    setState(() {
      _isSpinning = true;
    });
    
    _scaleController.forward().then((_) => _scaleController.reverse());
    _spinController.forward();
    
    await Future.delayed(const Duration(milliseconds: 800));
    
    setState(() {
      _currentSymbol = widget.value ? widget.symbols[1] : widget.symbols[0];
      _isSpinning = false;
    });
    
    if (widget.value) {
      _slideController.forward();
    } else {
      _slideController.reverse();
    }
    
    _spinController.reset();
  }
  
  @override
  void dispose() {
    _slideController.dispose();
    _spinController.dispose();
    _glowController.dispose();
    _scaleController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.onChanged != null && !_isSpinning) {
          widget.onChanged!(!widget.value);
        }
      },
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _slideAnimation,
          _glowAnimation,
          _scaleAnimation,
        ]),
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.height / 2),
                gradient: LinearGradient(
                  colors: widget.value
                      ? [
                          widget.activeColor.withOpacity(0.8),
                          widget.activeColor,
                          widget.activeColor.withOpacity(0.9),
                        ]
                      : [
                          widget.inactiveColor.withOpacity(0.6),
                          widget.inactiveColor,
                          widget.inactiveColor.withOpacity(0.8),
                        ],
                  stops: const [0.0, 0.5, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: (widget.value ? widget.activeColor : widget.inactiveColor)
                        .withOpacity(_glowAnimation.value * 0.3),
                    blurRadius: 15 * _glowAnimation.value,
                    spreadRadius: 2 * _glowAnimation.value,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Animated background pattern
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(widget.height / 2),
                      child: AnimatedBuilder(
                        animation: _glowAnimation,
                        builder: (context, child) {
                          return CustomPaint(
                            painter: SlotMachineBackgroundPainter(
                              animation: _glowAnimation.value,
                              isActive: widget.value,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  
                  // Sliding thumb
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    left: _slideAnimation.value * (widget.width - widget.height + 4) + 2,
                    top: 2,
                    child: Container(
                      width: widget.height - 4,
                      height: widget.height - 4,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular((widget.height - 4) / 2),
                        gradient: const RadialGradient(
                          colors: [
                            Colors.white,
                            Color(0xFFF5F5F5),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                          BoxShadow(
                            color: Colors.white.withOpacity(0.8),
                            blurRadius: 4,
                            offset: const Offset(0, -1),
                          ),
                        ],
                      ),
                      child: Center(
                        child: AnimatedBuilder(
                          animation: _spinAnimation,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: _spinAnimation.value * 2 * math.pi,
                              child: Text(
                                _currentSymbol,
                                style: TextStyle(
                                  fontSize: widget.height * 0.4,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  
                  // Jackpot text animation
                  if (widget.value && !_isSpinning)
                    Positioned.fill(
                      child: AnimatedBuilder(
                        animation: _glowAnimation,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _glowAnimation.value * 0.8,
                            child: Center(
                              child: Text(
                                'JACKPOT!',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
                          );
                        },
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

class SlotMachineBackgroundPainter extends CustomPainter {
  final double animation;
  final bool isActive;
  
  SlotMachineBackgroundPainter({
    required this.animation,
    required this.isActive,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    
    // Draw animated particles/sparkles
    if (isActive) {
      paint.color = Colors.white.withOpacity(animation * 0.4);
      
      for (int i = 0; i < 8; i++) {
        final angle = (i / 8) * 2 * math.pi + animation * math.pi;
        final x = size.width / 2 + math.cos(angle) * size.width / 4;
        final y = size.height / 2 + math.sin(angle) * size.height / 6;
        
        canvas.drawCircle(
          Offset(x, y),
          2 * animation,
          paint,
        );
      }
    }
    
    // Draw subtle grid pattern
    paint.color = Colors.white.withOpacity(0.1);
    paint.strokeWidth = 0.5;
    
    for (double i = 0; i < size.width; i += 10) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i, size.height),
        paint,
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Demo app to showcase the slot machine switch
class SlotMachineSwitchScreen extends StatefulWidget {
  @override
  _SlotMachineSwitchScreenState createState() => _SlotMachineSwitchScreenState();
}

class _SlotMachineSwitchScreenState extends State<SlotMachineSwitchScreen> {
  bool _switch1 = false;
  bool _switch2 = true;
  bool _switch3 = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Slot Machine Switch Demo',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1A1A2E),
      ),
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1A1A2E),
                Color(0xFF16213E),
                Color(0xFF0F3460),
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '🎰 SLOT MACHINE SWITCHES 🎰',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 50),
                
                // Default switch
                Column(
                  children: [
                    const Text(
                      'Classic Slot',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    SlotMachineSwitch(
                      value: _switch1,
                      onChanged: (value) => setState(() => _switch1 = value),
                    ),
                  ],
                ),
                
                const SizedBox(height: 40),
                
                // Custom sized switch with different symbols
                Column(
                  children: [
                    const Text(
                      'Lucky Numbers',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    SlotMachineSwitch(
                      value: _switch2,
                      onChanged: (value) => setState(() => _switch2 = value),
                      width: 140,
                      height: 70,
                      symbols: const ['7️⃣', '💰', '🎲', '🍒', '🔔', '💎'],
                      activeColor: const Color(0xFFFF6B35),
                    ),
                  ],
                ),
                
                const SizedBox(height: 40),
                
                // Compact switch
                Column(
                  children: [
                    const Text(
                      'Mini Casino',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    SlotMachineSwitch(
                      value: _switch3,
                      onChanged: (value) => setState(() => _switch3 = value),
                      width: 100,
                      height: 50,
                      symbols: const ['🎲', '🃏', '🎯', '⚡', '💫', '🏆'],
                      activeColor: const Color(0xFF00D2FF),
                      animationDuration: const Duration(milliseconds: 600),
                    ),
                  ],
                ),
                
                const SizedBox(height: 60),
                
                // Status display
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Switch States',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatusIndicator('Classic', _switch1),
                          _buildStatusIndicator('Lucky', _switch2),
                          _buildStatusIndicator('Mini', _switch3),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildStatusIndicator(String label, bool isOn) {
    return Column(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: isOn ? Colors.green : Colors.red,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: (isOn ? Colors.green : Colors.red).withOpacity(0.6),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}