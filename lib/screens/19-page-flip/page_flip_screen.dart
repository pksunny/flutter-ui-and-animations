import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui';


// Story Data Model
class Story {
  final String title;
  final String author;
  final String coverImage;
  final List<String> pages;
  final Color primaryColor;
  final Color accentColor;

  Story({
    required this.title,
    required this.author,
    required this.coverImage,
    required this.pages,
    required this.primaryColor,
    required this.accentColor,
  });
}

// Dummy Story Data
final List<Story> dummyStories = [
  Story(
    title: "The Enchanted Forest",
    author: "Luna Moonwhisper",
    coverImage: "🌲",
    primaryColor: Color(0xFF2E7D32),
    accentColor: Color(0xFF81C784),
    pages: [
      "Once upon a time, in a forest where the trees whispered ancient secrets and the moonlight danced through emerald leaves, there lived a young girl named Aria who could speak to the woodland creatures.",
      "Every morning, Aria would venture deep into the forest, her bare feet silent on the moss-covered ground. The rabbits would hop alongside her, sharing tales of hidden treasures buried beneath the old oak tree.",
      "One magical evening, as the fireflies began their nightly dance, Aria discovered a glowing crystal that pulsed with the heartbeat of the forest itself. The crystal revealed visions of a world beyond imagination.",
      "With the crystal's power, Aria could see the true nature of the forest - how every leaf, every creature, every drop of morning dew was connected in an intricate web of life and magic.",
      "The wise old owl perched on her shoulder and whispered, 'Child of the forest, you have been chosen to be the guardian of this sacred place. Will you accept this responsibility?'",
      "Aria nodded solemnly, feeling the weight of destiny upon her young shoulders. From that day forward, she became the protector of the enchanted forest, ensuring its magic would endure for generations to come.",
    ],
  ),
  Story(
    title: "Ocean's Mystery",
    author: "Captain Waverly",
    coverImage: "🌊",
    primaryColor: Color(0xFF1565C0),
    accentColor: Color(0xFF42A5F5),
    pages: [
      "Deep beneath the crystalline waves of the Pacific Ocean, where sunlight fades into mysterious blue depths, lived Marina, a young marine biologist who could breathe underwater.",
      "Her underwater laboratory was a marvel of glass and coral, where she studied the ancient secrets of the deep sea creatures that glowed like living jewels in the darkness.",
      "One day, while exploring a newly discovered trench, Marina encountered a magnificent creature - a whale whose skin shimmered with bioluminescent patterns that told stories of the ocean's history.",
      "The whale sang to her in frequencies that resonated through her very soul, sharing tales of sunken civilizations and treasures lost to time in the deepest parts of the ocean floor.",
      "Together, they embarked on a journey to the Mariana Trench, where they discovered an underwater city populated by beings of pure light who had been waiting centuries for someone worthy to share their knowledge.",
      "Marina realized that the ocean was not just water and marine life, but a living entity with consciousness, memory, and wisdom that connected all life on Earth through its endless, flowing embrace.",
    ],
  ),
  Story(
    title: "Sky Castle Adventures",
    author: "Nimbus Cloudwalker",
    coverImage: "☁️",
    primaryColor: Color(0xFF7B1FA2),
    accentColor: Color(0xFFBA68C8),
    pages: [
      "High above the clouds, where the air is thin and the sky stretches endlessly in all directions, stood a magnificent castle made entirely of crystallized air and solidified starlight.",
      "Princess Celeste lived in this sky castle, able to walk on clouds as if they were solid ground. Her days were spent tending to her garden of floating flowers that bloomed only in the upper atmosphere.",
      "Each morning, she would ride her pegasus across the sky, visiting other floating islands and helping lost birds find their way through the maze of cloud formations that shifted with the wind.",
      "One stormy day, a young boy named Kai fell from an airplane and landed on her cloud garden. Celeste nursed him back to health with nectar from her celestial flowers and dewdrops collected from rainbow's edge.",
      "Together, they discovered that the storm clouds were actually trying to communicate - they were the guardians of weather, responsible for bringing rain to the earth below and maintaining the balance of the atmosphere.",
      "Kai learned to speak the language of the wind and weather, and with Celeste's help, he became the first human to serve as an ambassador between the sky realm and the earth below.",
    ],
  ),
];

