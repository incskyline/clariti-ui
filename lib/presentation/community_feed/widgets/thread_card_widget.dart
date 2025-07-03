import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ThreadCardWidget extends StatefulWidget {
  final Map<String, dynamic> thread;
  final VoidCallback onTap;
  final VoidCallback onUpvote;
  final VoidCallback onDownvote;
  final VoidCallback onSave;
  final VoidCallback onLongPress;

  const ThreadCardWidget({
    super.key,
    required this.thread,
    required this.onTap,
    required this.onUpvote,
    required this.onDownvote,
    required this.onSave,
    required this.onLongPress,
  });

  @override
  State<ThreadCardWidget> createState() => _ThreadCardWidgetState();
}

class _ThreadCardWidgetState extends State<ThreadCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  final bool _isSwipeActive = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.1, 0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleSwipe(DismissDirection direction) {
    if (direction == DismissDirection.startToEnd) {
      widget.onUpvote();
      _showSwipeFeedback('Upvoted!', AppTheme.success);
    } else if (direction == DismissDirection.endToStart) {
      widget.onDownvote();
      _showSwipeFeedback('Downvoted', AppTheme.warning);
    }
  }

  void _showSwipeFeedback(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(milliseconds: 1500),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(4.w),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final thread = widget.thread;
    final isUpvoted = thread['isUpvoted'] as bool? ?? false;
    final isDownvoted = thread['isDownvoted'] as bool? ?? false;
    final isSaved = thread['isSaved'] as bool? ?? false;

    return Dismissible(
      key: Key('thread_${thread['id']}'),
      background: Container(
        decoration: BoxDecoration(
          color: AppTheme.success.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'thumb_up',
              color: AppTheme.success,
              size: 32,
            ),
            SizedBox(height: 1.h),
            Text(
              'Upvote',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppTheme.success,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
      secondaryBackground: Container(
        decoration: BoxDecoration(
          color: AppTheme.warning.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'thumb_down',
              color: AppTheme.warning,
              size: 32,
            ),
            SizedBox(height: 1.h),
            Text(
              'Downvote',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppTheme.warning,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        _handleSwipe(direction);
        return false; // Don't actually dismiss the card
      },
      child: GestureDetector(
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        child: AnimatedBuilder(
          animation: _slideAnimation,
          builder: (context, child) {
            return SlideTransition(
              position: _slideAnimation,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with emotion badge and time
                    Padding(
                      padding: EdgeInsets.all(4.w),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 3.w,
                              vertical: 1.h,
                            ),
                            decoration: BoxDecoration(
                              color: (thread['emotionColor'] as Color)
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomIconWidget(
                                  iconName: thread['emotionIcon'] as String,
                                  color: thread['emotionColor'] as Color,
                                  size: 16,
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  thread['emotion'] as String,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                        color: thread['emotionColor'] as Color,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Text(
                            thread['timeAgo'] as String,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                          ),
                          SizedBox(width: 2.w),
                          GestureDetector(
                            onTap: widget.onSave,
                            child: CustomIconWidget(
                              iconName:
                                  isSaved ? 'bookmark' : 'bookmark_border',
                              color: isSaved
                                  ? AppTheme.lightTheme.primaryColor
                                  : Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Question
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Text(
                        thread['question'] as String,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  height: 1.3,
                                ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    SizedBox(height: 1.h),

                    // Preview
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Text(
                        thread['preview'] as String,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                              height: 1.4,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    SizedBox(height: 2.h),

                    // Actions row
                    Padding(
                      padding: EdgeInsets.all(4.w),
                      child: Row(
                        children: [
                          // Upvote
                          GestureDetector(
                            onTap: widget.onUpvote,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 3.w,
                                vertical: 1.h,
                              ),
                              decoration: BoxDecoration(
                                color: isUpvoted
                                    ? AppTheme.success.withValues(alpha: 0.1)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomIconWidget(
                                    iconName: isUpvoted
                                        ? 'thumb_up'
                                        : 'thumb_up_outlined',
                                    color: isUpvoted
                                        ? AppTheme.success
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                    size: 18,
                                  ),
                                  SizedBox(width: 1.w),
                                  Text(
                                    '${thread['upvotes']}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(
                                          color: isUpvoted
                                              ? AppTheme.success
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

                          SizedBox(width: 3.w),

                          // Downvote
                          GestureDetector(
                            onTap: widget.onDownvote,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 3.w,
                                vertical: 1.h,
                              ),
                              decoration: BoxDecoration(
                                color: isDownvoted
                                    ? AppTheme.warning.withValues(alpha: 0.1)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomIconWidget(
                                    iconName: isDownvoted
                                        ? 'thumb_down'
                                        : 'thumb_down_outlined',
                                    color: isDownvoted
                                        ? AppTheme.warning
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                    size: 18,
                                  ),
                                  SizedBox(width: 1.w),
                                  Text(
                                    '${thread['downvotes']}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(
                                          color: isDownvoted
                                              ? AppTheme.warning
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

                          const Spacer(),

                          // Comments
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 3.w,
                              vertical: 1.h,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomIconWidget(
                                  iconName: 'chat_bubble_outline',
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                  size: 18,
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  '${thread['comments']}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
