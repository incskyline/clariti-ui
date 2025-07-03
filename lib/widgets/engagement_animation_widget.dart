import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EngagementAnimationWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool enableHover;
  final bool enablePulse;
  final Duration animationDuration;
  final Curve animationCurve;

  const EngagementAnimationWidget({
    super.key,
    required this.child,
    this.onTap,
    this.enableHover = true,
    this.enablePulse = false,
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.easeInOut,
  });

  @override
  State<EngagementAnimationWidget> createState() =>
      _EngagementAnimationWidgetState();
}

class _EngagementAnimationWidgetState extends State<EngagementAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: widget.animationCurve,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    if (widget.enablePulse) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (!_isPressed) {
      setState(() {
        _isPressed = true;
      });
      _scaleController.forward();
      HapticFeedback.lightImpact();
    }
  }

  void _onTapUp(TapUpDetails details) {
    _onTapEnd();
  }

  void _onTapCancel() {
    _onTapEnd();
  }

  void _onTapEnd() {
    if (_isPressed) {
      setState(() {
        _isPressed = false;
      });
      _scaleController.reverse();
      if (widget.onTap != null) {
        widget.onTap!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.enableHover ? _onTapDown : null,
      onTapUp: widget.enableHover ? _onTapUp : null,
      onTapCancel: widget.enableHover ? _onTapCancel : null,
      onTap: !widget.enableHover ? widget.onTap : null,
      child: AnimatedBuilder(
        animation: Listenable.merge([_scaleAnimation, _pulseAnimation]),
        builder: (context, child) {
          double scale = _scaleAnimation.value;
          if (widget.enablePulse) {
            scale *= _pulseAnimation.value;
          }
          return Transform.scale(
            scale: scale,
            child: widget.child,
          );
        },
      ),
    );
  }
}
