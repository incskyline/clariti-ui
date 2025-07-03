import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/onboarding_page_widget.dart';
import './widgets/page_indicator_widget.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _currentPage = 0;

  final List<Map<String, dynamic>> _onboardingData = [
{ "title": "Every decision starts with a What If...",
"description": "Clariti helps you explore life's big and small choices through clear scenarios and emotional insight.",
"illustration": "assets/images/no-image.jpg",
"primaryColor": Color(0xFF9B59B6), // Purple/lavender gradient 
"secondaryColor": Color(0xFF6B73FF),
"isFirstPage": true,
"exampleQuestion": "What if I change careers?",
"emotions": [ {"name": "Anxious", "color": Color(0xFF3182CE)}, // Blue 
{"name": "Curious", "color": Color(0xFFFFEB3B)}, // Yellow 
{"name": "Hopeful", "color": Color(0xFFFF5722)}, // Orange 
],
"bottomText": "You're one step closer to clarity."
},
{ "title": "Explore Outcomes",
"description": "Swipe through Best Case, Worst Case, and Final Judgment cards to gain clarity on your decision.",
"illustration": "https://images.unsplash.com/photo-1522202176988-66273c2fd55f?w=400&h=600&fit=crop",
"primaryColor": Color(0xFF48BB78),
"secondaryColor": Color(0xFF6B73FF),
},
{ "title": "Connect & Share",
"description": "Join our anonymous community. Share your decisions, vote on threads, and find support from others.",
"illustration": "https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=400&h=600&fit=crop",
"primaryColor": Color(0xFF9B59B6),
"secondaryColor": Color(0xFF48BB78),
},
];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _getStarted();
    }
  }

  void _skipOnboarding() {
    Navigator.pushReplacementNamed(context, '/home-dashboard');
  }

  void _getStarted() {
    Navigator.pushReplacementNamed(context, '/home-dashboard');
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Background gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _onboardingData[_currentPage]["primaryColor"]
                        .withValues(alpha: 0.1),
                    _onboardingData[_currentPage]["secondaryColor"]
                        .withValues(alpha: 0.05),
                  ],
                ),
              ),
            ),

            // Skip button
            Positioned(
              top: 2.h,
              right: 4.w,
              child: TextButton(
                onPressed: _skipOnboarding,
                child: Text(
                  'Skip',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),

            // Back button (visible on pages 2-3)
            if (_currentPage > 0)
              Positioned(
                top: 2.h,
                left: 4.w,
                child: IconButton(
                  onPressed: _previousPage,
                  icon: CustomIconWidget(
                    iconName: 'arrow_back_ios',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                ),
              ),

            // Main content
            Column(
              children: [
                // Progress indicator
                Container(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  child: Text(
                    '${_currentPage + 1} of ${_onboardingData.length}',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),

                // PageView
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    itemCount: _onboardingData.length,
                    itemBuilder: (context, index) {
                      return FadeTransition(
                        opacity: _fadeAnimation,
                        child: OnboardingPageWidget(
                          title: _onboardingData[index]["title"],
                          description: _onboardingData[index]["description"],
                          illustration: _onboardingData[index]["illustration"],
                          primaryColor: _onboardingData[index]["primaryColor"],
                          secondaryColor: _onboardingData[index]["secondaryColor"],
                          isLastPage: index == _onboardingData.length - 1,
                          isFirstPage: _onboardingData[index]["isFirstPage"] ?? false,
                          exampleQuestion: _onboardingData[index]["exampleQuestion"],
                          emotions: _onboardingData[index]["emotions"],
                          bottomText: _onboardingData[index]["bottomText"],
                        ),
                      );
                    },
                  ),
                ),

                // Bottom section with indicator and button
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                  child: Column(
                    children: [
                      // Page indicator
                      PageIndicatorWidget(
                        currentPage: _currentPage,
                        totalPages: _onboardingData.length,
                        activeColor: _onboardingData[_currentPage]
                            ["primaryColor"],
                        inactiveColor: AppTheme
                            .lightTheme.colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.3),
                      ),

                      SizedBox(height: 4.h),

                      // Next/Get Started button
                      SizedBox(
                        width: double.infinity,
                        height: 6.h,
                        child: ElevatedButton(
                          onPressed: _nextPage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _onboardingData[_currentPage]
                                ["primaryColor"],
                            foregroundColor: Colors.white,
                            elevation: 2,
                            shadowColor: _onboardingData[_currentPage]
                                    ["primaryColor"]
                                .withValues(alpha: 0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            _currentPage == _onboardingData.length - 1
                                ? 'Get Started'
                                : 'Next',
                            style: AppTheme.lightTheme.textTheme.labelLarge
                                ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}