import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';

class WaitingTimeAnimationScreen extends StatefulWidget {
  @override
  _WaitingTimeAnimationScreenState createState() => _WaitingTimeAnimationScreenState();
}

class _WaitingTimeAnimationScreenState extends State<WaitingTimeAnimationScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _particleController;
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _progressAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;
  
  double _progress = 0.0;
  int _timeRemaining = 0;
  bool _isUploading = false;
  bool _isCompleted = false;
  String _fileName = "Amazing_Design.zip";
  String _fileSize = "2.4 MB";
  List<Particle> particles = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _generateParticles();
  }

  void _initializeAnimations() {
    _mainController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _particleController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    )..repeat();
    
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);
    
    _rotationController = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    )..repeat();

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _mainController, curve: Curves.elasticOut),
    );
    
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mainController, curve: Curves.easeInOut),
    );
    
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mainController, curve: Curves.easeInOut),
    );
    
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    
    _rotationAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );

    _mainController.forward();
  }

  void _generateParticles() {
    particles = List.generate(15, (index) => Particle());
  }

  void _startUpload() {
    setState(() {
      _isUploading = true;
      _isCompleted = false;
      _progress = 0.0;
      _timeRemaining = 45; // 45 seconds estimated
    });

    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        _progress += 0.0025; // Smooth incremental progress
        if (_progress >= 1.0) {
          _progress = 1.0;
          _isCompleted = true;
          _isUploading = false;
          _timeRemaining = 0;
          timer.cancel();
        } else {
          _timeRemaining = ((1 - _progress) * 45).round();
        }
      });
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    if (minutes > 0) {
      return "${minutes}m ${remainingSeconds}s";
    }
    return "${remainingSeconds}s";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A0A0F),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.5,
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF0A0A0F),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Center(
                  child: AnimatedBuilder(
                    animation: _mainController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Opacity(
                          opacity: _opacityAnimation.value,
                          child: _buildMainCard(),
                        ),
                      );
                    },
                  ),
                ),
              ),
              _buildBottomControls(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(24),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.all(8),
            child: Icon(Icons.cloud_upload_rounded, color: Colors.white70),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'File Transfer',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'Secure Cloud Storage',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white60,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      padding: EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildFileInfo(),
          SizedBox(height: 40),
          _buildProgressSection(),
          SizedBox(height: 40),
          _buildStatusInfo(),
        ],
      ),
    );
  }

  Widget _buildFileInfo() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6C63FF), Color(0xFF3B82F6)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.folder_zip, color: Colors.white, size: 24),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _fileName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  _fileSize,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Particles
            AnimatedBuilder(
              animation: _particleController,
              builder: (context, child) {
                return CustomPaint(
                  size: Size(200, 200),
                  painter: ParticlePainter(particles, _particleController.value),
                );
              },
            ),
            // Main progress circle
            AnimatedBuilder(
              animation: _rotationController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _rotationAnimation.value,
                  child: Container(
                    width: 160,
                    height: 160,
                    child: CircularProgressIndicator(
                      value: _progress,
                      strokeWidth: 8,
                      backgroundColor: Colors.white.withOpacity(0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF6C63FF),
                      ),
                    ),
                  ),
                );
              },
            ),
            // Center content
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _isUploading ? _pulseAnimation.value : 1.0,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: _isCompleted
                                ? [Color(0xFF10B981), Color(0xFF059669)]
                                : [Color(0xFF6C63FF), Color(0xFF3B82F6)],
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: (_isCompleted ? Color(0xFF10B981) : Color(0xFF6C63FF))
                                  .withOpacity(0.4),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          _isCompleted
                              ? Icons.check_rounded
                              : _isUploading
                                  ? Icons.cloud_upload_rounded
                                  : Icons.upload_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 12),
                Text(
                  '${(_progress * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusInfo() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Status',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white60,
                ),
              ),
              Text(
                _isCompleted
                    ? 'Upload Complete!'
                    : _isUploading
                        ? 'Uploading...'
                        : 'Ready to Upload',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _isCompleted
                      ? Color(0xFF10B981)
                      : _isUploading
                          ? Color(0xFF6C63FF)
                          : Colors.white,
                ),
              ),
            ],
          ),
          if (_isUploading || _isCompleted)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Time Remaining',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white60,
                  ),
                ),
                Text(
                  _isCompleted ? 'Completed' : _formatTime(_timeRemaining),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    return Padding(
      padding: EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: _isUploading ? null : _startUpload,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                padding: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: _isUploading
                      ? LinearGradient(colors: [Colors.grey, Colors.grey])
                      : LinearGradient(
                          colors: [Color(0xFF6C63FF), Color(0xFF3B82F6)],
                        ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: _isUploading
                      ? []
                      : [
                          BoxShadow(
                            color: Color(0xFF6C63FF).withOpacity(0.4),
                            blurRadius: 20,
                            offset: Offset(0, 8),
                          ),
                        ],
                ),
                child: Center(
                  child: Text(
                    _isCompleted
                        ? 'Upload Another File'
                        : _isUploading
                            ? 'Uploading...'
                            : 'Start Upload',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (_isUploading) ...[
            SizedBox(width: 16),
            GestureDetector(
              onTap: () {
                _timer?.cancel();
                setState(() {
                  _isUploading = false;
                  _progress = 0.0;
                  _timeRemaining = 0;
                });
              },
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Icon(Icons.close, color: Colors.red),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mainController.dispose();
    _particleController.dispose();
    _pulseController.dispose();
    _rotationController.dispose();
    _timer?.cancel();
    super.dispose();
  }
}

class Particle {
  late double x, y;
  late double vx, vy;
  late double size;
  late Color color;
  late double life;

  Particle() {
    reset();
  }

  void reset() {
    final random = math.Random();
    x = random.nextDouble() * 200;
    y = random.nextDouble() * 200;
    vx = (random.nextDouble() - 0.5) * 2;
    vy = (random.nextDouble() - 0.5) * 2;
    size = random.nextDouble() * 3 + 1;
    life = random.nextDouble();
    
    final colors = [
      Color(0xFF6C63FF),
      Color(0xFF3B82F6),
      Color(0xFF10B981),
      Colors.white,
    ];
    color = colors[random.nextInt(colors.length)];
  }

  void update() {
    x += vx;
    y += vy;
    life -= 0.01;
    
    if (life <= 0 || x < 0 || x > 200 || y < 0 || y > 200) {
      reset();
    }
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;

  ParticlePainter(this.particles, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      particle.update();
      
      final paint = Paint()
        ..color = particle.color.withOpacity(particle.life * 0.6)
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(
        Offset(particle.x, particle.y),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}