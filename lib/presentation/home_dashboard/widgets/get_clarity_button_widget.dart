import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

class GetClarityButtonWidget extends StatefulWidget {
  final VoidCallback onPressed;
  final Color emotionColor;
  final bool isEnabled;

  const GetClarityButtonWidget({
    super.key,
    required this.onPressed,
    this.emotionColor = const Color(0xFF6B73FF),
    this.isEnabled = true,
  });

  @override
  State<GetClarityButtonWidget> createState() => _GetClarityButtonWidgetState();
}

class _GetClarityButtonWidgetState extends State<GetClarityButtonWidget>
    with TickerProviderStateMixin {
  late AnimationController _heartbeatController;
  late AnimationController _rippleController;
  late AnimationController _pressController;
  late Animation<double> _heartbeatAnimation;
  late Animation<double> _rippleAnimation;
  late Animation<double> _scaleAnimation;

  bool _isPressed = false;
  bool _showListeningText = false;

  @override
  void initState() {
    super.initState();
    _heartbeatController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();

    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _pressController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _heartbeatAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _heartbeatController,
      curve: Curves.easeInOut,
    ));

    _rippleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rippleController,
      curve: Curves.easeOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _pressController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _heartbeatController.dispose();
    _rippleController.dispose();
    _pressController.dispose();
    super.dispose();
  }

  void _handleTapDown() {
    setState(() => _isPressed = true);
    _pressController.forward();
    _rippleController.forward();
  }

  void _handleTapUp() {
    setState(() => _isPressed = false);
    _pressController.reverse();

    if (widget.isEnabled) {
      setState(() => _showListeningText = true);
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          widget.onPressed();
          setState(() => _showListeningText = false);
        }
      });
    }
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _pressController.reverse();
    _rippleController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _heartbeatAnimation,
        _rippleAnimation,
        _scaleAnimation,
      ]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Ripple effect
                if (_rippleAnimation.value > 0)
                  Container(
                    width: 88.w * (1 + _rippleAnimation.value * 0.3),
                    height: 14.h * (1 + _rippleAnimation.value * 0.3),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: widget.emotionColor.withValues(
                          alpha: (1 - _rippleAnimation.value) * 0.6,
                        ),
                        width: 2,
                      ),
                    ),
                  ),
                // Main button
                Transform.scale(
                  scale: widget.isEnabled ? _heartbeatAnimation.value : 1.0,
                  child: GestureDetector(
                    onTapDown: (_) => _handleTapDown(),
                    onTapUp: (_) => _handleTapUp(),
                    onTapCancel: _handleTapCancel,
                    child: Container(
                      width: 88.w,
                      height: 14.h,
                      decoration: BoxDecoration(
                        gradient: widget.isEnabled
                            ? LinearGradient(
                                colors: [
                                  widget.emotionColor,
                                  widget.emotionColor.withValues(alpha: 0.8),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : LinearGradient(
                                colors: [
                                  Colors.grey.shade300,
                                  Colors.grey.shade400,
                                ],
                              ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: widget.isEnabled
                            ? [
                                BoxShadow(
                                  color: widget.emotionColor
                                      .withValues(alpha: 0.4),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 8),
                                ),
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ]
                            : [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                      ),
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: _showListeningText
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  key: const ValueKey('listening'),
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          Colors.white.withValues(alpha: 0.8),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 3.w),
                                    Text(
                                      'We\'re listening…',
                                      style: GoogleFonts.inter(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  key: const ValueKey('getClarity'),
                                  children: [
                                    Icon(
                                      Icons.psychology_rounded,
                                      color: Colors.white,
                                      size: 26,
                                    ),
                                    SizedBox(width: 3.w),
                                    Text(
                                      'Get Clarity',
                                      style: GoogleFonts.inter(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
