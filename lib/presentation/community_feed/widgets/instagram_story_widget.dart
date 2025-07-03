import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class InstagramStoryWidget extends StatefulWidget {
  final List<Map<String, dynamic>> stories;
  final Function(Map<String, dynamic>) onStoryTap;

  const InstagramStoryWidget({
    super.key,
    required this.stories,
    required this.onStoryTap,
  });

  @override
  State<InstagramStoryWidget> createState() => _InstagramStoryWidgetState();
}

class _InstagramStoryWidgetState extends State<InstagramStoryWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 12.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: widget.stories.length + 1, // +1 for "Add Story"
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildAddStoryButton();
          }

          final story = widget.stories[index - 1];
          return _buildStoryItem(story);
        },
      ),
    );
  }

  Widget _buildAddStoryButton() {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/create-decision'),
      child: Container(
        width: 18.w,
        margin: EdgeInsets.only(right: 3.w),
        child: Column(
          children: [
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    width: 16.w,
                    height: 16.w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
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
                              .withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 1.h),
            Text(
              'Your Story',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryItem(Map<String, dynamic> story) {
    final bool hasUnread = story['hasUnread'] ?? false;

    return GestureDetector(
      onTap: () => widget.onStoryTap(story),
      child: Container(
        width: 18.w,
        margin: EdgeInsets.only(right: 3.w),
        child: Column(
          children: [
            Container(
              width: 16.w,
              height: 16.w,
              decoration: BoxDecoration(
                gradient: hasUnread
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFE91E63),
                          Color(0xFFFF5722),
                          Color(0xFFFFEB3B),
                        ],
                      )
                    : null,
                color: hasUnread ? null : Colors.grey.shade300,
                shape: BoxShape.circle,
                border: hasUnread
                    ? null
                    : Border.all(
                        color: Colors.grey.shade400,
                        width: 2,
                      ),
              ),
              padding: EdgeInsets.all(2),
              child: Container(
                decoration: BoxDecoration(
                  color: story['emotionColor'] != null
                      ? Color(int.parse(story['emotionColor']))
                          .withValues(alpha: 0.1)
                      : Theme.of(context).colorScheme.surface,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.surface,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    story['emotion']?.substring(0, 1).toUpperCase() ?? '?',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: story['emotionColor'] != null
                              ? Color(int.parse(story['emotionColor']))
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              story['emotion'] ?? 'Unknown',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
