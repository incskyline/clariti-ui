import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class InstagramHighlightsWidget extends StatefulWidget {
  final List<Map<String, dynamic>> highlights;
  final Function(Map<String, dynamic>) onHighlightTap;

  const InstagramHighlightsWidget({
    super.key,
    required this.highlights,
    required this.onHighlightTap,
  });

  @override
  State<InstagramHighlightsWidget> createState() =>
      _InstagramHighlightsWidgetState();
}

class _InstagramHighlightsWidgetState extends State<InstagramHighlightsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: Text(
              'Categories',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          SizedBox(height: 2.h),
          SizedBox(
            height: 12.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              itemCount: widget.highlights.length,
              itemBuilder: (context, index) {
                return _buildSimpleHighlightItem(widget.highlights[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleHighlightItem(Map<String, dynamic> highlight) {
    return GestureDetector(
      onTap: () => widget.onHighlightTap(highlight),
      child: Container(
        width: 18.w,
        margin: EdgeInsets.only(right: 4.w),
        child: Column(
          children: [
            Container(
              width: 16.w,
              height: 16.w,
              decoration: BoxDecoration(
                color:
                    Color(int.parse(highlight['color'])).withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Color(int.parse(highlight['color'])),
                  width: 2,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _getIconForCategory(highlight['category']),
                      color: Color(int.parse(highlight['color'])),
                      size: 20,
                    ),
                    if (highlight['count'] != null)
                      Text(
                        '${highlight['count']}',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Color(int.parse(highlight['color'])),
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              highlight['title'],
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'career':
        return Icons.work_outline;
      case 'love':
        return Icons.favorite_outline;
      case 'education':
        return Icons.school_outlined;
      case 'health':
        return Icons.health_and_safety_outlined;
      case 'finance':
        return Icons.attach_money;
      case 'travel':
        return Icons.flight_outlined;
      case 'family':
        return Icons.family_restroom_outlined;
      default:
        return Icons.psychology_outlined;
    }
  }
}
