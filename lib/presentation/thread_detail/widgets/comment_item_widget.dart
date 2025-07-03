import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CommentItemWidget extends StatelessWidget {
  final Map<String, dynamic> comment;
  final VoidCallback onLongPress;
  final Function(String) onLike;

  const CommentItemWidget({
    super.key,
    required this.comment,
    required this.onLongPress,
    required this.onLike,
  });

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    final replies = (comment["replies"] as List?) ?? [];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        children: [
          // Main Comment
          GestureDetector(
            onLongPress: () {
              HapticFeedback.mediumImpact();
              onLongPress();
            },
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor,
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Comment Header
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 5.w,
                        backgroundColor:
                            AppTheme.primaryLight.withValues(alpha: 0.1),
                        child: CustomImageWidget(
                          imageUrl: comment["avatar"],
                          width: 10.w,
                          height: 10.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              comment["author"],
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            Text(
                              _formatTimestamp(comment["timestamp"]),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          HapticFeedback.selectionClick();
                          onLike(comment["id"]);
                        },
                        icon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomIconWidget(
                              iconName: comment["isLiked"]
                                  ? 'favorite'
                                  : 'favorite_border',
                              color: comment["isLiked"]
                                  ? AppTheme.error
                                  : Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                              size: 20,
                            ),
                            if (comment["likes"] > 0) ...[
                              SizedBox(width: 1.w),
                              Text(
                                comment["likes"].toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: comment["isLiked"]
                                          ? AppTheme.error
                                          : Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 2.h),

                  // Comment Content
                  Text(
                    comment["content"],
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.5,
                        ),
                  ),

                  SizedBox(height: 2.h),

                  // Comment Actions
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: () => HapticFeedback.selectionClick(),
                        icon: CustomIconWidget(
                          iconName: 'reply',
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          size: 16,
                        ),
                        label: Text(
                          'Reply',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 1.h),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Replies
          if (replies.isNotEmpty) ...[
            SizedBox(height: 2.h),
            ...replies.map<Widget>((reply) => Container(
                  margin: EdgeInsets.only(left: 12.w),
                  child: _buildReplyItem(context, reply),
                )),
          ],
        ],
      ),
    );
  }

  Widget _buildReplyItem(BuildContext context, Map<String, dynamic> reply) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 4.w,
                backgroundColor: AppTheme.primaryLight.withValues(alpha: 0.1),
                child: CustomImageWidget(
                  imageUrl: reply["avatar"],
                  width: 8.w,
                  height: 8.w,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reply["author"],
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 12.sp,
                          ),
                    ),
                    Text(
                      _formatTimestamp(reply["timestamp"]),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 10.sp,
                          ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  HapticFeedback.selectionClick();
                  onLike(reply["id"]);
                },
                icon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName:
                          reply["isLiked"] ? 'favorite' : 'favorite_border',
                      color: reply["isLiked"]
                          ? AppTheme.error
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 16,
                    ),
                    if (reply["likes"] > 0) ...[
                      SizedBox(width: 1.w),
                      Text(
                        reply["likes"].toString(),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: reply["isLiked"]
                                  ? AppTheme.error
                                  : Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                              fontSize: 10.sp,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            reply["content"],
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.4,
                  fontSize: 12.sp,
                ),
          ),
        ],
      ),
    );
  }
}
