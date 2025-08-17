import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;

class AnimatedUploadingButtonScreen extends StatefulWidget {
  @override
  _AnimatedUploadingButtonScreenState createState() => _AnimatedUploadingButtonScreenState();
}

class _AnimatedUploadingButtonScreenState extends State<AnimatedUploadingButtonScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _progressController;
  late AnimationController _successController;
  late AnimationController _glowController;
  late AnimationController _particleController;
  
  late Animation<double> _pulseAnimation;
  late Animation<double> _progressAnimation;
  late Animation<double> _successAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _particleAnimation;
  
  UploadState _uploadState = UploadState.idle;
  String _fileName = '';
  Timer? _uploadTimer;
  int _progress = 0;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controllers
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _progressController = AnimationController(
      duration: Duration(milliseconds: 3000),
      vsync: this,
    );
    
    _successController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _glowController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _particleController = AnimationController(
      duration: Duration(milliseconds: 2500),
      vsync: this,
    );
    
    // Initialize animations
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );
    
    _successAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _successController, curve: Curves.elasticOut),
    );
    
    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
    
    _particleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _particleController, curve: Curves.easeOut),
    );
    
    // Start continuous glow animation
    _glowController.repeat(reverse: true);
    
    // Listen to progress animation
    _progressController.addListener(() {
      setState(() {
        _progress = (_progressAnimation.value * 100).round();
      });
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _progressController.dispose();
    _successController.dispose();
    _glowController.dispose();
    _particleController.dispose();
    _uploadTimer?.cancel();
    super.dispose();
  }

  void _selectFile() async {
    // Simulate file selection
    setState(() {
      _fileName = 'amazing_document.pdf';
      _uploadState = UploadState.selected;
    });
    
    _pulseController.repeat(reverse: true);
  }

  void _startUpload() async {
    setState(() {
      _uploadState = UploadState.uploading;
      _progress = 0;
    });
    
    _pulseController.stop();
    _pulseController.reset();
    _progressController.forward();
    
    // Simulate upload progress
    _uploadTimer = Timer.periodic(Duration(milliseconds: 30), (timer) {
      if (_progress >= 100) {
        timer.cancel();
        _completeUpload();
      }
    });
  }

  void _completeUpload() {
    setState(() {
      _uploadState = UploadState.success;
    });
    
    _successController.forward();
    _particleController.forward();
    
    // Reset after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      _resetButton();
    });
  }

  void _resetButton() {
    setState(() {
      _uploadState = UploadState.idle;
      _fileName = '';
      _progress = 0;
    });
    
    _progressController.reset();
    _successController.reset();
    _particleController.reset();
    _pulseController.stop();
    _pulseController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.0,
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF0A0A0A),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Amazing File Upload',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(height: 60),
              
              // Main Upload Button
              AnimatedBuilder(
                animation: Listenable.merge([
                  _pulseAnimation,
                  _progressAnimation,
                  _successAnimation,
                  _glowAnimation,
                  _particleAnimation,
                ]),
                builder: (context, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      // Particle effects for success
                      if (_uploadState == UploadState.success)
                        ...List.generate(12, (index) {
                          return ParticleWidget(
                            animation: _particleAnimation,
                            index: index,
                          );
                        }),
                      
                      // Glow effect
                      Container(
                        width: 220 * (_uploadState == UploadState.success ? 1.2 : 1.0),
                        height: 220 * (_uploadState == UploadState.success ? 1.2 : 1.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: _getGlowColor().withOpacity(0.3 * _glowAnimation.value),
                              blurRadius: 40,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                      ),
                      
                      // Main button container
                      Transform.scale(
                        scale: _uploadState == UploadState.selected ? _pulseAnimation.value : 1.0,
                        child: GestureDetector(
                          onTap: _getButtonAction(),
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: _getGradientColors(),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: _getGlowColor().withOpacity(0.4),
                                  blurRadius: 20,
                                  offset: Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Progress ring
                                if (_uploadState == UploadState.uploading)
                                  CustomPaint(
                                    size: Size(180, 180),
                                    painter: ProgressRingPainter(_progressAnimation.value),
                                  ),
                                
                                // Button content
                                _buildButtonContent(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              
              SizedBox(height: 40),
              
              // File info and progress
              if (_fileName.isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.insert_drive_file,
                        color: Colors.white70,
                        size: 20,
                      ),
                      SizedBox(width: 10),
                      Text(
                        _fileName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              
              if (_uploadState == UploadState.uploading)
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    '$_progress%',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButtonContent() {
    switch (_uploadState) {
      case UploadState.idle:
        return Icon(
          Icons.cloud_upload_outlined,
          size: 60,
          color: Colors.white,
        );
      
      case UploadState.selected:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.play_arrow,
              size: 50,
              color: Colors.white,
            ),
            SizedBox(height: 8),
            Text(
              'UPLOAD',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ],
        );
      
      case UploadState.uploading:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 3,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'UPLOADING',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ],
        );
      
      case UploadState.success:
        return Transform.scale(
          scale: _successAnimation.value,
          child: Icon(
            Icons.check,
            size: 80,
            color: Colors.white,
          ),
        );
    }
  }

  List<Color> _getGradientColors() {
    switch (_uploadState) {
      case UploadState.idle:
        return [Color(0xFF6366F1), Color(0xFF8B5CF6)];
      case UploadState.selected:
        return [Color(0xFF3B82F6), Color(0xFF1D4ED8)];
      case UploadState.uploading:
        return [Color(0xFFF59E0B), Color(0xFFEF4444)];
      case UploadState.success:
        return [Color(0xFF10B981), Color(0xFF059669)];
    }
  }

  Color _getGlowColor() {
    switch (_uploadState) {
      case UploadState.idle:
        return Color(0xFF8B5CF6);
      case UploadState.selected:
        return Color(0xFF3B82F6);
      case UploadState.uploading:
        return Color(0xFFF59E0B);
      case UploadState.success:
        return Color(0xFF10B981);
    }
  }

  VoidCallback? _getButtonAction() {
    switch (_uploadState) {
      case UploadState.idle:
        return _selectFile;
      case UploadState.selected:
        return _startUpload;
      case UploadState.uploading:
      case UploadState.success:
        return null;
    }
  }
}

class ProgressRingPainter extends CustomPainter {
  final double progress;

  ProgressRingPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // Background ring
    final backgroundPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress ring
    final progressPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ParticleWidget extends StatelessWidget {
  final Animation<double> animation;
  final int index;

  const ParticleWidget({
    Key? key,
    required this.animation,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final angle = (2 * math.pi * index) / 12;
    final distance = 100 * animation.value;
    final opacity = 1.0 - animation.value;

    return Transform.translate(
      offset: Offset(
        math.cos(angle) * distance,
        math.sin(angle) * distance,
      ),
      child: Opacity(
        opacity: opacity,
        child: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0xFF10B981).withOpacity(0.6),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum UploadState {
  idle,
  selected,
  uploading,
  success,
}