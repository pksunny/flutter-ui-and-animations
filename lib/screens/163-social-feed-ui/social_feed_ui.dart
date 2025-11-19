import 'package:flutter/material.dart';
import 'dart:math' as math;

// ============================================================================
// MAIN SCREEN - Social Feed with Floating Reactions
// ============================================================================

class SocialFeedScreen extends StatefulWidget {
  const SocialFeedScreen({Key? key}) : super(key: key);

  @override
  State<SocialFeedScreen> createState() => _SocialFeedScreenState();
}

class _SocialFeedScreenState extends State<SocialFeedScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<PostModel> _posts = PostModel.generateSamplePosts();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Custom App Bar with Gradient
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF667EEA),
                      Color(0xFF764BA2),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          'Social Feed',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${_posts.length} amazing posts',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Post List
          SliverPadding(
            padding: const EdgeInsets.only(top: 16, bottom: 24),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return AnimatedPostCard(
                    key: ValueKey(_posts[index].id),
                    post: _posts[index],
                    index: index,
                  );
                },
                childCount: _posts.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// POST CARD WIDGET - Main post component with animations
// ============================================================================

class AnimatedPostCard extends StatefulWidget {
  final PostModel post;
  final int index;

  const AnimatedPostCard({
    Key? key,
    required this.post,
    required this.index,
  }) : super(key: key);

  @override
  State<AnimatedPostCard> createState() => _AnimatedPostCardState();
}

