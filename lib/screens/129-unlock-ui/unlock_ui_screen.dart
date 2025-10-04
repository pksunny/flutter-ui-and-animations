import 'package:flutter/material.dart';
import 'dart:math' as math;

class UnlockUiScreen extends StatefulWidget {
  const UnlockUiScreen({Key? key}) : super(key: key);

  @override
  State<UnlockUiScreen> createState() => _UnlockUiScreenState();
}

class _UnlockUiScreenState extends State<UnlockUiScreen>
    with TickerProviderStateMixin {
  UnlockMode _mode = UnlockMode.create;
  List<int> _savedPattern = [];
  
  late AnimationController _titleController;
  late Animation<double> _titleAnimation;
  
  @override
  void initState() {
    super.initState();
    _titleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _titleAnimation = CurvedAnimation(
      parent: _titleController,
      curve: Curves.easeOutBack,
    );
    _titleController.forward();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _onPatternComplete(List<int> pattern) {
    if (_mode == UnlockMode.create) {
      if (_savedPattern.isEmpty) {
        setState(() {
          _savedPattern = pattern;
          _mode = UnlockMode.confirm;
        });
        _showMessage('Draw pattern again to confirm', Colors.blue);
      } else {
        if (_patternsMatch(pattern, _savedPattern)) {
          _showMessage('Pattern saved successfully! ✓', Colors.green);
          setState(() {
            _mode = UnlockMode.unlock;
          });
        } else {
          _showMessage('Patterns don\'t match. Try again.', Colors.red);
          setState(() {
            _savedPattern = [];
            _mode = UnlockMode.create;
          });
        }
      }
    } else if (_mode == UnlockMode.unlock) {
      if (_patternsMatch(pattern, _savedPattern)) {
        _showMessage('Unlocked! ✓', Colors.green);
      } else {
        _showMessage('Wrong pattern. Try again.', Colors.red);
      }
    }
  }

  bool _patternsMatch(List<int> p1, List<int> p2) {
    if (p1.length != p2.length) return false;
    for (int i = 0; i < p1.length; i++) {
      if (p1[i] != p2[i]) return false;
    }
    return true;
  }

  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _resetPattern() {
    setState(() {
      _savedPattern = [];
      _mode = UnlockMode.create;
    });
    _showMessage('Pattern reset. Create new pattern.', Colors.orange);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A0E27),
              Color(0xFF1A1F3A),
              Color(0xFF0F1729),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Animated Title
              ScaleTransition(
                scale: _titleAnimation,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue.withOpacity(0.3),
                            Colors.purple.withOpacity(0.3),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.3),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.lock_outline,
                        size: 48,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      _getModeTitle(),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getModeSubtitle(),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.6),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Pattern Lock Widget
              PatternLockWidget(
                onPatternComplete: _onPatternComplete,
                key: ValueKey(_mode),
              ),
              const Spacer(),
              // Reset Button
              if (_mode == UnlockMode.unlock)
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: TextButton.icon(
                    onPressed: _resetPattern,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset Pattern'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white70,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  String _getModeTitle() {
    switch (_mode) {
      case UnlockMode.create:
        return 'Create Pattern';
      case UnlockMode.confirm:
        return 'Confirm Pattern';
      case UnlockMode.unlock:
        return 'Unlock';
    }
  }

  String _getModeSubtitle() {
    switch (_mode) {
      case UnlockMode.create:
        return 'Draw your unlock pattern';
      case UnlockMode.confirm:
        return 'Draw the pattern again';
      case UnlockMode.unlock:
        return 'Enter your pattern to unlock';
    }
  }
}

enum UnlockMode { create, confirm, unlock }

/// Main Pattern Lock Widget
/// Fully customizable and reusable component
class PatternLockWidget extends StatefulWidget {
  final Function(List<int>) onPatternComplete;
  final int gridSize;
  final Color dotColor;
  final Color selectedDotColor;
  final Color lineColor;
  final double dotSize;
  final double selectedDotSize;
  final Duration animationDuration;
  final bool showNumbers;

