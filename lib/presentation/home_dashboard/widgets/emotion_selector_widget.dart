import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

enum EmotionType {
  calm,
  anxious,
  curious,
  hopeful,
  confused,
  excited,
}

class EmotionData {
  final EmotionType type;
  final String label;
  final IconData icon;
  final Color color;
  final Color backgroundColor;

  const EmotionData({
    required this.type,
    required this.label,
    required this.icon,
    required this.color,
    required this.backgroundColor,
  });
}

class EmotionSelectorWidget extends StatefulWidget {
  final Function(EmotionData) onEmotionSelected;
  final EmotionData? selectedEmotion;

  const EmotionSelectorWidget({
    super.key,
    required this.onEmotionSelected,
    this.selectedEmotion,
  });

  @override
  State<EmotionSelectorWidget> createState() => _EmotionSelectorWidgetState();
}

class _EmotionSelectorWidgetState extends State<EmotionSelectorWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _morphController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _morphAnimation;

  final List<EmotionData> emotions = [
    EmotionData(
      type: EmotionType.calm,
      label: 'Calm',
      icon: Icons.spa_outlined,
      color: const Color(0xFF4FD1C7),
      backgroundColor: const Color(0xFFE6FFFA),
    ),
    EmotionData(
      type: EmotionType.hopeful,
      label: 'Hopeful',
      icon: Icons.wb_sunny_outlined,
      color: const Color(0xFFFF8C00),
      backgroundColor: const Color(0xFFFFF5F0),
    ),
    EmotionData(
      type: EmotionType.excited,
      label: 'Excited',
      icon: Icons.celebration_outlined,
      color: const Color(0xFFFF6B9D),
      backgroundColor: const Color(0xFFFFF0F5),
    ),
    EmotionData(
      type: EmotionType.curious,
      label: 'Curious',
      icon: Icons.psychology_outlined,
      color: const Color(0xFFFFD700),
      backgroundColor: const Color(0xFFFFFBF0),
    ),
    EmotionData(
      type: EmotionType.confused,
      label: 'Confused',
      icon: Icons.help_outline,
      color: const Color(0xFF6B73FF),
      backgroundColor: const Color(0xFFF0F4FF),
    ),
    EmotionData(
      type: EmotionType.anxious,
      label: 'Anxious',
      icon: Icons.psychology_alt_outlined,
      color: const Color(0xFF8B8B8B),
      backgroundColor: const Color(0xFFF7FAFC),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);

    _morphController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _morphAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _morphController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _morphController.dispose();
    super.dispose();
  }

  void _onEmotionTap(EmotionData emotion) {
    widget.onEmotionSelected(emotion);
    _morphController.forward().then((_) {
      _morphController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How are you feeling?',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          SizedBox(
            height: 9.h, // Slightly smaller height
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: emotions.length,
              itemBuilder: (context, index) {
                return _buildEmotionCard(context, emotions[index], index);
              },
            ),
          ),
          SizedBox(height: 1.5.h),
          // Helper text
          Center(
            child: Text(
              widget.selectedEmotion == null
                  ? 'Swipe to explore emotions'
                  : 'Perfect! Let\'s explore this feeling',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmotionCard(
      BuildContext context, EmotionData emotion, int index) {
    final isSelected = widget.selectedEmotion?.type == emotion.type;

    return AnimatedBuilder(
      animation: Listenable.merge([_pulseAnimation, _morphAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale:
              isSelected ? _pulseAnimation.value * _morphAnimation.value : 1.0,
          child: GestureDetector(
            onTap: () => _onEmotionTap(emotion),
            child: Container(
              width: 26.w, // Slightly smaller width
              height: 7.h, // Smaller height
              margin: EdgeInsets.only(right: 2.5.w),
              padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 1.h),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        colors: [
                          emotion.color.withValues(alpha: 0.15),
                          emotion.backgroundColor.withValues(alpha: 0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color:
                    isSelected ? null : Theme.of(context).colorScheme.surface,
                // Enhanced curved design with unique asymmetric curves
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                      22 + (index % 3) * 3.0), // Variable curves
                  topRight: Radius.circular(18 + (index % 2) * 4.0),
                  bottomLeft: Radius.circular(15 + (index % 4) * 2.0),
                  bottomRight: Radius.circular(25 + (index % 3) * 2.0),
                ),
                border: Border.all(
                  color: isSelected
                      ? emotion.color
                      : Theme.of(context)
                          .colorScheme
                          .outline
                          .withValues(alpha: 0.2),
                  width: isSelected ? 2.5 : 1.2,
                ),
                boxShadow: [
                  if (isSelected)
                    BoxShadow(
                      color: emotion.color.withValues(alpha: 0.35),
                      blurRadius: 15,
                      spreadRadius: 2,
                      offset: const Offset(0, 8),
                    ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Icon container with enhanced curved styling
                  Container(
                    width: 7.w,
                    height: 7.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15 + (index % 2) * 3.0),
                        topRight: Radius.circular(12 + (index % 3) * 2.0),
                        bottomLeft: Radius.circular(18 + (index % 2) * 2.0),
                        bottomRight: Radius.circular(20 + (index % 3) * 1.0),
                      ),
                      color: isSelected
                          ? emotion.color.withValues(alpha: 0.15)
                          : emotion.backgroundColor,
                      border: Border.all(
                        color: emotion.color.withValues(alpha: 0.4),
                        width: 1.2,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        emotion.icon,
                        size: isSelected ? 18 : 16,
                        color: emotion.color,
                      ),
                    ),
                  ),
                  SizedBox(width: 1.5.w),
                  // Emotion label
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          emotion.label,
                          style: GoogleFonts.inter(
                            fontSize: isSelected ? 12 : 11,
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w600,
                            color: isSelected
                                ? emotion.color
                                : Theme.of(context).colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (isSelected) ...[
                          SizedBox(height: 0.3.h),
                          // Enhanced selection indicator with curved design
                          Container(
                            width: 3.5.w,
                            height: 0.4.h,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  emotion.color,
                                  emotion.color.withValues(alpha: 0.6),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ],
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
}
