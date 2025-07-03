import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class FloatingCardWidget extends StatefulWidget {
  final Widget child;
  final Color? shadowColor;
  final double? elevation;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Gradient? gradient;
  final bool enableHover;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const FloatingCardWidget({
    super.key,
    required this.child,
    this.shadowColor,
    this.elevation,
    this.borderRadius,
    this.padding,
    this.margin,
    this.gradient,
    this.enableHover = true,
    this.onTap,
    this.onLongPress,
  });

  @override
  State<FloatingCardWidget> createState() => _FloatingCardWidgetState();
}

class _FloatingCardWidgetState extends State<FloatingCardWidget>
    with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late AnimationController _floatingController;
  late Animation<double> _hoverAnimation;
  late Animation<double> _floatingAnimation;
  late Animation<double> _scaleAnimation;

  bool _isHovered = false;

  @override
  void initState() {
    super.initState();

    _hoverController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );

    _floatingController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _hoverAnimation = Tween<double>(
      begin: 0.0,
      end: 8.0,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOut,
    ));

    _floatingAnimation = Tween<double>(
      begin: -2.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  void _onHoverStart() {
    if (widget.enableHover) {
      setState(() {
        _isHovered = true;
      });
      _hoverController.forward();
    }
  }

  void _onHoverEnd() {
    if (widget.enableHover) {
      setState(() {
        _isHovered = false;
      });
      _hoverController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge(
          [_hoverAnimation, _floatingAnimation, _scaleAnimation]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatingAnimation.value + _hoverAnimation.value),
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: GestureDetector(
              onTap: widget.onTap,
              onLongPress: widget.onLongPress,
              child: MouseRegion(
                onEnter: (_) => _onHoverStart(),
                onExit: (_) => _onHoverEnd(),
                child: Container(
                  margin: widget.margin ??
                      EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    borderRadius:
                        widget.borderRadius ?? BorderRadius.circular(25),
                    gradient: widget.gradient,
                    color: widget.gradient == null
                        ? Theme.of(context).colorScheme.surface
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: widget.shadowColor ??
                            Theme.of(context)
                                .colorScheme
                                .primary
                                .withValues(alpha: _isHovered ? 0.15 : 0.08),
                        blurRadius:
                            (widget.elevation ?? 12) + (_isHovered ? 8 : 0),
                        offset: Offset(0,
                            (widget.elevation ?? 8) / 2 + (_isHovered ? 4 : 0)),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius:
                        widget.borderRadius ?? BorderRadius.circular(25),
                    child: Container(
                      padding: widget.padding ?? EdgeInsets.all(4.w),
                      child: widget.child,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