  const PatternLockWidget({
    Key? key,
    required this.onPatternComplete,
    this.gridSize = 3,
    this.dotColor = const Color(0xFF2D3561),
    this.selectedDotColor = const Color(0xFF00D4FF),
    this.lineColor = const Color(0xFF00D4FF),
    this.dotSize = 20.0,
    this.selectedDotSize = 24.0,
    this.animationDuration = const Duration(milliseconds: 200),
    this.showNumbers = false,
  }) : super(key: key);

  @override
  State<PatternLockWidget> createState() => _PatternLockWidgetState();
}

class _PatternLockWidgetState extends State<PatternLockWidget>
    with TickerProviderStateMixin {
  final List<int> _selectedDots = [];
  final List<Offset> _dotPositions = [];
  Offset? _currentTouchPosition;
  bool _isDrawing = false;
  
  late AnimationController _successController;
  late AnimationController _errorController;
  late AnimationController _rippleController;
  
  final List<AnimationController> _dotControllers = [];
  final List<Animation<double>> _dotAnimations = [];

  @override
  void initState() {
    super.initState();
    
    _successController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _errorController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat();

    // Create animation controllers for each dot
    for (int i = 0; i < widget.gridSize * widget.gridSize; i++) {
      final controller = AnimationController(
        duration: widget.animationDuration,
        vsync: this,
      );
      _dotControllers.add(controller);
      _dotAnimations.add(
        CurvedAnimation(parent: controller, curve: Curves.easeOutBack),
      );
    }
  }

  @override
  void dispose() {
    _successController.dispose();
    _errorController.dispose();
    _rippleController.dispose();
    for (var controller in _dotControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _isDrawing = true;
      _currentTouchPosition = details.localPosition;
    });
    _checkDotSelection(details.localPosition);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _currentTouchPosition = details.localPosition;
    });
    _checkDotSelection(details.localPosition);
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _isDrawing = false;
      _currentTouchPosition = null;
    });

    if (_selectedDots.isNotEmpty) {
      widget.onPatternComplete(_selectedDots);
      
      // Animate completion
      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          _selectedDots.clear();
          for (var controller in _dotControllers) {
            controller.reverse();
          }
        });
      });
    }
  }

  void _checkDotSelection(Offset position) {
    for (int i = 0; i < _dotPositions.length; i++) {
      if (_selectedDots.contains(i)) continue;

      final distance = (position - _dotPositions[i]).distance;
      if (distance < 40) {
        setState(() {
          _selectedDots.add(i);
          _dotControllers[i].forward();
        });
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = math.min(constraints.maxWidth, constraints.maxHeight) * 0.8;
        return Center(
          child: GestureDetector(
            onPanStart: _onPanStart,
            onPanUpdate: _onPanUpdate,
            onPanEnd: _onPanEnd,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.05),
                    Colors.white.withOpacity(0.02),
                  ],
                ),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 30,
                    spreadRadius: -5,
                  ),
                ],
              ),
              child: CustomPaint(
                painter: PatternPainter(
                  selectedDots: _selectedDots,
                  dotPositions: _dotPositions,
                  currentTouchPosition: _currentTouchPosition,
                  gridSize: widget.gridSize,
                  dotColor: widget.dotColor,
                  selectedDotColor: widget.selectedDotColor,
                  lineColor: widget.lineColor,
                  dotSize: widget.dotSize,
                  selectedDotSize: widget.selectedDotSize,
                  showNumbers: widget.showNumbers,
                  dotAnimations: _dotAnimations,
                  rippleAnimation: _rippleController,
                ),
                size: Size(size, size),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Custom Painter for Pattern Lock
class PatternPainter extends CustomPainter {
  final List<int> selectedDots;
  final List<Offset> dotPositions;
  final Offset? currentTouchPosition;
  final int gridSize;
  final Color dotColor;
  final Color selectedDotColor;
  final Color lineColor;
  final double dotSize;
  final double selectedDotSize;
  final bool showNumbers;
  final List<Animation<double>> dotAnimations;
  final AnimationController rippleAnimation;

  PatternPainter({
    required this.selectedDots,
    required this.dotPositions,
    this.currentTouchPosition,
    required this.gridSize,
    required this.dotColor,
    required this.selectedDotColor,
    required this.lineColor,
    required this.dotSize,
    required this.selectedDotSize,
    required this.showNumbers,
    required this.dotAnimations,
    required this.rippleAnimation,
  }) : super(repaint: rippleAnimation);

  @override
  void paint(Canvas canvas, Size size) {
    // Calculate dot positions if not already done
    if (dotPositions.isEmpty) {
      final spacing = size.width / (gridSize + 1);
      for (int i = 0; i < gridSize; i++) {
        for (int j = 0; j < gridSize; j++) {
          dotPositions.add(Offset(
            spacing * (j + 1),
            spacing * (i + 1),
          ));
        }
      }
    }

    // Draw connecting lines
    if (selectedDots.isNotEmpty) {
      _drawLines(canvas);
    }

    // Draw dots
    _drawDots(canvas);
  }

  void _drawLines(Canvas canvas) {
    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final glowPaint = Paint()
      ..color = lineColor.withOpacity(0.3)
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final path = Path();
    
    // Draw path through selected dots
    for (int i = 0; i < selectedDots.length; i++) {
      final dotIndex = selectedDots[i];
      final position = dotPositions[dotIndex];

      if (i == 0) {
        path.moveTo(position.dx, position.dy);
      } else {
        path.lineTo(position.dx, position.dy);
      }
    }

    // Add line to current touch position if drawing
    if (currentTouchPosition != null && selectedDots.isNotEmpty) {
      final lastDot = dotPositions[selectedDots.last];
      path.moveTo(lastDot.dx, lastDot.dy);
      path.lineTo(currentTouchPosition!.dx, currentTouchPosition!.dy);
    }

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, linePaint);
  }

  void _drawDots(Canvas canvas) {
    for (int i = 0; i < dotPositions.length; i++) {
      final position = dotPositions[i];
      final isSelected = selectedDots.contains(i);
      final animationValue = dotAnimations[i].value;

      // Draw ripple effect for selected dots
      if (isSelected) {
        final rippleValue = rippleAnimation.value;
        final ripplePaint = Paint()
          ..color = selectedDotColor.withOpacity(0.3 * (1 - rippleValue))
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

        canvas.drawCircle(
          position,
          selectedDotSize + (20 * rippleValue),
          ripplePaint,
        );
      }

      // Draw outer glow
      if (isSelected) {
        final glowPaint = Paint()
          ..color = selectedDotColor.withOpacity(0.4)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);

        canvas.drawCircle(
          position,
          selectedDotSize * animationValue,
          glowPaint,
        );
      }

      // Draw main dot
      final dotPaint = Paint()
        ..color = isSelected ? selectedDotColor : dotColor
        ..style = PaintingStyle.fill;

      final currentSize = isSelected
          ? dotSize + ((selectedDotSize - dotSize) * animationValue)
          : dotSize;

      canvas.drawCircle(position, currentSize, dotPaint);

      // Draw inner highlight
      if (isSelected) {
        final highlightPaint = Paint()
          ..color = Colors.white.withOpacity(0.3 * animationValue)
          ..style = PaintingStyle.fill;

        canvas.drawCircle(
          position,
          currentSize * 0.4,
          highlightPaint,
        );
      }

      // Draw number if enabled
      if (showNumbers) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: '${i + 1}',
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white54,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          position - Offset(textPainter.width / 2, textPainter.height / 2),
        );
      }

      // Draw selection order number
      if (isSelected) {
        final orderIndex = selectedDots.indexOf(i);
        final textPainter = TextPainter(
          text: TextSpan(
            text: '${orderIndex + 1}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          position - Offset(textPainter.width / 2, textPainter.height / 2),
        );
      }
    }
  }

  @override
  bool shouldRepaint(PatternPainter oldDelegate) {
    return oldDelegate.selectedDots != selectedDots ||
        oldDelegate.currentTouchPosition != currentTouchPosition;
  }
}