class _AnimatedPostCardState extends State<AnimatedPostCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  bool _isVisible = false;
  bool _isLiked = false;
  int _likeCount = 0;

  @override
  void initState() {
    super.initState();
    _likeCount = widget.post.likes;

    // Fade and Slide animation controller
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutCubic,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutCubic,
    ));

    // Staggered animation based on index
    Future.delayed(Duration(milliseconds: 100 * widget.index), () {
      if (mounted) {
        setState(() => _isVisible = true);
        _fadeController.forward();
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _handleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _likeCount += _isLiked ? 1 : -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Post Header
              _buildPostHeader(),

              // Post Image with Hero Animation
              _buildPostImage(),

              // Post Actions (Like, Comment, Share)
              _buildPostActions(),

              // Post Content
              _buildPostContent(),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Avatar with gradient border
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              ),
            ),
            padding: const EdgeInsets.all(2.5),
            child: CircleAvatar(
              radius: 22,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 20,
                backgroundColor: widget.post.avatarColor,
                child: Text(
                  widget.post.username[0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.post.username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.post.timeAgo,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          // More button
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.more_horiz, size: 20),
              onPressed: () {},
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostImage() {
    return Hero(
      tag: 'post_${widget.post.id}',
      child: Container(
        height: 280,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: widget.post.imageGradient,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Gradient overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.1),
                      ],
                    ),
                  ),
                ),
              ),
              // Post category tag
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    widget.post.category,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Like Button with Floating Reactions
          FloatingReactionButton(
            isLiked: _isLiked,
            onTap: _handleLike,
            reactionEmojis: const ['❤️', '😍', '🔥', '👏', '🎉'],
          ),
          const SizedBox(width: 8),
          Text(
            _likeCount.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(width: 24),

          // Comment Button
          _buildActionButton(
            icon: Icons.chat_bubble_outline_rounded,
            count: widget.post.comments,
            color: const Color(0xFF667EEA),
          ),
          const SizedBox(width: 24),

          // Share Button
          _buildActionButton(
            icon: Icons.share_outlined,
            count: widget.post.shares,
            color: const Color(0xFF764BA2),
          ),

          const Spacer(),

          // Bookmark Button
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: _isLiked ? 1 : 0),
            duration: const Duration(milliseconds: 300),
            builder: (context, value, child) {
              return Transform.scale(
                scale: 1 + (value * 0.2),
                child: IconButton(
                  icon: Icon(
                    Icons.bookmark_outline_rounded,
                    color: Colors.grey[600],
                  ),
                  onPressed: () {},
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required int count,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: color),
        ),
        const SizedBox(width: 6),
        Text(
          count.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Color(0xFF1A1A1A),
          ),
        ),
      ],
    );
  }

  Widget _buildPostContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.post.content,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
              color: Color(0xFF2A2A2A),
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          if (widget.post.hashtags.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: widget.post.hashtags.map((tag) {
                return Text(
                  '#$tag',
                  style: const TextStyle(
                    color: Color(0xFF667EEA),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}

// ============================================================================
// FLOATING REACTION BUTTON - Main attraction with emoji animations
// ============================================================================

class FloatingReactionButton extends StatefulWidget {
  final bool isLiked;
  final VoidCallback onTap;
  final List<String> reactionEmojis;

  const FloatingReactionButton({
    Key? key,
    required this.isLiked,
    required this.onTap,
    required this.reactionEmojis,
  }) : super(key: key);

  @override
  State<FloatingReactionButton> createState() => _FloatingReactionButtonState();
}

class _FloatingReactionButtonState extends State<FloatingReactionButton>
    with TickerProviderStateMixin {
  final List<FloatingEmoji> _floatingEmojis = [];
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _handleTap() {
    widget.onTap();

    if (widget.isLiked) {
      // Trigger pulse animation
      _pulseController.forward().then((_) => _pulseController.reverse());

      // Create multiple floating emojis
      for (int i = 0; i < 3; i++) {
        Future.delayed(Duration(milliseconds: i * 100), () {
          if (mounted) {
            _createFloatingEmoji();
          }
        });
      }
    }
  }

  void _createFloatingEmoji() {
    final random = math.Random();
    final emoji = widget.reactionEmojis[
        random.nextInt(widget.reactionEmojis.length)];

    final floatingEmoji = FloatingEmoji(
      emoji: emoji,
      onComplete: () {
        if (mounted) {
          setState(() {
            _floatingEmojis.removeWhere((e) => e.emoji == emoji);
          });
        }
      },
    );

    setState(() {
      _floatingEmojis.add(floatingEmoji);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Floating Emojis
        ..._floatingEmojis.map((floatingEmoji) {
          return Positioned(
            left: 0,
            bottom: 0,
            child: floatingEmoji,
          );
        }),

        // Like Button
        ScaleTransition(
          scale: Tween<double>(begin: 1, end: 1.2).animate(
            CurvedAnimation(
              parent: _pulseController,
              curve: Curves.easeInOut,
            ),
          ),
          child: GestureDetector(
            onTap: _handleTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: widget.isLiked
                    ? const Color(0xFFFF6B9D)
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
                boxShadow: widget.isLiked
                    ? [
                        BoxShadow(
                          color: const Color(0xFFFF6B9D).withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Icon(
                widget.isLiked ? Icons.favorite : Icons.favorite_border,
                size: 20,
                color: widget.isLiked ? Colors.white : Colors.grey[600],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// FLOATING EMOJI - Individual floating emoji animation
// ============================================================================

class FloatingEmoji extends StatefulWidget {
  final String emoji;
  final VoidCallback onComplete;

  const FloatingEmoji({
    Key? key,
    required this.emoji,
    required this.onComplete,
  }) : super(key: key);

  @override
  State<FloatingEmoji> createState() => _FloatingEmojiState();
}

class _FloatingEmojiState extends State<FloatingEmoji>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late double _horizontalOffset;

  @override
  void initState() {
    super.initState();

    // Random horizontal offset for variety
    final random = math.Random();
    _horizontalOffset = random.nextDouble() * 60 - 30;

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _floatAnimation = Tween<double>(
      begin: 0,
      end: -150,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
    ));

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.2),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.2, end: 1.0),
        weight: 80,
      ),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward().then((_) => widget.onComplete());
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
        return Transform.translate(
          offset: Offset(
            _horizontalOffset * _controller.value,
            _floatAnimation.value,
          ),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Text(
                widget.emoji,
                style: const TextStyle(fontSize: 28),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ============================================================================
// DATA MODELS
// ============================================================================

class PostModel {
  final String id;
  final String username;
  final String timeAgo;
  final String content;
  final int likes;
  final int comments;
  final int shares;
  final Color avatarColor;
  final LinearGradient imageGradient;
  final String category;
  final List<String> hashtags;

  PostModel({
    required this.id,
    required this.username,
    required this.timeAgo,
    required this.content,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.avatarColor,
    required this.imageGradient,
    required this.category,
    required this.hashtags,
  });

  static List<PostModel> generateSamplePosts() {
    final gradients = [
      const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFF6B9D), Color(0xFFFFA06B)],
      ),
      const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
      ),
      const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF43E97B), Color(0xFF38F9D7)],
      ),
      const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFA709A), Color(0xFFFEE140)],
      ),
      const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF30CFD0), Color(0xFF330867)],
      ),
    ];

    final avatarColors = [
      const Color(0xFFFF6B9D),
      const Color(0xFF667EEA),
      const Color(0xFF43E97B),
      const Color(0xFFFA709A),
      const Color(0xFF30CFD0),
    ];

    final categories = ['Travel', 'Food', 'Tech', 'Art', 'Lifestyle'];

    return List.generate(
      5,
      (index) => PostModel(
        id: 'post_$index',
        username: [
          'Alex Johnson',
          'Emma Wilson',
          'Michael Chen',
          'Sarah Davis',
          'James Miller'
        ][index],
        timeAgo: ['2m ago', '15m ago', '1h ago', '3h ago', '5h ago'][index],
        content: [
          'Just discovered this amazing place! The views are absolutely breathtaking and worth every step of the journey. 🌄',
          'Tried this new recipe today and it turned out better than expected! Sometimes the simplest ingredients create magic. ✨',
          'Working on an exciting new project that combines AI and design. The future of creativity is here! 🚀',
          'Art has the power to transform spaces and minds. This piece speaks volumes without saying a word. 🎨',
          'Living life one adventure at a time. Every moment is a new opportunity to create memories. 💫'
        ][index],
        likes: [234, 567, 892, 445, 723][index],
        comments: [45, 89, 123, 67, 91][index],
        shares: [12, 34, 56, 23, 45][index],
        avatarColor: avatarColors[index],
        imageGradient: gradients[index],
        category: categories[index],
        hashtags: [
          ['travel', 'nature', 'adventure'],
          ['food', 'cooking', 'recipe'],
          ['tech', 'ai', 'innovation'],
          ['art', 'creative', 'design'],
          ['lifestyle', 'motivation', 'inspiration']
        ][index],
      ),
    );
  }
}