import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import '../../widgets/engagement_animation_widget.dart';
import './widgets/vibrant_thread_card_widget.dart';

class CommunityFeed extends StatefulWidget {
  const CommunityFeed({super.key});

  @override
  State<CommunityFeed> createState() => _CommunityFeedState();
}

class _CommunityFeedState extends State<CommunityFeed>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final PageController _pageController = PageController(viewportFraction: 0.85);
  final bool _isSearchExpanded = false;
  bool _isLoading = false;
  bool _isRefreshing = false;
  String _selectedFilter = 'Recent';
  final List<String> _activeFilters = ['Recent'];
  bool _isFloatingMode = true;
  final int _currentPageIndex = 0;

  late AnimationController _floatingController;
  late AnimationController _pulseController;
  late AnimationController _filterTransitionController;
  late Animation<double> _floatingAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _filterTransitionAnimation;

  // Enhanced emotion categories with vibrant styling
  final List<Map<String, dynamic>> _emotionCategories = [
    {
      "emotion": "Anxious",
      "color": Color(0xFFED8936),
      "gradient": [Color(0xFFED8936), Color(0xFFFF6B35)],
      "icon": "psychology_outlined",
      "count": 24,
      "description": "Life-changing decisions",
    },
    {
      "emotion": "Hopeful",
      "color": Color(0xFF48BB78),
      "gradient": [Color(0xFF48BB78), Color(0xFF38A169)],
      "icon": "favorite_outline",
      "count": 18,
      "description": "Future possibilities",
    },
    {
      "emotion": "Curious",
      "color": Color(0xFF6B73FF),
      "gradient": [Color(0xFF6B73FF), Color(0xFF553C9A)],
      "icon": "lightbulb_outline",
      "count": 31,
      "description": "New experiences",
    },
    {
      "emotion": "Overwhelmed",
      "color": Color(0xFFE53E3E),
      "gradient": [Color(0xFFE53E3E), Color(0xFFC53030)],
      "icon": "cloud_off_outlined",
      "count": 12,
      "description": "Complex situations",
    },
    {
      "emotion": "Confident",
      "color": Color(0xFF9B59B6),
      "gradient": [Color(0xFF9B59B6), Color(0xFF8E44AD)],
      "icon": "star_outline",
      "count": 16,
      "description": "Bold moves",
    }
  ];

  // Enhanced featured decisions with vibrant data
  final List<Map<String, dynamic>> _featuredDecisions = [
    {
      "id": 1,
      "question": "Should I quit my job to travel the world?",
      "emotion": "Anxious",
      "emotionColor": Color(0xFFED8936),
      "gradient": [Color(0xFFED8936), Color(0xFFFF6B35)],
      "upvotes": 156,
      "comments": 42,
      "timeAgo": "2h ago",
      "preview":
          "I've been working the same job for 5 years and I feel stuck. The world is calling...",
      "author": "wanderer_soul",
      "clarityScore": 78,
      "isHot": true,
    },
    {
      "id": 2,
      "question": "What if I tell my crush how I feel?",
      "emotion": "Hopeful",
      "emotionColor": Color(0xFF48BB78),
      "gradient": [Color(0xFF48BB78), Color(0xFF38A169)],
      "upvotes": 89,
      "comments": 23,
      "timeAgo": "4h ago",
      "preview":
          "We've been friends for two years and I don't want to ruin it, but...",
      "author": "hopeful_heart",
      "clarityScore": 92,
      "isHot": false,
    },
    {
      "id": 3,
      "question": "Should I start my own tech company?",
      "emotion": "Curious",
      "emotionColor": Color(0xFF6B73FF),
      "gradient": [Color(0xFF6B73FF), Color(0xFF553C9A)],
      "upvotes": 203,
      "comments": 67,
      "timeAgo": "6h ago",
      "preview":
          "I have this amazing app idea and some savings, but the market is so competitive...",
      "author": "tech_dreamer",
      "clarityScore": 65,
      "isHot": true,
    },
    {
      "id": 4,
      "question": "Should I move back home to help my aging parents?",
      "emotion": "Overwhelmed",
      "emotionColor": Color(0xFFE53E3E),
      "gradient": [Color(0xFFE53E3E), Color(0xFFC53030)],
      "upvotes": 134,
      "comments": 56,
      "timeAgo": "8h ago",
      "preview":
          "My career is finally taking off, but my parents need me more than ever...",
      "author": "Anonymous",
      "clarityScore": 84,
      "isHot": false,
    },
    {
      "id": 5,
      "question": "Is it time to propose to my girlfriend?",
      "emotion": "Confident",
      "emotionColor": Color(0xFF9B59B6),
      "gradient": [Color(0xFF9B59B6), Color(0xFF8E44AD)],
      "upvotes": 198,
      "comments": 78,
      "timeAgo": "12h ago",
      "preview":
          "We've been together for 3 years and I know she's the one, but timing feels crucial...",
      "author": "ring_shopper",
      "clarityScore": 91,
      "isHot": true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Initialize enhanced animations
    _floatingController = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _filterTransitionController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _floatingAnimation = Tween<double>(
      begin: -8.0,
      end: 8.0,
    ).animate(CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _filterTransitionAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _filterTransitionController,
      curve: Curves.easeInOut,
    ));

    _filterTransitionController.forward();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _pageController.dispose();
    _floatingController.dispose();
    _pulseController.dispose();
    _filterTransitionController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreContent();
    }
  }

  Future<void> _refreshContent() async {
    setState(() {
      _isRefreshing = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isRefreshing = false;
    });
  }

  Future<void> _loadMoreContent() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });
  }

  void _toggleFloatingMode() {
    setState(() {
      _isFloatingMode = !_isFloatingMode;
    });
  }

  void _onCategoryTap(Map<String, dynamic> category) {
    setState(() {
      _selectedFilter = category['emotion'];
    });

    // Trigger filter transition animation
    _filterTransitionController.reset();
    _filterTransitionController.forward();
  }

  void _onDecisionTap(Map<String, dynamic> decision) {
    Navigator.pushNamed(context, '/thread-detail', arguments: decision);
  }

  Widget _buildUniqueHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(6.w, 4.h, 6.w, 2.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).scaffoldBackgroundColor,
            Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.8),
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Unique animated logo
                EngagementAnimationWidget(
                  enablePulse: true,
                  child: Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.secondary,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'C',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Clariti Community',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                      ),
                      Text(
                        'Where decisions find clarity',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                    ],
                  ),
                ),
                // Unique view toggle
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: EngagementAnimationWidget(
                    onTap: _toggleFloatingMode,
                    child: Container(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                        iconName:
                            _isFloatingMode ? 'view_list' : 'bubble_chart',
                        color: Theme.of(context).colorScheme.primary,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedEmotionCategories() {
    return AnimatedBuilder(
      animation: _filterTransitionAnimation,
      builder: (context, child) {
        return Container(
          height: 18.h,
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _emotionCategories.length,
            itemBuilder: (context, index) {
              final category = _emotionCategories[index];
              final isSelected = _selectedFilter == category['emotion'];

              return AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: isSelected ? _pulseAnimation.value : 1.0,
                    child: Transform.translate(
                      offset:
                          Offset(0, _filterTransitionAnimation.value * 10 - 10),
                      child: Opacity(
                        opacity: _filterTransitionAnimation.value,
                        child: EngagementAnimationWidget(
                          onTap: () => _onCategoryTap(category),
                          child: Container(
                            width: 35.w,
                            margin: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 1.h),
                            padding: EdgeInsets.all(4.w),
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? LinearGradient(colors: category['gradient'])
                                  : null,
                              color: isSelected
                                  ? null
                                  : Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(25),
                              border: isSelected
                                  ? null
                                  : Border.all(
                                      color: category['color']
                                          .withValues(alpha: 0.3),
                                      width: 2,
                                    ),
                              boxShadow: [
                                BoxShadow(
                                  color: isSelected
                                      ? category['color'].withValues(alpha: 0.4)
                                      : Colors.black.withValues(alpha: 0.05),
                                  blurRadius: isSelected ? 15 : 8,
                                  offset: Offset(0, isSelected ? 8 : 4),
                                  spreadRadius: isSelected ? 2 : 0,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(2.w),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.white.withValues(alpha: 0.2)
                                        : category['color']
                                            .withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: CustomIconWidget(
                                    iconName: category['icon'],
                                    color: isSelected
                                        ? Colors.white
                                        : category['color'],
                                    size: 28,
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  category['emotion'],
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        color: isSelected
                                            ? Colors.white
                                            : category['color'],
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                                Text(
                                  '${category['count']} active',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: isSelected
                                            ? Colors.white
                                                .withValues(alpha: 0.8)
                                            : Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filter decisions based on selected emotion
    final filteredDecisions = _selectedFilter == 'Recent'
        ? _featuredDecisions
        : _featuredDecisions
            .where((decision) => decision['emotion'] == _selectedFilter)
            .toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: RefreshIndicator(
        onRefresh: _refreshContent,
        color: Theme.of(context).colorScheme.primary,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  _buildUniqueHeader(),
                  _buildEnhancedEmotionCategories(),
                  SizedBox(height: 2.h),
                ],
              ),
            ),

            // Enhanced thread cards list
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index >= filteredDecisions.length) return null;

                  return VibrantThreadCardWidget(
                    thread: filteredDecisions[index],
                    onTap: () => _onDecisionTap(filteredDecisions[index]),
                    onUpvote: () {},
                    onDownvote: () {},
                    onSave: () {},
                    onShare: () {},
                  );
                },
                childCount: filteredDecisions.length,
              ),
            ),

            // Loading indicator
            if (_isLoading)
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: EngagementAnimationWidget(
              onTap: () => Navigator.pushNamed(context, '/create-decision'),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.4),
                      blurRadius: 25,
                      offset: Offset(0, 12),
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.psychology_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
