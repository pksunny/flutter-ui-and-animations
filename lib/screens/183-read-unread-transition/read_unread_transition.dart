import 'package:flutter/material.dart';

class ReadUnreadDemoScreen extends StatefulWidget {
  const ReadUnreadDemoScreen({Key? key}) : super(key: key);

  @override
  State<ReadUnreadDemoScreen> createState() => _ReadUnreadDemoScreenState();
}

class _ReadUnreadDemoScreenState extends State<ReadUnreadDemoScreen> {
  final List<MessageItem> _messages = [
    MessageItem(
      id: '1',
      sender: 'Sarah Johnson',
      message: 'Hey! Are we still on for lunch tomorrow?',
      time: '10:24 AM',
      isRead: false,
    ),
    MessageItem(
      id: '2',
      sender: 'Design Team',
      message: 'New mockups are ready for review',
      time: '9:15 AM',
      isRead: false,
    ),
    MessageItem(
      id: '3',
      sender: 'Alex Chen',
      message: 'Thanks for the quick turnaround on that!',
      time: 'Yesterday',
      isRead: true,
    ),
    MessageItem(
      id: '4',
      sender: 'Marketing Updates',
      message: 'Q1 campaign performance exceeded targets',
      time: 'Yesterday',
      isRead: false,
    ),
    MessageItem(
      id: '5',
      sender: 'Mom',
      message: 'Don\'t forget to call grandma this weekend',
      time: 'Monday',
      isRead: true,
    ),
  ];

  void _toggleReadStatus(String id) {
    setState(() {
      final index = _messages.indexWhere((msg) => msg.id == id);
      if (index != -1) {
        _messages[index] = _messages[index].copyWith(
          isRead: !_messages[index].isRead,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Messages',
          style: TextStyle(
            color: Color(0xFF1D1D1F),
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 0.5, color: const Color(0xFFE5E5EA)),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _messages.length,
        separatorBuilder:
            (context, index) => Container(
              height: 0.5,
              margin: const EdgeInsets.only(left: 72),
              color: const Color(0xFFE5E5EA),
            ),
        itemBuilder: (context, index) {
          return ReadUnreadListItem(
            message: _messages[index],
            onTap: () => _toggleReadStatus(_messages[index].id),
          );
        },
      ),
    );
  }
}

/// Core data model for a message item
class MessageItem {
  final String id;
  final String sender;
  final String message;
  final String time;
  final bool isRead;

  const MessageItem({
    required this.id,
    required this.sender,
    required this.message,
    required this.time,
    required this.isRead,
  });

  MessageItem copyWith({
    String? id,
    String? sender,
    String? message,
    String? time,
    bool? isRead,
  }) {
    return MessageItem(
      id: id ?? this.id,
      sender: sender ?? this.sender,
      message: message ?? this.message,
      time: time ?? this.time,
      isRead: isRead ?? this.isRead,
    );
  }
}

/// Premium animated list item that transitions smoothly between read/unread states
///
/// Key animations:
/// - Font weight morphs from bold (700) to regular (400) on read
/// - Subtle scale animation on tap
/// - Color transitions for text and background
/// - Unread indicator fades in/out smoothly
class ReadUnreadListItem extends StatefulWidget {
  final MessageItem message;
  final VoidCallback onTap;
  final Duration animationDuration;
  final Curve animationCurve;

  const ReadUnreadListItem({
    Key? key,
    required this.message,
    required this.onTap,
    this.animationDuration = const Duration(milliseconds: 600),
    this.animationCurve = Curves.easeOutCubic,
  }) : super(key: key);

  @override
  State<ReadUnreadListItem> createState() => _ReadUnreadListItemState();
}

class _ReadUnreadListItemState extends State<ReadUnreadListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Scale animation for tap feedback
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _scaleController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _scaleController.reverse();
  }

  void _handleTapCancel() {
    _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: widget.animationDuration,
          curve: widget.animationCurve,
          color:
              widget.message.isRead
                  ? Colors.white
                  : Colors.white.withOpacity(0.98),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                _buildAvatar(),
                const SizedBox(width: 12),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Sender name with animated font weight
                          Expanded(
                            child: _AnimatedFontWeight(
                              text: widget.message.sender,
                              isRead: widget.message.isRead,
                              duration: widget.animationDuration,
                              curve: widget.animationCurve,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Time stamp
                          _buildTimeStamp(),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Message preview with animated font weight
                      _AnimatedFontWeight(
                        text: widget.message.message,
                        isRead: widget.message.isRead,
                        duration: widget.animationDuration,
                        curve: widget.animationCurve,
                        fontSize: 15,
                        maxLines: 2,
                        color: const Color(0xFF86868B),
                      ),
                    ],
                  ),
                ),

