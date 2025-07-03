import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/emotional_particle_background_widget.dart'
    hide EmotionType;
import './widgets/clarity_streak_widget.dart';
import './widgets/emotion_selector_widget.dart';
import './widgets/get_clarity_button_widget.dart';
import './widgets/mood_of_day_widget.dart';
import './widgets/popular_whatifs_widget.dart';
import './widgets/prompt_suggestions_widget.dart';
import './widgets/smart_prompt_input_widget.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard>
    with TickerProviderStateMixin {
  final TextEditingController _promptController = TextEditingController();
  EmotionData? _selectedEmotion;
  int _currentBottomNavIndex = 0;

  late AnimationController _backgroundController;
  late Animation<Color?> _backgroundAnimation;

  // Community impact data
  final int communityImpactCount = 36;

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _backgroundAnimation = ColorTween(
      begin: Theme.of(context).scaffoldBackgroundColor,
      end: Theme.of(context).scaffoldBackgroundColor,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _promptController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  void _onEmotionSelected(EmotionData emotion) {
    setState(() {
      _selectedEmotion = emotion;
    });

    // Animate background color change with smoother transition
    _backgroundAnimation = ColorTween(
      begin: _backgroundAnimation.value,
      end: _getBackgroundColorForEmotion(emotion),
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));

    _backgroundController.forward();
  }

  Color _getBackgroundColorForEmotion(EmotionData emotion) {
    switch (emotion.type) {
      case EmotionType.anxious:
        return const Color(0xFFF8F9FA); // Slightly dimmed
      case EmotionType.hopeful:
        return const Color(0xFFFFF9F5); // Warm orange-green gradient feeling
      case EmotionType.curious:
        return const Color(0xFFFFFCF0); // Bright golden background
      case EmotionType.calm:
        return const Color(0xFFF0FDFA); // Soft teal background
      case EmotionType.confused:
        return const Color(0xFFF4F6FF); // Soft blue background
      case EmotionType.excited:
        return const Color(0xFFFFF5F8); // Soft pink background
      default:
        return Theme.of(context).scaffoldBackgroundColor;
    }
  }

  EmotionType? _getEmotionTypeFromData(EmotionData? emotion) {
    return emotion?.type;
  }

  void _onGetClarity() {
    if (_promptController.text.trim().isNotEmpty && _selectedEmotion != null) {
      // Navigate to decision results or process the decision
      Navigator.pushNamed(
        context,
        AppRoutes.decisionResults,
        arguments: {
          'question': _promptController.text.trim(),
          'emotion': _selectedEmotion,
        },
      );
    }
  }

  void _onSuggestionTap(String suggestion) {
    setState(() {
      _promptController.text = suggestion;
    });
  }

  void _onWhatIfTap(String whatIf) {
    setState(() {
      _promptController.text = whatIf;
    });
  }

  Widget _buildTopSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Updated to use the new Clariti logo
              ClipOval(
                child: Container(
                  width: 14.w,
                  height: 14.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (_selectedEmotion?.color ??
                                Theme.of(context).colorScheme.primary)
                            .withValues(alpha: 0.3),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ClarityLogoWidget(
                    width: 14.w,
                    height: 14.w,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Clariti',
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      'Make better decisions together',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  (_selectedEmotion?.color ??
                          Theme.of(context).colorScheme.primary)
                      .withValues(alpha: 0.1),
                  (_selectedEmotion?.color ??
                          Theme.of(context).colorScheme.secondary)
                      .withValues(alpha: 0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Community Impact',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        '$communityImpactCount people gained clarity today',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.trending_up,
                  color: _selectedEmotion?.color ??
                      Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _backgroundAnimation,
      builder: (context, child) {
        return EmotionalParticleBackground(
          child: Scaffold(
            backgroundColor: _backgroundAnimation.value ??
                Theme.of(context).scaffoldBackgroundColor,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                child: Column(
                  children: [
                    _buildTopSection(),
                    SizedBox(height: 6.h),

                    // Smart Prompt Input - Enhanced with glassmorphic design
                    SmartPromptInputWidget(
                      controller: _promptController,
                      onChanged: (value) {
                        setState(() {});
                      },
                      emotionColor: _selectedEmotion?.color ??
                          Theme.of(context).colorScheme.primary,
                      isGlowing: _selectedEmotion != null,
                    ),

                    SizedBox(height: 5.h),

                    // Emotion Selector - Redesigned as circular wheel
                    EmotionSelectorWidget(
                      onEmotionSelected: _onEmotionSelected,
                      selectedEmotion: _selectedEmotion,
                    ),

                    SizedBox(height: 6.h),

                    // Get Clarity Button - Enhanced with ripple and heartbeat effects
                    GetClarityButtonWidget(
                      onPressed: _onGetClarity,
                      emotionColor: _selectedEmotion?.color ??
                          Theme.of(context).colorScheme.primary,
                      isEnabled: _promptController.text.trim().isNotEmpty &&
                          _selectedEmotion != null,
                    ),

                    SizedBox(height: 5.h),

                    // Mood of the Day
                    MoodOfDayWidget(),

                    SizedBox(height: 4.h),

                    // Clarity Streak
                    ClarityStreakWidget(),

                    SizedBox(height: 5.h),

                    // Popular What-Ifs
                    PopularWhatIfsWidget(
                      onWhatIfTap: _onWhatIfTap,
                    ),

                    SizedBox(height: 5.h),

                    // Prompt Suggestions
                    PromptSuggestionsWidget(
                      onSuggestionTap: _onSuggestionTap,
                    ),

                    SizedBox(height: 12.h), // Extra space for bottom navigation
                  ],
                ),
              ),
            ),

            // ... keep existing floatingActionButton and bottomNavigationBar
            floatingActionButton: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _selectedEmotion?.color ??
                        Theme.of(context).colorScheme.primary,
                    (_selectedEmotion?.color ??
                            Theme.of(context).colorScheme.primary)
                        .withValues(alpha: 0.8),
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: (_selectedEmotion?.color ??
                            Theme.of(context).colorScheme.primary)
                        .withValues(alpha: 0.3),
                    blurRadius: 15,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: FloatingActionButton(
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.communityFeed),
                backgroundColor: Colors.transparent,
                elevation: 0,
                child: Icon(
                  Icons.people_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),

            // Bottom Navigation Bar - Enhanced styling
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.95),
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                border: Border(
                  top: BorderSide(
                    color: Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: 0.1),
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, -10),
                  ),
                ],
              ),
              child: BottomNavigationBar(
                currentIndex: _currentBottomNavIndex,
                onTap: _onBottomNavTap,
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.transparent,
                selectedItemColor: _selectedEmotion?.color ??
                    Theme.of(context).colorScheme.primary,
                unselectedItemColor:
                    Theme.of(context).colorScheme.onSurfaceVariant,
                elevation: 0,
                selectedLabelStyle: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
                unselectedLabelStyle: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined),
                    activeIcon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.people_outline),
                    activeIcon: Icon(Icons.people),
                    label: 'Community',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.psychology_outlined),
                    activeIcon: Icon(Icons.psychology),
                    label: 'Decide',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person_outline),
                    activeIcon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentBottomNavIndex = index;
    });

    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.pushNamed(context, AppRoutes.communityFeed);
        break;
      case 2:
        Navigator.pushNamed(context, AppRoutes.createDecision);
        break;
      case 3:
        Navigator.pushNamed(context, AppRoutes.userProfile);
        break;
    }
  }
}

// Remove duplicate EmotionType and EmotionData definitions - use the ones from emotion_selector_widget.dart
