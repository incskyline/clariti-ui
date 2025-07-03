import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/engagement_animation_widget.dart';

class VibrantCommentItemWidget extends StatefulWidget {
  final Map<String, dynamic> comment;
  final VoidCallback onLongPress;
  final Function(String) onLike;
  final Function(String, String)? onReaction;
  final Function(String)? onReply;
  final Function(String)? onPin;
  final Function(String)? onShare;
  final bool isTopComment;

  const VibrantCommentItemWidget({
    super.key,
    required this.comment,
    required this.onLongPress,
    required this.onLike,
    this.onReaction,
    this.onReply,
    this.onPin,
    this.onShare,
    this.isTopComment = false,
  });

  @override
  State<VibrantCommentItemWidget> createState() =>
      _VibrantCommentItemWidgetState();
}

class _VibrantCommentItemWidgetState extends State<VibrantCommentItemWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _showReactions = false;

  final List<String> _availableReactions = ['❤️', '🔥', '😂', '😮', '😢', '😡'];
  final Map<String, int> _commentReactions = {
    '❤️': 12,
    '🔥': 5,
    '😂': 3,
  };

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this)
      ..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
        CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

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

  Widget _buildCustomAvatar() {
    final isAnonymous = widget.comment['author'] == 'Anonymous';

    if (isAnonymous) {
      return AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(colors: [
                          AppTheme.primaryLight,
                          AppTheme.secondary,
                        ]),
                        boxShadow: [
                          BoxShadow(
                              color:
                                  AppTheme.primaryLight.withValues(alpha: 0.4),
                              blurRadius: 12,
                              spreadRadius: 2),
                        ]),
                    child: const Icon(Icons.psychology_rounded,
                        color: Colors.white, size: 20)));
          });
    }

    return Container(
        width: 12.w,
        height: 12.w,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
                color: AppTheme.primaryLight.withValues(alpha: 0.3), width: 2)),
        child: ClipOval(
            child: CustomImageWidget(
                imageUrl: widget.comment["avatar"] ?? '',
                width: 12.w,
                height: 12.w,
                fit: BoxFit.cover)));
  }

  @override
  Widget build(BuildContext context) {
    final replies = (widget.comment["replies"] as List?) ?? [];

    return Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        child: Column(children: [
          // Main Comment with enhanced bubble design
          EngagementAnimationWidget(
              child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                      color: widget.isTopComment
                          ? AppTheme.primaryLight.withValues(alpha: 0.05)
                          : Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: widget.isTopComment
                          ? Border.all(
                              color:
                                  AppTheme.primaryLight.withValues(alpha: 0.3),
                              width: 2)
                          : null,
                      boxShadow: [
                        BoxShadow(
                            color: widget.isTopComment
                                ? AppTheme.primaryLight.withValues(alpha: 0.15)
                                : Theme.of(context).shadowColor,
                            blurRadius: widget.isTopComment ? 12 : 6,
                            offset: const Offset(0, 3)),
                      ]),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Enhanced Comment Header
                        Row(children: [
                          _buildCustomAvatar(),
                          SizedBox(width: 3.w),
                          Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                Row(children: [
                                  Text(widget.comment["author"],
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold)),
                                  if (widget.isTopComment) ...[
                                    SizedBox(width: 2.w),
                                    Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 2.w, vertical: 0.5.h),
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(colors: [
                                              AppTheme.primaryLight,
                                              AppTheme.secondary,
                                            ]),
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Text('TOP',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 8.sp,
                                                fontWeight: FontWeight.bold))),
                                  ],
                                ]),
                                Text(
                                    _formatTimestamp(
                                        widget.comment["timestamp"]),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant)),
                              ])),
                          // Enhanced like button
                          EngagementAnimationWidget(
                              onTap: () {
                                HapticFeedback.selectionClick();
                                widget.onLike(widget.comment["id"]);
                              },
                              child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 2.w, vertical: 1.h),
                                  decoration: BoxDecoration(
                                      color: widget.comment["isLiked"]
                                          ? AppTheme.error
                                              .withValues(alpha: 0.1)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CustomIconWidget(
                                            iconName: widget.comment["isLiked"]
                                                ? 'favorite'
                                                : 'favorite_border',
                                            color: widget.comment["isLiked"]
                                                ? AppTheme.error
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .onSurfaceVariant,
                                            size: 20),
                                        if (widget.comment["likes"] > 0) ...[
                                          SizedBox(width: 1.w),
                                          Text(
                                              widget.comment["likes"]
                                                  .toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                      color: widget.comment[
                                                              "isLiked"]
                                                          ? AppTheme.error
                                                          : Theme.of(context)
                                                              .colorScheme
                                                              .onSurfaceVariant,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                        ],
                                      ]))),
                        ]),

                        SizedBox(height: 2.h),

                        // Enhanced Comment Content with bubble styling
                        Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(3.w),
                            decoration: BoxDecoration(
                                color: widget.isTopComment
                                    ? Colors.white.withValues(alpha: 0.7)
                                    : Theme.of(context)
                                        .colorScheme
                                        .surface
                                        .withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                    color: Theme.of(context).dividerColor,
                                    width: 1)),
                            child: Text(widget.comment["content"],
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(height: 1.5))),

                        SizedBox(height: 2.h),

                        // Enhanced reactions section
                        if (_commentReactions.isNotEmpty) ...[
                          Container(
                              padding: EdgeInsets.symmetric(vertical: 1.h),
                              child: Wrap(
                                  spacing: 2.w,
                                  children:
                                      _commentReactions.entries.map((entry) {
                                    return EngagementAnimationWidget(
                                        onTap: () => widget.onReaction?.call(
                                            widget.comment["id"], entry.key),
                                        child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 2.w,
                                                vertical: 0.5.h),
                                            decoration: BoxDecoration(
                                                color: AppTheme.primaryLight
                                                    .withValues(alpha: 0.1),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                    color: AppTheme.primaryLight
                                                        .withValues(alpha: 0.3),
                                                    width: 1)),
                                            child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(entry.key,
                                                      style: TextStyle(
                                                          fontSize: 14.sp)),
                                                  SizedBox(width: 1.w),
                                                  Text(entry.value.toString(),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall
                                                          ?.copyWith(
                                                              color: AppTheme
                                                                  .primaryLight,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                ])));
                                  }).toList())),
                          SizedBox(height: 1.h),
                        ],

                        // Enhanced Comment Actions
                        Row(children: [
                          _buildActionButton(
                              icon: Icons.reply_rounded,
                              label: 'Reply',
                              onTap: () =>
                                  widget.onReply?.call(widget.comment["id"])),
                          SizedBox(width: 2.w),
                          _buildActionButton(
                              icon: Icons.push_pin_outlined,
                              label: 'Pin',
                              onTap: () =>
                                  widget.onPin?.call(widget.comment["id"])),
                          SizedBox(width: 2.w),
                          _buildActionButton(
                              icon: Icons.share_outlined,
                              label: 'Share',
                              onTap: () =>
                                  widget.onShare?.call(widget.comment["id"])),
                          const Spacer(),
                          // Add reaction button
                          EngagementAnimationWidget(
                              onTap: () {
                                setState(() {
                                  _showReactions = !_showReactions;
                                });
                              },
                              child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 2.w, vertical: 1.h),
                                  decoration: BoxDecoration(
                                      color: _showReactions
                                          ? AppTheme.primaryLight
                                              .withValues(alpha: 0.1)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('😊',
                                            style: TextStyle(fontSize: 16.sp)),
                                        SizedBox(width: 1.w),
                                        Icon(
                                            _showReactions
                                                ? Icons.expand_less
                                                : Icons.add,
                                            size: 16,
                                            color: AppTheme.primaryLight),
                                      ]))),
                        ]),

                        // Reaction picker
                        if (_showReactions) ...[
                          SizedBox(height: 2.h),
                          Container(
                              padding: EdgeInsets.all(2.w),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      color: AppTheme.primaryLight
                                          .withValues(alpha: 0.3),
                                      width: 1)),
                              child: Wrap(
                                  spacing: 2.w,
                                  children: _availableReactions.map((reaction) {
                                    return EngagementAnimationWidget(
                                        onTap: () {
                                          widget.onReaction?.call(
                                              widget.comment["id"], reaction);
                                          setState(() {
                                            _showReactions = false;
                                            if (_commentReactions
                                                .containsKey(reaction)) {
                                              _commentReactions[reaction] =
                                                  _commentReactions[reaction]! +
                                                      1;
                                            } else {
                                              _commentReactions[reaction] = 1;
                                            }
                                          });
                                        },
                                        child: Container(
                                            padding: EdgeInsets.all(2.w),
                                            decoration: BoxDecoration(
                                                color: AppTheme.primaryLight
                                                    .withValues(alpha: 0.1),
                                                shape: BoxShape.circle),
                                            child: Text(reaction,
                                                style: TextStyle(
                                                    fontSize: 20.sp))));
                                  }).toList())),
                        ],
                      ]))),

          // Enhanced Replies with improved bubble design
          if (replies.isNotEmpty) ...[
            SizedBox(height: 2.h),
            ...replies.map<Widget>((reply) => Container(
                margin: EdgeInsets.only(left: 16.w, bottom: 2.h),
                child: _buildEnhancedReplyItem(context, reply))),
          ],
        ]));
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
  }) {
    return EngagementAnimationWidget(
        onTap: onTap ?? () => HapticFeedback.selectionClick(),
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
                color: AppTheme.primaryLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(15)),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(icon, size: 16, color: AppTheme.primaryLight),
              SizedBox(width: 1.w),
              Text(label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.primaryLight,
                      fontWeight: FontWeight.w500)),
            ])));
  }

  Widget _buildEnhancedReplyItem(
      BuildContext context, Map<String, dynamic> reply) {
    return Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.primaryLight.withValues(alpha: 0.05),
                  Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
                ]),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
                color: AppTheme.primaryLight.withValues(alpha: 0.2), width: 1)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                        colors: [AppTheme.primaryLight, AppTheme.secondary])),
                child: const Icon(Icons.person, color: Colors.white, size: 16)),
            SizedBox(width: 2.w),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(reply["author"],
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold, fontSize: 12.sp)),
                  Text(_formatTimestamp(reply["timestamp"]),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 10.sp,
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant)),
                ])),
            EngagementAnimationWidget(
                onTap: () {
                  HapticFeedback.selectionClick();
                  widget.onLike(reply["id"]);
                },
                child: Container(
                    padding: EdgeInsets.all(1.w),
                    decoration: BoxDecoration(
                        color: reply["isLiked"]
                            ? AppTheme.error.withValues(alpha: 0.1)
                            : Colors.transparent,
                        shape: BoxShape.circle),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      CustomIconWidget(
                          iconName:
                              reply["isLiked"] ? 'favorite' : 'favorite_border',
                          color: reply["isLiked"]
                              ? AppTheme.error
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                          size: 16),
                      if (reply["likes"] > 0) ...[
                        SizedBox(width: 1.w),
                        Text(reply["likes"].toString(),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    color: reply["isLiked"]
                                        ? AppTheme.error
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold)),
                      ],
                    ]))),
          ]),
          SizedBox(height: 1.h),
          Container(
              width: double.infinity,
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: AppTheme.primaryLight.withValues(alpha: 0.2),
                      width: 1)),
              child: Text(reply["content"],
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(height: 1.4, fontSize: 12.sp))),
        ]));
  }
}
