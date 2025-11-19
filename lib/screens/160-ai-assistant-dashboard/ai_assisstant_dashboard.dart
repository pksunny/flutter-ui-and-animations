import 'package:flutter/material.dart';
import 'dart:math' as math;

/// 🎯 Main AI Assistant Dashboard Widget
/// 
/// A beautiful, futuristic chat interface with:
/// - Pulsating AI orb at the top
/// - Glowing message bubbles with smooth animations
/// - Typing indicator with shimmering dots
/// - Animated voice input microphone
/// - Smooth micro-interactions throughout
class AIAssistantDashboard extends StatefulWidget {
  /// Customize the primary accent color
  final Color primaryColor;
  
  /// Customize the AI orb color
  final Color aiOrbColor;
  
  /// Background gradient colors
  final List<Color> backgroundGradient;
  
  /// Enable/disable voice input
  final bool enableVoiceInput;
  
  const AIAssistantDashboard({
    Key? key,
    this.primaryColor = const Color(0xFF6C63FF),
    this.aiOrbColor = const Color(0xFF00D9FF),
    this.backgroundGradient = const [
      Color(0xFFF8F9FF),
      Color(0xFFFFFFFF),
    ],
    this.enableVoiceInput = true,
  }) : super(key: key);

  @override
  State<AIAssistantDashboard> createState() => _AIAssistantDashboardState();
}

class _AIAssistantDashboardState extends State<AIAssistantDashboard>
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;
  bool _isVoiceRecording = false;

  late AnimationController _orbController;
  late AnimationController _voiceController;

  @override
  void initState() {
    super.initState();
    
    // AI Orb pulsating animation
    _orbController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    // Voice recording animation
    _voiceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Add welcome message
    _addWelcomeMessage();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _orbController.dispose();
    _voiceController.dispose();
    super.dispose();
  }

  void _addWelcomeMessage() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _messages.add(
            ChatMessage(
              text: "Hello! I'm your AI assistant. How can I help you today?",
              isUser: false,
              timestamp: DateTime.now(),
            ),
          );
        });
      }
    });
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(
          text: _messageController.text,
          isUser: true,
          timestamp: DateTime.now(),
        ),
      );
      _isTyping = true;
    });

    _messageController.clear();
    _scrollToBottom();

    // Simulate AI response
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        setState(() {
          _messages.add(
            ChatMessage(
              text: _getAIResponse(),
              isUser: false,
              timestamp: DateTime.now(),
            ),
          );
          _isTyping = false;
        });
        _scrollToBottom();
      }
    });
  }

  String _getAIResponse() {
    final responses = [
      "That's a great question! Let me help you with that.",
      "I understand what you're looking for. Here's what I think...",
      "Absolutely! I can assist you with that right away.",
      "Interesting point! Let me provide you with the best solution.",
      "I'm processing your request. Here's my analysis...",
    ];
    return responses[math.Random().nextInt(responses.length)];
  }

  void _toggleVoiceRecording() {
    setState(() {
      _isVoiceRecording = !_isVoiceRecording;
    });

    if (_isVoiceRecording) {
      _voiceController.repeat(reverse: true);
    } else {
      _voiceController.stop();
      _voiceController.reset();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: widget.backgroundGradient,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Section with AI Orb
              _buildTopSection(),

              // Chat Messages
              Expanded(
                child: _buildMessagesList(),
              ),

              // Typing Indicator
              if (_isTyping) _buildTypingIndicator(),

              // Input Section
              _buildInputSection(),
            ],
          ),
        ),
      ),
    );
  }

  /// 🌟 Top Section with Pulsating AI Orb
  Widget _buildTopSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      child: Column(
        children: [
          // AI Orb with glow effect
          AnimatedBuilder(
            animation: _orbController,
            builder: (context, child) {
              final scale = 1.0 + (_orbController.value * 0.15);
              final opacity = 0.3 + (_orbController.value * 0.4);

              return Stack(
                alignment: Alignment.center,
                children: [
                  // Outer glow
                  Container(
                    width: 100 * scale,
                    height: 100 * scale,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          widget.aiOrbColor.withOpacity(opacity),
                          widget.aiOrbColor.withOpacity(0),
                        ],
                      ),
                    ),
                  ),
                  // Middle glow
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          widget.aiOrbColor.withOpacity(0.5),
                          widget.aiOrbColor.withOpacity(0.1),
                        ],
                      ),
                    ),
                  ),
                  // Core orb
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          widget.aiOrbColor,
                          widget.primaryColor,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: widget.aiOrbColor.withOpacity(0.6),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.psychology_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          // Title
          Text(
            'AI Assistant',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Always here to help',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  /// 💬 Messages List
  Widget _buildMessagesList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        return _ChatBubble(
          message: _messages[index],
          primaryColor: widget.primaryColor,
          index: index,
        );
      },
    );
  }

  /// ⌨️ Typing Indicator
  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          _ShimmeringDots(color: widget.primaryColor),
          const SizedBox(width: 8),
          Text(
            'AI is typing...',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 13,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  /// 📝 Input Section
  Widget _buildInputSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Voice Input Button (if enabled)
          if (widget.enableVoiceInput) ...[
            _VoiceMicButton(
              isRecording: _isVoiceRecording,
              onTap: _toggleVoiceRecording,
              controller: _voiceController,
              color: widget.primaryColor,
            ),
            const SizedBox(width: 12),
          ],

          // Text Input Field
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Send Button
          _SendButton(
            onTap: _sendMessage,
            color: widget.primaryColor,
          ),
        ],
      ),
    );
  }
}

