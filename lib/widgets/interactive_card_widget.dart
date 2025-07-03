import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../core/app_export.dart';

class InteractiveCardWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onLongPress;
  final Function(DismissDirection)? onDismissed;
  final bool enableSwipe;
  final bool enableHover;
  final Color? backgroundColor;
  final double? elevation;
  final BorderRadius? borderRadius;
  final Duration animationDuration;

  const InteractiveCardWidget({
    super.key,
    required this.child,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.onDismissed,
    this.enableSwipe = false,
    this.enableHover = true,
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  @override
  State<InteractiveCardWidget> createState() => _InteractiveCardWidgetState();
}

class _InteractiveCardWidgetState extends State<InteractiveCardWidget>
    with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late AnimationController _tapController;
  late Animation<double> _hoverAnimation;
  late Animation<double> _tapAnimation;
  late Animation<double> _elevationAnimation;

  bool _isHovered = false;
  bool _isTapped = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _tapController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _hoverAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOut,
    ));

    _tapAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _tapController,
      curve: Curves.easeInOut,
    ));

    _elevationAnimation = Tween<double>(
      begin: widget.elevation ?? 2.0,
      end: (widget.elevation ?? 2.0) + 4.0,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _tapController.dispose();
    super.dispose();
  }

  void _onHoverStart() {
    if (!widget.enableHover || _isTapped) return;
    setState(() {
      _isHovered = true;
    });
    _hoverController.forward();
  }

  void _onHoverEnd() {
    if (!widget.enableHover) return;
    setState(() {
      _isHovered = false;
    });
    _hoverController.reverse();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isTapped = true;
    });
    _tapController.forward();
    HapticFeedback.lightImpact();
  }

  void _onTapUp(TapUpDetails details) {
    _onTapEnd();
  }

  void _onTapCancel() {
    _onTapEnd();
  }

  void _onTapEnd() {
    setState(() {
      _isTapped = false;
    });
    _tapController.reverse();
  }

  Widget _buildCard() {
    return AnimatedBuilder(
      animation: Listenable.merge(
          [_hoverAnimation, _tapAnimation, _elevationAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _hoverAnimation.value * _tapAnimation.value,
          child: Card(
            elevation: _isHovered
                ? _elevationAnimation.value
                : (widget.elevation ?? 2.0),
            color: widget.backgroundColor ?? Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: widget.borderRadius ?? BorderRadius.circular(16),
            ),
            shadowColor: AppTheme.shadowLight,
            child: ClipRRect(
              borderRadius: widget.borderRadius ?? BorderRadius.circular(16),
              child: Stack(
                children: [
                  widget.child,
                  // Hover overlay
                  if (_isHovered)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withValues(alpha: 0.05),
                          borderRadius:
                              widget.borderRadius ?? BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  // Tap overlay
                  if (_isTapped)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withValues(alpha: 0.1),
                          borderRadius:
                              widget.borderRadius ?? BorderRadius.circular(16),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInteractiveCard() {
    return GestureDetector(
      onTap: widget.onTap,
      onDoubleTap: widget.onDoubleTap,
      onLongPress: () {
        HapticFeedback.mediumImpact();
        widget.onLongPress?.call();
      },
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: MouseRegion(
        onEnter: (_) => _onHoverStart(),
        onExit: (_) => _onHoverEnd(),
        child: _buildCard(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.enableSwipe && widget.onDismissed != null) {
      return Dismissible(
        key: UniqueKey(),
        onDismissed: widget.onDismissed!,
        background: Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          decoration: BoxDecoration(
            color: AppTheme.success,
            borderRadius: widget.borderRadius ?? BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'check',
                color: Colors.white,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Complete',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
        secondaryBackground: Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          decoration: BoxDecoration(
            color: AppTheme.error,
            borderRadius: widget.borderRadius ?? BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Delete',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              SizedBox(width: 2.w),
              CustomIconWidget(
                iconName: 'delete',
                color: Colors.white,
                size: 24,
              ),
            ],
          ),
        ),
        child: _buildInteractiveCard(),
      );
    }

    return _buildInteractiveCard();
  }
}
