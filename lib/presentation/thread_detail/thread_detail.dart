import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/comment_input_widget.dart';
import './widgets/outcome_card_widget.dart';
import './widgets/vibrant_comment_item_widget.dart';
import './widgets/vote_section_widget.dart';

class ThreadDetail extends StatefulWidget {
  const ThreadDetail({super.key});

  @override
  State<ThreadDetail> createState() => _ThreadDetailState();
}

class _ThreadDetailState extends State<ThreadDetail>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  int _currentCardIndex = 0;
  bool _isCommentExpanded = false;
  bool _isSubmittingComment = false;
  bool _isRefreshing = false;
  int _userVoteState = 0; // -1: downvote, 0: none, 1: upvote

  // Enhanced mock thread data
  final Map<String, dynamic> _threadData = {
    "id": "thread_001",
    "question":
        "Should I quit my stable corporate job to start my own creative agency?",
    "emotion": "Anxious",
    "emotionIcon": "😰",
    "author": "Anonymous",
    "timestamp": DateTime.now().subtract(const Duration(hours: 6)),
    "upvotes": 127,
    "downvotes": 23,
    "commentCount": 45,
    "outcomes": [
      {
        "type": "Best Case",
        "title": "Creative Freedom & Success",
        "description":
            "Your agency thrives, you work with dream clients, achieve work-life balance, and build a sustainable business that reflects your values and creativity.",
        "color": 0xFF48BB78,
        "icon": "trending_up"
      },
      {
        "type": "Worst Case",
        "title": "Financial Instability",
        "description":
            "The agency struggles to find clients, you burn through savings, face mounting stress, and may need to return to corporate work with gaps in your resume.",
        "color": 0xFFE53E3E,
        "icon": "trending_down"
      },
      {
        "type": "Final Judgment",
        "title": "Calculated Risk Worth Taking",
        "description":
            "With proper planning, emergency fund, and gradual transition, the potential for personal fulfillment outweighs the risks. Start building clients while employed.",
        "color": 0xFF6B73FF,
        "icon": "psychology"
      }
    ]
  };

  final List<Map<String, dynamic>> _comments = [
    {
      "id": "comment_001",
      "author": "Anonymous",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "content":
          "I made this exact transition 2 years ago. Best decision ever! The key is having 6 months of expenses saved and starting to build your client base before you quit.",
      "timestamp": DateTime.now().subtract(const Duration(hours: 3)),
      "likes": 24,
      "isLiked": false,
      "isTopComment": true,
      "replies": [
        {
          "id": "reply_001",
          "author": "Anonymous",
          "avatar":
              "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
          "content":
              "How did you find your first clients? That's what I'm struggling with.",
          "timestamp": DateTime.now().subtract(const Duration(hours: 2)),
          "likes": 8,
          "isLiked": true,
        }
      ]
    },
    {
      "id": "comment_002",
      "author": "Anonymous",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "content":
          "Consider freelancing on weekends first. Test the waters without burning bridges. Corporate experience is valuable - don't underestimate it.",
      "timestamp": DateTime.now().subtract(const Duration(hours: 4)),
      "likes": 18,
      "isLiked": false,
      "isTopComment": false,
      "replies": []
    },
    {
      "id": "comment_003",
      "author": "Anonymous",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "content":
          "The anxiety you're feeling is normal. I felt the same way but realized staying in a job that drained my creativity was worse than the financial risk.",
      "timestamp": DateTime.now().subtract(const Duration(hours: 5)),
      "likes": 31,
      "isLiked": true,
      "isTopComment": true,
      "replies": []
    }
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();

    _commentFocusNode.addListener(() {
      setState(() {
        _isCommentExpanded = _commentFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    _commentController.dispose();
    _commentFocusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });

    if (mounted) {
      HapticFeedback.lightImpact();
    }
  }

  void _handleVote(int voteType) {
    setState(() {
      if (_userVoteState == voteType) {
        _userVoteState = 0; // Remove vote
      } else {
        _userVoteState = voteType;
      }
    });
    HapticFeedback.selectionClick();
  }

  void _handleCommentSubmit() async {
    if (_commentController.text.trim().isEmpty) return;

    setState(() {
      _isSubmittingComment = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    final newComment = {
      "id": "comment_${DateTime.now().millisecondsSinceEpoch}",
      "author": "Anonymous",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "content": _commentController.text.trim(),
      "timestamp": DateTime.now(),
      "likes": 0,
      "isLiked": false,
      "isTopComment": false,
      "replies": []
    };

    setState(() {
      _comments.insert(0, newComment);
      _commentController.clear();
      _isSubmittingComment = false;
    });

    _commentFocusNode.unfocus();
    HapticFeedback.lightImpact();
  }

  void _handleCommentReaction(String commentId, String reaction) {
    HapticFeedback.selectionClick();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Text(reaction, style: TextStyle(fontSize: 18.sp)),
            SizedBox(width: 2.w),
            Text('Reaction added!'),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _handleCommentReply(String commentId) {
    _commentFocusNode.requestFocus();
    _commentController.text = '@Anonymous ';
  }

  void _handleCommentPin(String commentId) {
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Comment pinned to top'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _handleCommentShare(String commentId) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Comment shared'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showContextMenu(String commentId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4,
              margin: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'content_copy',
                color: Theme.of(context).colorScheme.onSurface,
                size: 24,
              ),
              title: Text('Copy Comment'),
              onTap: () {
                Navigator.pop(context);
                HapticFeedback.selectionClick();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'reply',
                color: Theme.of(context).colorScheme.onSurface,
                size: 24,
              ),
              title: Text('Reply'),
              onTap: () {
                Navigator.pop(context);
                _handleCommentReply(commentId);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'report',
                color: AppTheme.error,
                size: 24,
              ),
              title: Text('Report', style: TextStyle(color: AppTheme.error)),
              onTap: () {
                Navigator.pop(context);
                HapticFeedback.selectionClick();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: Theme.of(context).colorScheme.onSurface,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Thread Detail',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'share',
              color: Theme.of(context).colorScheme.onSurface,
              size: 24,
            ),
            onPressed: () => HapticFeedback.selectionClick(),
          ),
          IconButton(
            icon: CustomIconWidget(
              iconName: 'more_vert',
              color: Theme.of(context).colorScheme.onSurface,
              size: 24,
            ),
            onPressed: () => HapticFeedback.selectionClick(),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Enhanced Thread Header
              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.all(4.w),
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.warning.withValues(alpha: 0.1),
                        Theme.of(context).colorScheme.surface,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppTheme.warning.withValues(alpha: 0.3),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.warning.withValues(alpha: 0.15),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 3.w,
                              vertical: 1.h,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppTheme.warning,
                                  AppTheme.warning.withValues(alpha: 0.8)
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      AppTheme.warning.withValues(alpha: 0.4),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _threadData["emotionIcon"],
                                  style: TextStyle(fontSize: 16.sp),
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  _threadData["emotion"],
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${DateTime.now().difference(_threadData["timestamp"] as DateTime).inHours}h ago',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        _threadData["question"],
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              height: 1.4,
                            ),
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(1.w),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppTheme.primaryLight,
                                  AppTheme.secondary
                                ],
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: CustomIconWidget(
                              iconName: 'person',
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            _threadData["author"],
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Outcome Cards
              SliverToBoxAdapter(
                child: Container(
                  height: 45.h,
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Column(
                    children: [
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentCardIndex = index;
                            });
                            HapticFeedback.selectionClick();
                          },
                          itemCount: (_threadData["outcomes"] as List).length,
                          itemBuilder: (context, index) {
                            final outcome = (_threadData["outcomes"]
                                as List)[index] as Map<String, dynamic>;
                            return OutcomeCardWidget(
                              outcome: outcome,
                              isActive: index == _currentCardIndex,
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          (_threadData["outcomes"] as List).length,
                          (index) => Container(
                            width: index == _currentCardIndex ? 8.w : 2.w,
                            height: 1.h,
                            margin: EdgeInsets.symmetric(horizontal: 1.w),
                            decoration: BoxDecoration(
                              color: index == _currentCardIndex
                                  ? AppTheme.primaryLight
                                  : Theme.of(context).dividerColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Vote Section
              SliverToBoxAdapter(
                child: VoteSectionWidget(
                  upvotes: _threadData["upvotes"] as int,
                  downvotes: _threadData["downvotes"] as int,
                  userVoteState: _userVoteState,
                  onVote: _handleVote,
                ),
              ),

              // Enhanced Comments Header
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppTheme.primaryLight, AppTheme.secondary],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: CustomIconWidget(
                          iconName: 'chat_bubble_rounded',
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        'Comments',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      SizedBox(width: 2.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppTheme.primaryLight, AppTheme.secondary],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${_threadData["commentCount"]}',
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Enhanced Comments List with vibrant styling
              _comments.isEmpty
                  ? SliverToBoxAdapter(
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(4.w),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppTheme.primaryLight
                                        .withValues(alpha: 0.1),
                                    AppTheme.secondary.withValues(alpha: 0.05),
                                  ],
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: CustomIconWidget(
                                iconName: 'chat_bubble_outline',
                                color: AppTheme.primaryLight,
                                size: 48,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'No comments yet',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              'Be the first to share your thoughts and support',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final comment = _comments[index];
                          return VibrantCommentItemWidget(
                            comment: comment,
                            onLongPress: () => _showContextMenu(comment["id"]),
                            onLike: (commentId) {
                              setState(() {
                                comment["isLiked"] = !comment["isLiked"];
                                comment["likes"] += comment["isLiked"] ? 1 : -1;
                              });
                              HapticFeedback.selectionClick();
                            },
                            onReaction: _handleCommentReaction,
                            onReply: _handleCommentReply,
                            onPin: _handleCommentPin,
                            onShare: _handleCommentShare,
                            isTopComment: comment["isTopComment"] ?? false,
                          );
                        },
                        childCount: _comments.length,
                      ),
                    ),

              // Bottom spacing for comment input
              SliverToBoxAdapter(
                child: SizedBox(height: 12.h),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: CommentInputWidget(
        controller: _commentController,
        focusNode: _commentFocusNode,
        isExpanded: _isCommentExpanded,
        isSubmitting: _isSubmittingComment,
        onSubmit: _handleCommentSubmit,
      ),
    );
  }
}
