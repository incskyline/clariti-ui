import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

class SmartPromptInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final Color emotionColor;
  final bool isGlowing;
  final String? selectedEmotionEmoji;

  const SmartPromptInputWidget({
    super.key,
    required this.controller,
    required this.onChanged,
    this.emotionColor = const Color(0xFF6B73FF),
    this.isGlowing = false,
    this.selectedEmotionEmoji,
  });

  @override
  State<SmartPromptInputWidget> createState() => _SmartPromptInputWidgetState();
}

class _SmartPromptInputWidgetState extends State<SmartPromptInputWidget>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late AnimationController _typeController;
  late AnimationController _cursorController;
  late AnimationController _helperTextController;
  late AnimationController _titleController;
  late Animation<double> _glowAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _cursorAnimation;
  late Animation<double> _helperTextAnimation;
  late Animation<double> _titleShimmerAnimation;
  bool _isFocused = false;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _typeController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _cursorController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    _helperTextController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _titleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _typeController,
      curve: Curves.easeOut,
    ));

    _cursorAnimation = Tween<double>(
      begin: 0.2,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _cursorController,
      curve: Curves.easeInOut,
    ));

    _helperTextAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _helperTextController,
      curve: Curves.easeInOut,
    ));

    _titleShimmerAnimation = Tween<double>(
      begin: -2.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _titleController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _glowController.dispose();
    _typeController.dispose();
    _cursorController.dispose();
    _helperTextController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  String _getEmotionExpression(String text) {
    if (widget.selectedEmotionEmoji == null) return '😐';

    if (text.isEmpty) return widget.selectedEmotionEmoji!;

    if (text.length < 10) return widget.selectedEmotionEmoji!;
    if (text.length < 30) {
      // Show thinking version
      switch (widget.selectedEmotionEmoji) {
        case '😰':
          return '🤔';
        case '🌅':
          return '😊';
        case '🤔':
          return '🧐';
        case '😌':
          return '🙂';
        case '🤨':
          return '😕';
        case '🎉':
          return '😄';
        default:
          return widget.selectedEmotionEmoji!;
      }
    }
    // Show engaged version
    switch (widget.selectedEmotionEmoji) {
      case '😰':
        return '😤';
      case '🌅':
        return '🤗';
      case '🤔':
        return '🤓';
      case '😌':
        return '😇';
      case '🤨':
        return '😣';
      case '🎉':
        return '🤩';
      default:
        return widget.selectedEmotionEmoji!;
    }
  }

  Color _getHelperTextColor(String text) {
    if (text.isEmpty) {
      return Colors.grey.shade400;
    } else if (text.length < 20) {
      return Colors.amber.shade600;
    } else {
      return Colors.green.shade600;
    }
  }

  String _getHelperText(String text) {
    if (text.isEmpty) {
      return 'Start typing your What If...';
    } else if (text.length < 20) {
      return 'Keep going, you\'re on the right track...';
    } else {
      return '✓ Ready';
    }
  }

  IconData? _getHelperIcon(String text) {
    if (text.length >= 20) {
      return Icons.check_circle;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _glowAnimation,
        _scaleAnimation,
        _cursorAnimation,
        _helperTextAnimation,
        _titleShimmerAnimation,
      ]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Enhanced Futuristic Title above the input box
                Padding(
                  padding: EdgeInsets.only(bottom: 3.h, left: 2.w, right: 2.w),
                  child: Text(
                    'Type your \'What If...\' below to get instant clarity.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade600,
                      letterSpacing: 0,
                    ),
                  ),
                ),
                // Main input container - larger size
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withValues(alpha: 0.95),
                        Colors.white.withValues(alpha: 0.88),
                        Colors.grey.shade50.withValues(alpha: 0.85),
                      ],
                    ),
                    border: Border.all(
                      color: _isFocused || widget.isGlowing
                          ? widget.emotionColor.withValues(alpha: 0.4)
                          : Colors.grey.shade200.withValues(alpha: 0.6),
                      width: _isFocused || widget.isGlowing ? 2.0 : 1.5,
                    ),
                    boxShadow: [
                      if (widget.isGlowing || _isFocused)
                        BoxShadow(
                          color: widget.emotionColor.withValues(
                            alpha: _glowAnimation.value * 0.3,
                          ),
                          blurRadius: 25,
                          spreadRadius: 2,
                          offset: const Offset(0, 8),
                        ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.7),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                    child: Row(
                      children: [
                        // Enhanced Animated Emoji Avatar
                        if (widget.selectedEmotionEmoji != null)
                          Container(
                            width: 16.w,
                            height: 16.w,
                            margin: EdgeInsets.only(right: 5.w),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  widget.emotionColor.withValues(alpha: 0.15),
                                  widget.emotionColor.withValues(alpha: 0.08),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color:
                                    widget.emotionColor.withValues(alpha: 0.25),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: widget.emotionColor
                                      .withValues(alpha: 0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Center(
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: Text(
                                  _getEmotionExpression(widget.controller.text),
                                  key: ValueKey(_getEmotionExpression(
                                      widget.controller.text)),
                                  style: TextStyle(fontSize: 28),
                                ),
                              ),
                            ),
                          ),
                        // Text Input with blended background
                        Expanded(
                          child: Container(
                            constraints: BoxConstraints(
                              minHeight: 12.h,
                            ),
                            child: Stack(
                              children: [
                                // Example text overlay when field is empty
                                if (widget.controller.text.isEmpty &&
                                    !_isFocused)
                                  Positioned.fill(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 3.h,
                                        horizontal: 4.w,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Example:',
                                            style: GoogleFonts.inter(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color: widget.emotionColor
                                                  .withValues(alpha: 0.7),
                                            ),
                                          ),
                                          SizedBox(height: 1.h),
                                          Text(
                                            '"Should I accept the job offer in another city?"',
                                            style: GoogleFonts.inter(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.grey.shade600
                                                  .withValues(alpha: 0.8),
                                              fontStyle: FontStyle.italic,
                                              height: 1.4,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                // Actual TextField - blended with container
                                TextField(
                                  controller: widget.controller,
                                  onChanged: (value) {
                                    widget.onChanged(value);
                                    if (value.isNotEmpty) {
                                      setState(() => _isTyping = true);
                                      _typeController.forward().then((_) {
                                        _typeController.reverse();
                                        Future.delayed(
                                            const Duration(milliseconds: 500),
                                            () {
                                          if (mounted) {
                                            setState(() => _isTyping = false);
                                          }
                                        });
                                      });
                                    }
                                  },
                                  onTap: () {
                                    setState(() => _isFocused = true);
                                  },
                                  onEditingComplete: () {
                                    setState(() => _isFocused = false);
                                  },
                                  onSubmitted: (_) {
                                    setState(() => _isFocused = false);
                                  },
                                  style: GoogleFonts.inter(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    height: 1.5,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'What\'s your decision dilemma?',
                                    hintStyle: GoogleFonts.inter(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey.shade500
                                          .withValues(alpha: 0.8),
                                    ),
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 3.h,
                                      horizontal: 4.w,
                                    ),
                                  ),
                                  maxLines: 5,
                                  minLines: 3,
                                  textInputAction: TextInputAction.done,
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Enhanced typing indicator with professional styling
                        if (_isTyping || _isFocused)
                          Container(
                            width: 3,
                            height: 24,
                            margin: EdgeInsets.only(left: 3.w),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  widget.emotionColor.withValues(
                                    alpha: _cursorAnimation.value * 0.8,
                                  ),
                                  widget.emotionColor.withValues(
                                    alpha: _cursorAnimation.value * 0.4,
                                  ),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // Dynamic Helper Text
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  margin: EdgeInsets.only(
                    top: 2.h,
                    left: 6.w,
                    right: 6.w,
                  ),
                  child: AnimatedOpacity(
                    opacity: _isFocused || widget.controller.text.isNotEmpty
                        ? 1.0
                        : 0.7,
                    duration: const Duration(milliseconds: 300),
                    child: Row(
                      children: [
                        // Icon for ready state
                        if (_getHelperIcon(widget.controller.text) != null)
                          AnimatedScale(
                            scale:
                                widget.controller.text.length >= 20 ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.elasticOut,
                            child: Container(
                              margin: EdgeInsets.only(right: 2.w),
                              child: Icon(
                                _getHelperIcon(widget.controller.text),
                                color:
                                    _getHelperTextColor(widget.controller.text),
                                size: 18,
                              ),
                            ),
                          ),
                        // Helper text
                        Expanded(
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: widget.controller.text.length >= 20
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              color:
                                  _getHelperTextColor(widget.controller.text),
                              height: 1.4,
                            ),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              switchInCurve: Curves.easeInOut,
                              switchOutCurve: Curves.easeInOut,
                              child: Text(
                                _getHelperText(widget.controller.text),
                                key: ValueKey(
                                    _getHelperText(widget.controller.text)),
                              ),
                            ),
                          ),
                        ),
                      ],
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
