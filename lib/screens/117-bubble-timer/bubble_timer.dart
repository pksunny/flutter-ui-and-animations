import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;

class BubbleTimerDemo extends StatefulWidget {
  @override
  _BubbleTimerDemoState createState() => _BubbleTimerDemoState();
}

class _BubbleTimerDemoState extends State<BubbleTimerDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
              Color(0xFF6B73FF),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Amazing Bubble Timer',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 40),
                // Main Bubble Timer Widget
                BubbleTimer(
                  duration: Duration(seconds: 30),
                  size: 300,
                  bubbleCount: 25,
                  primaryColor: Colors.cyan,
                  secondaryColor: Colors.purple,
                  accentColor: Colors.pink,
                  onTimerComplete: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Timer Complete! 🎉'),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Amazing Bubble Timer Widget
/// 
/// A highly customizable countdown timer with floating bubbles that pop
/// as time progresses. Features smooth animations and beautiful visual effects.
class BubbleTimer extends StatefulWidget {
  /// Total duration for the countdown timer
  final Duration duration;
  
  /// Size of the timer widget (width and height)
  final double size;
  
  /// Number of bubbles to display
  final int bubbleCount;
  
  /// Primary color for the timer and bubbles
  final Color primaryColor;
  
  /// Secondary color for gradient effects
  final Color secondaryColor;
  
  /// Accent color for special effects
  final Color accentColor;
  
  /// Background color (optional)
  final Color? backgroundColor;
  
  /// Text style for timer display
  final TextStyle? timerTextStyle;
  
  /// Callback when timer completes
  final VoidCallback? onTimerComplete;
  
  /// Callback for each second tick
  final Function(int remainingSeconds)? onTick;
  
  /// Whether to auto-start the timer
  final bool autoStart;

  const BubbleTimer({
    Key? key,
    required this.duration,
    this.size = 300,
    this.bubbleCount = 20,
    this.primaryColor = Colors.blue,
    this.secondaryColor = Colors.purple,
    this.accentColor = Colors.pink,
    this.backgroundColor,
    this.timerTextStyle,
    this.onTimerComplete,
    this.onTick,
    this.autoStart = true,
  }) : super(key: key);

  @override
  _BubbleTimerState createState() => _BubbleTimerState();
}

class _BubbleTimerState extends State<BubbleTimer>
    with TickerProviderStateMixin {
  late AnimationController _timerController;
  late AnimationController _bubbleController;
  late AnimationController _pulseController;
  
  Timer? _countdownTimer;
  int _remainingSeconds = 0;
  bool _isRunning = false;
  bool _isPaused = false;
  
  List<BubbleData> _bubbles = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.duration.inSeconds;
    
    // Initialize animation controllers
    _timerController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    
    _bubbleController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat();
    
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    
    _generateBubbles();
    
    if (widget.autoStart) {
      startTimer();
    }
  }

  @override
  void dispose() {
    _timerController.dispose();
    _bubbleController.dispose();
    _pulseController.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  /// Generate random bubbles with positions and properties
  void _generateBubbles() {
    _bubbles.clear();
    for (int i = 0; i < widget.bubbleCount; i++) {
      _bubbles.add(BubbleData(
        id: i,
        x: _random.nextDouble() * (widget.size - 40) + 20,
        y: _random.nextDouble() * (widget.size - 40) + 20,
        size: _random.nextDouble() * 30 + 10,
        speed: _random.nextDouble() * 2 + 1,
        color: _getBubbleColor(),
        opacity: _random.nextDouble() * 0.6 + 0.4,
        poppedAt: -1,
      ));
    }
  }

  /// Get random bubble color from the color palette
  Color _getBubbleColor() {
    List<Color> colors = [
      widget.primaryColor,
      widget.secondaryColor,
      widget.accentColor,
      widget.primaryColor.withOpacity(0.7),
      widget.secondaryColor.withOpacity(0.7),
    ];
    return colors[_random.nextInt(colors.length)];
  }

  /// Start the countdown timer
  void startTimer() {
    if (_isRunning || _remainingSeconds <= 0) return;
    
    setState(() {
      _isRunning = true;
      _isPaused = false;
    });
    
    _timerController.forward();
    
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _remainingSeconds--;
        _popBubblesForCurrentTime();
      });
      
      widget.onTick?.call(_remainingSeconds);
      
      if (_remainingSeconds <= 0) {
        _completeTimer();
      }
    });
  }

  /// Pause the timer
  void pauseTimer() {
    if (!_isRunning || _isPaused) return;
    
    setState(() {
      _isPaused = true;
    });
    
    _timerController.stop();
    _countdownTimer?.cancel();
  }

  /// Resume the timer
  void resumeTimer() {
    if (!_isPaused) return;
    
    setState(() {
      _isPaused = false;
    });
    
    startTimer();
  }

  /// Reset the timer
  void resetTimer() {
    _countdownTimer?.cancel();
    _timerController.reset();
    
    setState(() {
      _isRunning = false;
      _isPaused = false;
      _remainingSeconds = widget.duration.inSeconds;
    });
    
    _generateBubbles();
  }

  /// Complete the timer
  void _completeTimer() {
    _countdownTimer?.cancel();
    setState(() {
      _isRunning = false;
      _isPaused = false;
    });
    
    widget.onTimerComplete?.call();
  }

  /// Pop bubbles based on elapsed time
  void _popBubblesForCurrentTime() {
    int totalSeconds = widget.duration.inSeconds;
    int elapsedSeconds = totalSeconds - _remainingSeconds;
    int bubblesToPop = ((elapsedSeconds / totalSeconds) * widget.bubbleCount).floor();
    
    for (int i = 0; i < bubblesToPop && i < _bubbles.length; i++) {
      if (_bubbles[i].poppedAt == -1) {
        _bubbles[i].poppedAt = elapsedSeconds;
      }
    }
  }

  /// Format remaining time as MM:SS
  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!_isRunning) {
          startTimer();
        } else if (_isPaused) {
          resumeTimer();
        } else {
          pauseTimer();
        }
      },
      onDoubleTap: resetTimer,
      child: Container(
        width: widget.size,
        height: widget.size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background circle with gradient
            _buildBackgroundCircle(),
            
            // Animated bubbles
            ..._buildBubbles(),
            
            // Timer progress ring
            _buildProgressRing(),
            
            // Timer text and controls
            _buildTimerCenter(),
            
            // Pulse effect when running
            if (_isRunning && !_isPaused) _buildPulseEffect(),
          ],
        ),
      ),
    );
  }

  /// Build the background circle with gradient
  Widget _buildBackgroundCircle() {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            widget.backgroundColor ?? Colors.black.withOpacity(0.1),
            widget.backgroundColor?.withOpacity(0.3) ?? Colors.black.withOpacity(0.2),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: widget.primaryColor.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
    );
  }

  /// Build animated bubbles
  List<Widget> _buildBubbles() {
    return _bubbles.map((bubble) {
      bool isPopped = bubble.poppedAt != -1;
      
      return AnimatedBuilder(
        animation: _bubbleController,
        builder: (context, child) {
          // Calculate bubble position with floating animation
          double floatOffset = math.sin((_bubbleController.value * 2 * math.pi) + bubble.id) * 10;
          
          return Positioned(
            left: bubble.x,
            top: bubble.y + floatOffset,
            child: AnimatedScale(
              scale: isPopped ? 0.0 : 1.0,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
              child: AnimatedOpacity(
                opacity: isPopped ? 0.0 : bubble.opacity,
                duration: Duration(milliseconds: 300),
                child: Container(
                  width: bubble.size,
                  height: bubble.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        bubble.color.withOpacity(0.8),
                        bubble.color.withOpacity(0.3),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: bubble.color.withOpacity(0.4),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.3),
                          Colors.transparent,
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
    }).toList();
  }

  /// Build the progress ring
  Widget _buildProgressRing() {
    return SizedBox(
      width: widget.size * 0.9,
      height: widget.size * 0.9,
      child: AnimatedBuilder(
        animation: _timerController,
        builder: (context, child) {
          return CustomPaint(
            painter: ProgressRingPainter(
              progress: _timerController.value,
              primaryColor: widget.primaryColor,
              secondaryColor: widget.secondaryColor,
              strokeWidth: 8.0,
            ),
          );
        },
      ),
    );
  }

  /// Build the center content with timer and controls
  Widget _buildTimerCenter() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Timer text
        AnimatedDefaultTextStyle(
          duration: Duration(milliseconds: 300),
          style: widget.timerTextStyle ??
              TextStyle(
                fontSize: widget.size * 0.15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: widget.primaryColor.withOpacity(0.5),
                    blurRadius: 10,
                  ),
                ],
              ),
          child: Text(_formatTime(_remainingSeconds)),
        ),
        
        SizedBox(height: 20),
        
        // Control buttons
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildControlButton(
              icon: _isRunning
                  ? (_isPaused ? Icons.play_arrow : Icons.pause)
                  : Icons.play_arrow,
              onPressed: () {
                if (!_isRunning) {
                  startTimer();
                } else if (_isPaused) {
                  resumeTimer();
                } else {
                  pauseTimer();
                }
              },
            ),
            SizedBox(width: 20),
            _buildControlButton(
              icon: Icons.refresh,
              onPressed: resetTimer,
            ),
          ],
        ),
      ],
    );
  }

  /// Build control button
  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              widget.accentColor,
              widget.accentColor.withOpacity(0.7),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: widget.accentColor.withOpacity(0.4),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  /// Build pulse effect
  Widget _buildPulseEffect() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Container(
          width: widget.size * (0.95 + _pulseController.value * 0.1),
          height: widget.size * (0.95 + _pulseController.value * 0.1),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: widget.primaryColor.withOpacity(0.3 - _pulseController.value * 0.3),
              width: 3,
            ),
          ),
        );
      },
    );
  }
}

/// Custom painter for the progress ring
class ProgressRingPainter extends CustomPainter {
  final double progress;
  final Color primaryColor;
  final Color secondaryColor;
  final double strokeWidth;

  ProgressRingPainter({
    required this.progress,
    required this.primaryColor,
    required this.secondaryColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    
    // Background ring
    final backgroundPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    
    canvas.drawCircle(center, radius, backgroundPaint);
    
    // Progress ring with gradient effect
    final progressPaint = Paint()
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    
    // Create gradient shader
    final gradient = SweepGradient(
      startAngle: -math.pi / 2,
      colors: [
        primaryColor,
        secondaryColor,
        primaryColor,
      ],
      stops: [0.0, 0.5, 1.0],
    );
    
    progressPaint.shader = gradient.createShader(
      Rect.fromCircle(center: center, radius: radius),
    );
    
    // Draw progress arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(ProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// Data class for bubble properties
class BubbleData {
  final int id;
  final double x;
  final double y;
  final double size;
  final double speed;
  final Color color;
  final double opacity;
  int poppedAt;

  BubbleData({
    required this.id,
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.color,
    required this.opacity,
    required this.poppedAt,
  });
}