import 'package:flutter/material.dart';

class FluidSliderScreen extends StatefulWidget {
  const FluidSliderScreen({super.key});

  @override
  State<FluidSliderScreen> createState() => _FluidSliderScreenState();
}

class _FluidSliderScreenState extends State<FluidSliderScreen> {
  double _sliderValue = 0.5; // Initial slider value (0.0 to 1.0)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E), // Dark background for contrast
      appBar: AppBar(
        title: const Text('Fluid Slider', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Adjust Brightness',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(height: 50),
              FluidSlider(
                value: _sliderValue,
                onChanged: (newValue) {
                  setState(() {
                    _sliderValue = newValue;
                  });
                },
                min: 0.0,
                max: 1.0,
                height: 60.0, // Height of the slider track
                handleRadius: 25.0, // Radius of the circular part of the handle
                gradientColors: const [
                  Color(0xFF8A2BE2), // Blue Violet
                  Color(0xFFDA70D6), // Orchid
                  Color(0xFFFFA07A), // Light Salmon
                ],
              ),
              const SizedBox(height: 50),
              Text(
                'Value: ${(_sliderValue * 100).toStringAsFixed(0)}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FluidSlider extends StatefulWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final double min;
  final double max;
  final double height;
  final double handleRadius;
  final List<Color> gradientColors;

  const FluidSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
    this.height = 50.0,
    this.handleRadius = 20.0,
    this.gradientColors = const [Colors.blue, Colors.purple],
  });

  @override
  State<FluidSlider> createState() => _FluidSliderState();
}

class _FluidSliderState extends State<FluidSlider> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _wobbleAnimation;
  double _currentHandleX = 0.0; // Current X position of the handle
  double _trackWidth = 0.0; // Width of the slider track

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Wobble animation for the handle's stretching effect
    _wobbleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut, // Provides a nice bouncy effect
      ),
    );

    _animationController.addListener(() {
      setState(() {
        // Redraw the slider as the animation progresses
      });
    });
  }

  @override
  void didUpdateWidget(covariant FluidSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the value changes externally, update the handle position
    if (oldWidget.value != widget.value) {
      _updateHandlePosition(widget.value);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Converts slider value (0-1) to pixel position on the track
  double _valueToX(double value) {
    if (_trackWidth == 0) return 0; // Avoid division by zero
    final normalizedValue = (value - widget.min) / (widget.max - widget.min);
    return normalizedValue * _trackWidth;
  }

  // Converts pixel position on the track to slider value (0-1)
  double _xToValue(double x) {
    if (_trackWidth == 0) return widget.min; // Avoid division by zero
    final normalizedX = x / _trackWidth;
    return normalizedX * (widget.max - widget.min) + widget.min;
  }

  // Updates the handle's X position based on the slider value
  void _updateHandlePosition(double newValue) {
    setState(() {
      _currentHandleX = _valueToX(newValue);
    });
  }

  void _onHorizontalDragStart(DragStartDetails details) {
    _animationController.forward(from: 0.0); // Start wobble animation
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      // Update handle position based on drag delta
      _currentHandleX = (_currentHandleX + details.delta.dx)
          .clamp(0.0, _trackWidth); // Clamp within track bounds

      // Calculate new value and notify parent
      final newValue = _xToValue(_currentHandleX);
      widget.onChanged(newValue);
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    _animationController.reverse(from: 1.0); // Reverse wobble animation
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _trackWidth = constraints.maxWidth - (widget.handleRadius * 2); // Adjust for handle radius
        _currentHandleX = _valueToX(widget.value); // Initialize/update handle position

        return GestureDetector(
          onHorizontalDragStart: _onHorizontalDragStart,
          onHorizontalDragUpdate: _onHorizontalDragUpdate,
          onHorizontalDragEnd: _onHorizontalDragEnd,
          child: Container(
            height: widget.height,
            width: constraints.maxWidth,
            alignment: Alignment.centerLeft, // Align content to the left
            child: CustomPaint(
              size: Size(constraints.maxWidth, widget.height),
              painter: _FluidSliderPainter(
                value: widget.value,
                handleX: _currentHandleX + widget.handleRadius, // Pass center of handle
                trackWidth: _trackWidth,
                height: widget.height,
                handleRadius: widget.handleRadius,
                gradientColors: widget.gradientColors,
                wobbleFactor: _wobbleAnimation.value, // Pass animation value
              ),
            ),
          ),
        );
      },
    );
  }
}