/// 💭 Chat Message Model
class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

/// 🎨 Chat Bubble Widget with Glow Effect
class _ChatBubble extends StatefulWidget {
  final ChatMessage message;
  final Color primaryColor;
  final int index;

  const _ChatBubble({
    Key? key,
    required this.message,
    required this.primaryColor,
    required this.index,
  }) : super(key: key);

  @override
  State<_ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<_ChatBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    // Staggered animation based on index
    Future.delayed(Duration(milliseconds: widget.index * 100), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        alignment: widget.message.isUser
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: widget.message.isUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!widget.message.isUser) ...[
                _buildAvatar(false),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    gradient: widget.message.isUser
                        ? LinearGradient(
                            colors: [
                              widget.primaryColor,
                              widget.primaryColor.withOpacity(0.8),
                            ],
                          )
                        : LinearGradient(
                            colors: [
                              Colors.white,
                              Colors.grey[50]!,
                            ],
                          ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: widget.message.isUser
                            ? widget.primaryColor.withOpacity(0.3)
                            : Colors.black.withOpacity(0.08),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                        spreadRadius: widget.message.isUser ? 2 : 0,
                      ),
                    ],
                  ),
                  child: Text(
                    widget.message.text,
                    style: TextStyle(
                      color: widget.message.isUser
                          ? Colors.white
                          : Colors.grey[800],
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
              if (widget.message.isUser) ...[
                const SizedBox(width: 8),
                _buildAvatar(true),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(bool isUser) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: isUser
              ? [Colors.orange[300]!, Colors.orange[500]!]
              : [widget.primaryColor, Colors.blue[300]!],
        ),
        boxShadow: [
          BoxShadow(
            color: (isUser ? Colors.orange : widget.primaryColor)
                .withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Icon(
        isUser ? Icons.person_rounded : Icons.smart_toy_rounded,
        color: Colors.white,
        size: 18,
      ),
    );
  }
}

/// ✨ Shimmering Typing Dots
class _ShimmeringDots extends StatefulWidget {
  final Color color;

  const _ShimmeringDots({Key? key, required this.color}) : super(key: key);

  @override
  State<_ShimmeringDots> createState() => _ShimmeringDotsState();
}

class _ShimmeringDotsState extends State<_ShimmeringDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            final delay = index * 0.2;
            final value = (_controller.value - delay).clamp(0.0, 1.0);
            final opacity = (math.sin(value * math.pi) * 0.7) + 0.3;

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.color.withOpacity(opacity),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withOpacity(opacity * 0.5),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }
}

/// 🎤 Voice Microphone Button
class _VoiceMicButton extends StatelessWidget {
  final bool isRecording;
  final VoidCallback onTap;
  final AnimationController controller;
  final Color color;

  const _VoiceMicButton({
    Key? key,
    required this.isRecording,
    required this.onTap,
    required this.controller,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          final scale = isRecording ? 1.0 + (controller.value * 0.1) : 1.0;

          return Stack(
            alignment: Alignment.center,
            children: [
              // Animated glow when recording
              if (isRecording)
                Container(
                  width: 50 * scale,
                  height: 50 * scale,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        color.withOpacity(0.3),
                        color.withOpacity(0),
                      ],
                    ),
                  ),
                ),
              // Microphone button
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isRecording
                        ? [Colors.red[400]!, Colors.red[600]!]
                        : [color, color.withOpacity(0.8)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (isRecording ? Colors.red : color)
                          .withOpacity(0.4),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// 📤 Send Button
class _SendButton extends StatefulWidget {
  final VoidCallback onTap;
  final Color color;

  const _SendButton({
    Key? key,
    required this.onTap,
    required this.color,
  }) : super(key: key);

  @override
  State<_SendButton> createState() => _SendButtonState();
}

class _SendButtonState extends State<_SendButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _controller.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final scale = 1.0 - (_controller.value * 0.1);

          return Transform.scale(
            scale: scale,
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    widget.color,
                    widget.color.withOpacity(0.8),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withOpacity(0.4),
                    blurRadius: _isPressed ? 8 : 12,
                    spreadRadius: _isPressed ? 1 : 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          );
        },
      ),
    );
  }
}