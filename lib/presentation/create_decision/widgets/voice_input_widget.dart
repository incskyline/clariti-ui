import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VoiceInputWidget extends StatefulWidget {
  final Function(String) onVoiceInput;
  final Color selectedEmotionColor;

  const VoiceInputWidget({
    super.key,
    required this.onVoiceInput,
    required this.selectedEmotionColor,
  });

  @override
  State<VoiceInputWidget> createState() => _VoiceInputWidgetState();
}

class _VoiceInputWidgetState extends State<VoiceInputWidget>
    with SingleTickerProviderStateMixin {
  bool _isListening = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startListening() async {
    setState(() {
      _isListening = true;
    });

    _animationController.repeat(reverse: true);
    HapticFeedback.mediumImpact();

    // Simulate voice input - in real app, integrate with speech_to_text package
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isListening = false;
      });
      _animationController.stop();
      _animationController.reset();

      // Mock voice input result
      widget.onVoiceInput("What if I quit my job and start my own business?");

      // Show feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Voice input captured successfully!'),
          backgroundColor: widget.selectedEmotionColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isListening ? null : _startListening,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _isListening ? _scaleAnimation.value : 1.0,
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: _isListening
                    ? widget.selectedEmotionColor.withValues(alpha: 0.2)
                    : AppTheme.lightTheme.colorScheme.surface,
                shape: BoxShape.circle,
                border: Border.all(
                  color: _isListening
                      ? widget.selectedEmotionColor
                      : AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.3),
                  width: _isListening ? 2 : 1,
                ),
                boxShadow: _isListening
                    ? [
                        BoxShadow(
                          color: widget.selectedEmotionColor
                              .withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: CustomIconWidget(
                iconName: _isListening ? 'mic' : 'mic_none',
                color: _isListening
                    ? widget.selectedEmotionColor
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
          );
        },
      ),
    );
  }
}
