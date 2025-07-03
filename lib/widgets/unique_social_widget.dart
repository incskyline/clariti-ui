import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../core/app_export.dart';
import './custom_icon_widget.dart';

class UniqueSocialWidget extends StatefulWidget {
  final List<Map<String, dynamic>> socialMetrics;
  final VoidCallback? onTap;
  final bool showAnimation;

  const UniqueSocialWidget({
    super.key,
    required this.socialMetrics,
    this.onTap,
    this.showAnimation = true,
  });

  @override
  State<UniqueSocialWidget> createState() => _UniqueSocialWidgetState();
}

class _UniqueSocialWidgetState extends State<UniqueSocialWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    if (widget.showAnimation) {
      _pulseController = AnimationController(
        duration: Duration(seconds: 2),
        vsync: this,
      )..repeat(reverse: true);

      _rotationController = AnimationController(
        duration: Duration(seconds: 8),
        vsync: this,
      )..repeat();

      _pulseAnimation = Tween<double>(
        begin: 0.8,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ));

      _rotationAnimation = Tween<double>(
        begin: 0.0,
        end: 2.0,
      ).animate(CurvedAnimation(
        parent: _rotationController,
        curve: Curves.linear,
      ));
    }
  }

  @override
  void dispose() {
    if (widget.showAnimation) {
      _pulseController.dispose();
      _rotationController.dispose();
    }
    super.dispose();
  }

  Widget _buildSocialMetric(Map<String, dynamic> metric, int index) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            (metric['color'] as Color).withValues(alpha: 0.1),
            (metric['color'] as Color).withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: (metric['color'] as Color).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: metric['icon'] as String,
            color: metric['color'] as Color,
            size: 16,
          ),
          SizedBox(width: 2.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${metric['value']}',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: metric['color'] as Color,
                    ),
              ),
              Text(
                metric['label'] as String,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.showAnimation) {
      return GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: EdgeInsets.all(4.w),
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
          child: Wrap(
            spacing: 3.w,
            runSpacing: 1.h,
            children: widget.socialMetrics
                .asMap()
                .entries
                .map((entry) => _buildSocialMetric(entry.value, entry.key))
                .toList(),
          ),
        ),
      );
    }

    return AnimatedBuilder(
      animation: Listenable.merge([_pulseAnimation, _rotationAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: GestureDetector(
            onTap: widget.onTap,
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.surface,
                    Theme.of(context)
                        .colorScheme
                        .surface
                        .withValues(alpha: 0.8),
                  ],
                  transform: GradientRotation(_rotationAnimation.value),
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.1),
                    blurRadius: 15,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Wrap(
                spacing: 3.w,
                runSpacing: 1.h,
                children: widget.socialMetrics
                    .asMap()
                    .entries
                    .map((entry) => _buildSocialMetric(entry.value, entry.key))
                    .toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}
