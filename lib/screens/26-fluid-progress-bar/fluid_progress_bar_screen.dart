import 'package:flutter/material.dart';

class FluidProgressBarScreen extends StatefulWidget {
  @override
  _FluidProgressBarScreenState createState() => _FluidProgressBarScreenState();
}

class _FluidProgressBarScreenState extends State<FluidProgressBarScreen>
    with TickerProviderStateMixin {
  PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 4;
  
  late AnimationController _progressController;
  late AnimationController _bubbleController;
  late Animation<double> _progressAnimation;
  late Animation<double> _bubbleAnimation;
  
  // Form data
  final _formData = {
    'name': '',
    'email': '',
    'phone': '',
    'company': '',
    'position': '',
    'experience': '',
    'skills': <String>[],
    'availability': '',
  };

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    _bubbleController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOutCubic,
    ));
    
    _bubbleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _bubbleController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _progressController.dispose();
    _bubbleController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });
      _progressController.forward();
      _bubbleController.forward();
      _pageController.nextPage(
        duration: Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _progressController.reverse();
      _pageController.previousPage(
        duration: Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A0E27),
      body: SafeArea(
        child: Column(
          children: [
            // Header with fluid progress bar
            Container(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  // Title
                  Text(
                    'Create Your Profile',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Step ${_currentStep + 1} of $_totalSteps',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  SizedBox(height: 32),
                  // Fluid Progress Bar
                  FluidProgressBar(
                    currentStep: _currentStep,
                    totalSteps: _totalSteps,
                    progressAnimation: _progressAnimation,
                    bubbleAnimation: _bubbleAnimation,
                  ),
                ],
              ),
            ),
            // Form content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  _buildPersonalInfoStep(),
                  _buildContactInfoStep(),
                  _buildProfessionalInfoStep(),
                  _buildCompletionStep(),
                ],
              ),
            ),
            // Navigation buttons
            Container(
              padding: EdgeInsets.all(24),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: _buildButton(
                        'Previous',
                        Icons.arrow_back,
                        Colors.white.withOpacity(0.1),
                        Colors.white.withOpacity(0.7),
                        _previousStep,
                      ),
                    ),
                  if (_currentStep > 0) SizedBox(width: 16),
                  Expanded(
                    child: _buildButton(
                      _currentStep == _totalSteps - 1 ? 'Complete' : 'Next',
                      _currentStep == _totalSteps - 1 ? Icons.check : Icons.arrow_forward,
                      Color(0xFF6C5CE7),
                      Colors.white,
                      _nextStep,
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

  Widget _buildButton(String text, IconData icon, Color bgColor, Color textColor, VoidCallback onPressed) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (text == 'Previous') ...[
              Icon(icon, size: 20),
              SizedBox(width: 8),
            ],
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (text != 'Previous') ...[
              SizedBox(width: 8),
              Icon(icon, size: 20),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfoStep() {
    return _buildStepContainer(
      'Personal Information',
      'Tell us about yourself',
      [
        _buildTextField('Full Name', Icons.person, (value) => _formData['name'] = value),
        _buildTextField('Email Address', Icons.email, (value) => _formData['email'] = value),
      ],
    );
  }

  Widget _buildContactInfoStep() {
    return _buildStepContainer(
      'Contact Details',
      'How can we reach you?',
      [
        _buildTextField('Phone Number', Icons.phone, (value) => _formData['phone'] = value),
        _buildTextField('Company', Icons.business, (value) => _formData['company'] = value),
      ],
    );
  }

  Widget _buildProfessionalInfoStep() {
    return _buildStepContainer(
      'Professional Info',
      'Share your experience',
      [
        _buildTextField('Position', Icons.work, (value) => _formData['position'] = value),
        _buildDropdown('Experience Level', ['Entry', 'Mid', 'Senior', 'Lead'], (value) => _formData['experience'] = value ?? ''),
      ],
    );
  }

  Widget _buildCompletionStep() {
    return _buildStepContainer(
      'All Set!',
      'Your profile is ready',
      [
        Container(
          padding: EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Color(0xFF6C5CE7).withOpacity(0.1),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Color(0xFF6C5CE7).withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Icon(
                Icons.check_circle,
                size: 64,
                color: Color(0xFF6C5CE7),
              ),
              SizedBox(height: 16),
              Text(
                'Profile Created Successfully!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'Welcome to our platform. Your journey starts now!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepContainer(String title, String subtitle, List<Widget> children) {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          SizedBox(height: 32),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, Function(String) onChanged) {
    return Container(
      margin: EdgeInsets.only(bottom: 24),
      child: TextField(
        onChanged: onChanged,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
          prefixIcon: Icon(icon, color: Color(0xFF6C5CE7)),
          filled: true,
          fillColor: Colors.white.withOpacity(0.05),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Color(0xFF6C5CE7), width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> options, Function(String?) onChanged) {
    return Container(
      margin: EdgeInsets.only(bottom: 24),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
          prefixIcon: Icon(Icons.arrow_drop_down, color: Color(0xFF6C5CE7)),
          filled: true,
          fillColor: Colors.white.withOpacity(0.05),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Color(0xFF6C5CE7), width: 2),
          ),
        ),
        dropdownColor: Color(0xFF1A1F3A),
        style: TextStyle(color: Colors.white),
        items: options.map((option) => DropdownMenuItem(
          value: option,
          child: Text(option),
        )).toList(),
        onChanged: onChanged,
      ),
    );
  }
}

class FluidProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final Animation<double> progressAnimation;
  final Animation<double> bubbleAnimation;

  const FluidProgressBar({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
    required this.progressAnimation,
    required this.bubbleAnimation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([progressAnimation, bubbleAnimation]),
      builder: (context, child) {
        return Container(
          height: 28, // Increased height for the progress bar
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(14), // Adjusted for larger bar
          ),
          child: Stack(
            children: [
              // Background track
              Container(
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              // Animated progress fill
              AnimatedContainer(
                duration: Duration(milliseconds: 800),
                curve: Curves.easeInOutCubic,
                height: 28,
                width: (MediaQuery.of(context).size.width - 48) * 
                       (currentStep / (totalSteps - 1)),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF6C5CE7),
                      Color(0xFF74B9FF),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              // Step indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(totalSteps, (index) {
                  final isActive = index <= currentStep;
                  final isCompleted = index < currentStep;
                  
                  return Transform.translate(
                    // Move indicators down so numbers/icons are fully visible in taller bar
                    offset: Offset(0, 2), // Changed from -12 to 2
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: isActive ? Color(0xFF6C5CE7) : Colors.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isActive ? Color(0xFF6C5CE7) : Colors.white.withOpacity(0.5),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: isCompleted
                            ? Icon(
                                Icons.check,
                                size: 14,
                                color: Colors.white,
                              )
                            : Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: isActive ? Colors.white : Colors.white.withOpacity(0.7),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}