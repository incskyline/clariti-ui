import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/action_bar_widget.dart';
import './widgets/original_question_widget.dart';
import './widgets/page_indicator_widget.dart';
import './widgets/vibrant_outcome_card_widget.dart';

class DecisionResults extends StatefulWidget {
  const DecisionResults({super.key});

  @override
  State<DecisionResults> createState() => _DecisionResultsState();
}

class _DecisionResultsState extends State<DecisionResults>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _cardAnimationController;
  late AnimationController _pullDownAnimationController;
  late AnimationController _confettiController;
  late Animation<double> _cardAnimation;
  late Animation<double> _pullDownAnimation;

  int _currentPage = 0;
  bool _showOriginalQuestion = false;
  bool _isCardFlipped = false;

  // Enhanced mock data for vibrant decision results
  final Map<String, dynamic> _decisionData = {
    "originalQuestion":
        "Should I quit my current job to start my own business?",
    "selectedEmotion": "Anxious",
    "emotionIcon": "😰",
    "outcomes": [
      {
        "type": "Best Case",
        "color": 0xFF48BB78,
        "title": "Entrepreneurial Success",
        "description":
            "Your business takes off within 6 months, generating steady income that exceeds your previous salary. You gain financial independence and personal fulfillment.",
        "confidence": 0.7,
        "insights": [
          "Market research shows demand for your service",
          "You have 6 months of savings as buffer",
          "Strong network of potential clients already identified"
        ],
        "additionalDetails":
            "Based on your skills and market conditions, there's a 70% chance of achieving sustainable income within the first year."
      },
      {
        "type": "Worst Case",
        "color": 0xFFE53E3E,
        "title": "Financial Struggle",
        "description":
            "The business fails to generate sufficient income, depleting your savings. You struggle to find employment at your previous salary level.",
        "confidence": 0.3,
        "insights": [
          "Competitive market with established players",
          "Limited initial capital for marketing",
          "Economic uncertainty affecting consumer spending"
        ],
        "additionalDetails":
            "Market saturation and initial capital constraints could lead to challenges in the first 18 months."
      },
      {
        "type": "Final Judgment",
        "color": 0xFF6B73FF,
        "title": "Calculated Risk Worth Taking",
        "description":
            "While there are risks, your preparation and market opportunity suggest this is the right time to make the transition with proper planning.",
        "confidence": 0.8,
        "insights": [
          "Your anxiety shows you're taking this seriously",
          "Having a solid business plan reduces risks significantly",
          "Part-time transition could minimize financial impact"
        ],
        "additionalDetails":
            "Consider a gradual transition: start part-time while maintaining current income, then switch fully once revenue stabilizes."
      }
    ]
  };

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _cardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _pullDownAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _confettiController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _cardAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _cardAnimationController,
      curve: Curves.elasticOut,
    ));

    _pullDownAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pullDownAnimationController,
      curve: Curves.easeOut,
    ));

    _cardAnimationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _cardAnimationController.dispose();
    _pullDownAnimationController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
    HapticFeedback.lightImpact();

    // Trigger confetti for Final Judgment
    final outcome =
        (_decisionData["outcomes"] as List)[page] as Map<String, dynamic>;
    if (outcome["type"] == "Final Judgment") {
      _confettiController.forward().then((_) {
        _confettiController.reset();
      });
    }
  }

  void _toggleOriginalQuestion() {
    setState(() {
      _showOriginalQuestion = !_showOriginalQuestion;
    });

    if (_showOriginalQuestion) {
      _pullDownAnimationController.forward();
    } else {
      _pullDownAnimationController.reverse();
    }
  }

  void _flipCard() {
    setState(() {
      _isCardFlipped = !_isCardFlipped;
    });
    HapticFeedback.mediumImpact();
  }

  void _handleReaction(String reaction) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Text(reaction, style: TextStyle(fontSize: 20.sp)),
            SizedBox(width: 2.w),
            Text('Thanks for your reaction!'),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: AppTheme.primaryLight,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _saveDecision() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Decision saved to your profile'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _shareResults() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Results shared successfully'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _tryAgain() {
    HapticFeedback.lightImpact();
    Navigator.pushReplacementNamed(context, '/create-decision');
  }

  void _exploreSimilar() {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(context, '/community-feed');
  }

  void _showCardContextMenu(BuildContext context, int cardIndex) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'content_copy',
                color: Theme.of(context).colorScheme.onSurface,
                size: 24,
              ),
              title: Text('Copy Text'),
              onTap: () {
                Navigator.pop(context);
                HapticFeedback.lightImpact();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Text copied to clipboard')),
                );
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'report',
                color: AppTheme.warning,
                size: 24,
              ),
              title: Text('Report Issue'),
              onTap: () {
                Navigator.pop(context);
                HapticFeedback.lightImpact();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'feedback',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              title: Text('Provide Feedback'),
              onTap: () {
                Navigator.pop(context);
                HapticFeedback.lightImpact();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Enhanced header with back button and actions
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: CustomIconWidget(
                      iconName: 'arrow_back',
                      color: Theme.of(context).colorScheme.onSurface,
                      size: 24,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Decision Results',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: CustomIconWidget(
                      iconName: 'more_vert',
                      color: Theme.of(context).colorScheme.onSurface,
                      size: 24,
                    ),
                    onSelected: (value) {
                      switch (value) {
                        case 'save':
                          _saveDecision();
                          break;
                        case 'share':
                          _shareResults();
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'save',
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'bookmark',
                              color: Theme.of(context).colorScheme.onSurface,
                              size: 20,
                            ),
                            SizedBox(width: 3.w),
                            Text('Save Decision'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'share',
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'share',
                              color: Theme.of(context).colorScheme.onSurface,
                              size: 20,
                            ),
                            SizedBox(width: 3.w),
                            Text('Share Results'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Pull-down gesture area for original question
            GestureDetector(
              onTap: _toggleOriginalQuestion,
              child: AnimatedBuilder(
                animation: _pullDownAnimation,
                builder: (context, child) {
                  return Container(
                    height: _showOriginalQuestion
                        ? 15.h * _pullDownAnimation.value
                        : 3.h,
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    child: _showOriginalQuestion
                        ? OriginalQuestionWidget(
                            question:
                                _decisionData["originalQuestion"] as String,
                            emotion: _decisionData["selectedEmotion"] as String,
                            emotionIcon: _decisionData["emotionIcon"] as String,
                            animation: _pullDownAnimation,
                          )
                        : Container(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomIconWidget(
                                  iconName: 'keyboard_arrow_down',
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                  size: 20,
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  'Tap to see original question',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                  );
                },
              ),
            ),

            // Enhanced main content - Swipeable vibrant cards
            Expanded(
              child: AnimatedBuilder(
                animation: _cardAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 0.8 + (0.2 * _cardAnimation.value),
                    child: Opacity(
                      opacity: _cardAnimation.value,
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: _onPageChanged,
                        itemCount: (_decisionData["outcomes"] as List).length,
                        itemBuilder: (context, index) {
                          final outcome = (_decisionData["outcomes"]
                              as List)[index] as Map<String, dynamic>;
                          return Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 4.w, vertical: 2.h),
                            child: GestureDetector(
                              onTap: _flipCard,
                              onLongPress: () =>
                                  _showCardContextMenu(context, index),
                              child: VibrantOutcomeCardWidget(
                                outcome: outcome,
                                isFlipped: _isCardFlipped,
                                onFlip: _flipCard,
                                onReaction: _handleReaction,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),

            // Enhanced page indicator
            PageIndicatorWidget(
              currentPage: _currentPage,
              totalPages: (_decisionData["outcomes"] as List).length,
            ),

            SizedBox(height: 2.h),

            // Action bar
            ActionBarWidget(
              onSave: _saveDecision,
              onShare: _shareResults,
              onTryAgain: _tryAgain,
            ),

            SizedBox(height: 2.h),
          ],
        ),
      ),

      // Enhanced floating explore similar button
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 8.h),
        child: FloatingActionButton.extended(
          onPressed: _exploreSimilar,
          backgroundColor: AppTheme.secondary,
          foregroundColor: Colors.white,
          elevation: 8,
          label: Text(
            'Explore Similar',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
          ),
          icon: CustomIconWidget(
            iconName: 'explore',
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