                // Unread indicator
                const SizedBox(width: 12),
                _buildUnreadIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return AnimatedContainer(
      duration: widget.animationDuration,
      curve: widget.animationCurve,
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors:
              widget.message.isRead
                  ? [const Color(0xFFD1D1D6), const Color(0xFFC7C7CC)]
                  : [const Color(0xFF007AFF), const Color(0xFF0051D5)],
        ),
      ),
      child: Center(
        child: AnimatedDefaultTextStyle(
          duration: widget.animationDuration,
          curve: widget.animationCurve,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
          child: Text(widget.message.sender[0].toUpperCase()),
        ),
      ),
    );
  }

  Widget _buildTimeStamp() {
    return AnimatedDefaultTextStyle(
      duration: widget.animationDuration,
      curve: widget.animationCurve,
      style: TextStyle(
        fontSize: 14,
        color:
            widget.message.isRead
                ? const Color(0xFFAEAEB2)
                : const Color(0xFF007AFF),
        fontWeight: widget.message.isRead ? FontWeight.w400 : FontWeight.w500,
      ),
      child: Text(widget.message.time),
    );
  }

  Widget _buildUnreadIndicator() {
    return AnimatedScale(
      duration: widget.animationDuration,
      curve: widget.animationCurve,
      scale: widget.message.isRead ? 0.0 : 1.0,
      child: AnimatedOpacity(
        duration: widget.animationDuration,
        curve: widget.animationCurve,
        opacity: widget.message.isRead ? 0.0 : 1.0,
        child: Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF007AFF),
          ),
        ),
      ),
    );
  }
}

/// Custom widget that animates font weight smoothly between read/unread states
///
/// Uses TweenAnimationBuilder to morph font weight from bold (700) to regular (400)
/// This creates the signature "text weight gently drops" effect
class _AnimatedFontWeight extends StatelessWidget {
  final String text;
  final bool isRead;
  final Duration duration;
  final Curve curve;
  final double fontSize;
  final int maxLines;
  final Color? color;

  const _AnimatedFontWeight({
    Key? key,
    required this.text,
    required this.isRead,
    required this.duration,
    required this.curve,
    required this.fontSize,
    this.maxLines = 1,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Font weight values: unread = 700 (bold), read = 400 (regular)
    final targetWeight = isRead ? FontWeight.w400 : FontWeight.w700;
    final targetColor =
        color ?? (isRead ? const Color(0xFF1D1D1F) : const Color(0xFF000000));

    return TweenAnimationBuilder<FontWeight>(
      tween: FontWeightTween(
        begin: isRead ? FontWeight.w700 : FontWeight.w400,
        end: targetWeight,
      ),
      duration: duration,
      curve: curve,
      builder: (context, fontWeight, child) {
        return AnimatedDefaultTextStyle(
          duration: duration,
          curve: curve,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: targetColor,
            letterSpacing: -0.3,
            height: 1.35,
          ),
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
          child: Text(text),
        );
      },
    );
  }
}

/// Custom Tween for smoothly interpolating between FontWeight values
///
/// Flutter doesn't provide a built-in FontWeight tween, so we create one
/// that linearly interpolates between weight indices
class FontWeightTween extends Tween<FontWeight> {
  FontWeightTween({FontWeight? begin, FontWeight? end})
    : super(begin: begin, end: end);

  @override
  FontWeight lerp(double t) {
    // Convert FontWeight to index (0-8 for w100-w900)
    final beginIndex = _fontWeightToIndex(begin ?? FontWeight.w400);
    final endIndex = _fontWeightToIndex(end ?? FontWeight.w400);

    // Interpolate between indices
    final currentIndex = (beginIndex + (endIndex - beginIndex) * t).round();

    // Convert back to FontWeight
    return _indexToFontWeight(currentIndex);
  }

  int _fontWeightToIndex(FontWeight weight) {
    switch (weight) {
      case FontWeight.w100:
        return 0;
      case FontWeight.w200:
        return 1;
      case FontWeight.w300:
        return 2;
      case FontWeight.w400:
        return 3;
      case FontWeight.w500:
        return 4;
      case FontWeight.w600:
        return 5;
      case FontWeight.w700:
        return 6;
      case FontWeight.w800:
        return 7;
      case FontWeight.w900:
        return 8;
      default:
        return 3;
    }
  }

  FontWeight _indexToFontWeight(int index) {
    switch (index) {
      case 0:
        return FontWeight.w100;
      case 1:
        return FontWeight.w200;
      case 2:
        return FontWeight.w300;
      case 3:
        return FontWeight.w400;
      case 4:
        return FontWeight.w500;
      case 5:
        return FontWeight.w600;
      case 6:
        return FontWeight.w700;
      case 7:
        return FontWeight.w800;
      case 8:
        return FontWeight.w900;
      default:
        return FontWeight.w400;
    }
  }
}
