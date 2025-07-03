import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class InstagramFeedCardWidget extends StatefulWidget {
  final Map<String, dynamic> thread;
  final VoidCallback onTap;
  final VoidCallback onUpvote;
  final VoidCallback onDownvote;
  final VoidCallback onSave;
  final VoidCallback onShare;
  final VoidCallback onComment;

  const InstagramFeedCardWidget({
    super.key,
    required this.thread,
    required this.onTap,
    required this.onUpvote,
    required this.onDownvote,
    required this.onSave,
    required this.onShare,
    required this.onComment,
  });

  @override
  State<InstagramFeedCardWidget> createState() =>
      _InstagramFeedCardWidgetState();
}

class _InstagramFeedCardWidgetState extends State<InstagramFeedCardWidget>
    with TickerProviderStateMixin {
  late AnimationController _likeController;
  late AnimationController _scaleController;
  late Animation<double> _likeAnimation;
  late Animation<double> _scaleAnimation;
  bool _showHeart = false;

  @override
  void initState() {
    super.initState();
    _likeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _likeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _likeController, curve: Curves.elasticOut),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _likeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _onDoubleTap() {
    if (!(widget.thread['isUpvoted'] ?? false)) {
      widget.onUpvote();
      setState(() {
        _showHeart = true;
      });
      _likeController.forward().then((_) {
        Future.delayed(Duration(milliseconds: 1000), () {
          if (mounted) {
            setState(() {
              _showHeart = false;
            });
            _likeController.reset();
          }
        });
      });
    }
  }

  void _onTapDown(TapDownDetails details) {
    _scaleController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _scaleController.reverse();
  }

  void _onTapCancel() {
    _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final thread = widget.thread;
    final isUpvoted = thread['isUpvoted'] as bool? ?? false;
    final isDownvoted = thread['isDownvoted'] as bool? ?? false;
    final isSaved = thread['isSaved'] as bool? ?? false;

    final cardWidget = AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTap: widget.onTap,
            onDoubleTap: _onDoubleTap,
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            child: Container(
              margin: EdgeInsets.only(bottom: 4.h),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header (Instagram-like)
                  Padding(
                    padding: EdgeInsets.all(4.w),
                    child: Row(
                      children: [
                        Container(
                          width: 10.w,
                          height: 10.w,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                (thread['emotionColor'] as Color),
                                (thread['emotionColor'] as Color)
                                    .withValues(alpha: 0.7),
                              ],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              thread['emotion'].substring(0, 1).toUpperCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Anonymous · ${thread['emotion']}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              Text(
                                thread['timeAgo'],
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.more_vert,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Content
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          thread['question'],
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    height: 1.3,
                                  ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          thread['preview'],
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                    height: 1.5,
                                  ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Instagram-like action bar
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: widget.onUpvote,
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            child: Icon(
                              isUpvoted
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isUpvoted
                                  ? Colors.red
                                  : Theme.of(context).colorScheme.onSurface,
                              size: 28,
                            ),
                          ),
                        ),
                        SizedBox(width: 5.w),
                        GestureDetector(
                          onTap: widget.onComment,
                          child: Icon(
                            Icons.chat_bubble_outline,
                            color: Theme.of(context).colorScheme.onSurface,
                            size: 26,
                          ),
                        ),
                        SizedBox(width: 5.w),
                        GestureDetector(
                          onTap: widget.onShare,
                          child: Icon(
                            Icons.send_outlined,
                            color: Theme.of(context).colorScheme.onSurface,
                            size: 26,
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: widget.onSave,
                          child: Icon(
                            isSaved ? Icons.bookmark : Icons.bookmark_border,
                            color: isSaved
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.onSurface,
                            size: 26,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // Likes and comments count (Instagram style)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if ((thread['upvotes'] as int) > 0)
                          RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.bodyMedium,
                              children: [
                                TextSpan(
                                  text: '${thread['upvotes']} ',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                TextSpan(
                                  text: 'likes',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant),
                                ),
                              ],
                            ),
                          ),
                        if ((thread['comments'] as int) > 0) ...[
                          SizedBox(height: 1.h),
                          GestureDetector(
                            onTap: widget.onComment,
                            child: Text(
                              'View all ${thread['comments']} comments',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  SizedBox(height: 3.h),
                ],
              ),
            ),
          ),
        );
      },
    );

    // Heart animation overlay
    return Stack(
      children: [
        cardWidget,
        if (_showHeart)
          Positioned.fill(
            child: Center(
              child: AnimatedBuilder(
                animation: _likeAnimation,
                builder: (context, _) {
                  return Transform.scale(
                    scale: _likeAnimation.value,
                    child: Opacity(
                      opacity: 1.0 - _likeAnimation.value,
                      child: Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 80,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}
