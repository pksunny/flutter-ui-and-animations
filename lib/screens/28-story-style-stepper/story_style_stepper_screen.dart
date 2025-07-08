import 'package:flutter/material.dart';


class StoryStyleStepperScreen extends StatefulWidget {
  @override
  _StoryStyleStepperScreenState createState() => _StoryStyleStepperScreenState();
}

class _StoryStyleStepperScreenState extends State<StoryStyleStepperScreen>
    with TickerProviderStateMixin {
  PageController _pageController = PageController();
  late AnimationController _progressController;
  late AnimationController _slideController;
  late Animation<double> _slideAnimation;
  
  int currentStep = 0;
  final int totalSteps = 5;
  
  // Form data
  Map<String, dynamic> formData = {
    'name': '',
    'email': '',
    'phone': '',
    'interest': '',
    'message': '',
  };

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    
    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOutCubic,
    ));
    
    _slideController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    _slideController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (currentStep < totalSteps - 1) {
      setState(() {
        currentStep++;
      });
      _pageController.nextPage(
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
      _animateProgress();
    }
  }

  void _previousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
      _pageController.previousPage(
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
      _animateProgress();
    }
  }

  void _animateProgress() {
    _progressController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _slideAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, 50 * (1 - _slideAnimation.value)),
              child: Opacity(
                opacity: _slideAnimation.value,
                child: Column(
                  children: [
                    _buildProgressBar(),
                    Expanded(
                      child: PageView(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            currentStep = index;
                          });
                          _animateProgress();
                        },
                        children: [
                          _buildStoryCard(
                            title: "What's your name?",
                            subtitle: "Let's get to know you better",
                            icon: Icons.person_outline,
                            color: Colors.purple,
                            child: _buildNameInput(),
                          ),
                          _buildStoryCard(
                            title: "Your email address?",
                            subtitle: "We'll keep it safe and secure",
                            icon: Icons.email_outlined,
                            color: Colors.blue,
                            child: _buildEmailInput(),
                          ),
                          _buildStoryCard(
                            title: "Phone number?",
                            subtitle: "For important updates only",
                            icon: Icons.phone_outlined,
                            color: Colors.green,
                            child: _buildPhoneInput(),
                          ),
                          _buildStoryCard(
                            title: "What interests you?",
                            subtitle: "Pick what excites you most",
                            icon: Icons.interests_outlined,
                            color: Colors.orange,
                            child: _buildInterestSelection(),
                          ),
                          _buildStoryCard(
                            title: "Any final thoughts?",
                            subtitle: "Share anything else with us",
                            icon: Icons.message_outlined,
                            color: Colors.pink,
                            child: _buildMessageInput(),
                          ),
                        ],
                      ),
                    ),
                    _buildNavigationButtons(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: List.generate(totalSteps, (index) {
          return Expanded(
            child: Container(
              height: 4,
              margin: EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: Colors.grey[800],
              ),
              child: AnimatedBuilder(
                animation: _progressController,
                builder: (context, child) {
                  double progress = 0.0;
                  if (index < currentStep) {
                    progress = 1.0;
                  } else if (index == currentStep) {
                    progress = _progressController.value;
                  }
                  
                  return LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getStepColor(index),
                    ),
                    minHeight: 4,
                  );
                },
              ),
            ),
          );
        }),
      ),
    );
  }

  Color _getStepColor(int index) {
    switch (index) {
      case 0: return Colors.purple;
      case 1: return Colors.blue;
      case 2: return Colors.green;
      case 3: return Colors.orange;
      case 4: return Colors.pink;
      default: return Colors.purple;
    }
  }

  Widget _buildStoryCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Widget child,
  }) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: color,
              size: 32,
            ),
          ),
          SizedBox(height: 24),
          Text(
            title,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[400],
            ),
          ),
          SizedBox(height: 32),
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildNameInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          style: TextStyle(color: Colors.white, fontSize: 18),
          decoration: InputDecoration(
            hintText: "Enter your full name",
            hintStyle: TextStyle(color: Colors.grey[500]),
            filled: true,
            fillColor: Colors.grey[900],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.all(20),
          ),
          onChanged: (value) {
            formData['name'] = value;
          },
        ),
        SizedBox(height: 16),
        _buildInputTip("This helps us personalize your experience"),
      ],
    );
  }

  Widget _buildEmailInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          style: TextStyle(color: Colors.white, fontSize: 18),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: "your.email@example.com",
            hintStyle: TextStyle(color: Colors.grey[500]),
            filled: true,
            fillColor: Colors.grey[900],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.all(20),
          ),
          onChanged: (value) {
            formData['email'] = value;
          },
        ),
        SizedBox(height: 16),
        _buildInputTip("We'll send you updates and important notifications"),
      ],
    );
  }

  Widget _buildPhoneInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          style: TextStyle(color: Colors.white, fontSize: 18),
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: "+1 (555) 123-4567",
            hintStyle: TextStyle(color: Colors.grey[500]),
            filled: true,
            fillColor: Colors.grey[900],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.all(20),
          ),
          onChanged: (value) {
            formData['phone'] = value;
          },
        ),
        SizedBox(height: 16),
        _buildInputTip("Optional - for urgent notifications only"),
      ],
    );
  }

  Widget _buildInterestSelection() {
    List<String> interests = [
      "Technology", "Design", "Business", "Marketing", 
      "Sports", "Travel", "Food", "Music"
    ];
    
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: interests.map((interest) {
        bool isSelected = formData['interest'] == interest;
        return GestureDetector(
          onTap: () {
            setState(() {
              formData['interest'] = interest;
            });
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? Colors.orange : Colors.grey[900],
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: isSelected ? Colors.orange : Colors.grey[700]!,
                width: 2,
              ),
            ),
            child: Text(
              interest,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMessageInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          style: TextStyle(color: Colors.white, fontSize: 18),
          maxLines: 4,
          decoration: InputDecoration(
            hintText: "Tell us what you're looking for...",
            hintStyle: TextStyle(color: Colors.grey[500]),
            filled: true,
            fillColor: Colors.grey[900],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.all(20),
          ),
          onChanged: (value) {
            formData['message'] = value;
          },
        ),
        SizedBox(height: 16),
        _buildInputTip("Optional - helps us serve you better"),
      ],
    );
  }

  Widget _buildInputTip(String tip) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[800]?.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.lightbulb_outline, color: Colors.amber, size: 16),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              tip,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          if (currentStep > 0)
            Expanded(
              child: ElevatedButton(
                onPressed: _previousStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[800],
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_back),
                    SizedBox(width: 8),
                    Text("Previous", style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
          if (currentStep > 0) SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: currentStep < totalSteps - 1 ? _nextStep : () {
                // Handle form submission
                _showCompletionDialog();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _getStepColor(currentStep),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    currentStep < totalSteps - 1 ? "Continue" : "Complete",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 8),
                  Icon(currentStep < totalSteps - 1 ? Icons.arrow_forward : Icons.check),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text("🎉 Awesome!", style: TextStyle(color: Colors.white)),
        content: Text(
          "Your story is complete! We've got all the information we need.",
          style: TextStyle(color: Colors.grey[300]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Great!", style: TextStyle(color: Colors.pink)),
          ),
        ],
      ),
    );
  }
}