class _FluidSliderPainter extends CustomPainter {
  final double value;
  final double handleX; // Center X coordinate of the handle
  final double trackWidth;
  final double height;
  final double handleRadius;
  final List<Color> gradientColors;
  final double wobbleFactor; // 0.0 (no wobble) to 1.0 (full wobble)

  _FluidSliderPainter({
    required this.value,
    required this.handleX,
    required this.trackWidth,
    required this.height,
    required this.handleRadius,
    required this.gradientColors,
    required this.wobbleFactor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final trackHeight = height * 0.2; // Thin track
    final trackY = height / 2 - trackHeight / 2;

    // Paint for the background track
    final trackPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    // Draw the background track
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(handleRadius, trackY, trackWidth, trackHeight),
        const Radius.circular(10.0),
      ),
      trackPaint,
    );

    // Calculate the current fill width based on the slider value
    final fillWidth = (value - 0.0) / (1.0 - 0.0) * trackWidth;

    // Paint for the filled track with gradient
    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: gradientColors,
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(Rect.fromLTWH(handleRadius, trackY, trackWidth, trackHeight));

    // Draw the filled portion of the track
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(handleRadius, trackY, fillWidth, trackHeight),
        const Radius.circular(10.0),
      ),
      fillPaint,
    );

    // --- Draw the Fluid Handle ---
    final handleCenterY = height / 2;

    // Define control points for the Bezier curve to create a blob shape
    // The wobbleFactor influences how much the blob stretches horizontally
    final double stretch = wobbleFactor * handleRadius * 0.8; // Max stretch
    final double squash = wobbleFactor * handleRadius * 0.3; // Max squash vertically

    final Path handlePath = Path();

    // Start at the left-most point of the handle's circular part
    handlePath.moveTo(handleX - handleRadius, handleCenterY);

    // Left half of the circle
    handlePath.arcToPoint(
      Offset(handleX + handleRadius, handleCenterY),
      radius: Radius.circular(handleRadius),
      clockwise: false,
    );

    // Right side of the blob, stretching towards the right
    handlePath.quadraticBezierTo(
      handleX + handleRadius + stretch, // Control point X (stretches right)
      handleCenterY - squash, // Control point Y (squashes up)
      handleX + handleRadius, // End point X
      handleCenterY, // End point Y
    );

    // Right half of the circle (this part is actually the left half of the blob)
    handlePath.arcToPoint(
      Offset(handleX - handleRadius, handleCenterY),
      radius: Radius.circular(handleRadius),
      clockwise: false,
    );

    // Left side of the blob, stretching towards the left
    handlePath.quadraticBezierTo(
      handleX - handleRadius - stretch, // Control point X (stretches left)
      handleCenterY + squash, // Control point Y (squashes down)
      handleX - handleRadius, // End point X
      handleCenterY, // End point Y
    );

    handlePath.close(); // Close the path

    // Paint for the fluid handle with gradient
    final handlePaint = Paint()
      ..shader = LinearGradient(
        colors: gradientColors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(
        Rect.fromCircle(center: Offset(handleX, handleCenterY), radius: handleRadius * 1.5),
      )
      ..style = PaintingStyle.fill;

    // Draw the fluid handle
    canvas.drawPath(handlePath, handlePaint);

    // Optional: Draw a small circle in the center of the handle for visual anchor
    canvas.drawCircle(
      Offset(handleX, handleCenterY),
      handleRadius * 0.4,
      Paint()..color = Colors.white.withOpacity(0.8),
    );
  }

  @override
  bool shouldRepaint(covariant _FluidSliderPainter oldDelegate) {
    return oldDelegate.value != value ||
        oldDelegate.handleX != handleX ||
        oldDelegate.wobbleFactor != wobbleFactor;
  }
}