// Main Stories Home Page
class PageFlipAnimationScreen extends StatefulWidget {
  @override
  _PageFlipAnimationScreenState createState() => _PageFlipAnimationScreenState();
}

class _PageFlipAnimationScreenState extends State<PageFlipAnimationScreen>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late AnimationController _cardController;
  late Animation<Color?> _backgroundAnimation;

  // Define _totalPages at the top of your State class, or wherever your page count is determined:
  late final int _totalPages;

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      duration: Duration(seconds: 8),
      vsync: this,
    )..repeat();

    _cardController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _backgroundAnimation = ColorTween(
      begin: Color(0xFF0D1B2A),
      end: Color(0xFF1B263B),
    ).animate(_backgroundController);

    _cardController.forward();

    // Set _totalPages to the length of your page/story list
    _totalPages = dummyStories.length; // Replace 'myPages' with your actual list variable
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topRight,
                radius: 1.5,
                colors: [
                  _backgroundAnimation.value!,
                  Color(0xFF0F172A),
                  Color(0xFF020617),
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: _buildStoryGrid(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Text(
            "Immersive tales with magical animations",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryGrid() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: dummyStories.length,
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: _cardController,
            builder: (context, child) {
              final animationValue = Curves.elasticOut.transform(
                (math.max(0.0, (_cardController.value - (index * 0.1))).clamp(0.0, 1.0) as double)
              );
              
              return Container(
                height: 220,
                margin: EdgeInsets.only(bottom: 24),
                child: Transform.scale(
                  scale: animationValue,
                  child: Transform.translate(
                    offset: Offset(0, 50 * (1 - animationValue)),
                    child: _buildStoryCard(dummyStories[index], index),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildStoryCard(Story story, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                StoryReaderPage(story: story),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOutCubic;

              var tween = Tween(begin: begin, end: end).chain(
                CurveTween(curve: curve),
              );

              return SlideTransition(
                position: animation.drive(tween),
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
            transitionDuration: Duration(milliseconds: 600),
          ),
        );
      },
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              story.primaryColor.withOpacity(0.3),
              story.accentColor.withOpacity(0.1),
            ],
          ),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: story.primaryColor.withOpacity(0.3),
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
              ),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          story.primaryColor.withOpacity(0.8),
                          story.accentColor.withOpacity(0.6),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        story.coverImage,
                        style: TextStyle(fontSize: 36),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          story.title,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8),
                        Text(
                          "by ${story.author}",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          "${story.pages.length} pages",
                          style: TextStyle(
                            fontSize: 14,
                            color: story.accentColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Story Reader Page with Page Flip Animation
class StoryReaderPage extends StatefulWidget {
  final Story story;

  const StoryReaderPage({Key? key, required this.story}) : super(key: key);

  @override
  _StoryReaderPageState createState() => _StoryReaderPageState();
}

class _StoryReaderPageState extends State<StoryReaderPage> with TickerProviderStateMixin {
  PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  bool _isFlipping = false;

  // Define _totalPages at the top of your State class, or wherever your page count is determined:
  late final int _totalPages;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOutCubic),
    );

    // Set _totalPages based on your actual story/pages list
    _totalPages = widget.story.pages.length; // or whatever your page list is called
  }

  @override
  void dispose() {
    _pageController.dispose();
    _flipController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < widget.story.pages.length - 1) {
      _animatePageFlip(() {
        _currentPage++;
        // Before calling animateToPage or any PageController method that requires attachment, check if the controller has clients:
        if (_pageController.hasClients) {
          final currentPage = _pageController.page?.round() ?? 0;
          final nextPage = currentPage + 1;
          if (nextPage < _totalPages) {
            // Only trigger the back flip animation here
            _triggerBackFlipAnimation(nextPage);
          }
        }
      });
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _animatePageFlip(() {
        _currentPage--;
        // Similarly, for any other PageController usage:
        if (_pageController.hasClients) {
          final currentPage = _pageController.page?.round() ?? 0;
          final prevPage = currentPage - 1;
          if (prevPage >= 0) {
            _pageController.animateToPage(
              prevPage,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            );
          }
        }
      });
    }
  }

  void _animatePageFlip(VoidCallback onMidPoint) {
    if (_isFlipping) return;
    
    setState(() {
      _isFlipping = true;
    });

    _flipController.forward().then((_) {
      onMidPoint();
      _flipController.reverse().then((_) {
        setState(() {
          _isFlipping = false;
        });
      });
    });
  }

  void _triggerBackFlipAnimation(int nextPage) {
    // Only animate the back flip, do not call front flip here
    _flipController.forward(from: 0).then((_) {
      // After the back flip animation completes, jump to the next page
      if (_pageController.hasClients) {
        _pageController.jumpToPage(nextPage);
      }
      // Do NOT trigger a front flip here
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
            colors: [
              widget.story.primaryColor.withOpacity(0.1),
              widget.story.accentColor.withOpacity(0.05),
              Color(0xFF0F172A),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: _buildPageViewer(),
              ),
              _buildBottomControls(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.2),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.story.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "by ${widget.story.author}",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          Text(
            "${_currentPage + 1}/${widget.story.pages.length}",
            style: TextStyle(
              fontSize: 16,
              color: widget.story.accentColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageViewer() {
    return GestureDetector(
      onTapUp: (details) {
        final screenWidth = MediaQuery.of(context).size.width;
        if (details.globalPosition.dx > screenWidth / 2) {
          _nextPage();
        } else {
          _previousPage();
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: AnimatedBuilder(
          animation: _flipAnimation,
          builder: (context, child) {
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(_flipAnimation.value * math.pi),
              child: _flipAnimation.value <= 0.5
                  ? _buildPage(_currentPage)
                  : Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..rotateY(math.pi),
                      child: _buildPage(_currentPage),
                    ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPage(int pageIndex) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.05),
          ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: widget.story.primaryColor.withOpacity(0.2),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (pageIndex == 0) ...[
                  Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            widget.story.primaryColor.withOpacity(0.8),
                            widget.story.accentColor.withOpacity(0.6),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          widget.story.coverImage,
                          style: TextStyle(fontSize: 48),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 32),
                ],
                Text(
                  widget.story.pages[pageIndex],
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    height: 1.8,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.3,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomControls() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: _currentPage > 0 ? _previousPage : null,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPage > 0
                    ? widget.story.primaryColor.withOpacity(0.3)
                    : Colors.grey.withOpacity(0.2),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
              child: Icon(
                Icons.chevron_left,
                color: _currentPage > 0 ? Colors.white : Colors.grey,
                size: 24,
              ),
            ),
          ),
          Container(
            height: 4,
            width: MediaQuery.of(context).size.width * 0.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: Colors.white.withOpacity(0.2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: (_currentPage + 1) / widget.story.pages.length,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  gradient: LinearGradient(
                    colors: [
                      widget.story.primaryColor,
                      widget.story.accentColor,
                    ],
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: _currentPage < widget.story.pages.length - 1 ? _nextPage : null,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPage < widget.story.pages.length - 1
                    ? widget.story.primaryColor.withOpacity(0.3)
                    : Colors.grey.withOpacity(0.2),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
              child: Icon(
                Icons.chevron_right,
                color: _currentPage < widget.story.pages.length - 1
                    ? Colors.white
                    : Colors.grey,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

