import 'package:flutter/material.dart';
import 'dart:math' as math;

class AiChatBubbleMorphingAnimationScreen extends StatefulWidget {
  const AiChatBubbleMorphingAnimationScreen({Key? key}) : super(key: key);

  @override
  State<AiChatBubbleMorphingAnimationScreen> createState() => _AiChatBubbleMorphingAnimationScreenState();
}

class _AiChatBubbleMorphingAnimationScreenState extends State<AiChatBubbleMorphingAnimationScreen>
    with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  late AnimationController _thinkingController;
  late AnimationController _glowController;
  late AnimationController _morphController;
  bool _isThinking = false;

  @override
  void initState() {
    super.initState();
    _thinkingController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _morphController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    // Start with a welcome message
    _addMessage("Welcome! I'm your AI assistant. Try sending me a message to see the morphing animations!", false);
  }

  @override
  void dispose() {
    _thinkingController.dispose();
    _glowController.dispose();
    _morphController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;

    final userMessage = _controller.text.trim();
    _controller.clear();
    
    setState(() {
      _messages.add(ChatMessage(text: userMessage, isUser: true));
      _isThinking = true;
    });

    // Start thinking animation
    _thinkingController.repeat();
    _glowController.repeat(reverse: true);

    // Simulate AI thinking delay
    await Future.delayed(const Duration(milliseconds: 2500));

    // Stop thinking and show response
    _thinkingController.stop();
    _glowController.stop();
    
    setState(() {
      _isThinking = false;
    });

    // Add AI response with morphing animation
    _morphController.forward().then((_) {
      _morphController.reverse();
    });

    _addMessage(_generateAIResponse(userMessage), false);
  }

  void _addMessage(String text, bool isUser) {
    setState(() {
      _messages.add(ChatMessage(text: text, isUser: isUser));
    });
  }

  String _generateAIResponse(String userMessage) {
    final responses = [
      "That's fascinating! The morphing animation you just saw represents my neural networks processing your message.",
      "I love how these chat bubbles transform! Each shape represents a different thought pattern.",
      "The glowing edges you see simulate the electrical activity in AI processing units.",
      "Watch how smoothly the bubbles expand - that's the beauty of fluid animations!",
      "These morphing shapes represent the dynamic nature of AI conversations.",
    ];
    return responses[math.Random().nextInt(responses.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 2.0,
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF0A0A0F),
            ],
          ),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF00F5FF), Color(0xFF0080FF)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00F5FF).withOpacity(0.3),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 15),
                  const Text(
                    'AI Assistant',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            
            // Chat Messages
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _messages.length + (_isThinking ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _messages.length && _isThinking) {
                    return ThinkingBubble(
                      thinkingController: _thinkingController,
                      glowController: _glowController,
                    );
                  }
                  
                  final message = _messages[index];
                  return MorphingChatBubble(
                    message: message,
                    morphController: _morphController,
                    isLatest: index == _messages.length - 1,
                  );
                },
              ),
            ),
            
            // Input Area
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1E1E2E), Color(0xFF2A2A3E)],
                        ),
                        border: Border.all(
                          color: const Color(0xFF00F5FF).withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: TextField(
                        controller: _controller,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Type your message...',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00F5FF), Color(0xFF0080FF)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00F5FF).withOpacity(0.4),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

class MorphingChatBubble extends StatefulWidget {
  final ChatMessage message;
  final AnimationController morphController;
  final bool isLatest;

  const MorphingChatBubble({
    Key? key,
    required this.message,
    required this.morphController,
    required this.isLatest,
  }) : super(key: key);

  @override
  State<MorphingChatBubble> createState() => _MorphingChatBubbleState();
}

class _MorphingChatBubbleState extends State<MorphingChatBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _appearController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _appearController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _appearController,
      curve: Curves.elasticOut,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _appearController,
      curve: Curves.easeOut,
    ));

    _appearController.forward();
  }

  @override
  void dispose() {
    _appearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_appearController, widget.morphController]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: widget.message.isUser
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: [
                  if (!widget.message.isUser) ...[
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00F5FF), Color(0xFF0080FF)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00F5FF).withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.auto_awesome, color: Colors.white, size: 16),
                    ),
                    const SizedBox(width: 10),
                  ],
                  
                  Flexible(
                    child: CustomPaint(
                      painter: MorphingBubblePainter(
                        isUser: widget.message.isUser,
                        morphProgress: widget.isLatest && !widget.message.isUser
                            ? widget.morphController.value
                            : 0.0,
                        glowIntensity: widget.isLatest && !widget.message.isUser ? 0.8 : 0.0,
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        child: Text(
                          widget.message.text,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  if (widget.message.isUser) ...[
                    const SizedBox(width: 10),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF8A2BE2), Color(0xFFDA70D6)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF8A2BE2).withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.person, color: Colors.white, size: 16),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ThinkingBubble extends StatelessWidget {
  final AnimationController thinkingController;
  final AnimationController glowController;

  const ThinkingBubble({
    Key? key,
    required this.thinkingController,
    required this.glowController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF00F5FF), Color(0xFF0080FF)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00F5FF).withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: const Icon(Icons.auto_awesome, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 10),
          
          AnimatedBuilder(
            animation: Listenable.merge([thinkingController, glowController]),
            builder: (context, child) {
              return CustomPaint(
                painter: ThinkingBubblePainter(
                  thinkingProgress: thinkingController.value,
                  glowIntensity: glowController.value,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ThinkingDots(controller: thinkingController),
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
}

class ThinkingDots extends StatelessWidget {
  final AnimationController controller;

  const ThinkingDots({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            final delay = index * 0.2;
            final progress = (controller.value - delay).clamp(0.0, 1.0);
            final scale = math.sin(progress * math.pi) * 0.5 + 0.5;
            
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              child: Transform.scale(
                scale: 0.5 + scale * 0.5,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF00F5FF).withOpacity(0.5 + scale * 0.5),
                        Color(0xFF0080FF).withOpacity(0.5 + scale * 0.5),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF00F5FF).withOpacity(scale * 0.5),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

class MorphingBubblePainter extends CustomPainter {
  final bool isUser;
  final double morphProgress;
  final double glowIntensity;

  MorphingBubblePainter({
    required this.isUser,
    required this.morphProgress,
    required this.glowIntensity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    // Create morphing path
    final path = Path();
    final baseRadius = 20.0;
    final morphAmount = morphProgress * 8.0;
    
    // Dynamic corner radii based on morph progress
    final topLeft = baseRadius + math.sin(morphProgress * math.pi * 2) * morphAmount;
    final topRight = baseRadius + math.cos(morphProgress * math.pi * 2) * morphAmount;
    final bottomLeft = baseRadius + math.sin(morphProgress * math.pi * 2 + math.pi) * morphAmount;
    final bottomRight = baseRadius + math.cos(morphProgress * math.pi * 2 + math.pi) * morphAmount;

    path.addRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(0, 0, size.width, size.height),
        topLeft: Radius.circular(topLeft),
        topRight: Radius.circular(topRight),
        bottomLeft: Radius.circular(bottomLeft),
        bottomRight: Radius.circular(bottomRight),
      ),
    );

    // Glow effect
    if (glowIntensity > 0) {
      final glowPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0 + glowIntensity * 3.0
        ..color = (isUser ? const Color(0xFF8A2BE2) : const Color(0xFF00F5FF))
            .withOpacity(glowIntensity * 0.8)
        ..maskFilter = MaskFilter.blur(BlurStyle.outer, glowIntensity * 4.0);
      
      canvas.drawPath(path, glowPaint);
    }

    // Main bubble gradient
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    paint.shader = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: isUser
          ? [
              const Color(0xFF8A2BE2).withOpacity(0.8),
              const Color(0xFFDA70D6).withOpacity(0.6),
            ]
          : [
              const Color(0xFF1E1E2E).withOpacity(0.9),
              const Color(0xFF2A2A3E).withOpacity(0.7),
            ],
    ).createShader(rect);

    canvas.drawPath(path, paint);

    // Inner glow for AI bubbles
    if (!isUser && glowIntensity > 0) {
      final innerGlowPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0
        ..color = const Color(0xFF00F5FF).withOpacity(glowIntensity * 0.4);
      
      canvas.drawPath(path, innerGlowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ThinkingBubblePainter extends CustomPainter {
  final double thinkingProgress;
  final double glowIntensity;

  ThinkingBubblePainter({
    required this.thinkingProgress,
    required this.glowIntensity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    // Create pulsating bubble
    final path = Path();
    final baseRadius = 20.0;
    final pulseAmount = math.sin(thinkingProgress * math.pi * 4) * 3.0;
    final radius = baseRadius + pulseAmount;

    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(radius),
      ),
    );

    // Animated glow
    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0 + glowIntensity * 4.0
      ..color = const Color(0xFF00F5FF).withOpacity(glowIntensity * 0.8)
      ..maskFilter = MaskFilter.blur(BlurStyle.outer, glowIntensity * 6.0);
    
    canvas.drawPath(path, glowPaint);

    // Main bubble
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    paint.shader = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        const Color(0xFF1E1E2E).withOpacity(0.9),
        const Color(0xFF2A2A3E).withOpacity(0.7),
      ],
    ).createShader(rect);

    canvas.drawPath(path, paint);

    // Inner pulse effect
    final innerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = const Color(0xFF00F5FF).withOpacity(thinkingProgress * 0.6);
    
    canvas.drawPath(path, innerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}